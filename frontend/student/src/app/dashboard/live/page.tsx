"use client";

import { useEffect, useState, useCallback, useRef } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { courseApi, studentCalendarApi, type SessionDto, type CalendarEventDto } from "@/lib/api";
import { Radio, Calendar, Clock, Play, Loader2, ChevronRight, ExternalLink } from "lucide-react";
import Link from "next/link";
import { openUrl } from "@/lib/openUrl";
import { useToast } from "@/components/ToastProvider";

export default function LiveSessionsPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [liveSessions, setLiveSessions] = useState<(SessionDto & { courseId: string; courseTitle: string })[]>([]);
    const [calendarEvents, setCalendarEvents] = useState<CalendarEventDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [loadingEvents, setLoadingEvents] = useState(true);
    const [joining, setJoining] = useState<string | null>(null);
    const { showToast } = useToast();

    // Fetch live sessions (visibility-aware polling — pauses when backgrounded)
    const fetchSessions = useCallback(() => {
        if (!token || !tenantId) return;
        courseApi.getUpcomingSessions(token, tenantId)
            .then(sessions => {
                setLiveSessions(sessions.filter(s => s.status === "Live"));
            })
            .catch(console.error)
            .finally(() => setLoading(false));
    }, [token, tenantId]);

    useEffect(() => {
        if (!token || !tenantId) return;
        fetchSessions(); // initial fetch

        let interval: ReturnType<typeof setInterval> | null = null;
        const start = () => { if (!interval) interval = setInterval(fetchSessions, 30000); };
        const stop = () => { if (interval) { clearInterval(interval); interval = null; } };
        const onVisibility = () => {
            if (document.hidden) { stop(); }
            else { fetchSessions(); start(); } // re-fetch immediately on becoming visible
        };

        if (!document.hidden) start();
        document.addEventListener("visibilitychange", onVisibility);
        return () => { stop(); document.removeEventListener("visibilitychange", onVisibility); };
    }, [token, tenantId, fetchSessions]);

    // Fetch upcoming calendar events
    useEffect(() => {
        if (!token || !tenantId) return;
        const now = new Date();
        const oneMonthLater = new Date(now);
        oneMonthLater.setMonth(oneMonthLater.getMonth() + 1);

        studentCalendarApi.getEvents(token, tenantId, now.toISOString(), oneMonthLater.toISOString())
            .then(events => {
                // Filter future events and sort by start date
                const upcoming = events
                    .filter(e => new Date(e.startDate) > now)
                    .sort((a, b) => new Date(a.startDate).getTime() - new Date(b.startDate).getTime())
                    .slice(0, 8);
                setCalendarEvents(upcoming);
            })
            .catch(console.error)
            .finally(() => setLoadingEvents(false));
    }, [token, tenantId]);

    const handleJoin = async (session: SessionDto & { courseId: string }) => {
        if (!token || !tenantId) return;
        setJoining(session.id);
        try {
            const result = await courseApi.joinSession(token, tenantId, session.courseId, session.id);
            await openUrl(result.joinUrl);
        } catch (err) {
            console.error("Join hatası:", err);
            showToast("Derse katılım sağlanamadı. Lütfen tekrar deneyin.", "error");
        } finally {
            setJoining(null);
        }
    };

    const getEventColor = (color: string | null, eventType: string) => {
        if (color) return color;
        switch (eventType) {
            case "Session": return "#1B3B6F";
            case "Exam": return "#DC2626";
            case "Assignment": return "#D97706";
            default: return "#6B7280";
        }
    };

    const getEventLabel = (eventType: string) => {
        switch (eventType) {
            case "Session": return "Ders";
            case "Exam": return "Sınav";
            case "Assignment": return "Ödev";
            case "Holiday": return "Tatil";
            default: return "Etkinlik";
        }
    };

    return (
        <div className="max-w-4xl mx-auto space-y-10">
            <div>
                <h1 className="text-2xl font-bold text-[#0A1931] mb-1 flex items-center gap-2">
                    <Radio size={22} className="text-red-500" /> Canlı Dersler
                </h1>
                <p className="text-[#A9A9A9] text-sm">Aktif canlı dersler ve yaklaşan etkinlikler</p>
            </div>

            {/* ── Şu An Canlı ── */}
            <div>
                <h2 className="text-[#0A1931] font-semibold mb-4 flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-red-500 animate-pulse" />
                    Şu An Canlı
                </h2>
                {loading ? (
                    <div className="glass-card p-5 animate-pulse h-24" />
                ) : liveSessions.length === 0 ? (
                    <div className="glass-card p-10 text-center border-dashed">
                        <div className="w-14 h-14 rounded-2xl bg-red-50 flex items-center justify-center mx-auto mb-3">
                            <Radio size={24} className="text-red-300" />
                        </div>
                        <p className="text-[#0A1931] font-medium mb-1">Şu an aktif canlı ders yok</p>
                        <p className="text-[#A9A9A9] text-xs">Canlı ders başladığında buradan katılabilirsiniz</p>
                    </div>
                ) : (
                    <div className="space-y-4">
                        {liveSessions.map(s => (
                            <div key={s.id} className="relative overflow-hidden rounded-2xl border border-red-200 bg-gradient-to-r from-red-50 via-white to-red-50/30 p-6 shadow-sm hover:shadow-md transition-all">
                                {/* Animated pulse border */}
                                <div className="absolute top-0 left-0 w-1.5 h-full bg-gradient-to-b from-red-500 to-red-600 rounded-l-2xl" />

                                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pl-3">
                                    <div className="flex items-center gap-4 flex-1 min-w-0">
                                        <div className="w-14 h-14 rounded-2xl bg-red-100 flex items-center justify-center shrink-0">
                                            <span className="w-5 h-5 rounded-full bg-red-500 animate-pulse shadow-lg shadow-red-500/40" />
                                        </div>
                                        <div className="flex-1 min-w-0">
                                            <h3 className="text-[#0A1931] font-bold text-base truncate">{s.title}</h3>
                                            <p className="text-[#A9A9A9] text-xs mt-1 truncate">{s.courseTitle}</p>
                                            <p className="text-red-500 text-[11px] mt-1.5 font-medium flex items-center gap-1.5">
                                                <span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse" />
                                                Şu an canlı yayında
                                            </p>
                                        </div>
                                    </div>
                                    <button
                                        onClick={() => handleJoin(s)}
                                        disabled={joining === s.id}
                                        className="shrink-0 flex items-center justify-center gap-2.5 px-7 py-3.5 bg-gradient-to-r from-red-600 to-red-500 hover:from-red-500 hover:to-red-400 disabled:opacity-60 text-white text-sm font-bold rounded-2xl transition-all shadow-lg shadow-red-500/30 hover:shadow-xl hover:shadow-red-500/40 hover:scale-[1.02] active:scale-95 w-full sm:w-auto"
                                    >
                                        {joining === s.id ? (
                                            <Loader2 size={16} className="animate-spin" />
                                        ) : (
                                            <Play size={16} fill="white" />
                                        )}
                                        Derse Katıl
                                        <ExternalLink size={12} className="opacity-60" />
                                    </button>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>

            {/* ── Yaklaşan Etkinlikler (Takvimden) ── */}
            <div>
                <div className="flex items-center justify-between mb-4">
                    <h2 className="text-[#0A1931] font-semibold flex items-center gap-2">
                        <Calendar size={16} className="text-[#A0AEC0]" /> Yaklaşan Etkinlikler
                    </h2>
                    <Link href="/dashboard/calendar" className="text-[#1B3B6F] text-xs font-medium hover:underline flex items-center gap-1">
                        Takvime Git <ChevronRight size={12} />
                    </Link>
                </div>
                {loadingEvents ? (
                    <div className="space-y-2">
                        {[...Array(3)].map((_, i) => <div key={i} className="glass-card p-4 animate-pulse h-16" />)}
                    </div>
                ) : calendarEvents.length === 0 ? (
                    <div className="glass-card p-10 text-center border-dashed">
                        <Calendar size={28} className="text-[#A0AEC0] opacity-40 mx-auto mb-3" />
                        <p className="text-[#A9A9A9] text-sm">Yaklaşan etkinlik yok</p>
                        <Link href="/dashboard/calendar" className="text-[#1B3B6F] text-xs font-medium hover:underline mt-2 inline-block">
                            Takvimi görüntüle →
                        </Link>
                    </div>
                ) : (
                    <div className="space-y-2">
                        {calendarEvents.map(event => {
                            const eventColor = getEventColor(event.color, event.eventType);
                            const startDate = new Date(event.startDate);
                            const isToday = startDate.toDateString() === new Date().toDateString();
                            const isTomorrow = startDate.toDateString() === new Date(Date.now() + 86400000).toDateString();
                            const dayLabel = isToday ? "Bugün" : isTomorrow ? "Yarın" : startDate.toLocaleDateString("tr-TR", { day: "numeric", month: "short" });

                            return (
                                <div key={event.id} className="glass-card p-4 hover:border-[#1B3B6F]/15 transition-all group">
                                    <div className="flex items-center gap-4">
                                        {/* Color indicator */}
                                        <div className="w-1 h-10 rounded-full shrink-0" style={{ backgroundColor: eventColor }} />

                                        {/* Event info */}
                                        <div className="flex-1 min-w-0">
                                            <div className="flex items-center gap-2 mb-0.5">
                                                <p className="text-[#0A1931] text-sm font-medium truncate">{event.title}</p>
                                                <span className="px-1.5 py-0.5 rounded text-[9px] font-bold shrink-0" style={{ backgroundColor: `${eventColor}15`, color: eventColor }}>
                                                    {getEventLabel(event.eventType)}
                                                </span>
                                            </div>
                                            <div className="flex items-center gap-3 text-[#A9A9A9] text-xs">
                                                {event.courseTitle && <span className="truncate">{event.courseTitle}</span>}
                                                {event.groupName && <span className="truncate">• {event.groupName}</span>}
                                            </div>
                                        </div>

                                        {/* Date/Time */}
                                        <div className="text-right shrink-0">
                                            <p className={`text-xs font-semibold ${isToday ? "text-red-500" : "text-[#1B3B6F]"}`}>
                                                {dayLabel}
                                            </p>
                                            <p className="text-[#A9A9A9] text-[11px] flex items-center gap-1 justify-end mt-0.5">
                                                <Clock size={10} />
                                                {startDate.toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                )}
            </div>
        </div>
    );
}
