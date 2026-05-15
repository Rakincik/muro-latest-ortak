"use client";

import { useEffect, useState, useCallback, useRef } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { courseApi, mediaApi, sessionRecordingApi, videoApi, getFileUrl, type SessionDto, type CourseDto, type MediaAssetDto, type RecordingDto, type VideoNoteDto, type CourseMaterialDto } from "@/lib/api";
import Link from "next/link";
import { useParams, useRouter } from "next/navigation";
import {
    ChevronLeft, Play, BookOpen, Clock, Video, Users, Calendar,
    CheckCircle2, ArrowRight, Layers, FileText, X, Maximize2,
    Minimize2, SkipBack, SkipForward, List, StickyNote, Send, Trash2,
    PanelRightClose, PanelRightOpen, Check, Keyboard, RotateCcw
} from "lucide-react";
import { useVideoPlayer, usePlayerNotes } from "@/hooks/useVideoPlayer";
import { openUrl } from "@/lib/openUrl";
import { useToast } from "@/components/ToastProvider";

// ─── HLS Player Component ──────────────────────────────────────────────────
function HlsVideoPlayer({ src, onLoaded }: { src: string, onLoaded: () => void }) {
    const videoRef = useRef<HTMLVideoElement>(null);
    useEffect(() => {
        const video = videoRef.current;
        if (!video || !src) return;
        const fullSrc = src.startsWith("/") 
            ? `${process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") || "http://localhost:5292"}${src}`
            : src;
            
        const load = async () => {
            if (video.canPlayType("application/vnd.apple.mpegurl")) {
                video.src = fullSrc;
            } else {
                const Hls = (await import("hls.js")).default;
                if (Hls.isSupported()) {
                    const hls = new Hls();
                    hls.loadSource(fullSrc);
                    hls.attachMedia(video);
                    hls.on(Hls.Events.MANIFEST_PARSED, () => {
                        onLoaded();
                    });
                    return () => hls.destroy();
                }
            }
        };
        load();
    }, [src, onLoaded]);
    
    return <video ref={videoRef} controls autoPlay onCanPlay={onLoaded} className="w-full h-full outline-none" />;
}

function fmtDuration(sec: number | null): string {
    if (!sec) return "";
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    return m >= 60 ? `${Math.floor(m / 60)}s ${m % 60}dk` : `${m}:${String(s).padStart(2, "0")}`;
}

type Tab = "sessions" | "videos" | "materials" | "about";

const fmtTime = (sec: number) => {
    const h = Math.floor(sec / 3600);
    const m = Math.floor((sec % 3600) / 60);
    const s = Math.floor(sec % 60);
    return h > 0 ? `${h}:${m.toString().padStart(2, "0")}:${s.toString().padStart(2, "0")}` : `${m}:${s.toString().padStart(2, "0")}`;
};

