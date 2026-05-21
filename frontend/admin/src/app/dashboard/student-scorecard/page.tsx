"use client";

import { useState, useEffect, useMemo, useCallback } from "react";
import {
    Search, User, BarChart3, Video, BookOpen, FileText,
    Clock, Activity, Download, X, TrendingUp, TrendingDown,
    Monitor, Globe, ChevronDown, Eye, RefreshCw, Users
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import {
    analyticsAdminApi,
    notificationApi,
    type UserDto,
    type StudentScorecardDto,
    type ScorecardSummaryDto,
    type DeviceSessionDto,
} from "@/lib/api";

function CountUp({ target, duration = 600 }: { target: number; duration?: number }) {
    const [val, setVal] = useState(0);
    useEffect(() => {
        if (target === 0) { setVal(0); return; }
        const start = Date.now();
        const frame = () => {
            const elapsed = Date.now() - start;
            const p = Math.min(elapsed / duration, 1);
            setVal(Math.round(target * (1 - Math.pow(1 - p, 3))));
            if (p < 1) requestAnimationFrame(frame);
        };
        requestAnimationFrame(frame);
    }, [target, duration]);
    return <>{val}</>;
}

function rateColor(rate: number) {
    if (rate >= 80) return "text-emerald-600";
    if (rate >= 60) return "text-amber-600";
    return "text-red-600";
}
function rateBg(rate: number) {
    if (rate >= 80) return "bg-emerald-500";
    if (rate >= 60) return "bg-amber-500";
    return "bg-red-500";
}

function timeAgo(dateStr: string) {
    const diff = Date.now() - new Date(dateStr).getTime();
    const m = Math.floor(diff / 60000);
    if (m < 1) return "Az önce";
    if (m < 60) return `${m}dk önce`;
    const h = Math.floor(m / 60);
    if (h < 24) return `${h}sa önce`;
    const d = Math.floor(h / 24);
    if (d < 30) return `${d}g önce`;
    return `${Math.floor(d / 30)}ay önce`;
}

function formatDuration(loginAt: string, logoutAt: string | null) {
    const end = logoutAt ? new Date(logoutAt).getTime() : Date.now();
    const mins = Math.floor((end - new Date(loginAt).getTime()) / 60000);
    if (mins < 60) return `${mins} dk`;
    return `${Math.floor(mins / 60)}sa ${mins % 60}dk`;
}

// ─── Scorecard Detail Panel ─────────────────────────────────────────────────
function ScorecardPanel({ user, classAvg, sessions, onClose }: {
    user: UserDto; classAvg: StudentScorecardDto | null;
    sessions: DeviceSessionDto[]; onClose: () => void;
}) {
    const { token, currentTenantId: tenantId } = useAuth();
    const [card, setCard] = useState<StudentScorecardDto | null>(null);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState<"overview" | "sessions">("overview");

    useEffect(() => {
        if (!token || !tenantId) return;
        setLoading(true);
        analyticsAdminApi.studentScorecard(token, tenantId, user.id)
            .then(setCard).catch(console.error).finally(() => setLoading(false));
    }, [token, tenantId, user.id]);

    const userSessions = sessions.filter(s => s.userId === user.id)
        .sort((a, b) => new Date(b.loginAt).getTime() - new Date(a.loginAt).getTime());

    return (
        <div className="fixed inset-0 z-[100] flex" onClick={onClose}>
            <div className="absolute inset-0 bg-black/30 backdrop-blur-sm" />
            <div className="ml-auto relative w-full max-w-[560px] bg-white shadow-2xl border-l border-[#E2E8F0] overflow-y-auto h-full" onClick={e => e.stopPropagation()}>
                {/* Header */}
                <div className="sticky top-0 bg-white z-10 px-6 py-4 border-b border-[#E2E8F0]">
                    <div className="flex items-center justify-between">
                        <div className="flex items-center gap-3">
                            <div className="w-11 h-11 rounded-full bg-gradient-to-br from-[#1B3B6F] to-[#0A1931] flex items-center justify-center text-white font-bold text-sm shadow-lg">
                                {user.firstName[0]}{user.lastName[0]}
                            </div>
                            <div>
                                <p className="font-bold text-[#0A1931]">{user.firstName} {user.lastName}</p>
                                <p className="text-xs text-[#A0AEC0]">{user.email}</p>
                            </div>
                        </div>
                        <button onClick={onClose} className="p-2 rounded-xl bg-[#E2E8F0]/20 text-[#A0AEC0] hover:text-[#0A1931]"><X size={16} /></button>
                    </div>
                    {/* Tab bar */}
                    <div className="flex mt-3 bg-[#E2E8F0]/30 rounded-xl p-0.5">
                        <button onClick={() => setActiveTab("overview")} className={`flex-1 py-1.5 rounded-lg text-xs font-bold transition-all ${activeTab === "overview" ? "bg-white text-[#0A1931] shadow-sm" : "text-[#A0AEC0]"}`}>📊 Genel Bakış</button>
                        <button onClick={() => setActiveTab("sessions")} className={`flex-1 py-1.5 rounded-lg text-xs font-bold transition-all ${activeTab === "sessions" ? "bg-white text-[#0A1931] shadow-sm" : "text-[#A0AEC0]"}`}>🔐 Giriş Geçmişi ({userSessions.length})</button>
                    </div>
                </div>

                {loading ? (
                    <div className="p-6 space-y-3">{[...Array(5)].map((_, i) => <div key={i} className="h-16 rounded-xl bg-[#E2E8F0]/40 animate-pulse" />)}</div>
                ) : !card ? (
                    <div className="p-12 text-center"><User size={40} className="text-[#A9A9A9] mx-auto mb-3" /><p className="text-[#A0AEC0] text-sm">Veri bulunamadı</p></div>
                ) : activeTab === "overview" ? (
                    <div className="p-6 space-y-5">
                        {/* KPI Grid */}
                        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                            {[
                                { label: "İzleme Süresi", value: `${card.totalWatchedMinutes}dk`, icon: Video, color: "text-violet-600", bg: "bg-violet-50" },
                                { label: "Video", value: `${card.completedVideos}/${card.totalVideos}`, icon: Eye, color: "text-blue-600", bg: "bg-blue-50" },
                                { label: "Devam", value: `${card.attendanceRate.toFixed(0)}%`, icon: BookOpen, color: rateColor(card.attendanceRate), bg: card.attendanceRate >= 80 ? "bg-emerald-50" : card.attendanceRate >= 60 ? "bg-amber-50" : "bg-red-50" },
                                { label: "Oturum", value: `${card.attendedSessions}/${card.totalSessions}`, icon: Users, color: "text-[#1B3B6F]", bg: "bg-[#1B3B6F]/5" },
                                { label: "Sınav Ort.", value: card.avgExamScore > 0 ? card.avgExamScore.toFixed(1) : "—", icon: FileText, color: "text-orange-600", bg: "bg-orange-50" },
                                { label: "Ödev", value: String(card.submittedAssignments), icon: Clock, color: "text-teal-600", bg: "bg-teal-50" },
                            ].map(s => (
                                <div key={s.label} className={`${s.bg} rounded-xl border border-[#E2E8F0]/60 p-3`}>
                                    <s.icon size={14} className={s.color + " mb-1"} />
                                    <p className={`text-lg font-bold ${s.color}`}>{s.value}</p>
                                    <p className="text-[10px] text-[#A0AEC0]">{s.label}</p>
                                </div>
                            ))}
                        </div>

                        {/* Progress Bars with Class Average Comparison */}
                        <div className="space-y-4">
                            <h4 className="text-xs font-bold text-[#A0AEC0] uppercase tracking-widest">Sınıf Ortalaması Karşılaştırma</h4>
                            {[
                                { label: "Devam Oranı", value: card.attendanceRate, avg: classAvg?.attendanceRate ?? 0 },
                                { label: "Video Tamamlama", value: card.videoCompletionRate, avg: classAvg?.videoCompletionRate ?? 0 },
                                { label: "Sınav Ortalaması", value: card.avgExamScore, avg: classAvg?.avgExamScore ?? 0 },
                            ].map(row => {
                                const diff = row.avg > 0 ? row.value - row.avg : 0;
                                const isAbove = diff >= 0;
                                return (
                                    <div key={row.label}>
                                        <div className="flex items-center justify-between mb-1">
                                            <span className="text-xs text-[#0A1931] font-medium">{row.label}</span>
                                            <div className="flex items-center gap-2">
                                                <span className={`text-xs font-bold ${rateColor(row.value)}`}>{row.value.toFixed(0)}%</span>
                                                {row.avg > 0 && (
                                                    <span className={`text-[10px] font-bold flex items-center gap-0.5 px-1.5 py-0.5 rounded ${isAbove ? "bg-emerald-50 text-emerald-600" : "bg-red-50 text-red-500"}`}>
                                                        {isAbove ? <TrendingUp size={9} /> : <TrendingDown size={9} />}
                                                        {isAbove ? "+" : ""}{diff.toFixed(0)}
                                                    </span>
                                                )}
                                            </div>
                                        </div>
                                        <div className="relative h-2.5 bg-[#E2E8F0]/40 rounded-full overflow-hidden">
                                            <div className={`h-full rounded-full transition-all duration-700 ${rateBg(row.value)}`}
                                                style={{ width: `${Math.min(row.value, 100)}%` }} />
                                            {row.avg > 0 && (
                                                <div className="absolute top-0 h-full w-0.5 bg-[#0A1931]/40"
                                                    style={{ left: `${Math.min(row.avg, 100)}%` }}
                                                    title={`Sınıf ort: ${row.avg.toFixed(0)}%`} />
                                            )}
                                        </div>
                                        {row.avg > 0 && <p className="text-[9px] text-[#A0AEC0] mt-0.5">Sınıf ortalaması: {row.avg.toFixed(0)}%</p>}
                                    </div>
                                );
                            })}
                        </div>

                        {/* Last Login Info */}
                        {userSessions.length > 0 && (
                            <div className="bg-[#E2E8F0]/10 rounded-xl border border-[#E2E8F0]/40 p-4">
                                <h4 className="text-xs font-bold text-[#A0AEC0] uppercase tracking-widest mb-2">Son Giriş Bilgisi</h4>
                                <div className="grid grid-cols-2 gap-3">
                                    <div>
                                        <p className="text-[10px] text-[#A0AEC0]">Son Giriş</p>
                                        <p className="text-xs font-bold text-[#0A1931]">{timeAgo(userSessions[0].loginAt)}</p>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-[#A0AEC0]">Toplam Oturum</p>
                                        <p className="text-xs font-bold text-[#0A1931]">{userSessions.length}</p>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-[#A0AEC0]">Cihaz</p>
                                        <p className="text-xs font-bold text-[#0A1931]">{userSessions[0].deviceInfo || "—"}</p>
                                    </div>
                                    <div>
                                        <p className="text-[10px] text-[#A0AEC0]">IP Adresi</p>
                                        <p className="text-xs font-bold text-[#0A1931]">{userSessions[0].ipAddress || "—"}</p>
                                    </div>
                                </div>
                            </div>
                        )}
                    </div>
                ) : (
                    /* Sessions Tab */
                    <div className="p-6">
                        {userSessions.length === 0 ? (
                            <div className="py-12 text-center text-[#A0AEC0]"><Globe size={32} className="mx-auto opacity-20 mb-2" /><p className="text-sm">Oturum verisi yok</p></div>
                        ) : (
                            <div className="space-y-2">
                                {userSessions.map(s => (
                                    <div key={s.id} className={`flex items-center gap-3 p-3 rounded-xl border ${s.isActive ? "bg-emerald-50/50 border-emerald-200" : "border-[#E2E8F0]/40"}`}>
                                        <div className={`w-2 h-2 rounded-full flex-shrink-0 ${s.isActive ? "bg-emerald-500 animate-pulse" : "bg-[#E2E8F0]"}`} />
                                        <div className="flex-1 min-w-0">
                                            <div className="flex items-center gap-2">
                                                <span className="text-xs font-bold text-[#0A1931]">
                                                    {new Date(s.loginAt).toLocaleDateString("tr-TR", { day: "numeric", month: "short", year: "numeric" })}
                                                </span>
                                                <span className="text-[10px] text-[#A0AEC0]">
                                                    {new Date(s.loginAt).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}
                                                </span>
                                                {s.isActive && <span className="text-[8px] font-bold bg-emerald-100 text-emerald-700 px-1.5 py-0.5 rounded-full">ÇEVRİMİÇİ</span>}
                                            </div>
                                            <div className="flex items-center gap-3 mt-0.5">
                                                <span className="text-[10px] text-[#A0AEC0] flex items-center gap-0.5"><Monitor size={9} />{s.deviceInfo || "—"}</span>
                                                {s.ipAddress && <span className="text-[10px] text-[#A0AEC0] flex items-center gap-0.5"><Globe size={9} />{s.ipAddress}</span>}
                                            </div>
                                        </div>
                                        <div className="text-right flex-shrink-0">
                                            <p className="text-[10px] text-[#A0AEC0] flex items-center gap-0.5 justify-end"><Clock size={9} />{formatDuration(s.loginAt, s.logoutAt)}</p>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}

// ─── MAIN PAGE ────────────────────────────────────────────────────────────────
export default function StudentScorecardPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [users, setUsers] = useState<UserDto[]>([]);
    const [scorecards, setScorecards] = useState<Map<string, StudentScorecardDto>>(new Map());
    const [sessions, setSessions] = useState<DeviceSessionDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [loadingCards, setLoadingCards] = useState(false);
    const [search, setSearch] = useState("");
    const [selected, setSelected] = useState<UserDto | null>(null);
    const [sortBy, setSortBy] = useState<"name" | "attendance" | "video" | "exam">("name");

    // Load users + sessions
    useEffect(() => {
        if (!token || !tenantId) return;
        setLoading(true);
        Promise.all([
            notificationApi.allUsers(token, tenantId),
            analyticsAdminApi.activeSessions(token, tenantId).catch(() => []),
        ]).then(([u, sess]) => {
            const students = u.filter(x => x.role === "Student" || x.role === "student");
            setUsers(students);
            setSessions(sess);

            // Load scorecards for all students
            if (students.length > 0) {
                setLoadingCards(true);
                Promise.all(
                    students.slice(0, 50).map(s =>
                        analyticsAdminApi.studentScorecard(token, tenantId, s.id)
                            .then(card => ({ userId: s.id, card }))
                            .catch(() => null)
                    )
                ).then(results => {
                    const map = new Map<string, StudentScorecardDto>();
                    results.forEach(r => { if (r) map.set(r.userId, r.card); });
                    setScorecards(map);
                }).finally(() => setLoadingCards(false));
            }
        }).catch(console.error).finally(() => setLoading(false));
    }, [token, tenantId]);

    // Class averages — from backend summary endpoint
    const [classAvgSummary, setClassAvgSummary] = useState<ScorecardSummaryDto | null>(null);
    useEffect(() => {
        if (!token || !tenantId) return;
        analyticsAdminApi.scorecardSummary(token, tenantId)
            .then(setClassAvgSummary)
            .catch(console.error);
    }, [token, tenantId]);

    // Adapt summary to classAvg shape for comparison bars
    const classAvg = useMemo<StudentScorecardDto | null>(() => {
        if (!classAvgSummary) return null;
        return {
            userId: "", fullName: "", email: "",
            attendedSessions: classAvgSummary.avgAttendedSessions,
            totalSessions: classAvgSummary.avgTotalSessions,
            attendanceRate: classAvgSummary.avgAttendanceRate,
            completedVideos: classAvgSummary.avgCompletedVideos,
            totalVideos: classAvgSummary.avgTotalVideos,
            videoCompletionRate: classAvgSummary.avgVideoCompletionRate,
            totalWatchedMinutes: classAvgSummary.avgTotalWatchedMinutes,
            submittedAssignments: classAvgSummary.avgSubmittedAssignments,
            avgExamScore: classAvgSummary.avgExamScore,
        };
    }, [classAvgSummary]);

    // Filter + sort
    const filtered = useMemo(() => {
        let list = users.filter(u => !search ||
            `${u.firstName} ${u.lastName}`.toLowerCase().includes(search.toLowerCase()) ||
            u.email.toLowerCase().includes(search.toLowerCase()));

        if (sortBy !== "name") {
            list = [...list].sort((a, b) => {
                const ca = scorecards.get(a.id);
                const cb = scorecards.get(b.id);
                if (!ca && !cb) return 0;
                if (!ca) return 1;
                if (!cb) return -1;
                if (sortBy === "attendance") return cb.attendanceRate - ca.attendanceRate;
                if (sortBy === "video") return cb.videoCompletionRate - ca.videoCompletionRate;
                if (sortBy === "exam") return cb.avgExamScore - ca.avgExamScore;
                return 0;
            });
        }
        return list;
    }, [users, search, sortBy, scorecards]);

    // CSV export
    const exportCSV = useCallback(() => {
        const header = "Ad Soyad,E-posta,Devam %,Video %,İzleme (dk),Sınav Ort.,Ödev,Aktif\n";
        const rows = filtered.map(u => {
            const c = scorecards.get(u.id);
            return `"${u.firstName} ${u.lastName}","${u.email}","${c?.attendanceRate.toFixed(0) ?? '—'}","${c?.videoCompletionRate.toFixed(0) ?? '—'}","${c?.totalWatchedMinutes ?? '—'}","${c?.avgExamScore.toFixed(1) ?? '—'}","${c?.submittedAssignments ?? '—'}","${u.isActive ? 'Evet' : 'Hayır'}"`;
        }).join("\n");
        const blob = new Blob(["\uFEFF" + header + rows], { type: "text/csv;charset=utf-8;" });
        const a = document.createElement("a"); a.href = URL.createObjectURL(blob);
        a.download = `ogrenci_karneleri_${new Date().toISOString().slice(0, 10)}.csv`; a.click();
    }, [filtered, scorecards]);

    return (
        <div className="space-y-5">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <User size={22} className="text-[#1B3B6F]" /> Öğrenci Karnesi
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-0.5">Detaylı performans ve aktivite profili</p>
                </div>
                <div className="flex items-center gap-2">
                    {filtered.length > 0 && (
                        <button onClick={exportCSV} className="px-3 py-2 text-xs font-bold bg-white border border-[#E2E8F0] rounded-xl text-[#1B3B6F] hover:bg-[#E2E8F0]/20 flex items-center gap-1.5">
                            <Download size={12} /> CSV İndir
                        </button>
                    )}
                </div>
            </div>

            {/* Class Average KPIs */}
            {classAvg && (
                <div className="flex lg:grid lg:grid-cols-5 gap-3 overflow-x-auto hide-scrollbar pb-2 snap-x">
                    {[
                        { label: "Öğrenci Sayısı", value: String(users.length), icon: Users, color: "text-[#1B3B6F]", bg: "bg-[#1B3B6F]/5" },
                        { label: "Ort. Devam", value: `${classAvg.attendanceRate.toFixed(0)}%`, icon: BookOpen, color: rateColor(classAvg.attendanceRate), bg: classAvg.attendanceRate >= 80 ? "bg-emerald-50" : "bg-amber-50" },
                        { label: "Ort. Video", value: `${classAvg.videoCompletionRate.toFixed(0)}%`, icon: Video, color: "text-blue-600", bg: "bg-blue-50" },
                        { label: "Ort. Sınav", value: classAvg.avgExamScore > 0 ? classAvg.avgExamScore.toFixed(1) : "—", icon: FileText, color: "text-orange-600", bg: "bg-orange-50" },
                        { label: "Ort. İzleme", value: `${classAvg.totalWatchedMinutes}dk`, icon: Clock, color: "text-violet-600", bg: "bg-violet-50" },
                    ].map(s => (
                        <div key={s.label} className={`min-w-[140px] lg:min-w-0 shrink-0 snap-start ${s.bg} rounded-xl border border-[#E2E8F0]/60 p-4 flex items-center gap-3`}>
                            <s.icon size={16} className={s.color} />
                            <div>
                                <p className={`text-lg font-bold ${s.color}`}>{s.value}</p>
                                <p className="text-[10px] text-[#A0AEC0] font-medium">{s.label}</p>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {/* Search + Sort */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-3 flex flex-col sm:flex-row items-center gap-3">
                <div className="w-full sm:flex-1 relative">
                    <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                    <input type="text" placeholder="Öğrenci ara..." value={search} onChange={e => setSearch(e.target.value)}
                        className="w-full pl-8 pr-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10" />
                </div>
                <div className="w-full sm:w-auto flex items-center gap-3">
                    <select value={sortBy} onChange={e => setSortBy(e.target.value as typeof sortBy)}
                        className="flex-1 sm:flex-none px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                        <option value="name">İsme Göre</option>
                        <option value="attendance">Devam Oranına Göre</option>
                        <option value="video">Video Tamamlamaya Göre</option>
                        <option value="exam">Sınav Ortalamasına Göre</option>
                    </select>
                    <span className="text-xs text-[#A0AEC0] font-bold shrink-0">{filtered.length} öğrenci</span>
                </div>
            </div>

            {/* Student Table */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 overflow-x-auto">
                {loading ? (
                    <div className="p-4 space-y-2">{[...Array(6)].map((_, i) => <div key={i} className="h-14 rounded-xl bg-[#E2E8F0]/40 animate-pulse" />)}</div>
                ) : filtered.length === 0 ? (
                    <div className="py-16 text-center"><User size={32} className="text-[#A9A9A9] mx-auto mb-2" /><p className="text-sm text-[#A0AEC0]">Öğrenci bulunamadı</p></div>
                ) : (
                    <table className="w-full">
                        <thead className="bg-[#E2E8F0]/15 border-b border-[#E2E8F0]">
                            <tr>
                                <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Öğrenci</th>
                                <th className="text-center px-3 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Devam</th>
                                <th className="text-center px-3 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Video</th>
                                <th className="text-center px-3 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">İzleme</th>
                                <th className="text-center px-3 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Sınav</th>
                                <th className="text-center px-3 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Ödev</th>
                                <th className="text-center px-3 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Durum</th>
                                <th className="text-right px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase"></th>
                            </tr>
                        </thead>
                        <tbody>
                            {filtered.map((u, idx) => {
                                const c = scorecards.get(u.id);
                                const lastSession = sessions.filter(s => s.userId === u.id).sort((a, b) => new Date(b.loginAt).getTime() - new Date(a.loginAt).getTime())[0];
                                return (
                                    <tr key={u.id} onClick={() => setSelected(u)}
                                        className={`border-b border-[#E2E8F0]/40 hover:bg-[#E2E8F0]/10 cursor-pointer transition-colors ${idx % 2 === 0 ? "" : "bg-[#E2E8F0]/5"}`}>
                                        <td className="px-4 py-3">
                                            <div className="flex items-center gap-3">
                                                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-[#1B3B6F] to-[#0A1931] flex items-center justify-center text-white text-[10px] font-bold flex-shrink-0">
                                                    {u.firstName[0]}{u.lastName[0]}
                                                </div>
                                                <div>
                                                    <p className="text-xs font-bold text-[#0A1931]">{u.firstName} {u.lastName}</p>
                                                    <p className="text-[10px] text-[#A0AEC0]">{lastSession ? `Son giriş: ${timeAgo(lastSession.loginAt)}` : u.email}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td className="px-3 py-3 text-center">
                                            {c ? (
                                                <div>
                                                    <span className={`text-xs font-bold ${rateColor(c.attendanceRate)}`}>{c.attendanceRate.toFixed(0)}%</span>
                                                    <div className="h-1 bg-[#E2E8F0]/40 rounded-full mt-0.5 w-12 mx-auto overflow-hidden">
                                                        <div className={`h-full rounded-full ${rateBg(c.attendanceRate)}`} style={{ width: `${c.attendanceRate}%` }} />
                                                    </div>
                                                </div>
                                            ) : loadingCards ? <div className="w-8 h-3 bg-[#E2E8F0]/40 rounded animate-pulse mx-auto" /> : <span className="text-[10px] text-[#A0AEC0]">—</span>}
                                        </td>
                                        <td className="px-3 py-3 text-center">
                                            {c ? <span className="text-xs font-bold text-blue-600">{c.videoCompletionRate.toFixed(0)}%</span>
                                                : loadingCards ? <div className="w-8 h-3 bg-[#E2E8F0]/40 rounded animate-pulse mx-auto" /> : <span className="text-[10px] text-[#A0AEC0]">—</span>}
                                        </td>
                                        <td className="px-3 py-3 text-center">
                                            {c ? <span className="text-xs font-bold text-violet-600">{c.totalWatchedMinutes}dk</span>
                                                : loadingCards ? <div className="w-8 h-3 bg-[#E2E8F0]/40 rounded animate-pulse mx-auto" /> : <span className="text-[10px] text-[#A0AEC0]">—</span>}
                                        </td>
                                        <td className="px-3 py-3 text-center">
                                            {c ? <span className={`text-xs font-bold ${c.avgExamScore > 0 ? "text-orange-600" : "text-[#A0AEC0]"}`}>{c.avgExamScore > 0 ? c.avgExamScore.toFixed(1) : "—"}</span>
                                                : loadingCards ? <div className="w-8 h-3 bg-[#E2E8F0]/40 rounded animate-pulse mx-auto" /> : <span className="text-[10px] text-[#A0AEC0]">—</span>}
                                        </td>
                                        <td className="px-3 py-3 text-center">
                                            {c ? <span className="text-xs font-bold text-teal-600">{c.submittedAssignments}</span>
                                                : loadingCards ? <div className="w-8 h-3 bg-[#E2E8F0]/40 rounded animate-pulse mx-auto" /> : <span className="text-[10px] text-[#A0AEC0]">—</span>}
                                        </td>
                                        <td className="px-3 py-3 text-center">
                                            <span className={`text-[9px] font-bold px-2 py-0.5 rounded-full ${u.isActive ? "bg-emerald-50 text-emerald-600" : "bg-[#E2E8F0]/40 text-[#A0AEC0]"}`}>
                                                {u.isActive ? "Aktif" : "Pasif"}
                                            </span>
                                        </td>
                                        <td className="px-4 py-3 text-right">
                                            <button className="text-[10px] text-[#1B3B6F] font-bold hover:text-[#0A1931] flex items-center gap-1 ml-auto">
                                                <BarChart3 size={11} /> Detay
                                            </button>
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                )}
            </div>

            {selected && <ScorecardPanel user={selected} classAvg={classAvg} sessions={sessions} onClose={() => setSelected(null)} />}
        </div>
    );
}
