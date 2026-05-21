"use client";
import React, { useState, useMemo } from "react";
import {
    PiArrowLeftBold as ArrowLeft,
    PiMagnifyingGlassDuotone as Search,
    PiDownloadDuotone as Download,
    PiMedalDuotone as Award,
    PiTargetDuotone as Target,
    PiHashDuotone as Hash,
    PiCheckCircleDuotone as CheckCircle2,
    PiXCircleDuotone as XCircle,
    PiMinusCircleDuotone as MinusCircle,
    PiUsersDuotone as Users,
    PiChartBarDuotone as BarChart3,
    PiStarDuotone as Star
} from "react-icons/pi";
import type { ExamDetailDto } from "@/lib/api";
import StudentScorecardModal from "./StudentScorecardModal";

interface Props {
    exam: ExamDetailDto;
    onClose: () => void;
}

export default function ExamResultsDashboard({ exam, onClose }: Props) {
    const [search, setSearch] = useState("");
    const [sortConfig, setSortConfig] = useState<{ key: string, direction: 'asc' | 'desc' }>({ key: 'score', direction: 'desc' });
    const [selectedResult, setSelectedResult] = useState<any | null>(null);

    const summary = exam.resultSummary;
    const results = summary?.results || [];

    const handleSort = (key: string) => {
        let direction: 'asc' | 'desc' = 'desc';
        if (sortConfig.key === key && sortConfig.direction === 'desc') direction = 'asc';
        setSortConfig({ key, direction });
    };

    const sortedResults = useMemo(() => {
        let sortable = [...results];
        if (search) {
            sortable = sortable.filter(r => r.userFullName.toLowerCase().includes(search.toLowerCase()));
        }
        
        sortable.sort((a, b) => {
            const aVal = (a as any)[sortConfig.key];
            const bVal = (b as any)[sortConfig.key];
            
            if (aVal < bVal) return sortConfig.direction === 'asc' ? -1 : 1;
            if (aVal > bVal) return sortConfig.direction === 'asc' ? 1 : -1;
            return 0;
        });
        return sortable;
    }, [results, sortConfig, search]);

    const sectionKeys = useMemo(() => {
        const keys = new Set<string>();
        results.forEach(r => {
            if (r.sectionResults) {
                Object.keys(r.sectionResults).forEach(k => keys.add(k));
            }
        });
        return Array.from(keys).sort();
    }, [results]);

    const handleExportCsv = () => {
        if (!results.length) return;
        
        // Dynamically add section headers
        const sectionHeaders = sectionKeys.map(k => `${k} Net`);
        const headers = ["Sıra", "Öğrenci Adı", "Doğru", "Yanlış", "Boş", ...sectionHeaders, "Toplam Net", "Puan"];
        
        const csvContent = [
            headers.join(","),
            ...sortedResults.map((r, i) => {
                const sectionNets = sectionKeys.map(k => r.sectionResults?.[k]?.net ?? 0);
                return [
                    i + 1,
                    `"${r.userFullName}"`,
                    r.correctCount,
                    r.wrongCount,
                    r.emptyCount,
                    ...sectionNets,
                    r.net,
                    r.score
                ].join(",");
            })
        ].join("\n");

        const blob = new Blob(["\uFEFF" + csvContent], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement("a");
        const url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", `${exam.title.replace(/\s+/g, '_')}_Sonuclar.csv`);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };

    const getScoreColor = (score: number) => {
        if (score >= 85) return "text-emerald-600 bg-emerald-50 border-emerald-200";
        if (score >= 70) return "text-blue-600 bg-blue-50 border-blue-200";
        if (score >= 50) return "text-amber-600 bg-amber-50 border-amber-200";
        return "text-red-600 bg-red-50 border-red-200";
    };

    return (
        <div className="fixed inset-0 z-[100] bg-[#F8FAFC] overflow-y-auto flex flex-col">
            {/* Header */}
            <div className="sticky top-0 z-10 bg-white border-b border-[#E2E8F0] shadow-sm">
                <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
                    <div className="flex items-center gap-6">
                        <button onClick={onClose} className="p-2.5 rounded-xl text-[#A0AEC0] hover:text-[#0A1931] hover:bg-[#E2E8F0]/50 transition-all group">
                            <ArrowLeft size={22} className="group-hover:-translate-x-1 transition-transform" />
                        </button>
                        <div>
                            <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-3">
                                {exam.title} <span className="text-[#A0AEC0] font-normal">/ Sonuç Analizi</span>
                            </h1>
                            <div className="flex items-center gap-3 text-sm text-[#A0AEC0] font-medium mt-1">
                                <span className="flex items-center gap-1.5"><BarChart3 size={14} /> Soru Sayısı: {exam.questionCount}</span>
                                <span>•</span>
                                <span className="flex items-center gap-1.5"><Star size={14} /> Maks Puan: 100</span>
                            </div>
                        </div>
                    </div>
                    <div className="flex items-center gap-3">
                        <button onClick={handleExportCsv} className="flex items-center gap-2 px-5 py-2.5 text-sm font-bold bg-white text-[#1B3B6F] border-2 border-[#1B3B6F]/20 rounded-xl hover:bg-[#1B3B6F] hover:text-white transition-all shadow-sm">
                            <Download size={16} /> Excel İndir
                        </button>
                    </div>
                </div>
            </div>

            {/* Content */}
            <div className="flex-1 max-w-7xl mx-auto w-full px-6 py-8 space-y-8">
                
                {/* Stats Grid */}
                {summary && (
                    <div className="grid grid-cols-5 gap-4">
                        {[
                            { label: "Katılımcı", value: summary.totalParticipants, icon: Users, color: "text-[#0A1931]" },
                            { label: "Ort. Puan", value: `${summary.averageScore}%`, icon: Award, color: "text-[#0A1931]" },
                            { label: "Ort. Net", value: summary.averageNet, icon: Target, color: "text-[#0A1931]" },
                            { label: "En Yüksek", value: `${summary.highestScore}%`, icon: CheckCircle2, color: "text-emerald-600" },
                            { label: "En Düşük", value: `${summary.lowestScore}%`, icon: XCircle, color: "text-rose-600" },
                        ].map((s, i) => (
                            <div key={i} className="bg-white p-5 rounded-2xl border border-[#E2E8F0] shadow-sm relative overflow-hidden flex flex-col justify-between h-[110px]">
                                <div className="flex items-center justify-between">
                                    <p className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-wider">{s.label}</p>
                                    <s.icon size={16} className="text-[#A0AEC0]" />
                                </div>
                                <p className={`text-3xl font-black tracking-tight ${s.color}`}>{s.value}</p>
                            </div>
                        ))}
                    </div>
                )}

                {/* Filters */}
                <div className="flex items-center justify-between bg-white p-4 rounded-2xl shadow-sm border border-[#E2E8F0]">
                    <div className="relative w-80">
                        <Search size={16} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                        <input type="text" placeholder="Öğrenci adı ile ara..." value={search} onChange={(e) => setSearch(e.target.value)}
                            className="w-full pl-10 pr-4 py-2.5 text-sm bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 transition-all" />
                    </div>
                    <div className="text-sm text-[#A0AEC0] font-medium">
                        Toplam <span className="text-[#0A1931] font-bold">{sortedResults.length}</span> sonuç gösteriliyor
                    </div>
                </div>

                {/* DataGrid */}
                <div className="bg-white rounded-2xl border border-[#E2E8F0] shadow-sm overflow-hidden">
                    {!summary || results.length === 0 ? (
                        <div className="text-center py-20 text-[#A0AEC0]">
                            <Target size={48} className="mx-auto mb-4 opacity-20" />
                            <h3 className="text-lg font-bold text-[#0A1931] mb-1">Sonuç Bulunamadı</h3>
                            <p className="text-sm">Bu sınav için henüz girilmiş bir sonuç yok veya kimse sınava katılmadı.</p>
                        </div>
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="w-full text-left border-collapse">
                                <thead>
                                    <tr className="bg-[#F8FAFC] border-b border-[#E2E8F0]">
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider w-16">#</th>
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider cursor-pointer hover:bg-[#E2E8F0]/50 transition-colors group" onClick={() => handleSort('userFullName')}>
                                            <div className="flex items-center gap-1.5">Öğrenci Adı {sortConfig.key === 'userFullName' && <span className="text-[#0A1931]">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>}</div>
                                        </th>
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider cursor-pointer hover:bg-[#E2E8F0]/50 transition-colors group" onClick={() => handleSort('correctCount')}>
                                            <div className="flex items-center gap-1.5"><CheckCircle2 size={14} className="text-emerald-500" /> Doğru {sortConfig.key === 'correctCount' && <span className="text-[#0A1931]">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>}</div>
                                        </th>
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider cursor-pointer hover:bg-[#E2E8F0]/50 transition-colors group" onClick={() => handleSort('wrongCount')}>
                                            <div className="flex items-center gap-1.5"><XCircle size={14} className="text-red-500" /> Yanlış {sortConfig.key === 'wrongCount' && <span className="text-[#0A1931]">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>}</div>
                                        </th>
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider cursor-pointer hover:bg-[#E2E8F0]/50 transition-colors group" onClick={() => handleSort('emptyCount')}>
                                            <div className="flex items-center gap-1.5"><MinusCircle size={14} className="text-amber-500" /> Boş {sortConfig.key === 'emptyCount' && <span className="text-[#0A1931]">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>}</div>
                                        </th>
                                        
                                        {/* Dynamic Section Headers */}
                                        {sectionKeys.map(key => (
                                            <th key={`section-${key}`} className="py-4 px-6 text-xs font-bold text-[#1B3B6F] uppercase tracking-wider">
                                                {key} Net
                                            </th>
                                        ))}
                                        
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider cursor-pointer hover:bg-[#E2E8F0]/50 transition-colors group" onClick={() => handleSort('net')}>
                                            <div className="flex items-center gap-1.5"><Hash size={14} className="text-blue-500" /> Toplam Net {sortConfig.key === 'net' && <span className="text-[#0A1931]">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>}</div>
                                        </th>
                                        <th className="py-4 px-6 text-xs font-bold text-[#A0AEC0] uppercase tracking-wider cursor-pointer hover:bg-[#E2E8F0]/50 transition-colors group" onClick={() => handleSort('score')}>
                                            <div className="flex items-center gap-1.5"><Award size={14} className="text-[#0A1931]" /> Puan {sortConfig.key === 'score' && <span className="text-[#0A1931]">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>}</div>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {sortedResults.map((r, i) => (
                                        <React.Fragment key={r.id || i}>
                                            <tr 
                                                onClick={() => setSelectedResult(r)}
                                                className={`border-b border-[#E2E8F0] hover:bg-[#F8FAFC] transition-colors group cursor-pointer ${selectedResult?.id === r.id ? 'bg-[#F8FAFC]' : ''}`}
                                            >
                                                <td className="py-4 px-6 text-sm font-bold text-[#A0AEC0]">
                                                    {sortConfig.key === 'score' && sortConfig.direction === 'desc' ? i + 1 : '-'}
                                                </td>
                                                <td className="py-4 px-6">
                                                    <div className="font-bold text-[#0A1931]">{r.userFullName}</div>
                                                </td>
                                                <td className="py-4 px-6">
                                                    <span className="inline-flex items-center justify-center min-w-[2rem] px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-700 text-xs font-bold">{r.correctCount}</span>
                                                </td>
                                                <td className="py-4 px-6">
                                                    <span className="inline-flex items-center justify-center min-w-[2rem] px-2 py-0.5 rounded-md bg-rose-100 text-rose-700 text-xs font-bold">{r.wrongCount}</span>
                                                </td>
                                                <td className="py-4 px-6">
                                                    <span className="inline-flex items-center justify-center min-w-[2rem] px-2 py-0.5 rounded-md bg-[#E2E8F0]/50 text-[#A0AEC0] text-xs font-bold">{r.emptyCount}</span>
                                                </td>
                                                
                                                {/* Dynamic Section Nets */}
                                                {sectionKeys.map(key => {
                                                    const sec = r.sectionResults?.[key];
                                                    return (
                                                        <td key={`sec-${key}-${r.id}`} className="py-4 px-6 text-sm font-bold text-[#1B3B6F]">
                                                            {sec?.net ?? '-'}
                                                        </td>
                                                    );
                                                })}

                                                <td className="py-4 px-6">
                                                    <span className="text-sm font-black text-[#0A1931] bg-[#F8FAFC] px-3 py-1 rounded-lg border border-[#E2E8F0]">
                                                        {r.net}
                                                    </span>
                                                </td>
                                                <td className="py-4 px-6">
                                                    <span className={`text-sm font-black ${r.score >= 50 ? 'text-[#0A1931]' : 'text-rose-600'}`}>
                                                        {r.score.toFixed(1)}
                                                    </span>
                                                </td>
                                            </tr>
                                        </React.Fragment>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>
            </div>

            {selectedResult && (
                <StudentScorecardModal
                    examTitle={exam.title}
                    examType={exam.examType}
                    result={selectedResult}
                    onClose={() => setSelectedResult(null)}
                />
            )}
        </div>
    );
}
