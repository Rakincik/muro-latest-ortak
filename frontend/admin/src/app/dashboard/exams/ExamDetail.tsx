"use client";
import { useState, useMemo } from "react";
import { ArrowLeft, FileText, Clock, Users, Award, BarChart3, Settings, Trash2, ExternalLink, Download, Plus, X, CheckCircle, Upload } from "lucide-react";
import { uploadApi, type ExamDetailDto } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import ExamResultsDashboard from "./ExamResultsDashboard";

const typeColors: Record<string, { bg: string; text: string }> = {
    TYT: { bg: "bg-[#0A1931] text-white", text: "text-white" }, AYT: { bg: "bg-[#1B3B6F] text-white", text: "text-white" },
    Deneme: { bg: "bg-[#1B3B6F] text-white", text: "text-white" }, Quiz: { bg: "bg-[#A9A9A9] text-white", text: "text-white" },
    Genel: { bg: "bg-[#E2E8F0]/40", text: "text-[#1B3B6F]" },
};
const statusStyles: Record<string, { bg: string; text: string; dot: string }> = {
    Taslak: { bg: "bg-[#E2E8F0]/40", text: "text-[#1B3B6F]", dot: "bg-[#A0AEC0]" },
    Yayında: { bg: "bg-emerald-50", text: "text-emerald-700", dot: "bg-emerald-500" },
    Tamamlandı: { bg: "bg-[#E2E8F0]/20", text: "text-[#A9A9A9]", dot: "bg-[#A0AEC0]" },
};
const tabs = [
    { id: "overview", label: "Genel Bakış", icon: FileText },
    { id: "optical", label: "Optik Form", icon: BarChart3 },
    { id: "assignments", label: "Atamalar", icon: Users },
    { id: "results", label: "Sonuçlar", icon: Award },
    { id: "settings", label: "Ayarlar", icon: Settings },
];

interface Props {
    exam: ExamDetailDto;
    onBack: () => void;
    onEdit: () => void;
    onAnswerKeySave: (key: Record<number, string>) => void;
    onStatusChange: (s: string) => void;
    onPdfUpdate: (d: { pdfUrl?: string; solutionPdfUrl?: string }) => void;
    onDelete: () => void;
    onUpdate: (d: Record<string, unknown>) => void;
}

