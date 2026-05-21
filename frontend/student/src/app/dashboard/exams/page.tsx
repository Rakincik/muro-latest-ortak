"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useAuth } from "@/contexts/AuthContext";
import { examApi, type MyExamResultDto, type ExamListDto } from "@/lib/api";
import { KpiGrid } from "@/components/ui/KpiGrid";
import {
    PiFilesDuotone as FileText,
    PiTargetDuotone as Target,
    PiTrophyDuotone as Trophy
} from "react-icons/pi";

function GaugeBar({ value, max, color }: { value: number; max: number; color: string }) {
    return (
        <div className="relative h-2 bg-[#1B3B6F]/15 rounded-full overflow-hidden">
            <div className="absolute inset-y-0 left-0 rounded-full transition-all duration-700" style={{ width: `${Math.max(0, Math.min(100, (value / max) * 100))}%`, background: color }} />
        </div>
    );
}

export default function ExamsPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [results, setResults] = useState<MyExamResultDto[]>([]);
    const [available, setAvailable] = useState<ExamListDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [selected, setSelected] = useState<MyExamResultDto | null>(null);

    useEffect(() => {
        if (!token || !tenantId) return;
        Promise.all([
            examApi.myResults(token, tenantId).catch(() => []),
            examApi.list(token, tenantId, "Yayında").catch(() => [])
        ]).then(([resData, availData]) => {
            const filteredResults = resData.filter(r => r.examType !== "Quiz");
            setResults(filteredResults);
            // Girilmiş sınavları aktif listeden çıkar ve quizleri gizle
            const completedExamIds = new Set(resData.map(r => r.examId));
            const now = new Date();
            
            setAvailable(availData.filter(exam => {
                const isNotCompleted = !completedExamIds.has(exam.id);
                const isNotQuiz = exam.examType !== "Quiz";
                const isNotExpired = !exam.endDate || new Date(exam.endDate) >= now;
                
                return isNotCompleted && isNotQuiz && isNotExpired;
            }));
        }).finally(() => setLoading(false));
    }, [token, tenantId]);

    const avgNet = results.length > 0 ? (results.reduce((s, r) => s + r.net, 0) / results.length).toFixed(2) : "—";
    const bestScore = results.length > 0 ? Math.max(...results.map(r => r.score)).toFixed(1) : "—";

    return (
        <div className="max-w-5xl mx-auto">
            <div className="flex items-center justify-between mb-2">
                <h1 className="text-2xl font-bold text-[#0A1931]">📊 Sınavlarım</h1>
            </div>
            <p className="text-[#A9A9A9] text-sm mb-6">{available.length} bekleyen, {results.length} tamamlanan sınav</p>

            {/* Mevcut Sınavlar (Atanmış ama girilmemiş) */}
            {!loading && available.length > 0 && (
                <div className="mb-8">
                    <h2 className="text-sm font-bold text-emerald-500 mb-3 flex items-center gap-2 uppercase tracking-wide">
                        <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                        Aktif Sınavlar
                    </h2>
                    <div className="space-y-3">
                        {available.map(exam => (
                            <div key={exam.id} className="glass-card p-5 border-l-4 border-l-emerald-400 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                                <div>
                                    <h3 className="text-[#0A1931] font-bold text-lg mb-1">{exam.title}</h3>
                                    {exam.description && <p className="text-[#A9A9A9] text-sm mb-3">{exam.description}</p>}
                                    <div className="flex flex-wrap items-center gap-3 text-xs text-[#A0AEC0]">
                                        <span className="flex items-center gap-1.5 px-2.5 py-1 bg-[#1B3B6F]/5 rounded-lg border border-[#1B3B6F]/10">
                                            📝 {exam.questionCount} soru
                                        </span>
                                        <span className="flex items-center gap-1.5 px-2.5 py-1 bg-blue-500/5 rounded-lg border border-blue-500/10 text-blue-600 font-medium">
                                            ⏱ {exam.durationMinutes ? `${exam.durationMinutes} dk` : "Süresiz"}
                                        </span>
                                    </div>
                                </div>
                                <Link
                                    href={`/dashboard/exams/${exam.id}/solve`}
                                    className="px-8 py-3 bg-[#0A1931] hover:bg-[#1B3B6F] text-white text-sm font-bold rounded-xl transition-all shadow-lg shadow-[#0A1931]/20 flex-shrink-0 text-center"
                                >
                                    ▶ Başla
                                </Link>
                            </div>
                        ))}
                    </div>
                </div>
            )}

            {/* Summary bar */}
            {results.length > 0 && (
                <div className="mb-8">
                    <KpiGrid 
                        items={[
                            { label: "Toplam Sınav", value: results.length, icon: FileText, colorClass: "text-[#0A1931]", bgClass: "bg-[#1B3B6F]/10", iconColorClass: "text-[#1B3B6F]" },
                            { label: "Ortalama Net", value: avgNet, icon: Target, colorClass: "text-[#0A1931]", bgClass: "bg-blue-100", iconColorClass: "text-blue-600" },
                            { label: "En Yüksek Puan", value: bestScore, icon: Trophy, colorClass: "text-[#0A1931]", bgClass: "bg-emerald-100", iconColorClass: "text-emerald-600" }
                        ]}
                        className="grid grid-cols-1 sm:grid-cols-3 gap-4"
                    />
                </div>
            )}

            {/* Puan Trendi Grafiği */}
            {!loading && results.length > 1 && (
                <div className="glass-card p-5 mb-8">
                    <h3 className="text-[#0A1931] text-sm font-semibold mb-4">📈 Puan Trendi</h3>
                    <div className="flex items-end gap-2 h-28 overflow-x-auto pb-1 hide-scrollbar">
                        {results.slice(-10).map((r, i) => {
                            const maxScore = Math.max(...results.map(x => x.score), 100);
                            const pct = (r.score / maxScore) * 100;
                            const avgPct = r.averageScore ? (r.averageScore / maxScore) * 100 : null;
                            return (
                                <div key={r.examId} className="flex-1 flex flex-col items-center gap-1 group relative">
                                    {/* Tooltip */}
                                    <div className="absolute bottom-full mb-2 left-1/2 -translate-x-1/2 bg-[#1B3B6F] border border-[#1B3B6F]/30 rounded-lg px-2 py-1 text-xs text-[#0A1931] opacity-0 group-hover:opacity-100 transition-all whitespace-nowrap z-10 pointer-events-none">
                                        {r.score.toFixed(1)} puan
                                        {avgPct && <span className="text-[#A0AEC0] ml-1">/ ort {r.averageScore?.toFixed(0)}</span>}
                                    </div>
                                    {/* Bar */}
                                    <div className="w-full relative" style={{ height: "100px" }}>
                                        {/* Average line */}
                                        {avgPct && (
                                            <div
                                                className="absolute left-0 right-0 border-t border-dashed border-yellow-500/40"
                                                style={{ bottom: `${avgPct}%` }}
                                            />
                                        )}
                                        {/* Score bar */}
                                        <div
                                            className="absolute bottom-0 left-0 right-0 rounded-t-sm transition-all duration-700"
                                            style={{
                                                height: `${pct}%`,
                                                background: r.score >= (r.averageScore ?? 0)
                                                    ? "linear-gradient(to top, #4f46e5, #8b5cf6)"
                                                    : "linear-gradient(to top, #dc2626, #f87171)",
                                            }}
                                        />
                                    </div>
                                    <span className="text-[#A0AEC0] text-xs truncate w-full text-center" title={r.examTitle}>
                                        {r.examTitle.slice(0, 4)}
                                    </span>
                                </div>
                            );
                        })}
                    </div>
                    <div className="flex items-center gap-4 mt-3 text-xs text-[#A0AEC0]">
                        <span className="flex items-center gap-1.5"><span className="w-3 h-3 rounded-sm bg-[#1B3B6F] inline-block" /> Puanın</span>
                        <span className="flex items-center gap-1.5"><span className="w-3 border-t border-dashed border-yellow-500/60 inline-block" /> Sınıf Ort.</span>
                    </div>
                </div>
            )}

            {loading ? (
                <div className="space-y-3">
                    {[...Array(3)].map((_, i) => <div key={i} className="glass-card p-5 animate-pulse h-24" />)}
                </div>
            ) : (
                <>
                    {results.length === 0 && available.length === 0 ? (
                        <div className="text-center py-20">
                            <p className="text-4xl mb-3">📭</p>
                            <p className="text-[#A0AEC0]">Şu an atanmış aktif bir sınavınız veya sonucunuz yok.</p>
                        </div>
                    ) : results.length > 0 ? (
                        <div className="mb-8">
                            <h2 className="text-sm font-bold text-[#A0AEC0] mb-3 flex items-center gap-2 uppercase tracking-wide">
                                Geçmiş Sınav Sonuçları
                            </h2>
                            <div className="space-y-3">
                                {results.map(r => (
                                    <div
                                        key={r.examId + r.submittedAt}
                                        className="glass-card p-5 hover:border-[#1B3B6F]/25 transition-all cursor-pointer"
                                        onClick={() => setSelected(selected?.examId === r.examId ? null : r)}
                                    >
                                        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 sm:gap-0 mb-3">
                                            <div className="flex-1 min-w-0">
                                                <h3 className="text-[#0A1931] text-sm font-semibold">{r.examTitle}</h3>
                                                <p className="text-[#A9A9A9] text-xs mt-0.5">{r.examType} • {new Date(r.submittedAt).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric" })}</p>
                                            </div>
                                            <div className="flex items-center gap-3">
                                                <Link
                                                    href={`/dashboard/exams/${r.examId}/solve`}
                                                    onClick={e => e.stopPropagation()}
                                                    className="px-3 py-1.5 bg-[#1B3B6F]/20 hover:bg-[#1B3B6F]/40 border border-violet-500/30 text-[#A0AEC0] text-xs rounded-lg transition-all flex-shrink-0"
                                                >
                                                    Tekrar Gir
                                                </Link>
                                                <div className="text-right">
                                                    <p className="text-[#0A1931] text-xl font-bold">{r.score.toFixed(1)}</p>
                                                    <p className="text-[#A9A9A9] text-xs">Net: {r.net.toFixed(2)}</p>
                                                </div>
                                            </div>
                                        </div>

                                        {/* Doğru / Yanlış / Boş */}
                                        <div className="flex items-center gap-4 text-xs mb-3">
                                            <span className="text-green-400">✓ {r.correctCount} D</span>
                                            <span className="text-red-400">✗ {r.wrongCount} Y</span>
                                            <span className="text-[#A9A9A9]">— {r.emptyCount} B</span>
                                            {r.rank && r.showResults && <span className="ml-auto text-[#A0AEC0]">🏆 {r.rank}. sıra</span>}
                                        </div>

                                        {/* Progress bars */}
                                        <div className="space-y-1.5">
                                            <GaugeBar value={r.correctCount} max={r.questionCount} color="linear-gradient(90deg,#22c55e,#16a34a)" />
                                            <GaugeBar value={r.wrongCount} max={r.questionCount} color="linear-gradient(90deg,#ef4444,#dc2626)" />
                                        </div>

                                        {/* Expanded: class average & rank */}
                                        {selected?.examId === r.examId && r.showResults && r.averageScore !== null && (
                                            <div className="mt-4 p-4 bg-[#1B3B6F]/10 border border-[#1B3B6F]/20 rounded-xl grid grid-cols-2 gap-4">
                                                <div className="text-center">
                                                    <p className="text-[#A0AEC0] text-xs mb-1">Sınıf Ortalaması</p>
                                                    <p className="text-[#0A1931] font-bold text-lg">{r.averageScore}</p>
                                                </div>
                                                <div className="text-center">
                                                    <p className="text-[#A0AEC0] text-xs mb-1">Senin Puanın</p>
                                                    <p className={`font-bold text-lg ${r.score >= r.averageScore ? "text-green-400" : "text-red-400"}`}>{r.score.toFixed(1)}</p>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    ) : null}
                </>
            )}
        </div>
    );
}
