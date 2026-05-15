"use client";

import { useEffect, useState, useMemo } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { analyticsApi, courseApi, type StudentDashboardDto, type UpcomingSessionDto, type CourseDto } from "@/lib/api";
import Link from "next/link";
import { openUrl } from "@/lib/openUrl";
import { useToast } from "@/components/ToastProvider";
import {
    Play, Clock, Flame, BookOpen, Calendar, CheckCircle2, Video,
    ArrowRight, Zap, Trophy, Target, Star
} from "lucide-react";



export default function StudentDashboardPage() {
    const { user, token, currentTenantId: tenantId } = useAuth();
    const [stats, setStats] = useState<StudentDashboardDto | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(false);
    const [liveSessions, setLiveSessions] = useState<UpcomingSessionDto[]>([]);
    const [upcomingSessions, setUpcomingSessions] = useState<UpcomingSessionDto[]>([]);
    const [courses, setCourses] = useState<CourseDto[]>([]);
    const [joiningId, setJoiningId] = useState<string | null>(null);
    const { showToast } = useToast();

    useEffect(() => {
        if (!token || !tenantId) return;
        setLoading(true); setError(false);
        Promise.all([
            analyticsApi.studentDashboard(token, tenantId).catch(() => null),
            courseApi.getUpcomingSessions(token, tenantId).catch(() => []),
            courseApi.list(token, tenantId).catch(() => []),
        ]).then(([s, sessions, crs]) => {
            setStats(s);
            setLiveSessions((sessions as UpcomingSessionDto[])?.filter?.(s => s.status === "Live") || []);
            setUpcomingSessions((sessions as UpcomingSessionDto[])?.filter?.(s => s.status !== "Live")?.slice(0, 5) || []);
            setCourses((crs as CourseDto[]) || []);
        }).catch(() => setError(true)).finally(() => setLoading(false));
    }, [token, tenantId]);

    const handleJoinLive = async (session: UpcomingSessionDto) => {
        if (!token || !tenantId) return;
        setJoiningId(session.id);
        try {
            const res = await courseApi.joinSession(token, tenantId, session.courseId, session.id);
            await openUrl(res.joinUrl);
        } catch { showToast("Derse katılım sağlanamadı.", "error"); }
        finally { setJoiningId(null); }
    };

    const hours = stats ? Math.floor((stats.totalWatchedMinutes || 0) / 60) : 0;
    const mins = stats ? (stats.totalWatchedMinutes || 0) % 60 : 0;
    const now = new Date();
    const greeting = now.getHours() < 12 ? "Günaydın" : now.getHours() < 18 ? "İyi günler" : "İyi akşamlar";
    const streak = stats?.consecutiveDays || 0;

    // Weekly activity comes from API now, ensure it falls back to empty array if null
    const weeklyData = stats?.weeklyActivity || [];

    return (
        <div className="max-w-7xl mx-auto space-y-6">
            {/* ── Hero Welcome ── */}
            <div className="hero-continue p-6 sm:p-8 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 sm:gap-0 animate-fade-in">
                <div className="relative z-10">
                    <p className="text-white/50 text-sm font-medium mb-1">{greeting} 👋</p>
                    <h1 className="text-3xl font-bold text-white mb-2">{user?.firstName} {user?.lastName}</h1>
                    <p className="text-white/40 text-sm">
                        {new Date().toLocaleDateString("tr-TR", { weekday: "long", day: "numeric", month: "long", year: "numeric" })}
                    </p>
                    {streak > 0 && (
                        <div className="flex items-center gap-2 mt-4 px-4 py-2 bg-white/10 rounded-xl w-fit backdrop-blur-sm border border-white/10">
                            <Flame size={18} className="text-orange-400" />
                            <span className="text-white font-bold text-sm">{streak} Gün</span>
                            <span className="text-white/50 text-xs">kesintisiz çalışma 🔥</span>
                        </div>
                    )}
                </div>
                <div className="hidden md:flex items-center gap-6 relative z-10">
                    {/* Stats in hero */}
                    <div className="text-center">
                        <div className="w-14 h-14 rounded-2xl bg-white/10 flex items-center justify-center mb-2 backdrop-blur-sm border border-white/10">
                            <Clock size={22} className="text-white/70" />
                        </div>
                        <p className="text-white font-bold text-lg">{hours}s {mins}dk</p>
                        <p className="text-white/40 text-[10px]">çalışma süresi</p>
                    </div>
                    <div className="text-center">
                        <div className="w-14 h-14 rounded-2xl bg-white/10 flex items-center justify-center mb-2 backdrop-blur-sm border border-white/10">
                            <Video size={22} className="text-white/70" />
                        </div>
                        <p className="text-white font-bold text-lg">{stats?.completedVideos ?? 0}</p>
                        <p className="text-white/40 text-[10px]">tamamlanan video</p>
                    </div>
                    <div className="text-center">
                        <div className="w-14 h-14 rounded-2xl bg-white/10 flex items-center justify-center mb-2 backdrop-blur-sm border border-white/10">
                            <Target size={22} className="text-white/70" />
                        </div>
                        <p className="text-white font-bold text-lg">%{stats?.attendanceRate ?? 0}</p>
                        <p className="text-white/40 text-[10px]">katılım oranı</p>
                    </div>
                </div>
            </div>

            {/* 🔴 Canlı Ders Banner */}
            {liveSessions?.length > 0 && (
                <div className="space-y-2 animate-fade-in animate-fade-in-delay-1">
                    {liveSessions.map(s => (
                        <div key={s.id} className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 p-4 rounded-2xl bg-red-50 border border-red-200">
                            <div className="flex items-center gap-3 min-w-0 w-full sm:w-auto">
                                <div className="w-10 h-10 rounded-xl bg-red-100 flex items-center justify-center shrink-0">
                                    <span className="w-3 h-3 rounded-full bg-red-500 animate-pulse" />
                                </div>
                                <div className="min-w-0">
                                    <p className="text-[#0A1931] text-sm font-bold truncate">{s.title}</p>
                                    <p className="text-[#A9A9A9] text-xs truncate">{s.courseTitle} • Şu an canlı</p>
                                </div>
                            </div>
                            <button onClick={() => handleJoinLive(s)} disabled={joiningId === s.id}
                                className="shrink-0 w-full sm:w-auto justify-center px-5 py-2.5 bg-red-600 hover:bg-red-500 disabled:opacity-60 text-white text-xs font-bold rounded-xl transition-all hover:scale-105 active:scale-95 flex items-center gap-2 shadow-lg shadow-red-500/25">
                                {joiningId === s.id ? "Bağlanıyor..." : "🔴 Katıl"}
                            </button>
                        </div>
                    ))}
                </div>
            )}

            {/* ── Stats Grid (Mobile) ── */}
            <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 md:hidden animate-fade-in animate-fade-in-delay-1">
                {loading ? Array.from({ length: 4 }).map((_, i) => (
                    <div key={i} className="glass-card p-4"><div className="w-9 h-9 rounded-xl shimmer mb-3" /><div className="h-3 shimmer rounded w-16 mb-2" /><div className="h-6 shimmer rounded w-12" /></div>
                )) : (
                    <>
                        <div className="glass-card p-4 bg-gradient-to-br from-[#1B3B6F]/5 to-[#0A1931]/5">
                            <div className="w-9 h-9 rounded-xl bg-[#1B3B6F]/10 flex items-center justify-center mb-3"><Clock size={16} className="text-[#1B3B6F]" /></div>
                            <p className="text-[#0A1931] text-xl font-bold">{hours}s {mins}dk</p>
                            <p className="text-[#A9A9A9] text-[10px] mt-0.5">çalışma süresi</p>
                        </div>
                        <div className="glass-card p-4 bg-gradient-to-br from-emerald-50 to-green-50">
                            <div className="w-9 h-9 rounded-xl bg-emerald-100 flex items-center justify-center mb-3"><CheckCircle2 size={16} className="text-emerald-600" /></div>
                            <p className="text-[#0A1931] text-xl font-bold">{stats?.completedVideos ?? 0}</p>
                            <p className="text-[#A9A9A9] text-[10px] mt-0.5">tamamlanan video</p>
                        </div>
                        <div className="glass-card p-4 bg-gradient-to-br from-blue-50 to-indigo-50">
                            <div className="w-9 h-9 rounded-xl bg-blue-100 flex items-center justify-center mb-3"><Target size={16} className="text-blue-600" /></div>
                            <p className="text-[#0A1931] text-xl font-bold">%{stats?.attendanceRate ?? 0}</p>
                            <p className="text-[#A9A9A9] text-[10px] mt-0.5">katılım oranı</p>
                        </div>
                        <div className="glass-card p-4 bg-gradient-to-br from-orange-50 to-amber-50">
                            <div className="w-9 h-9 rounded-xl bg-orange-100 flex items-center justify-center mb-3"><Flame size={16} className="text-orange-500" /></div>
                            <p className="text-[#0A1931] text-xl font-bold">{streak} Gün</p>
                            <p className="text-[#A9A9A9] text-[10px] mt-0.5">aktif seri 🔥</p>
                        </div>
                    </>
                )}
            </div>

            <div className="grid grid-cols-12 gap-6">
                {/* ── Left Column ── */}
                <div className="col-span-12 lg:col-span-8 space-y-6">

                    {/* My Courses */}
                    {
                        courses?.length > 0 && (
                            <div className="animate-fade-in animate-fade-in-delay-2">
                                <div className="flex items-center justify-between mb-4">
                                    <h2 className="text-[#0A1931] font-bold text-base flex items-center gap-2">
                                        <BookOpen size={16} className="text-[#1B3B6F]" /> Derslerim
                                    </h2>
                                    <Link href="/dashboard/courses" className="text-xs text-[#1B3B6F] font-semibold hover:text-[#0A1931] flex items-center gap-1">
                                        Tümü <ArrowRight size={12} />
                                    </Link>
                                </div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                                    {courses.slice(0, 4).map(c => (
                                        <Link key={c.id} href={`/dashboard/courses/${c.id}`}
                                            className="glass-card p-4 flex items-center gap-4 group hover:border-[#1B3B6F]/30">
                                            <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-[#1B3B6F]/10 to-[#0A1931]/10 flex items-center justify-center shrink-0">
                                                <BookOpen size={18} className="text-[#1B3B6F]" />
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <p className="text-sm font-semibold text-[#0A1931] truncate group-hover:text-[#1B3B6F] transition-colors">{c.title}</p>
                                                <p className="text-[10px] text-[#A9A9A9] mt-0.5">{c.sessionCount} oturum</p>
                                            </div>
                                            <ArrowRight size={14} className="text-[#A0AEC0] group-hover:text-[#1B3B6F] transition-colors shrink-0" />
                                        </Link>
                                    ))}
                                </div>
                            </div>
                        )
                    }

                    {/* Weekly Activity */}
                    <div className="glass-card p-5 animate-fade-in animate-fade-in-delay-3">
                        <h3 className="text-sm font-bold text-[#0A1931] mb-4 flex items-center gap-2">
                            <Zap size={14} className="text-amber-500" /> Bu Hafta Aktivitesi
                        </h3>
                        {weeklyData?.length > 0 ? (
                            <div className="flex items-end gap-2 justify-between">
                                {weeklyData.map((d, i) => {
                                    const maxMin = Math.max(...weeklyData.map(w => w?.minutes || 0), 1);
                                    const mins = d?.minutes || 0;
                                    const barH = mins > 0 ? Math.max(20, (mins / maxMin) * 80) : 8;
                                    return (
                                        <div key={i} className="flex-1 flex flex-col items-center gap-2">
                                            <div className="w-full max-w-[36px] rounded-lg transition-all group relative"
                                                style={{
                                                    height: `${barH}px`,
                                                    background: d.isToday
                                                        ? "linear-gradient(180deg, #1B3B6F, #0A1931)"
                                                        : d.minutes > 0 ? "#E2E8F0" : "#f1f5f9"
                                                }}>
                                                {d.minutes > 0 && (
                                                    <div className="absolute -top-7 left-1/2 -translate-x-1/2 bg-[#0A1931] text-white text-[9px] font-bold px-1.5 py-0.5 rounded-md whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity">
                                                        {d.minutes}dk
                                                    </div>
                                                )}
                                            </div>
                                            <span className={`text-[10px] font-bold ${d.isToday ? "text-[#1B3B6F]" : "text-[#A9A9A9]"}`}>{d.dayLabel}</span>
                                        </div>
                                    );
                                })}
                            </div>
                        ) : (
                            <div className="text-center py-4 text-[#A9A9A9] text-xs">Henüz aktivite yok</div>
                        )}
                    </div>
                </div >

                {/* ── Right Sidebar ── */}
                < div className="col-span-12 lg:col-span-4 space-y-5" >

                    {/* Quick Actions */}
                    < div className="glass-card p-5 animate-fade-in animate-fade-in-delay-1" >
                        <h3 className="text-sm font-bold text-[#0A1931] mb-3 flex items-center gap-2">
                            <Zap size={14} className="text-[#1B3B6F]" /> Hızlı Erişim
                        </h3>
                        <div className="grid grid-cols-2 gap-2">
                            {[
                                { href: "/dashboard/courses", icon: <BookOpen size={16} />, label: "Derslerim", color: "text-[#1B3B6F] bg-[#1B3B6F]/10" },
                                { href: "/dashboard/assignments", icon: <Target size={16} />, label: "Ödevler", color: "text-amber-600 bg-amber-50" },
                                { href: "/dashboard/exams", icon: <Trophy size={16} />, label: "Sınavlar", color: "text-violet-600 bg-violet-50" },
                                { href: "/dashboard/notes", icon: <Star size={16} />, label: "Notlarım", color: "text-pink-600 bg-pink-50" },
                                { href: "/dashboard/podcast", icon: <Zap size={16} />, label: "Podcast", color: "text-blue-600 bg-blue-50" },
                            ].map(a => (
                                <Link key={a.href} href={a.href}
                                    className="flex items-center gap-2.5 p-3 rounded-xl hover:bg-[#E2E8F0]/30 transition-all group">
                                    <div className={`w-8 h-8 rounded-lg ${a.color} flex items-center justify-center shrink-0`}>{a.icon}</div>
                                    <span className="text-xs font-semibold text-[#0A1931] group-hover:text-[#1B3B6F] transition-colors">{a.label}</span>
                                </Link>
                            ))}
                        </div>
                    </div >

                    {/* Upcoming Sessions */}
                    < div className="glass-card p-5 animate-fade-in animate-fade-in-delay-2" >
                        <div className="flex items-center justify-between mb-3">
                            <h3 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                                <Calendar size={14} className="text-[#1B3B6F]" /> Yaklaşan Dersler
                            </h3>
                            <Link href="/dashboard/calendar" className="text-[10px] text-[#1B3B6F] font-bold hover:text-[#0A1931]">Takvim →</Link>
                        </div>
                        {
                            upcomingSessions?.length > 0 ? (
                                <div className="space-y-2">
                                    {upcomingSessions.map(s => (
                                        <div key={s.id} className="flex items-center gap-3 p-3 rounded-xl bg-[#E2E8F0]/10 hover:bg-[#E2E8F0]/20 transition-colors">
                                            <div className="w-10 h-10 rounded-lg bg-[#1B3B6F]/10 flex items-center justify-center shrink-0">
                                                <Calendar size={14} className="text-[#1B3B6F]" />
                                            </div>
                                            <div className="flex-1 min-w-0">
                                                <p className="text-xs font-semibold text-[#0A1931] truncate">{s.title}</p>
                                                <p className="text-[10px] text-[#A9A9A9] truncate">{s.courseTitle}</p>
                                                {s.scheduledStart && !isNaN(new Date(s.scheduledStart).getTime()) && (
                                                    <p className="text-[10px] text-[#1B3B6F] font-medium mt-0.5">
                                                        {new Date(s.scheduledStart).toLocaleDateString("tr-TR", { day: "numeric", month: "short" })} ·{" "}
                                                        {new Date(s.scheduledStart).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}
                                                    </p>
                                                )}
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            ) : (
                                <div className="text-center py-6 text-[#A9A9A9]">
                                    <Calendar size={24} className="mx-auto opacity-20 mb-2" />
                                    <p className="text-xs">Yaklaşan ders yok</p>
                                </div>
                            )
                        }
                    </div >

                    {/* Motivasyon Kartı */}
                    < div className="glass-card p-5 bg-gradient-to-br from-amber-50 to-orange-50 border-amber-200/40 animate-fade-in animate-fade-in-delay-3" >
                        <div className="flex items-center gap-3 mb-2">
                            <div className="w-10 h-10 rounded-xl bg-amber-100 flex items-center justify-center">
                                <Trophy size={18} className="text-amber-600" />
                            </div>
                            <div>
                                <p className="text-sm font-bold text-[#0A1931]">
                                    {streak >= 7 ? "Muhteşem! 🏆" : streak >= 3 ? "Harika gidiyorsun! ⚡" : "Başlayalım! 🚀"}
                                </p>
                                <p className="text-[10px] text-[#A9A9A9]">
                                    {streak >= 7
                                        ? `${streak} günlük seri — efsane!`
                                        : streak >= 3
                                            ? `${streak} gün üst üste çalıştın`
                                            : "Her gün biraz çalış, fark yarat"}
                                </p>
                            </div>
                        </div>
                    </div >
                </div >
            </div >
        </div >
    );
}