const fmtClockTime = (iso: string) => {
    try { return new Date(iso).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" }); }
    catch { return "--:--"; }
};

export default function CourseDetailPage() {
    const router = useRouter();
    const { token, currentTenantId: tenantId } = useAuth();
    const params = useParams();
    const courseId = params.courseId as string;

    const [course, setCourse] = useState<CourseDto | null>(null);
    const [sessions, setSessions] = useState<SessionDto[]>([]);
    const [videos, setVideos] = useState<MediaAssetDto[]>([]);
    const [recordings, setRecordings] = useState<RecordingDto[]>([]);
    const [materials, setMaterials] = useState<CourseMaterialDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<Tab>("sessions");
    const [joiningId, setJoiningId] = useState<string | null>(null);
    const { showToast } = useToast();

    // ── Custom hooks — extracted player & notes state ──
    const player = useVideoPlayer(courseId, recordings, token, tenantId, activeTab);
    const playerNotes = usePlayerNotes(player.selectedRec?.id ?? null, token, tenantId);

    // Aliases for backward compatibility with render code
    const { selectedRec, setSelectedRec, isFullscreen, toggleFullscreen, sidebarOpen, setSidebarOpen,
        iframeLoaded, setIframeLoaded, watchedMap, playerContainerRef, sortedRecordings,
        watchedCount, progressPercent, lastWatchedRec } = player;

    // Optimistic note add with backend persist
    const addPlayerNote = async () => {
        if (!playerNotes.noteText.trim()) return;
        const text = playerNotes.noteText.trim();
        playerNotes.setNoteText("");

        const now = new Date().toISOString();
        const tempNote: VideoNoteDto = {
            id: crypto.randomUUID(), mediaAssetId: selectedRec?.id || "",
            timestampSeconds: 0,
            timestampFormatted: fmtClockTime(now),
            text, createdAt: now,
        };
        // Manually add to notes (optimistic)
        playerNotes.addNote();

        // Persist via hook
        if (token && tenantId && selectedRec) {
            try {
                await videoApi.addNote(token, tenantId, selectedRec.id, 0, text);
            } catch { /* keep optimistic note */ }
        }
    };

    const deletePlayerNote = async (noteId: string) => {
        playerNotes.deleteNote(noteId);
    };

    useEffect(() => {
        if (!token || !tenantId || !courseId) return;
        setLoading(true);

        const headers = {
            "Authorization": `Bearer ${token}`,
            "X-Tenant-Id": tenantId,
        };

        // Fetch course detail (includes sessions array)
        const fetchCourse = async () => {
            try {
                const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/courses/${courseId}`, { headers });
                if (res.ok) return await res.json();
            } catch { /* ignore */ }
            return null;
        };

        // Fetch recordings
        const fetchRecordings = async () => {
            try { return await sessionRecordingApi.list(token, tenantId); }
            catch { return []; }
        };

        // Fetch media assets
        const fetchMedia = async () => {
            try { return await mediaApi.list(token, tenantId, { courseId, pageSize: 100 }); }
            catch { return []; }
        };

        // Fetch materials
        const fetchMaterials = async () => {
            try { return await courseApi.getMaterials(token, tenantId, courseId); }
            catch { return []; }
        };

        Promise.all([fetchCourse(), fetchMedia(), fetchRecordings(), fetchMaterials()])
            .then(([courseData, vids, recs, mats]) => {
                setCourse(courseData);
                // Sessions come from course detail response
                const sess = courseData?.sessions ?? [];
                setSessions(sess);
                setVideos(vids);
                // Filter recordings to only this course's sessions
                const courseRecs = (recs as RecordingDto[]).filter(r =>
                    sess.some((s: SessionDto) => s.id === r.sessionId)
                );
                setRecordings(courseRecs.filter((r: RecordingDto) => r.status === "Ready"));
                setMaterials(mats || []);
            })
            .catch(console.error)
            .finally(() => setLoading(false));
    }, [token, tenantId, courseId]);

    const handleJoin = async (session: SessionDto) => {
        if (!token || !tenantId) return;
        setJoiningId(session.id);
        try {
            const res = await courseApi.joinSession(token, tenantId, courseId, session.id);
            await openUrl(res.joinUrl);
        } catch { showToast("Derse katılım sağlanamadı.", "error"); }
        finally { setJoiningId(null); }
    };

    const liveSessions = sessions.filter(s => s.status === "Live");
    const completedSessions = sessions.filter(s => s.status === "Completed");
    const scheduledSessions = sessions.filter(s => s.status === "Scheduled");
    const completedVideos = videos.filter(v => (v.progress?.completionPercentage ?? 0) >= 95);
    const totalVideoCount = videos.length + recordings.length;

    const getStatusBadge = (status: string) => {
        switch (status) {
            case "Live": return <span className="px-2.5 py-1 bg-red-50 text-red-600 text-[10px] font-bold rounded-full border border-red-200 flex items-center gap-1"><span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse" />CANLI</span>;
            case "Completed": return <span className="px-2.5 py-1 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-full border border-emerald-200 flex items-center gap-1"><CheckCircle2 size={10} />Tamamlandı</span>;
            default: return <span className="px-2.5 py-1 bg-[#E2E8F0]/50 text-[#A0AEC0] text-[10px] font-bold rounded-full border border-[#E2E8F0] flex items-center gap-1"><Calendar size={10} />Planlandı</span>;
        }
    };

    const tabs: { key: Tab; label: string; icon: React.ReactNode; count: number }[] = [
        { key: "sessions", label: "Canlı Dersler", icon: <Layers size={14} />, count: liveSessions.length },
        { key: "videos", label: "Videolar", icon: <Video size={14} />, count: totalVideoCount },
        { key: "materials", label: "Dokümanlar", icon: <BookOpen size={14} />, count: materials.length },
        { key: "about", label: "Hakkında", icon: <FileText size={14} />, count: 0 },
    ];

    if (loading) {
        return (
            <div className="max-w-5xl mx-auto">
                <div className="h-4 shimmer rounded w-32 mb-6" />
                <div className="h-48 shimmer rounded-2xl mb-6" />
                <div className="flex gap-3 mb-6">{[1, 2, 3].map(i => <div key={i} className="h-10 shimmer rounded-xl w-32" />)}</div>
                <div className="space-y-3">{[1, 2, 3, 4].map(i => <div key={i} className="h-24 shimmer rounded-2xl" />)}</div>
            </div>
        );
    }

    return (
        <div className="max-w-5xl mx-auto animate-fade-in">
            {/* Breadcrumb */}
            <div className="mb-5">
                <Link href="/dashboard/courses" className="text-[#A9A9A9] text-xs hover:text-[#1B3B6F] transition-colors flex items-center gap-1 w-fit">
                    <ChevronLeft size={14} /> Derslerime Dön
                </Link>
            </div>

            {/* ── Course Hero Card ── */}
            <div className="relative rounded-[2.5rem] overflow-hidden group shadow-2xl shadow-indigo-900/10 bg-[#0A1931] mb-6">
                {course?.thumbnailUrl ? (
                    <>
                        <img src={getFileUrl(course.thumbnailUrl)} alt="Cover" className="absolute inset-0 w-full h-full object-cover opacity-80" />
                        <div className="absolute inset-0 bg-black/60" />
                    </>
                ) : (
                    <div className="absolute inset-0 bg-gradient-to-br from-[#1B3B6F] via-violet-600 to-blue-700" />
                )}
                <div className="absolute inset-0 bg-gradient-to-t from-[#0A1931]/90 via-transparent to-white/5" />
                <div className="relative p-10 flex flex-col md:flex-row items-center gap-8">
                    <div className="w-24 h-24 rounded-3xl bg-white/10 backdrop-blur-xl flex items-center justify-center shadow-2xl ring-1 ring-white/20 overflow-hidden shrink-0">
                        {course?.thumbnailUrl ? (
                            <img src={getFileUrl(course.thumbnailUrl)} alt="Cover" className="w-full h-full object-cover" />
                        ) : (
                            <BookOpen size={40} className="text-white" />
                        )}
                    </div>
                    <div className="flex-1 text-center md:text-left">
                        <div className="flex flex-wrap items-center justify-center md:justify-start gap-3 mb-3">
                            <span className="text-[10px] font-bold uppercase tracking-widest px-3 py-1 rounded-full bg-white/10 text-white/70 border border-white/10">
                                {course?.isPublished ? "Aktif Kurs" : "Taslak"}
                            </span>
                        </div>
                        <h1 className="text-4xl font-black text-white tracking-tight mb-2">{course?.title ?? "Kurs"}</h1>
                        {course?.description && (
                            <p className="text-sm font-medium text-white/60 max-w-xl leading-relaxed line-clamp-2">{course.description}</p>
                        )}
                        <div className="flex items-center justify-center md:justify-start gap-5 mt-4 text-white/50 text-xs">
                            <span className="flex items-center gap-1.5"><Video size={12} />{totalVideoCount} video</span>
                            {liveSessions.length > 0 && (
                                <span className="flex items-center gap-1.5"><span className="w-1.5 h-1.5 rounded-full bg-red-400 animate-pulse" />{liveSessions.length} canlı ders</span>
                            )}
                        </div>
                    </div>
                </div>
            </div>

            {/* ── Tabs ── */}
            <div className="flex items-center gap-2 mb-6 bg-white border border-[#E2E8F0] rounded-2xl p-1.5">
                {tabs.map(tab => (
                    <button key={tab.key} onClick={() => setActiveTab(tab.key)}
                        className={`flex-1 flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold transition-all
                            ${activeTab === tab.key ? "bg-[#0A1931] text-white shadow-sm" : "text-[#A9A9A9] hover:text-[#0A1931] hover:bg-[#E2E8F0]/30"}`}>
                        {tab.icon}
                        {tab.label}
                        {tab.count > 0 && (
                            <span className={`px-1.5 py-0.5 rounded-full text-[9px] font-bold ${activeTab === tab.key ? "bg-white/20" : "bg-[#E2E8F0]/50"}`}>
                                {tab.count}
                            </span>
                        )}
                    </button>
                ))}
            </div>

            {/* ── Canlı Dersler Tab ── */}
            {activeTab === "sessions" && (
                <div className="space-y-3">
                    {liveSessions.map(s => (
                        <div key={s.id} className="glass-card p-6 border-red-200 bg-gradient-to-r from-red-50/50 to-white">
                            <div className="flex items-center justify-between gap-4">
                                <div className="flex items-center gap-4 flex-1 min-w-0">
                                    <div className="w-14 h-14 rounded-2xl bg-red-100 flex items-center justify-center shrink-0">
                                        <span className="w-4 h-4 rounded-full bg-red-500 animate-pulse" />
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <h3 className="text-[#0A1931] font-bold text-base truncate">{s.title}</h3>
                                        <p className="text-red-500 text-xs mt-1 font-medium flex items-center gap-1">
                                            <span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse" /> Şu an canlı yayında
                                        </p>
                                    </div>
                                </div>
                                <button onClick={() => handleJoin(s)} disabled={joiningId === s.id}
                                    className="px-6 py-3 bg-red-600 hover:bg-red-500 disabled:opacity-60 text-white text-sm font-bold rounded-xl transition-all hover:scale-105 flex items-center gap-2 shadow-lg shadow-red-500/25">
                                    {joiningId === s.id ? "Bağlanıyor..." : "🔴 Katıl"}
                                </button>
                            </div>
                        </div>
                    ))}
                    {liveSessions.length === 0 && (
                        <div className="glass-card p-16 text-center border-dashed">
                            <div className="w-16 h-16 rounded-2xl bg-[#E2E8F0]/30 flex items-center justify-center mx-auto mb-4">
                                <Video size={28} className="text-[#A0AEC0] opacity-50" />
                            </div>
                            <p className="text-[#0A1931] font-semibold mb-1">Şu an canlı ders yok</p>
                            <p className="text-[#A9A9A9] text-sm">Canlı ders başladığında buradan katılabilirsiniz</p>
                        </div>
                    )}
                </div>
            )}

            {/* ── Videos Tab — Udemy-style Player ── */}
            {activeTab === "videos" && (() => {
                const activeRec = selectedRec || sortedRecordings[0];
                const activeIdx = activeRec ? sortedRecordings.findIndex(r => r.id === activeRec.id) : -1;
                if (!activeRec) return (
                    <div className="glass-card p-12 text-center border-dashed">
                        <Video size={32} className="mx-auto text-[#A0AEC0] opacity-30 mb-3" />
                        <p className="text-[#0A1931] font-semibold mb-1">Henüz video yok</p>
                        <p className="text-[#A9A9A9] text-sm">Bu kurs için video eklendiğinde burada görünecek</p>
                    </div>
                );
                return (
                    <div ref={playerContainerRef} className={`${isFullscreen ? 'fixed inset-0 z-[100] bg-white' : ''}`}>
                        {/* ── Resume Banner ── */}
                        {!selectedRec && lastWatchedRec && (
                            <button onClick={() => setSelectedRec(lastWatchedRec)}
                                className="w-full mb-3 flex items-center gap-3 px-4 py-3 bg-gradient-to-r from-[#1B3B6F] to-[#0A1931] text-white rounded-xl shadow-md hover:shadow-lg transition-all group">
                                <RotateCcw size={16} className="shrink-0 group-hover:rotate-[-360deg] transition-transform duration-700" />
                                <div className="flex-1 text-left">
                                    <p className="text-xs font-semibold">Kaldığın yerden devam</p>
                                    <p className="text-[10px] text-white/70">{lastWatchedRec.sessionTitle}</p>
                                </div>
                                <ArrowRight size={14} className="shrink-0 group-hover:translate-x-1 transition-transform" />
                            </button>
                        )}

                        {/* ── Player + Sidebar Row ── */}
                        <div className={`flex flex-col md:flex-row border border-[#E2E8F0] rounded-2xl overflow-hidden shadow-lg ${isFullscreen ? 'h-screen rounded-none border-0' : ''}`}>
                            {/* ── Left: Video + Bottom Tabs ── */}
                            <div className="flex-1 flex flex-col min-w-0">
                                {/* Video iframe area */}
                                <div className={`bg-[#F8F9FA] relative group/player ${isFullscreen ? 'flex-1' : 'aspect-video'}`}>
                                    {/* Loading skeleton */}
                                    {!iframeLoaded && (
                                        <div className="absolute inset-0 z-[5] bg-[#F8F9FA] flex items-center justify-center">
                                            <div className="text-center">
                                                <div className="w-16 h-16 rounded-full border-4 border-[#E2E8F0] border-t-[#1B3B6F] animate-spin mx-auto mb-3" />
                                                <p className="text-sm text-[#A0AEC0] font-medium">Video yükleniyor...</p>
                                            </div>
                                        </div>
                                    )}
                                    {activeRec.hlsPath ? (
                                        <HlsVideoPlayer 
                                            key={activeRec.id} 
                                            src={activeRec.hlsPath} 
                                            onLoaded={() => setIframeLoaded(true)} 
                                        />
                                    ) : (
                                        <iframe
                                            key={activeRec.id}
                                            src={activeRec.playbackUrl || ""}
                                            className="w-full h-full border-0"
                                            allow="autoplay; fullscreen"
                                            allowFullScreen
                                            title={activeRec.sessionTitle}
                                            onLoad={() => setIframeLoaded(true)}
                                        />
                                    )}

                                    {/* ── Floating Controls Overlay ── */}
                                    <div className="absolute top-3 right-3 flex items-center gap-2 z-10">
                                        {/* Sidebar toggle */}
                                        <button onClick={() => setSidebarOpen(prev => !prev)}
                                            className="flex items-center gap-1.5 px-3 py-2 bg-white/95 hover:bg-white shadow-lg rounded-lg border border-[#E2E8F0] text-[#0A1931] text-xs font-semibold transition-all hover:shadow-xl"
                                            title={sidebarOpen ? 'İçeriği Gizle' : 'İçeriği Göster'}>
                                            {sidebarOpen ? <PanelRightClose size={16} /> : <PanelRightOpen size={16} />}
                                            <span className="hidden sm:inline">{sidebarOpen ? 'Gizle' : 'İçerik'}</span>
                                        </button>
                                        {/* Fullscreen */}
                                        <button onClick={toggleFullscreen}
                                            className="flex items-center gap-1.5 px-3 py-2 bg-[#1B3B6F] hover:bg-[#0A1931] shadow-lg rounded-lg text-white text-xs font-semibold transition-all hover:shadow-xl"
                                            title={isFullscreen ? 'Küçült' : 'Tam Ekran'}>
                                            {isFullscreen ? <Minimize2 size={16} /> : <Maximize2 size={16} />}
                                            <span className="hidden sm:inline">{isFullscreen ? 'Küçült' : 'Tam Ekran'}</span>
                                        </button>
                                    </div>
                                </div>

                                {/* Bottom Tabs area */}
                                <div className={`bg-white border-t border-[#E2E8F0] ${isFullscreen ? 'hidden' : ''}`}>
                                    {/* Tab headers */}
                                    <div className="flex border-b border-[#E2E8F0] px-5">
                                        <button onClick={() => playerNotes.setSideTab("playlist")}
                                            className={`py-3 px-4 text-sm font-semibold border-b-2 transition-colors ${playerNotes.sideTab === "playlist" ? "border-[#1B3B6F] text-[#0A1931]" : "border-transparent text-[#A0AEC0] hover:text-[#0A1931]"}`}>
                                            Genel Bakış
                                        </button>
                                        <button onClick={() => playerNotes.setSideTab("notes")}
                                            className={`py-3 px-4 text-sm font-semibold border-b-2 transition-colors flex items-center gap-1.5 ${playerNotes.sideTab === "notes" ? "border-[#1B3B6F] text-[#0A1931]" : "border-transparent text-[#A0AEC0] hover:text-[#0A1931]"}`}>
                                            <StickyNote size={13} /> Notlar
                                        </button>
                                    </div>

                                    {/* Tab content */}
                                    <div className="p-5 max-h-[200px] overflow-y-auto">
                                        {playerNotes.sideTab === "playlist" ? (
                                            <div>
                                                <h3 className="text-sm font-bold text-[#0A1931] mb-2">{activeRec.sessionTitle}</h3>
                                                <p className="text-xs text-[#A9A9A9]">
                                                    {new Date(activeRec.scheduledStart || activeRec.createdAt).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric" })}
                                                    {activeRec.durationSeconds && activeRec.durationSeconds > 0 && ` • ${fmtDuration(activeRec.durationSeconds)}`}
                                                </p>
                                                {course?.description && <p className="text-xs text-[#5A6A7A] mt-3 leading-relaxed">{course.description}</p>}
                                            </div>
                                        ) : (
                                            <div>
                                                {playerNotes.notes.length === 0 && (
                                                    <p className="text-xs text-[#A9A9A9] text-center py-4">Henüz not eklemediniz. Aşağıdan not ekleyebilirsiniz.</p>
                                                )}
                                                {playerNotes.notes.map((note: VideoNoteDto) => (
                                                    <div key={note.id} className="group flex items-start gap-3 p-2 mb-1 rounded-lg hover:bg-[#F0F4FF] transition-colors">
                                                        <span className="text-[10px] font-mono text-[#1B3B6F] bg-[#E8F0FE] px-1.5 py-0.5 rounded shrink-0 mt-0.5">🕐 {fmtClockTime(note.createdAt)}</span>
                                                        <p className="text-xs text-[#5A6A7A] flex-1">{note.text}</p>
                                                        <button onClick={() => deletePlayerNote(note.id)}
                                                            className="opacity-0 group-hover:opacity-100 text-[#A0AEC0] hover:text-red-500 transition-all shrink-0">
                                                            <Trash2 size={12} />
                                                        </button>
                                                    </div>
                                                ))}
                                                <div className="mt-3 pt-3 border-t border-[#E2E8F0]">
                                                    <p className="text-[10px] text-[#A0AEC0] mb-1.5">📝 Not ekle</p>
                                                    <div className="flex gap-2">
                                                        <input type="text" value={playerNotes.noteText} onChange={e => playerNotes.setNoteText(e.target.value)}
                                                            onKeyDown={e => e.key === "Enter" && addPlayerNote()}
                                                            placeholder="Not yazın..."
                                                            className="flex-1 bg-[#F8F9FA] border border-[#E2E8F0] rounded-lg px-3 py-2 text-xs text-[#0A1931] placeholder:text-[#A0AEC0] focus:outline-none focus:border-[#1B3B6F] transition-colors" />
                                                        <button onClick={addPlayerNote} disabled={!playerNotes.noteText.trim()}
                                                            className="px-3 py-2 bg-[#1B3B6F] hover:bg-[#0A1931] disabled:opacity-30 text-white rounded-lg text-xs font-semibold transition-all">
                                                            Ekle
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            </div>

                            {/* ── Right: Kurs İçeriği Sidebar (collapsible) ── */}
                            <div className={`bg-white border-l border-[#E2E8F0] flex flex-col shrink-0 transition-all duration-300 ${sidebarOpen ? 'w-full md:w-80' : 'w-0 overflow-hidden border-l-0'}`}>
                                {/* Header */}
                                <div className="h-12 flex items-center justify-between px-4 border-b border-[#E2E8F0] shrink-0">
                                    <span className="text-sm font-bold text-[#0A1931] whitespace-nowrap">Kurs İçeriği</span>
                                    <button onClick={() => setSidebarOpen(false)} className="text-[#A0AEC0] hover:text-[#0A1931] transition-colors p-1" title="Gizle">
                                        <X size={14} />
                                    </button>
                                </div>

                                {/* Progress bar + summary */}
                                <div className="px-4 py-2.5 border-b border-[#E2E8F0] bg-[#F8F9FA] shrink-0">
                                    <div className="flex items-center justify-between mb-1.5">
                                        <p className="text-[11px] text-[#5A6A7A] font-medium whitespace-nowrap">
                                            {watchedCount} / {sortedRecordings.length} tamamlandı
                                        </p>
                                        <span className="text-[10px] text-[#1B3B6F] font-bold">%{progressPercent}</span>
                                    </div>
                                    <div className="w-full h-1.5 bg-[#E2E8F0] rounded-full overflow-hidden">
                                        <div className="h-full bg-gradient-to-r from-[#1B3B6F] to-[#4A7CFF] rounded-full transition-all duration-500" style={{ width: `${progressPercent}%` }} />
                                    </div>
                                </div>

                                {/* Session list */}
                                <div className="flex-1 overflow-y-auto">
                                    {sortedRecordings.map((rec, idx) => {
                                        const isActive = rec.id === activeRec.id;
                                        return (
                                            <button key={rec.id} onClick={() => setSelectedRec(rec)}
                                                className={`w-full text-left px-4 py-3 border-b border-[#F0F0F0] transition-all flex items-start gap-3 group ${isActive ? "bg-[#E8F0FE]" : "hover:bg-[#F8F9FA]"}`}>
                                                {/* Watch status indicator */}
                                                <div className={`w-5 h-5 rounded border flex items-center justify-center shrink-0 mt-0.5 transition-colors ${isActive ? "bg-[#1B3B6F] border-[#1B3B6F]" : watchedMap[rec.id] ? "bg-emerald-500 border-emerald-500" : "border-[#D0D5DD]"}`}>
                                                    {isActive ? <Play size={10} className="text-white ml-0.5" /> : watchedMap[rec.id] ? <Check size={10} className="text-white" /> : <span className="text-[9px] text-[#A0AEC0] font-medium">{idx + 1}</span>}
                                                </div>
                                                <div className="flex-1 min-w-0">
                                                    <p className={`text-[12px] font-medium leading-tight ${isActive ? "text-[#0A1931]" : "text-[#5A6A7A] group-hover:text-[#0A1931]"}`}>
                                                        {rec.sessionTitle}
                                                    </p>
                                                    <div className="flex items-center gap-2 mt-1">
                                                        <span className="text-[10px] text-[#A0AEC0] flex items-center gap-0.5">
                                                            <Video size={8} />
                                                            {rec.durationSeconds && rec.durationSeconds > 0 ? fmtDuration(rec.durationSeconds) : "Kayıt"}
                                                        </span>
                                                        {rec.scheduledStart && (
                                                            <span className="text-[10px] text-[#A0AEC0]">
                                                                {new Date(rec.scheduledStart).toLocaleDateString("tr-TR", { day: "numeric", month: "short" })}
                                                            </span>
                                                        )}
                                                    </div>
                                                </div>
                                            </button>
                                        );
                                    })}
                                </div>
                            </div>
                        </div>
                    </div>
                );
            })()}
            {/* ── Materials Tab ── */}
            {activeTab === "materials" && (
                <div className="space-y-3">
                    {materials.length === 0 ? (
                        <div className="glass-card p-12 text-center border-dashed">
                            <FileText size={32} className="mx-auto text-[#A0AEC0] opacity-30 mb-3" />
                            <p className="text-[#0A1931] font-semibold mb-1">Henüz doküman yok</p>
                            <p className="text-[#A9A9A9] text-sm">Bu kurs için henüz herhangi bir materyal eklenmemiş.</p>
                        </div>
                    ) : (
                        materials.map(m => (
                            <div key={m.id} className="glass-card p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 hover:shadow-md transition-shadow group">
                                <div className="flex items-center gap-4 flex-1 min-w-0">
                                    <div className={`w-12 h-12 rounded-2xl flex items-center justify-center shrink-0 ${m.contentType.includes("pdf") ? "bg-red-50 text-red-500" : m.contentType.includes("word") || m.contentType.includes("doc") ? "bg-blue-50 text-blue-500" : m.contentType.includes("sheet") || m.contentType.includes("xls") ? "bg-emerald-50 text-emerald-500" : "bg-[#E2E8F0]/30 text-[#A0AEC0]"}`}>
                                        <FileText size={20} />
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <h3 className="text-[#0A1931] font-bold text-sm truncate">{m.title}</h3>
                                        <div className="flex items-center gap-3 mt-1 text-xs text-[#A0AEC0]">
                                            <span>{(m.fileSize / 1024 / 1024).toFixed(2)} MB</span>
                                            <span>•</span>
                                            <span>{new Date(m.createdAt).toLocaleDateString("tr-TR")}</span>
                                        </div>
                                    </div>
                                </div>
                                <a href={getFileUrl(m.filePath)} target="_blank" rel="noopener noreferrer"
                                    className="px-5 py-2.5 bg-[#F8F9FA] hover:bg-[#1B3B6F] text-[#0A1931] hover:text-white text-xs font-bold rounded-xl transition-all shadow-sm border border-[#E2E8F0] shrink-0 w-full sm:w-auto text-center">
                                    Görüntüle / İndir
                                </a>
                            </div>
                        ))
                    )}
                </div>
            )}

            {/* ── About Tab ── */}
            {
                activeTab === "about" && (
                    <div className="space-y-5">
                        <div className="glass-card p-6">
                            <h3 className="text-sm font-bold text-[#0A1931] mb-3 flex items-center gap-2">
                                <BookOpen size={14} className="text-[#1B3B6F]" /> Kurs Bilgileri
                            </h3>
                            <p className="text-[#A9A9A9] text-sm leading-relaxed">
                                {course?.description || "Bu kurs için henüz bir açıklama eklenmemiş."}
                            </p>
                        </div>
                        <div className="grid grid-cols-3 gap-4">
                            <div className="glass-card p-5 text-center bg-gradient-to-br from-[#1B3B6F]/5 to-[#0A1931]/5">
                                <Layers size={20} className="mx-auto text-[#1B3B6F] mb-2" />
                                <p className="text-xl font-bold text-[#0A1931]">{sessions.length}</p>
                                <p className="text-[10px] text-[#A9A9A9] mt-0.5">Oturum</p>
                            </div>
                            <div className="glass-card p-5 text-center bg-gradient-to-br from-emerald-50 to-green-50">
                                <Video size={20} className="mx-auto text-emerald-600 mb-2" />
                                <p className="text-xl font-bold text-[#0A1931]">{videos.length}</p>
                                <p className="text-[10px] text-[#A9A9A9] mt-0.5">Video</p>
                            </div>
                            <div className="glass-card p-5 text-center bg-gradient-to-br from-amber-50 to-orange-50">
                                <CheckCircle2 size={20} className="mx-auto text-amber-600 mb-2" />
                                <p className="text-xl font-bold text-[#0A1931]">{completedVideos.length}</p>
                                <p className="text-[10px] text-[#A9A9A9] mt-0.5">Tamamladığın</p>
                            </div>
                        </div>
                    </div>
                )
            }
        </div >
    );
}
