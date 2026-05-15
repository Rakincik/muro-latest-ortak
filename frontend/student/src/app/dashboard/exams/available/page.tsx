"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useAuth } from "@/contexts/AuthContext";
import { examApi, type ExamListDto } from "@/lib/api";

function StatusChip({ status }: { status: string }) {
    const map: Record<string, { bg: string; text: string; label: string }> = {
        "Yayında": { bg: "bg-green-500/15", text: "text-green-400", label: "🟢 Aktif" },
        "Taslak": { bg: "bg-[#A9A9A9]/15", text: "text-[#A0AEC0]", label: "⚪ Taslak" },
        "Tamamlandı": { bg: "bg-blue-500/15", text: "text-blue-400", label: "✓ Bitti" },
    };
    const s = map[status] ?? { bg: "bg-[#1B3B6F]/15", text: "text-[#A9A9A9]", label: status };
    return <span className={`px-2.5 py-0.5 text-xs rounded-full border ${s.bg} ${s.text} border-transparent`}>{s.label}</span>;
}

export default function AvailableExamsPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [exams, setExams] = useState<ExamListDto[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (!token || !tenantId) return;
        examApi.list(token, tenantId)
            .then(setExams)
            .catch(() => setExams([]))
            .finally(() => setLoading(false));
    }, [token, tenantId]);

    const active = exams.filter(e => e.status === "Yayında");
    const others = exams.filter(e => e.status !== "Yayında");

    return (
        <div className="max-w-3xl mx-auto">
            <div className="flex items-center gap-3 mb-2">
                <Link href="/dashboard/exams" className="text-[#A0AEC0] hover:text-[#A0AEC0] transition-colors text-sm">← Geri</Link>
                <h1 className="text-2xl font-bold text-[#0A1931]">📋 Mevcut Sınavlar</h1>
            </div>
            <p className="text-[#A9A9A9] text-sm mb-8">Sınava girmek için "Başla" butonuna tıkla.</p>

            {loading ? (
                <div className="space-y-3">
                    {[...Array(4)].map((_, i) => <div key={i} className="glass-card p-5 animate-pulse h-24" />)}
                </div>
            ) : exams.length === 0 ? (
                <div className="text-center py-20">
                    <p className="text-5xl mb-4">📭</p>
                    <p className="text-[#A0AEC0]">Şu an aktif sınav yok.</p>
                </div>
            ) : (
                <div className="space-y-6">
                    {/* Aktif sınavlar */}
                    {active.length > 0 && (
                        <div>
                            <h2 className="text-green-400 text-xs font-semibold uppercase tracking-wider mb-3">🟢 Aktif Sınavlar</h2>
                            <div className="space-y-3">
                                {active.map(e => <ExamCard key={e.id} exam={e} />)}
                            </div>
                        </div>
                    )}

                    {/* Diğer */}
                    {others.length > 0 && (
                        <div>
                            <h2 className="text-[#A9A9A9] text-xs font-semibold uppercase tracking-wider mb-3">Diğer</h2>
                            <div className="space-y-3">
                                {others.map(e => <ExamCard key={e.id} exam={e} />)}
                            </div>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}

function ExamCard({ exam }: { exam: ExamListDto }) {
    const isActive = exam.status === "Yayında";
    return (
        <div className={`glass-card p-5 flex items-center gap-4 ${isActive ? "border-green-500/20" : ""}`}>
            <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                    <h3 className="text-[#0A1931] font-medium text-sm">{exam.title}</h3>
                    <StatusChip status={exam.status} />
                </div>
                {exam.description && <p className="text-[#A9A9A9] text-xs mb-2 line-clamp-1">{exam.description}</p>}
                <div className="flex items-center gap-4 text-xs text-[#A0AEC0]">
                    <span>📝 {exam.questionCount} soru</span>
                    <span>🔤 {exam.optionCount} şık</span>
                    {exam.durationMinutes && <span>⏱ {exam.durationMinutes} dk</span>}
                    {exam.startDate && (
                        <span>📅 {new Date(exam.startDate).toLocaleDateString("tr-TR", { day: "numeric", month: "short" })}</span>
                    )}
                </div>
            </div>
            <Link
                href={`/dashboard/exams/${exam.id}/solve`}
                className={`flex-shrink-0 px-5 py-2.5 text-sm font-semibold rounded-xl transition-all ${isActive
                        ? "bg-[#1B3B6F] hover:bg-[#1B3B6F] text-[#0A1931] shadow-lg shadow-[#0A1931]/20"
                        : "bg-[#1B3B6F]/15 border border-[#1B3B6F]/30 text-[#A9A9A9] hover:text-[#0A1931] hover:bg-white/10"
                    }`}
            >
                {isActive ? "▶ Başla" : "Detay"}
            </Link>
        </div>
    );
}
