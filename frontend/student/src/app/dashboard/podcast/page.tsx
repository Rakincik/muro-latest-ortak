"use client";

import { useEffect, useRef, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { podcastApi, PodcastDto } from "@/lib/api";

function formatDuration(secs: number | null): string {
    if (!secs) return "";
    const m = Math.floor(secs / 60);
    const s = secs % 60;
    return `${m}:${s.toString().padStart(2, "0")}`;
}

export default function PodcastPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [podcasts, setPodcasts] = useState<PodcastDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [playing, setPlaying] = useState<PodcastDto | null>(null);
    const [isPlaying, setIsPlaying] = useState(false);
    const [currentTime, setCurrentTime] = useState(0);
    const [duration, setDuration] = useState(0);
    const audioRef = useRef<HTMLAudioElement>(null);

    useEffect(() => {
        if (!token || !tenantId) return;
        podcastApi.list(token, tenantId)
            .then(items => setPodcasts(items.filter(p => p.status === "Ready")))
            .catch(() => setPodcasts([]))
            .finally(() => setLoading(false));
    }, [token, tenantId]);

    const play = (podcast: PodcastDto) => {
        if (playing?.id === podcast.id) {
            if (isPlaying) audioRef.current?.pause();
            else audioRef.current?.play();
            return;
        }
        setPlaying(podcast);
        setIsPlaying(false);
        setTimeout(() => { audioRef.current?.play(); }, 100);
    };

    const pct = duration > 0 ? (currentTime / duration) * 100 : 0;

    return (
        <div className="max-w-3xl mx-auto">
            <h1 className="text-2xl font-bold text-[#0A1931] mb-2">🎙️ Podcast</h1>
            <p className="text-[#A9A9A9] text-sm mb-8">AI tarafından üretilen ders ses içerikleri</p>

            {/* Sticky player bar */}
            {playing && (
                <div className="glass-card p-4 mb-6 border-[#1B3B6F]/25 sticky top-4 z-10">
                    <audio
                        ref={audioRef}
                        src={podcastApi.audioUrl(playing.id)}
                        onTimeUpdate={() => setCurrentTime(audioRef.current?.currentTime ?? 0)}
                        onLoadedMetadata={() => setDuration(audioRef.current?.duration ?? 0)}
                        onPlay={() => setIsPlaying(true)}
                        onPause={() => setIsPlaying(false)}
                        onEnded={() => setIsPlaying(false)}
                    />
                    <div className="flex items-center gap-4">
                        <button
                            onClick={() => isPlaying ? audioRef.current?.pause() : audioRef.current?.play()}
                            className="w-10 h-10 rounded-full bg-[#1B3B6F] hover:bg-[#1B3B6F] flex items-center justify-center text-[#0A1931] flex-shrink-0 transition-all shadow-lg shadow-[#0A1931]/25"
                        >
                            {isPlaying ? "⏸" : "▶"}
                        </button>
                        <div className="flex-1 min-w-0">
                            <p className="text-[#0A1931] text-sm font-medium truncate mb-1.5">{playing.title}</p>
                            {playing.courseTitle && <p className="text-xs text-[#A0AEC0] mb-1">{playing.courseTitle}</p>}
                            <input
                                type="range" min={0} max={duration || 0} value={currentTime}
                                onChange={e => { const t = Number(e.target.value); if (audioRef.current) audioRef.current.currentTime = t; setCurrentTime(t); }}
                                className="w-full h-1 accent-violet-500 cursor-pointer"
                            />
                            <div className="flex justify-between text-xs text-[#A0AEC0] mt-1">
                                <span>{formatDuration(Math.floor(currentTime))}</span>
                                <span>{formatDuration(Math.floor(duration))}</span>
                            </div>
                        </div>
                    </div>
                </div>
            )}

            {/* Podcast list */}
            {loading ? (
                <div className="space-y-3">
                    {[...Array(4)].map((_, i) => (
                        <div key={i} className="glass-card p-5 animate-pulse">
                            <div className="flex gap-4">
                                <div className="w-12 h-12 rounded-xl bg-[#1B3B6F]/50" />
                                <div className="flex-1 space-y-2">
                                    <div className="h-4 bg-[#1B3B6F]/50 rounded w-2/3" />
                                    <div className="h-3 bg-[#1B3B6F]/50 rounded w-1/3" />
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            ) : podcasts.length === 0 ? (
                <div className="text-center py-20">
                    <p className="text-5xl mb-4">🎙️</p>
                    <p className="text-[#A0AEC0] font-medium">Henüz podcast yayınlanmamış.</p>
                    <p className="text-[#A0AEC0] text-sm mt-1">Yeni içerikler için takipte kal!</p>
                </div>
            ) : (
                <div className="space-y-2">
                    {podcasts.map(p => {
                        const isActive = playing?.id === p.id;
                        return (
                            <div
                                key={p.id}
                                className={`glass-card p-5 transition-all cursor-pointer ${isActive ? "border-violet-500/40 bg-[#1B3B6F]/5" : "hover:border-violet-500/20"}`}
                                onClick={() => play(p)}
                            >
                                <div className="flex items-center gap-4">
                                    <div className={`w-12 h-12 rounded-xl flex items-center justify-center text-xl flex-shrink-0 ${isActive && isPlaying ? "bg-[#1B3B6F]/30 animate-pulse" : "bg-[#1B3B6F]/15"}`}>
                                        {isActive && isPlaying ? "🔊" : "🎙️"}
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <h3 className="text-[#0A1931] text-sm font-medium truncate mb-0.5">{p.title}</h3>
                                        <div className="flex items-center gap-3 text-xs text-[#A9A9A9]">
                                            {p.courseTitle && <span>{p.courseTitle}</span>}
                                            {p.durationSeconds && <span>⏱ {formatDuration(p.durationSeconds)}</span>}
                                            <span>{new Date(p.createdAt).toLocaleDateString("tr-TR", { day: "numeric", month: "short" })}</span>
                                        </div>
                                    </div>
                                    {isActive && duration > 0 ? (
                                        <div className="w-12 flex-shrink-0">
                                            <div className="text-right text-xs text-[#A0AEC0] mb-1">{Math.round(pct)}%</div>
                                            <div className="h-1 bg-white/10 rounded-full overflow-hidden">
                                                <div className="h-full bg-[#1B3B6F] rounded-full transition-all" style={{ width: `${pct}%` }} />
                                            </div>
                                        </div>
                                    ) : (
                                        <svg viewBox="0 0 24 24" fill="currentColor" className="w-8 h-8 text-[#E2E8F0] flex-shrink-0">
                                            <path d="M8 6.82v10.36c0 .79.87 1.27 1.54.84l8.14-5.18a1 1 0 0 0 0-1.69L9.54 5.98A1 1 0 0 0 8 6.82Z" />
                                        </svg>
                                    )}
                                </div>
                            </div>
                        );
                    })}
                </div>
            )}
        </div>
    );
}
