"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { attendanceApi, type MyAttendanceDto } from "@/lib/api";

export default function AttendancePage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [records, setRecords] = useState<MyAttendanceDto[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!token || !tenantId) return;
        attendanceApi.myHistory(token, tenantId)
            .then(setRecords)
            .catch(console.error)
            .finally(() => setLoading(false));
    }, [token, tenantId]);

    const attended = records.filter(r => r.durationMinutes && r.durationMinutes > 0);
    const rate = records.length > 0 ? Math.round(attended.length / records.length * 100) : 0;

    return (
        <div className="max-w-4xl mx-auto">
            <h1 className="text-2xl font-bold text-[#0A1931] mb-2 hidden md:block">📅 Devam Takibim</h1>
            <p className="text-[#A9A9A9] text-sm mb-8 hidden md:block">Ders katılım geçmişin</p>

            {/* Summary cards */}
            <div className="grid grid-cols-3 gap-4 mb-8 pt-4 md:pt-0">
                <div className="stat-card text-center">
                    <p className="text-3xl font-bold gradient-text">{loading ? "..." : records.length}</p>
                    <p className="text-[#A9A9A9] text-xs mt-1">Toplam Ders</p>
                </div>
                <div className="stat-card text-center">
                    <p className="text-3xl font-bold text-green-400">{loading ? "..." : attended.length}</p>
                    <p className="text-[#A9A9A9] text-xs mt-1">Katıldım</p>
                </div>
                <div className="stat-card text-center">
                    <p className="text-3xl font-bold" style={{ color: rate >= 75 ? "#4ade80" : rate >= 50 ? "#facc15" : "#f87171" }}>
                        {loading ? "..." : `%${rate}`}
                    </p>
                    <p className="text-[#A9A9A9] text-xs mt-1">Katılım Oranı</p>
                </div>
            </div>

            {/* Rate bar */}
            {!loading && (
                <div className="glass-card p-5 mb-8">
                    <div className="flex justify-between text-xs text-[#A9A9A9] mb-2">
                        <span>Katılım Oranı</span>
                        <span className="font-medium text-[#0A1931]">%{rate}</span>
                    </div>
                    <div className="progress-bar" style={{ height: "8px" }}>
                        <div className="progress-fill" style={{ width: `${rate}%`, background: rate >= 75 ? "linear-gradient(90deg,#22c55e,#16a34a)" : rate >= 50 ? "linear-gradient(90deg,#eab308,#ca8a04)" : "linear-gradient(90deg,#ef4444,#dc2626)" }} />
                    </div>
                    <p className="text-xs text-[#A0AEC0] mt-2">
                        {rate >= 75 ? "✅ Devam durumun çok iyi!" : rate >= 50 ? "⚠️ Devam oranın düşüyor, dikkat et." : "❌ Devam oranın kritik seviyede."}
                    </p>
                </div>
            )}

            {/* Table or Cards */}
            {loading ? (
                <div className="space-y-2">
                    {[...Array(5)].map((_, i) => (
                        <div key={i} className="glass-card p-4 animate-pulse h-14" />
                    ))}
                </div>
            ) : records.length === 0 ? (
                <div className="text-center py-16">
                    <p className="text-4xl mb-3">📭</p>
                    <p className="text-[#A0AEC0]">Henüz kayıtlı ders katılımın yok.</p>
                </div>
            ) : (
                <>
                    {/* Desktop Table View */}
                    <div className="glass-card overflow-hidden hidden md:block">
                        <table className="w-full text-sm">
                            <thead>
                                <tr className="border-b border-[#1B3B6F]/20">
                                    <th className="text-left text-[#A9A9A9] font-medium px-5 py-3">Ders</th>
                                    <th className="text-left text-[#A9A9A9] font-medium px-5 py-3">Kurs</th>
                                    <th className="text-left text-[#A9A9A9] font-medium px-5 py-3">Giriş</th>
                                    <th className="text-left text-[#A9A9A9] font-medium px-5 py-3">Süre</th>
                                    <th className="text-left text-[#A9A9A9] font-medium px-5 py-3">Durum</th>
                                </tr>
                            </thead>
                            <tbody>
                                {records.map((r) => (
                                    <tr key={r.sessionId} className="border-b border-[#1B3B6F]/20 hover:bg-white/2 transition-colors">
                                        <td className="px-5 py-3 text-[#0A1931] text-xs font-medium">{r.sessionTitle}</td>
                                        <td className="px-5 py-3 text-[#A9A9A9] text-xs">{r.courseTitle}</td>
                                        <td className="px-5 py-3 text-[#A9A9A9] text-xs">
                                            {new Date(r.joinedAt).toLocaleDateString("tr-TR", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}
                                        </td>
                                        <td className="px-5 py-3 text-[#A0AEC0] text-xs">
                                            {r.durationMinutes ? `${r.durationMinutes} dk` : "-"}
                                        </td>
                                        <td className="px-5 py-3">
                                            {r.durationMinutes && r.durationMinutes > 0
                                                ? <span className="px-2 py-0.5 bg-green-500/15 text-green-400 rounded-full text-xs">✓ Katıldı</span>
                                                : <span className="px-2 py-0.5 bg-red-500/15 text-red-400 rounded-full text-xs">✗ Katılmadı</span>
                                            }
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    {/* Mobile Card List View */}
                    <div className="flex flex-col gap-3 md:hidden">
                        {records.map((r) => {
                            const isAttended = r.durationMinutes && r.durationMinutes > 0;
                            return (
                                <div key={r.sessionId} className="glass-card p-4 flex flex-col gap-2">
                                    <div className="flex items-start justify-between gap-3">
                                        <div>
                                            <h3 className="text-sm font-bold text-[#0A1931]">{r.sessionTitle}</h3>
                                            <p className="text-xs text-[#A9A9A9] mt-0.5">{r.courseTitle}</p>
                                        </div>
                                        <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold shrink-0 ${isAttended ? 'bg-green-500/15 text-green-500 border border-green-500/20' : 'bg-red-500/15 text-red-500 border border-red-500/20'}`}>
                                            {isAttended ? "✓ Katıldı" : "✗ Katılmadı"}
                                        </span>
                                    </div>
                                    
                                    <div className="border-t border-[#E2E8F0] pt-2 flex items-center justify-between text-[11px] text-[#A9A9A9]">
                                        <span>Giriş: {new Date(r.joinedAt).toLocaleDateString("tr-TR", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}</span>
                                        <span className="font-semibold text-[#0A1931]">Süre: {r.durationMinutes ? `${r.durationMinutes} dk` : "-"}</span>
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                </>
            )}
        </div>
    );
}
