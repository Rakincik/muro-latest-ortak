"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import {
    Video, Search, Trash2, Play, RefreshCw,
    Calendar, Clock, BookOpen, AlertCircle, X
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { ConfirmDialog } from "@/components/confirm-dialog";
import { recordingApi, type RecordingDto } from "@/lib/api";

// ─── Status badge helpers ─────────────────────────────────────────────────────
const STATUS_MAP: Record<string, { label: string; cls: string }> = {
    Ready: { label: "Hazır", cls: "bg-emerald-50 text-emerald-700" },
    Processing: { label: "İşleniyor", cls: "bg-amber-50 text-amber-700 animate-pulse" },
    Failed: { label: "Hata", cls: "bg-red-50 text-red-600" },
    Uploading: { label: "Yükleniyor", cls: "bg-blue-50 text-blue-700 animate-pulse" },
    Published: { label: "Yayımlandı", cls: "bg-[#E2E8F0]/30 text-[#0A1931]" },
};
function StatusBadge({ status }: { status: string }) {
    const s = STATUS_MAP[status] ?? { label: status, cls: "bg-[#E2E8F0]/40 text-[#A9A9A9]" };
    return <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-lg ${s.cls}`}>{s.label}</span>;
}

function fmtDuration(sec: number | null): string {
    if (!sec) return "—";
    const m = Math.floor(sec / 60), s = sec % 60;
    return `${m}:${String(s).padStart(2, "0")}`;
}

// ─── Video Player Modal ───────────────────────────────────────────────────────
function VideoPlayerModal({ rec, onClose }: { rec: RecordingDto; onClose: () => void }) {
    const videoRef = useRef<HTMLVideoElement>(null);

    useEffect(() => {
        const video = videoRef.current;
        if (!video || !rec.hlsPath) return;
        const src = `${process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") || "http://localhost:5292"}${rec.hlsPath}`;

        const load = async () => {
            if (video.canPlayType("application/vnd.apple.mpegurl")) {
                video.src = src;
            } else {
                const Hls = (await import("hls.js")).default;
                if (Hls.isSupported()) {
                    const hls = new Hls();
                    hls.loadSource(src);
                    hls.attachMedia(video);
                    return () => hls.destroy();
                }
            }
        };
        load();
    }, [rec.hlsPath]);

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/80" onClick={onClose}>
            <div className="relative w-full max-w-4xl" onClick={e => e.stopPropagation()}>
                <div className="flex items-center justify-between mb-3">
                    <div>
                        <h3 className="text-white font-semibold text-sm">{rec.sessionTitle}</h3>
                        <p className="text-[#A0AEC0] text-xs">{rec.courseTitle}</p>
                    </div>
                    <button onClick={onClose} className="p-2 rounded-xl bg-white/10 hover:bg-white/20 text-white transition-colors">
                        <X size={16} />
                    </button>
                </div>
                {rec.hlsPath ? (
                    <video
                        ref={videoRef}
                        controls
                        autoPlay
                        className="w-full rounded-2xl bg-black aspect-video"
                        style={{ maxHeight: "70vh" }}
                    />
                ) : (
                    <div className="w-full aspect-video rounded-2xl bg-[#1B3B6F] flex flex-col items-center justify-center text-[#A0AEC0]">
                        <Video size={48} className="opacity-30 mb-3" />
                        <p className="text-sm">Video henüz hazır değil</p>
                        <StatusBadge status={rec.status} />
                    </div>
                )}
            </div>
        </div>
    );
}