export default function ExamDetail({ exam, onBack, onEdit, onAnswerKeySave, onStatusChange, onPdfUpdate, onDelete, onUpdate }: Props) {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: errToast } = useToast();
    const [tab, setTab] = useState("overview");
    const [answerKey, setAnswerKey] = useState<Record<number, string>>(exam.answerKey || {});
    const [pdfUrl, setPdfUrl] = useState(exam.pdfUrl || "");
    const [solUrl, setSolUrl] = useState(exam.solutionPdfUrl || "");
    const [uploadingPdf, setUploadingPdf] = useState(false);
    const [uploadingSol, setUploadingSol] = useState(false);

    const options = Array.from({ length: exam.optionCount }, (_, i) => String.fromCharCode(65 + i));
    const tc = typeColors[exam.examType] || typeColors.Genel;
    const ss = statusStyles[exam.status] || statusStyles.Taslak;

    const handleUpload = async (file: File, type: 'pdf' | 'sol') => {
        if (!token || !tenantId) return;
        const setter = type === 'pdf' ? setUploadingPdf : setUploadingSol;
        setter(true);
        try {
            const preRes = await uploadApi.getPresignedUrl(token, tenantId, file.name, file.type || "application/pdf");
            const uploadReq = await fetch(preRes.uploadUrl, { method: "PUT", body: file, headers: { "Content-Type": file.type || "application/pdf" } });
            if (!uploadReq.ok) throw new Error("Yükleme başarısız");
            
            if (type === 'pdf') {
                setPdfUrl(preRes.publicUrl);
                onPdfUpdate({ pdfUrl: preRes.publicUrl });
            } else {
                setSolUrl(preRes.publicUrl);
                onPdfUpdate({ solutionPdfUrl: preRes.publicUrl });
            }
            success("Dosya başarıyla yüklendi");
        } catch (err) {
            errToast("Dosya yüklenirken bir hata oluştu");
        } finally {
            setter(false);
        }
    };

    const toggleAnswer = (q: number, opt: string) => {
        setAnswerKey(prev => {
            const next = { ...prev };
            if (next[q] === opt) delete next[q]; else next[q] = opt;
            return next;
        });
    };

    const filledCount = Object.keys(answerKey).length;

    const sections = useMemo<{ name: string, start: number, end: number }[]>(() => {
        if (!exam.sectionsJson) return [];
        try {
            return JSON.parse(exam.sectionsJson);
        } catch { return []; }
    }, [exam.sectionsJson]);
    return (
        <div className="space-y-6">
            {/* Back */}
            <button onClick={onBack} className="flex items-center gap-1.5 text-sm text-[#A9A9A9] hover:text-[#0A1931] transition-colors">
                <ArrowLeft size={16} /> Sınav Listesine Dön
            </button>
            {/* Hero */}
            <div className="relative overflow-hidden rounded-3xl bg-[#0A1931] p-8 text-white shadow-2xl shadow-[#0A1931]900/20">
                <div className="absolute top-0 right-0 w-96 h-96 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2 blur-3xl" />
                <div className="relative">
                    <div className="flex items-center gap-2 mb-4">
                        <span className={`text-[10px] font-bold px-2.5 py-1 rounded-full uppercase tracking-widest bg-white/10`}>{exam.examType}</span>
                        <span className={`text-[10px] font-bold px-2.5 py-1 rounded-full uppercase tracking-widest bg-white/10 flex items-center gap-1.5`}>
                            <span className={`w-1.5 h-1.5 rounded-full ${ss.dot}`} /> {exam.status}
                        </span>
                        <div className="flex-1" />
                        <button onClick={onEdit} className="px-4 py-2 bg-white/10 hover:bg-white/20 rounded-xl text-sm font-bold text-white transition-all flex items-center gap-2">
                             <Settings size={14} /> Düzenle
                        </button>
                    </div>
                    <h1 className="text-4xl font-bold mb-2 tracking-tight">{exam.title}</h1>
                    {exam.description && <p className="text-sm font-medium text-white/50 max-w-2xl leading-relaxed">{exam.description}</p>}
                    <div className="grid grid-cols-4 gap-4 mt-4">
                        {[
                            { label: "Soru", value: exam.questionCount, icon: FileText },
                            { label: "Süre", value: exam.durationMinutes ? `${exam.durationMinutes} dk` : "—", icon: Clock },
                            { label: "Katılımcı", value: exam.resultCount ?? 0, icon: Users },
                            { label: "Ortalama", value: (exam.averageScore !== null && exam.averageScore !== undefined) ? `${exam.averageScore}` : "—", icon: Award },
                        ].map(s => (
                            <div key={s.label} className="bg-white/15 rounded-xl p-3 text-center backdrop-blur-sm">
                                <p className="text-lg font-bold">{s.value}</p>
                                <p className="text-[10px] text-white/70">{s.label}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
            {/* Tabs */}
            <div className="flex gap-1 bg-white rounded-2xl border border-[#E2E8F0]/60 p-1.5 shadow-sm">
                {tabs.map(t => (
                    <button key={t.id} onClick={() => setTab(t.id)}
                        className={`flex-1 flex items-center justify-center gap-2 py-3 rounded-xl text-xs font-bold uppercase tracking-wider transition-all ${tab === t.id ? "bg-[#0A1931] text-white shadow-lg shadow-[#0A1931]900/10" : "text-[#A0AEC0] hover:text-[#1B3B6F] hover:bg-[#E2E8F0]/20"}`}>
                        <t.icon size={14} /> {t.label}
                    </button>
                ))}
            </div>

            {/* ── Tab Content ── */}
            {tab === "overview" && (
                <div className="grid grid-cols-2 gap-4">
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-5 space-y-3">
                        <h3 className="text-sm font-bold text-[#0A1931]">Sınav Bilgileri</h3>
                        {[
                            ["Tip", exam.examType], ["Soru Sayısı", exam.questionCount],
                            ["Seçenek", `${exam.optionCount} (A-${String.fromCharCode(64 + exam.optionCount)})`],
                            ["Süre", exam.durationMinutes ? `${exam.durationMinutes} dk` : "Sınırsız"],
                            ["Cevap Anahtarı", filledCount === exam.questionCount ? `✅ ${filledCount}/${exam.questionCount}` : `⚠️ ${filledCount}/${exam.questionCount}`],
                        ].map(([k, v]) => (
                            <div key={String(k)} className="flex justify-between text-sm"><span className="text-[#A0AEC0]">{k}</span><span className="font-medium text-[#0A1931]">{String(v)}</span></div>
                        ))}
                    </div>
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-5 space-y-3">
                        <h3 className="text-sm font-bold text-[#0A1931]">Zamanlama</h3>
                        {[
                            ["Başlangıç", exam.startDate ? new Date(exam.startDate).toLocaleString("tr-TR") : "Belirlenmedi"],
                            ["Bitiş", exam.endDate ? new Date(exam.endDate).toLocaleString("tr-TR") : "Belirlenmedi"],
                            ["Durum", exam.status], ["Sonuçlar", exam.showResults ? "Görünür" : "Gizli"],
                        ].map(([k, v]) => (
                            <div key={String(k)} className="flex justify-between text-sm"><span className="text-[#A0AEC0]">{k}</span><span className="font-medium text-[#0A1931]">{String(v)}</span></div>
                        ))}
                    </div>
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-5 space-y-3">
                        <h3 className="text-sm font-bold text-[#0A1931]">Dosyalar</h3>
                        {exam.pdfUrl ? <a href={exam.pdfUrl} target="_blank" className="flex items-center gap-2 text-sm text-orange-600 hover:underline"><FileText size={14} /> Sınav PDF <ExternalLink size={12} /></a> : <p className="text-xs text-[#A0AEC0]">PDF yüklenmedi</p>}
                        {exam.solutionPdfUrl ? <a href={exam.solutionPdfUrl} target="_blank" className="flex items-center gap-2 text-sm text-emerald-600 hover:underline"><Download size={14} /> Çözüm Kitapçığı <ExternalLink size={12} /></a> : <p className="text-xs text-[#A0AEC0]">Çözüm yüklenmedi</p>}
                    </div>
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-5 space-y-3">
                        <h3 className="text-sm font-bold text-[#0A1931]">Atamalar</h3>
                        <p className="text-2xl font-bold text-orange-600">{exam.assignmentCount}</p>
                        <p className="text-xs text-[#A0AEC0]">grup/kişi atanmış</p>
                    </div>
                </div>
            )}

            {tab === "optical" && (
                <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-6">
                    <div className="flex items-center justify-between mb-4">
                        <div>
                            <h3 className="text-sm font-bold text-[#0A1931]">Optik Cevap Anahtarı</h3>
                            <p className="text-xs text-[#A0AEC0] mt-0.5">{filledCount}/{exam.questionCount} soru işaretlendi</p>
                        </div>
                        <button onClick={() => { onAnswerKeySave(answerKey); success("Cevap Anahtarı Kaydedildi"); }}
                            className="px-6 py-2.5 text-xs font-bold uppercase tracking-wider bg-[#0A1931] text-white rounded-xl hover:bg-[#1B3B6F] transition-all shadow-lg shadow-[#0A1931]900/10">
                            Kaydet
                        </button>
                    </div>
                    {/* Progress */}
                    <div className="w-full h-3 bg-[#E2E8F0]/40 rounded-full mb-8 overflow-hidden">
                        <div className="h-full bg-[#0A1931] rounded-full transition-all" style={{ width: `${(filledCount / exam.questionCount) * 100}%` }} />
                    </div>
                    {/* Grid */}
                    <div className="overflow-x-auto">
                        {sections.length > 0 ? (
                            <div className="flex gap-6 overflow-x-auto pb-4 custom-scrollbar">
                                {sections.map((sec, idx) => (
                                    <div key={idx} className="min-w-[max-content] shrink-0">
                                        <div className="text-center font-bold text-xs bg-[#1B3B6F] text-white py-1.5 rounded-t-lg">{sec.name}</div>
                                        <table className="w-full border-x border-b border-[#E2E8F0]/60 rounded-b-lg">
                                            <thead>
                                                <tr className="border-b border-[#E2E8F0]/60 bg-gray-50">
                                                    <th className="py-2 px-2 text-left text-xs font-bold text-[#A9A9A9] w-12">#</th>
                                                    {options.map(o => <th key={o} className="py-2 px-1 text-center text-xs font-bold text-[#A9A9A9] w-10">{o}</th>)}
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {Array.from({ length: sec.end - sec.start + 1 }, (_, i) => sec.start + i).map(q => (
                                                    <tr key={q} className={`border-b border-[#E2E8F0] ${q % 2 === 0 ? "bg-[#E2E8F0]/15" : ""}`}>
                                                        <td className="py-1 px-2 text-[11px] font-bold text-[#1B3B6F]">{q - sec.start + 1}</td>
                                                        {options.map(o => (
                                                            <td key={o} className="py-1 px-1 text-center">
                                                                <button onClick={() => toggleAnswer(q, o)}
                                                                    className={`w-8 h-8 rounded-lg border-2 text-[11px] font-bold transition-all ${answerKey[q] === o
                                                                        ? "bg-[#0A1931] border-[#0A1931] text-white scale-110 shadow-sm"
                                                                        : "border-[#E2E8F0]/60 text-[#A0AEC0] hover:border-[#E2E8F0] hover:text-[#A9A9A9]"}`}>
                                                                    {o}
                                                                </button>
                                                            </td>
                                                        ))}
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                ))}
                            </div>
                        ) : (
                            <table className="w-full">
                                <thead>
                                    <tr className="border-b border-[#E2E8F0]/60">
                                        <th className="py-2 px-3 text-left text-xs font-bold text-[#A9A9A9] w-16">#</th>
                                        {options.map(o => <th key={o} className="py-2 px-2 text-center text-xs font-bold text-[#A9A9A9] w-14">{o}</th>)}
                                    </tr>
                                </thead>
                                <tbody>
                                    {Array.from({ length: exam.questionCount }, (_, i) => i + 1).map(q => (
                                        <tr key={q} className={`border-b border-[#E2E8F0] ${q % 2 === 0 ? "bg-[#E2E8F0]/15" : ""}`}>
                                            <td className="py-1.5 px-3 text-xs font-bold text-[#1B3B6F]">{q}</td>
                                            {options.map(o => (
                                                <td key={o} className="py-1.5 px-2 text-center">
                                                    <button onClick={() => toggleAnswer(q, o)}
                                                        className={`w-10 h-10 rounded-xl border-2 text-sm font-bold transition-all ${answerKey[q] === o
                                                            ? "bg-[#0A1931] border-[#E2E8F0] text-white scale-110 shadow-lg shadow-[#0A1931]900/20"
                                                            : "border-[#E2E8F0]/60 text-[#A0AEC0] hover:border-[#E2E8F0] hover:text-[#A9A9A9]"}`}>
                                                        {o}
                                                    </button>
                                                </td>
                                            ))}
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        )}
                    </div>
                </div>
            )}

            {tab === "assignments" && (
                <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-6">
                    <div className="flex items-center justify-between mb-4">
                        <h3 className="text-sm font-bold text-[#0A1931]">Atamalar</h3>
                    </div>
                    {exam.assignments.length > 0 ? (
                        <div className="space-y-2">
                            {exam.assignments.map(a => (
                                <div key={a.id} className="flex items-center justify-between p-3 rounded-xl border border-[#E2E8F0]/60 hover:bg-[#E2E8F0]/20 transition-colors">
                                    <div className="flex items-center gap-3">
                                        <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-xs font-bold ${a.targetType === "Group" ? "bg-[#E2E8F0]/30 text-[#1B3B6F]" : "bg-blue-50 text-blue-600"}`}>
                                            {a.targetType === "Group" ? "G" : "K"}
                                        </div>
                                        <div>
                                            <p className="text-sm font-medium text-[#0A1931]">{a.targetName}</p>
                                            <p className="text-[10px] text-[#A0AEC0]">{a.targetType === "Group" ? "Grup" : "Kişi"} · {new Date(a.assignedAt).toLocaleDateString("tr-TR")}</p>
                                        </div>
                                    </div>
                                    {a.startsAt && <span className="text-[10px] text-[#A0AEC0]">{new Date(a.startsAt).toLocaleDateString("tr-TR")} — {a.endsAt ? new Date(a.endsAt).toLocaleDateString("tr-TR") : "∞"}</span>}
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div className="text-center py-12 text-[#A0AEC0]"><Users size={32} className="mx-auto mb-2 opacity-30" /><p className="text-sm">Henüz atama yapılmadı</p></div>
                    )}
                </div>
            )}

            {tab === "results" && (
                <ExamResultsDashboard exam={exam} onClose={() => setTab("overview")} />
            )}

            {tab === "settings" && (
                <div className="space-y-4">
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-5 space-y-4">
                        <h3 className="text-sm font-bold text-[#0A1931]">Dosya Yönetimi</h3>
                        
                        <div className="grid grid-cols-2 gap-4">
                            {/* Sınav PDF */}
                            <div className={`border-2 border-dashed rounded-xl p-6 text-center transition-all ${pdfUrl ? "border-emerald-300 bg-emerald-50/30" : "border-[#E2E8F0] bg-[#E2E8F0]/10"}`}>
                                <Upload size={28} className={`mx-auto mb-2 ${pdfUrl ? "text-emerald-400" : "text-[#A0AEC0]"}`} />
                                <p className="text-sm font-bold text-[#0A1931] mb-1">Sınav Kitapçığı (PDF)</p>
                                <p className="text-[10px] text-[#A0AEC0] mb-3 uppercase tracking-widest font-semibold">Öğrencilerin göreceği sınav dosyası</p>
                                
                                <input type="file" accept=".pdf" className="hidden" id="exam-pdf-upload-settings" 
                                    onChange={e => e.target.files?.[0] && handleUpload(e.target.files[0], 'pdf')} />
                                
                                {pdfUrl ? (
                                    <div className="flex flex-col items-center gap-2 mt-2">
                                        <div className="flex items-center gap-2">
                                            <span className="text-xs text-emerald-600 font-bold flex items-center gap-1"><CheckCircle size={12} /> Yüklendi</span>
                                            <a href={pdfUrl} target="_blank" className="text-xs text-[#1B3B6F] hover:underline flex items-center gap-1"><ExternalLink size={12}/> Görüntüle</a>
                                        </div>
                                        <div className="flex gap-2 w-full mt-1 px-4">
                                            <button onClick={() => document.getElementById('exam-pdf-upload-settings')?.click()} disabled={uploadingPdf}
                                                className="flex-1 py-1.5 text-xs font-bold bg-[#0A1931] text-white rounded-lg hover:bg-[#1B3B6F] transition-all disabled:opacity-50">
                                                {uploadingPdf ? "Yükleniyor..." : "Değiştir"}
                                            </button>
                                            <button onClick={() => { setPdfUrl(""); onPdfUpdate({ pdfUrl: "" }); success("Sınav PDF Kaldırıldı"); }}
                                                className="flex-1 py-1.5 text-xs font-bold bg-red-100 text-red-600 rounded-lg hover:bg-red-200 transition-all">
                                                Kaldır
                                            </button>
                                        </div>
                                    </div>
                                ) : (
                                    <button onClick={() => document.getElementById('exam-pdf-upload-settings')?.click()} disabled={uploadingPdf}
                                        className="px-6 py-2 text-xs font-bold bg-[#0A1931] text-white rounded-xl hover:bg-[#1B3B6F] transition-all disabled:opacity-50">
                                        {uploadingPdf ? "Yükleniyor..." : "PDF Seç ve Yükle"}
                                    </button>
                                )}
                            </div>

                            {/* Çözüm Kitapçığı PDF */}
                            <div className={`border-2 border-dashed rounded-xl p-6 text-center transition-all ${solUrl ? "border-emerald-300 bg-emerald-50/30" : "border-emerald-200 bg-emerald-50/10"}`}>
                                <FileText size={28} className={`mx-auto mb-2 ${solUrl ? "text-emerald-400" : "text-emerald-300"}`} />
                                <p className="text-sm font-medium text-[#0A1931] mb-1">Çözüm Kitapçığı (PDF)</p>
                                <p className="text-[10px] text-[#A0AEC0] mb-3 uppercase tracking-widest font-semibold">Opsiyonel — sınav sonrası paylaşılır</p>
                                
                                <input type="file" accept=".pdf" className="hidden" id="sol-pdf-upload-settings" 
                                    onChange={e => e.target.files?.[0] && handleUpload(e.target.files[0], 'sol')} />
                                
                                {solUrl ? (
                                    <div className="flex flex-col items-center gap-2 mt-2">
                                        <div className="flex items-center gap-2">
                                            <span className="text-xs text-emerald-600 font-bold flex items-center gap-1"><CheckCircle size={12} /> Yüklendi</span>
                                            <a href={solUrl} target="_blank" className="text-xs text-emerald-700 hover:underline flex items-center gap-1"><ExternalLink size={12}/> Görüntüle</a>
                                        </div>
                                        <div className="flex gap-2 w-full mt-1 px-4">
                                            <button onClick={() => document.getElementById('sol-pdf-upload-settings')?.click()} disabled={uploadingSol}
                                                className="flex-1 py-1.5 text-xs font-bold bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-all disabled:opacity-50">
                                                {uploadingSol ? "Yükleniyor..." : "Değiştir"}
                                            </button>
                                            <button onClick={() => { setSolUrl(""); onPdfUpdate({ solutionPdfUrl: "" }); success("Çözüm PDF Kaldırıldı"); }}
                                                className="flex-1 py-1.5 text-xs font-bold bg-red-100 text-red-600 rounded-lg hover:bg-red-200 transition-all">
                                                Kaldır
                                            </button>
                                        </div>
                                    </div>
                                ) : (
                                    <button onClick={() => document.getElementById('sol-pdf-upload-settings')?.click()} disabled={uploadingSol}
                                        className="px-6 py-2 text-xs font-bold bg-emerald-500 text-white rounded-xl hover:bg-emerald-600 transition-all disabled:opacity-50">
                                        {uploadingSol ? "Yükleniyor..." : "Çözüm PDF Yükle"}
                                    </button>
                                )}
                            </div>
                        </div>
                    </div>
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-5 space-y-4">
                        <h3 className="text-sm font-bold text-[#0A1931]">Durum Yönetimi</h3>
                        <div className="flex gap-2">
                            {["Taslak", "Yayında", "Tamamlandı"].map(s => {
                                const st = statusStyles[s];
                                return (
                                    <button key={s} onClick={() => { onStatusChange(s); success(`Durum: ${s}`); }} className={`flex-1 py-2.5 rounded-xl text-xs font-semibold border-2 transition-all ${exam.status === s ? `${st.bg} ${st.text} border-current` : "border-[#E2E8F0]/60 text-[#A0AEC0] hover:border-[#E2E8F0]"}`}>
                                        {s}
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                    <div className="bg-red-50 rounded-xl border border-red-200/60 p-5">
                        <h3 className="text-sm font-bold text-red-700 mb-2">Tehlikeli Bölge</h3>
                        <p className="text-xs text-red-500 mb-3">Bu sınavı ve tüm sonuçlarını kalıcı olarak siler.</p>
                        <button onClick={onDelete} className="px-4 py-2 text-xs font-medium bg-red-600 text-white rounded-lg hover:bg-red-700 flex items-center gap-1.5"><Trash2 size={12} /> Sınavı Sil</button>
                    </div>
                </div>
            )}
        </div>
    );
}
