"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { assignmentApi, uploadApi, type MyAssignmentDto } from "@/lib/api";
import { UploadCloud } from "lucide-react";

const STATUS_CONFIG: Record<string, { label: string; color: string; icon: string }> = {
    pending: { label: "Bekliyor", color: "bg-amber-50 text-amber-600 border-amber-200", icon: "⏳" },
    submitted: { label: "Gönderildi", color: "bg-blue-50 text-blue-600 border-blue-200", icon: "📤" },
    graded: { label: "Notlandı", color: "bg-emerald-50 text-emerald-600 border-emerald-200", icon: "✅" },
    overdue: { label: "Süresi Geçti", color: "bg-red-50 text-red-600 border-red-200", icon: "❌" },
};

function SubmitModal({ assignment, token, tenantId, onClose, onSubmitted }: {
    assignment: MyAssignmentDto; token: string; tenantId: string;
    onClose: () => void; onSubmitted: () => void;
}) {
    const draftKey = `assignment-draft-${assignment.id}`;
    const savedDraft = typeof window !== 'undefined' ? JSON.parse(localStorage.getItem(draftKey) ?? '{}') : {};
    const [comment, setComment] = useState(savedDraft.comment ?? "");
    const [fileUrl, setFileUrl] = useState(savedDraft.fileUrl ?? "");
    const [submitting, setSubmitting] = useState(false);
    const [error, setError] = useState("");

    const saveDraft = (newComment: string, newFileUrl: string) => {
        localStorage.setItem(draftKey, JSON.stringify({ comment: newComment, fileUrl: newFileUrl }));
    };

    const [selectedFile, setSelectedFile] = useState<File | null>(null);

    const handleSubmit = async () => {
        setSubmitting(true);
        setError("");
        try {
            let finalUrl = fileUrl || undefined;

            if (selectedFile) {
                const preRes = await uploadApi.getPresignedUrl(token, tenantId, selectedFile.name, selectedFile.type || "application/octet-stream");
                const uploadReq = await fetch(preRes.uploadUrl, { method: "PUT", body: selectedFile, headers: { "Content-Type": selectedFile.type || "application/octet-stream" } });
                if (!uploadReq.ok) throw new Error("Dosya yüklenemedi");
                finalUrl = preRes.publicUrl;
            }

            await assignmentApi.submit(token, tenantId, assignment.id, { comment: comment || undefined, fileUrl: finalUrl });
            localStorage.removeItem(draftKey);
            onSubmitted();
        } catch (e: unknown) {
            setError(e instanceof Error ? e.message : "Bir hata oluştu");
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center z-50 p-4" onClick={onClose}>
            <div className="bg-white rounded-2xl shadow-2xl p-6 w-full max-w-lg border border-[#E2E8F0] animate-fade-in" onClick={e => e.stopPropagation()}>
                <h2 className="text-[#0A1931] font-bold text-lg mb-1">{assignment.title}</h2>
                <p className="text-[#A9A9A9] text-xs mb-4">
                    {assignment.courseName} • Son tarih: {new Date(assignment.dueDate).toLocaleDateString("tr-TR", { day: "numeric", month: "long", hour: "2-digit", minute: "2-digit" })}
                </p>

                {assignment.fileUrl && (
                    <a href={assignment.fileUrl} target="_blank" className="flex items-center gap-2 text-[#1B3B6F] text-sm hover:underline mb-4 transition-colors">
                        📎 Ödev dosyasını indir
                    </a>
                )}

                <div className="space-y-4">
                    <div>
                        <label className="text-[#1B3B6F] text-xs font-medium mb-1 block">Dosya Yükle</label>
                        <label className="relative flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-[#A0AEC0]/40 rounded-2xl cursor-pointer hover:bg-[#E2E8F0]/10 hover:border-[#1B3B6F]/40 transition-all bg-[#F8FAFC]">
                            <input
                                type="file"
                                className="hidden"
                                onChange={e => {
                                    if (e.target.files && e.target.files.length > 0) {
                                        setSelectedFile(e.target.files[0]);
                                        setFileUrl(""); // clear URL if file uploaded
                                    }
                                }}
                            />
                            <div className="flex flex-col items-center justify-center pt-5 pb-6 text-center">
                                <UploadCloud className="w-8 h-8 mb-2 text-[#A0AEC0]" />
                                {selectedFile ? (
                                    <p className="text-sm font-semibold text-[#1B3B6F] truncate max-w-[200px]">{selectedFile.name}</p>
                                ) : (
                                    <>
                                        <p className="text-sm text-[#0A1931] font-semibold">Tıklayıp dosya seçin</p>
                                        <p className="text-xs text-[#A9A9A9] mt-1">PDF, DOC, ZIP vb.</p>
                                    </>
                                )}
                            </div>
                        </label>
                    </div>

                    <div className="relative">
                        <div className="absolute inset-0 flex items-center"><div className="w-full border-t border-[#E2E8F0]"></div></div>
                        <div className="relative flex justify-center text-xs"><span className="px-2 bg-white text-[#A0AEC0]">VEYA DOSYA URL</span></div>
                    </div>

                    <div>
                        <input
                            type="url"
                            value={fileUrl}
                            onChange={e => { setFileUrl(e.target.value); setSelectedFile(null); saveDraft(comment, e.target.value); }}
                            placeholder="https://drive.google.com/..."
                            disabled={!!selectedFile}
                            className="w-full bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl px-4 py-2.5 text-[#0A1931] text-sm placeholder-[#A9A9A9] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#A0AEC0] disabled:opacity-50"
                        />
                    </div>
                    <div>
                        <label className="text-[#1B3B6F] text-xs font-medium mb-1 block">Yorum (isteğe bağlı)</label>
                        <textarea
                            value={comment}
                            onChange={e => { setComment(e.target.value); saveDraft(e.target.value, fileUrl); }}
                            rows={3}
                            placeholder="Ödevinle ilgili eklemek istediğin bir şey..."
                            className="w-full bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl px-4 py-2.5 text-[#0A1931] text-sm placeholder-[#A9A9A9] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#A0AEC0] resize-none"
                        />
                    </div>
                </div>

                {error && <p className="text-red-500 text-xs mt-2">{error}</p>}

                <div className="flex gap-3 mt-5">
                    <button
                        onClick={handleSubmit}
                        disabled={submitting || (!fileUrl && !comment)}
                        className="flex-1 py-2.5 bg-[#0A1931] hover:bg-[#1B3B6F] disabled:opacity-40 text-white text-sm font-bold rounded-xl transition-all shadow-lg shadow-black/10"
                    >
                        {submitting ? "Gönderiliyor..." : "Gönder 📤"}
                    </button>
                    <button onClick={onClose} className="px-4 py-2.5 text-sm text-[#A9A9A9] hover:text-[#0A1931] transition-colors">
                        İptal
                    </button>
                </div>
            </div>
        </div>
    );
}

export default function AssignmentsPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [assignments, setAssignments] = useState<MyAssignmentDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState<string>("all");
    const [submitting, setSubmitting] = useState<MyAssignmentDto | null>(null);

    const load = () => {
        if (!token || !tenantId) return;
        setLoading(true);
        assignmentApi.myAssignments(token, tenantId)
            .then(setAssignments)
            .catch(console.error)
            .finally(() => setLoading(false));
    };

    useEffect(load, [token, tenantId]);

    const filtered = filter === "all" ? assignments : assignments.filter(a => a.status === filter);

    const counts = {
        all: assignments.length,
        pending: assignments.filter(a => a.status === "pending").length,
        submitted: assignments.filter(a => a.status === "submitted").length,
        graded: assignments.filter(a => a.status === "graded").length,
        overdue: assignments.filter(a => a.status === "overdue").length,
    };

    return (
        <div className="max-w-4xl mx-auto pt-16 md:pt-0">
            <h1 className="text-2xl font-bold text-[#0A1931] mb-1">📝 Ödevlerim</h1>
            <p className="text-[#A9A9A9] text-sm mb-6">{assignments.length} ödev</p>

            {/* Stats */}
            <div className="flex overflow-x-auto sm:grid sm:grid-cols-4 gap-3 mb-6 pb-2 snap-x hide-scrollbar">
                {[
                    { label: "Toplam", value: counts.all, emoji: "📋", color: "text-[#0A1931]" },
                    { label: "Bekliyor", value: counts.pending, emoji: "⏳", color: "text-amber-600" },
                    { label: "Gönderilen", value: counts.submitted, emoji: "📤", color: "text-blue-600" },
                    { label: "Notlanan", value: counts.graded, emoji: "✅", color: "text-emerald-600" },
                ].map(s => (
                    <div key={s.label} className="bg-white rounded-2xl border border-[#E2E8F0] p-4 text-center shrink-0 w-36 sm:w-auto snap-center">
                        <span className="text-xl mb-1 block">{s.emoji}</span>
                        <p className={`text-xl font-bold ${s.color}`}>{s.value}</p>
                        <p className="text-[10px] font-bold uppercase tracking-widest text-[#A0AEC0] mt-0.5">{s.label}</p>
                    </div>
                ))}
            </div>

            {/* Filter tabs */}
            <div className="flex gap-2 mb-6 overflow-x-auto pb-2 hide-scrollbar">
                {[
                    { key: "all", label: "Tümü" },
                    { key: "pending", label: "Bekliyor" },
                    { key: "submitted", label: "Gönderildi" },
                    { key: "graded", label: "Notlandı" },
                    { key: "overdue", label: "Gecikmiş" },
                ].map(f => (
                    <button
                        key={f.key}
                        onClick={() => setFilter(f.key)}
                        className={`px-3.5 py-1.5 rounded-lg text-xs font-semibold transition-all border ${filter === f.key
                            ? "bg-[#0A1931] text-white border-[#0A1931]"
                            : "bg-[#E2E8F0]/20 text-[#A9A9A9] border-[#E2E8F0] hover:border-[#A0AEC0] hover:text-[#1B3B6F]"
                            }`}
                    >
                        {f.label}
                        {counts[f.key as keyof typeof counts] > 0 && (
                            <span className={`ml-1.5 px-1.5 py-0.5 rounded-full text-xs ${filter === f.key ? "bg-white/20" : "bg-[#E2E8F0]/40"}`}>
                                {counts[f.key as keyof typeof counts]}
                            </span>
                        )}
                    </button>
                ))}
            </div>

            {loading ? (
                <div className="space-y-3">
                    {[...Array(4)].map((_, i) => <div key={i} className="bg-white rounded-2xl border border-[#E2E8F0] p-5 animate-pulse h-24" />)}
                </div>
            ) : filtered.length === 0 ? (
                <div className="text-center py-16 bg-white rounded-2xl border border-[#E2E8F0]">
                    <p className="text-4xl mb-3">📭</p>
                    <p className="text-[#A9A9A9] text-sm">Bu kategoride ödev yok</p>
                </div>
            ) : (
                <div className="space-y-3">
                    {filtered.map(a => {
                        const cfg = STATUS_CONFIG[a.status] ?? STATUS_CONFIG.pending;
                        const daysUntil = Math.ceil((new Date(a.dueDate).getTime() - Date.now()) / 86400000);
                        const isOverdue = a.status === "overdue";
                        return (
                            <div key={a.id} className={`bg-white rounded-2xl border p-5 transition-all hover:shadow-md ${isOverdue ? "border-red-200" : "border-[#E2E8F0] hover:border-[#A0AEC0]"}`}>
                                <div className="flex flex-col sm:flex-row sm:items-start justify-between gap-4">
                                    <div className="flex-1 min-w-0">
                                        <div className="flex items-center gap-2 mb-1">
                                            <h3 className="text-[#0A1931] text-sm font-bold">{a.title}</h3>
                                            <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold border ${cfg.color} flex-shrink-0`}>
                                                {cfg.icon} {cfg.label}
                                            </span>
                                        </div>
                                        <p className="text-[#A9A9A9] text-xs mb-2">{a.courseName}</p>
                                        <div className="flex items-center gap-4 text-xs text-[#A0AEC0] mb-3">
                                            <span>📅 {new Date(a.dueDate).toLocaleDateString("tr-TR", { day: "numeric", month: "long" })}</span>
                                            {a.status === "pending" && daysUntil > 0 && (
                                                <span className={daysUntil <= 2 ? "text-amber-500 font-semibold" : ""}>{daysUntil} gün kaldı</span>
                                            )}
                                            <span>🎯 {a.maxScore} puan</span>
                                        </div>

                                        {/* Description and Files */}
                                        <div className="bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl p-4 mb-3">
                                            {a.description ? (
                                                <p className="text-[#5A6A7A] text-sm leading-relaxed whitespace-pre-wrap">{a.description}</p>
                                            ) : (
                                                <p className="text-[#A0AEC0] text-sm italic">Açıklama bulunmuyor.</p>
                                            )}
                                            {a.fileUrl && (
                                                <a href={a.fileUrl} target="_blank" rel="noopener noreferrer" className="inline-flex items-center gap-2 mt-3 px-3 py-1.5 bg-violet-50 text-violet-600 hover:bg-violet-100 hover:text-violet-700 font-semibold text-xs rounded-lg transition-colors border border-violet-100">
                                                    📄 Ek Dosyayı İndir
                                                </a>
                                            )}
                                        </div>

                                        {/* Graded result */}
                                        {a.status === "graded" && a.score !== null && (
                                            <div className="mt-3 p-3 bg-emerald-50 border border-emerald-200 rounded-xl">
                                                <div className="flex items-center gap-3">
                                                    <p className="text-emerald-700 font-bold text-lg">{a.score}<span className="text-[#A9A9A9] text-sm font-normal">/{a.maxScore}</span></p>
                                                    <div className="flex-1">
                                                        <div className="h-1.5 bg-emerald-100 rounded-full overflow-hidden">
                                                            <div className="h-full bg-emerald-500 rounded-full transition-all" style={{ width: `${(a.score / a.maxScore) * 100}%` }} />
                                                        </div>
                                                    </div>
                                                    <span className="text-emerald-600 text-xs font-bold">%{Math.round((a.score / a.maxScore) * 100)}</span>
                                                </div>
                                                {a.feedback && <p className="text-[#1B3B6F] text-xs mt-2 italic">&ldquo;{a.feedback}&rdquo;</p>}
                                            </div>
                                        )}
                                    </div>

                                    {/* Action */}
                                    <div className="flex-shrink-0 w-full sm:w-auto">
                                        {a.status === "pending" && (
                                            <button
                                                onClick={() => setSubmitting(a)}
                                                className="w-full sm:w-auto px-4 py-2 bg-[#0A1931] hover:bg-[#1B3B6F] text-white text-xs font-bold rounded-xl transition-all shadow-md shadow-black/10 hover:shadow-lg"
                                            >
                                                Teslim Et →
                                            </button>
                                        )}
                                        {a.status === "submitted" && (
                                            <span className="block text-center sm:inline-block text-[#1B3B6F] text-xs font-medium bg-blue-50 px-3 py-1.5 rounded-lg border border-blue-200">Değerlendirme bekleniyor</span>
                                        )}
                                    </div>
                                </div>
                            </div>
                        );
                    })}
                </div>
            )}

            {/* Submit modal */}
            {submitting && token && tenantId && (
                <SubmitModal
                    assignment={submitting}
                    token={token}
                    tenantId={tenantId}
                    onClose={() => setSubmitting(null)}
                    onSubmitted={() => { setSubmitting(null); load(); }}
                />
            )}
        </div>
    );
}