// ─── Main Page ────────────────────────────────────────────────────────────────
export default function RecordingsPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [recordings, setRecordings] = useState<RecordingDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState("");
    const [statusFilter, setStatus] = useState("all");
    const [playing, setPlaying] = useState<RecordingDto | null>(null);
    const [deleteId, setDeleteId] = useState<string | null>(null);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const data = await recordingApi.list(token, tenantId);
            setRecordings(data);
        } catch {
            toastError("Hata", "Kayıtlar yüklenemedi.");
        } finally {
            setLoading(false);
        }
    }, [token, tenantId]);

    useEffect(() => { load(); }, [token, tenantId]); // eslint-disable-line react-hooks/exhaustive-deps

    const handleDelete = async () => {
        if (!token || !tenantId || !deleteId) return;
        try {
            await recordingApi.delete(token, tenantId, deleteId);
            setRecordings(prev => prev.filter(r => r.id !== deleteId));
            success("Kayıt silindi");
        } catch {
            toastError("Hata", "Kayıt silinemedi.");
        } finally {
            setDeleteId(null);
        }
    };

    const filtered = recordings.filter(r => {
        const matchSearch = !search || r.sessionTitle.toLowerCase().includes(search.toLowerCase()) || r.courseTitle.toLowerCase().includes(search.toLowerCase());
        const matchStatus = statusFilter === "all" || r.status === statusFilter;
        return matchSearch && matchStatus;
    });

    // Stats
    const ready = recordings.filter(r => r.status === "Ready" || r.status === "Published").length;
    const processing = recordings.filter(r => r.status === "Processing" || r.status === "Uploading").length;
    const failed = recordings.filter(r => r.status === "Failed").length;

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-3xl font-bold text-[#0A1931] tracking-tight flex items-center gap-3">
                        <Video size={28} className="text-[#1B3B6F]" /> Canlı Ders Kayıtları
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-1">BBB kayıtlarını oynatın ve yönetin</p>
                </div>
                <button onClick={load} className="p-2.5 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9] transition-colors">
                    <RefreshCw size={16} />
                </button>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-4 gap-4">
                {[
                    { label: "Toplam Kayıt", value: recordings.length, color: "text-[#1B3B6F]" },
                    { label: "Hazır", value: ready, color: "text-emerald-600" },
                    { label: "İşleniyor", value: processing, color: "text-amber-600" },
                    { label: "Hata", value: failed, color: "text-red-500" },
                ].map(s => (
                    <div key={s.label} className="bg-white rounded-xl border border-[#E2E8F0]/60 p-4">
                        <p className={`text-2xl font-bold ${s.color}`}>{s.value}</p>
                        <p className="text-xs text-[#A0AEC0] mt-0.5">{s.label}</p>
                    </div>
                ))}
            </div>

            {/* Filters */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-4 flex items-center gap-3">
                <div className="flex-1 relative">
                    <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                    <input type="text" placeholder="Oturum veya kurs ara..." value={search} onChange={e => setSearch(e.target.value)}
                        className="w-full pl-9 pr-4 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10" />
                </div>
                <select value={statusFilter} onChange={e => setStatus(e.target.value)}
                    className="px-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10">
                    <option value="all">Tüm Durumlar</option>
                    <option value="Ready">Hazır</option>
                    <option value="Published">Yayımlandı</option>
                    <option value="Processing">İşleniyor</option>
                    <option value="Failed">Hata</option>
                </select>
            </div>

            {/* Table */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 overflow-hidden">
                {loading ? (
                    <div className="p-4 space-y-3">{[...Array(6)].map((_, i) => <div key={i} className="h-16 rounded-xl bg-[#E2E8F0]/40 animate-pulse" />)}</div>
                ) : filtered.length === 0 ? (
                    <div className="py-20 flex flex-col items-center text-[#A0AEC0]">
                        <Video size={40} className="opacity-25 mb-3" />
                        <p className="text-sm font-medium">
                            {recordings.length === 0 ? "Henüz kayıt yok" : "Sonuç bulunamadı"}
                        </p>
                        {recordings.length === 0 && (
                            <p className="text-xs mt-1 text-[#A0AEC0]">Canlı dersler tamamlandıkça kayıtlar burada görünür</p>
                        )}
                    </div>
                ) : (
                    <table className="w-full">
                        <thead className="bg-[#E2E8F0]/20 border-b border-[#E2E8F0]">
                            <tr>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Oturum</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Kurs</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Tarih</th>
                                <th className="text-center px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Süre</th>
                                <th className="text-center px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Durum</th>
                                <th className="text-right px-5 py-3 text-xs font-semibold text-[#A9A9A9]">İşlem</th>
                            </tr>
                        </thead>
                        <tbody>
                            {filtered.map((r, i) => (
                                <tr key={r.id} className={`border-b border-[#E2E8F0] hover:bg-[#E2E8F0]/15 transition-colors ${i % 2 === 0 ? "" : "bg-[#E2E8F0]/5"}`}>
                                    <td className="px-5 py-4">
                                        <div className="flex items-center gap-3">
                                            <div className="w-9 h-9 rounded-xl bg-[#E2E8F0]/30 flex items-center justify-center shrink-0">
                                                <Video size={16} className="text-[#1B3B6F]" />
                                            </div>
                                            <span className="text-sm font-semibold text-[#0A1931] truncate max-w-[200px]">{r.sessionTitle}</span>
                                        </div>
                                    </td>
                                    <td className="px-5 py-4">
                                        <span className="text-xs text-[#A9A9A9] flex items-center gap-1.5">
                                            <BookOpen size={11} />{r.courseTitle}
                                        </span>
                                    </td>
                                    <td className="px-5 py-4">
                                        <span className="text-xs text-[#A9A9A9] flex items-center gap-1.5">
                                            <Calendar size={11} />
                                            {r.scheduledStart
                                                ? new Date(r.scheduledStart).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric" })
                                                : new Date(r.createdAt).toLocaleDateString("tr-TR")}
                                        </span>
                                    </td>
                                    <td className="px-5 py-4 text-center">
                                        <span className="text-xs text-[#A9A9A9] flex items-center justify-center gap-1">
                                            <Clock size={11} />{fmtDuration(r.durationSeconds)}
                                        </span>
                                    </td>
                                    <td className="px-5 py-4 text-center">
                                        <StatusBadge status={r.status} />
                                    </td>
                                    <td className="px-5 py-4 text-right">
                                        <div className="flex items-center justify-end gap-2">
                                            {(r.status === "Ready" || r.status === "Published") && r.hlsPath ? (
                                                <button onClick={() => setPlaying(r)}
                                                    className="p-2 rounded-lg bg-[#E2E8F0]/30 hover:bg-[#E2E8F0]/40 text-[#1B3B6F] transition-colors"
                                                    title="Oynat">
                                                    <Play size={14} />
                                                </button>
                                            ) : (
                                                <button disabled className="p-2 rounded-lg bg-[#E2E8F0]/20 text-[#A0AEC0] cursor-not-allowed" title="Video hazır değil">
                                                    <Play size={14} />
                                                </button>
                                            )}
                                            <button onClick={() => setDeleteId(r.id)}
                                                className="p-2 rounded-lg hover:bg-red-50 text-[#A0AEC0] hover:text-red-600 transition-colors"
                                                title="Sil">
                                                <Trash2 size={14} />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                )}
            </div>

            {playing && <VideoPlayerModal rec={playing} onClose={() => setPlaying(null)} />}
            <ConfirmDialog
                open={deleteId !== null}
                onClose={() => setDeleteId(null)}
                onConfirm={handleDelete}
                title="Kaydı Sil"
                message="Bu kayıt kalıcı olarak silinecek. Bu işlem geri alınamaz."
            />
        </div>
    );
}
