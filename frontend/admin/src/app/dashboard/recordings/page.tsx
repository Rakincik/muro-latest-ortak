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

// â”€â”€â”€ Status badge helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const STATUS_MAP: Record<string, { label: string; cls: string }> = {
    Ready: { label: "HazÄ±r", cls: "bg-emerald-50 text-emerald-700" },
    Processing: { label: "Ä°ÅŸleniyor", cls: "bg-amber-50 text-amber-700 animate-pulse" },
    Failed: { label: "Hata", cls: "bg-red-50 text-red-600" },
    Uploading: { label: "YÃ¼kleniyor", cls: "bg-blue-50 text-blue-700 animate-pulse" },
    Published: { label: "YayÄ±mlandÄ±", cls: "bg-[#E2E8F0]/30 text-[#0A1931]" },
};
function StatusBadge({ status }: { status: string }) {
    const s = STATUS_MAP[status] ?? { label: status, cls: "bg-[#E2E8F0]/40 text-[#A9A9A9]" };
    return <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-lg ${s.cls}`}>{s.label}</span>;
}

function fmtDuration(sec: number | null): string {
    if (!sec) return "â€”";
    const m = Math.floor(sec / 60), s = sec % 60;
    return `${m}:${String(s).padStart(2, "0")}`;
}

// â”€â”€â”€ Video Player Modal â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
function VideoPlayerModal({ rec, onClose }: { rec: RecordingDto; onClose: () => void }) {
    const videoRef = useRef<HTMLVideoElement>(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        if (!rec.hlsPath) {
            setIsLoading(false);
            return;
        }
        const video = videoRef.current;
        if (!video) return;
        
        const src = `${process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") || "http://localhost:5292"}${rec.hlsPath}`;

        let hls: any = null;
        let player: any = null;

        const initPlyr = async () => {
            const Plyr = (await import("plyr")).default;
            await import("plyr/dist/plyr.css");
            player = new Plyr(video, {
                controls: ['play-large', 'play', 'progress', 'current-time', 'mute', 'volume', 'captions', 'settings', 'pip', 'airplay', 'fullscreen'],
                settings: ['captions', 'quality', 'speed']
            });
        };

        const load = async () => {
            if (video.canPlayType("application/vnd.apple.mpegurl")) {
                video.src = src;
                video.addEventListener('loadedmetadata', () => {
                    setIsLoading(false);
                    initPlyr();
                });
            } else {
                const Hls = (await import("hls.js")).default;
                if (Hls.isSupported()) {
                    hls = new Hls();
                    hls.loadSource(src);
                    hls.attachMedia(video);
                    hls.on(Hls.Events.MANIFEST_PARSED, () => {
                        setIsLoading(false);
                        initPlyr();
                    });
                }
            }
        };
        load();

        return () => {
            if (hls) hls.destroy();
            if (player) player.destroy();
        };
    }, [rec.hlsPath]);

    const isBBB = !rec.hlsPath && rec.playbackUrl;

    return (
        <div className="fixed inset-0 z-[120] flex items-center justify-center bg-black/90 backdrop-blur-xl animate-in fade-in duration-300" onClick={onClose}>
            <div className="absolute top-6 right-6">
                <button onClick={onClose} className="p-3 bg-white/10 hover:bg-white/20 text-white rounded-full transition-all hover:scale-105 backdrop-blur-md border border-white/10" title="Kapat">
                    <X size={24} />
                </button>
            </div>

            <div className="w-full max-w-6xl mx-auto px-6 flex flex-col items-center" onClick={e => e.stopPropagation()}>
                <div className="w-full mb-6 flex justify-between items-end">
                    <div>
                        <h2 className="text-white text-2xl font-semibold tracking-tight">{rec.sessionTitle}</h2>
                        <p className="text-gray-400 text-sm mt-1">{rec.courseTitle} • {rec.status}</p>
                    </div>
                </div>

                <div className="relative w-full aspect-video bg-black rounded-3xl overflow-hidden border border-white/10 shadow-[0_0_100px_rgba(0,0,0,0.5)] ring-1 ring-white/5">
                    {isLoading && !isBBB && (
                        <div className="absolute inset-0 flex items-center justify-center bg-[#09090B] z-10">
                            <div className="flex flex-col items-center gap-4">
                                <div className="p-4 bg-white/5 rounded-2xl animate-pulse">
                                    <div className="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin" />
                                </div>
                                <span className="text-gray-400 text-sm font-medium tracking-wide">Yükleniyor...</span>
                            </div>
                        </div>
                    )}
                    
                    {rec.hlsPath ? (
                        <video ref={videoRef} className="w-full h-full object-contain outline-none bg-black" crossOrigin="anonymous" />
                    ) : isBBB ? (
                        <iframe src={rec.playbackUrl} className="w-full h-full border-0" allowFullScreen />
                    ) : (
                        <div className="absolute inset-0 flex items-center justify-center bg-[#09090B] z-10 p-6 text-center">
                            <div className="flex flex-col items-center gap-3 text-[#A0AEC0]">
                                <Video size={48} className="opacity-30 mb-2" />
                                <p className="text-sm">Video henüz hazır değil veya işleniyor.</p>
                                <StatusBadge status={rec.status} />
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}

// â”€â”€â”€ Main Page â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
            toastError("Hata", "KayÄ±tlar yÃ¼klenemedi.");
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
            success("KayÄ±t silindi");
        } catch {
            toastError("Hata", "KayÄ±t silinemedi.");
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
                        <Video size={28} className="text-[#1B3B6F]" /> CanlÄ± Ders KayÄ±tlarÄ±
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-1">BBB kayÄ±tlarÄ±nÄ± oynatÄ±n ve yÃ¶netin</p>
                </div>
                <button onClick={load} className="p-2.5 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9] transition-colors">
                    <RefreshCw size={16} />
                </button>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-4 gap-4">
                {[
                    { label: "Toplam KayÄ±t", value: recordings.length, color: "text-[#1B3B6F]" },
                    { label: "HazÄ±r", value: ready, color: "text-emerald-600" },
                    { label: "Ä°ÅŸleniyor", value: processing, color: "text-amber-600" },
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
                    <option value="all">TÃ¼m Durumlar</option>
                    <option value="Ready">HazÄ±r</option>
                    <option value="Published">YayÄ±mlandÄ±</option>
                    <option value="Processing">Ä°ÅŸleniyor</option>
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
                            {recordings.length === 0 ? "HenÃ¼z kayÄ±t yok" : "SonuÃ§ bulunamadÄ±"}
                        </p>
                        {recordings.length === 0 && (
                            <p className="text-xs mt-1 text-[#A0AEC0]">CanlÄ± dersler tamamlandÄ±kÃ§a kayÄ±tlar burada gÃ¶rÃ¼nÃ¼r</p>
                        )}
                    </div>
                ) : (
                    <table className="w-full">
                        <thead className="bg-[#E2E8F0]/20 border-b border-[#E2E8F0]">
                            <tr>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Oturum</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Kurs</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Tarih</th>
                                <th className="text-center px-5 py-3 text-xs font-semibold text-[#A9A9A9]">SÃ¼re</th>
                                <th className="text-center px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Durum</th>
                                <th className="text-right px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Ä°ÅŸlem</th>
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
                                                <button disabled className="p-2 rounded-lg bg-[#E2E8F0]/20 text-[#A0AEC0] cursor-not-allowed" title="Video hazÄ±r deÄŸil">
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
                title="KaydÄ± Sil"
                message="Bu kayÄ±t kalÄ±cÄ± olarak silinecek. Bu iÅŸlem geri alÄ±namaz."
            />
        </div>
    );
}


