"use client";

import React from "react";
import { X } from "lucide-react";
import type { ExamResultItemDto } from "@/lib/api"; // Let's assume this exists or use any for now

interface Props {
    examTitle: string;
    examType?: string;
    result: any; // We'll use any to be safe since type might vary slightly
    onClose: () => void;
}

export default function StudentScorecardModal({ examTitle, examType, result, onClose }: Props) {
    const isAboveAvg = result.averageScore != null && result.score >= result.averageScore;
    const net = result.net ?? (result.correctCount - (result.wrongCount * 0.25)); // Fallback

    return (
        <div className="fixed inset-0 z-[200] bg-[#0A1931]/80 backdrop-blur-sm flex items-center justify-center p-4 sm:p-6 animate-fade-in">
            <div className="bg-[#F8FAFC] rounded-[2.5rem] w-full max-w-5xl max-h-[90vh] overflow-y-auto shadow-2xl flex flex-col relative animate-slide-up">
                
                {/* Close Button */}
                <button onClick={onClose} className="absolute top-6 right-6 z-50 p-2.5 bg-white/10 hover:bg-white/20 backdrop-blur-md rounded-full text-white transition-all">
                    <X size={20} />
                </button>

                {/* İçerik Kartı (Öğrenci Tarafının Aynısı) */}
                <div className="w-full">
                    {/* Tepedeki Devasa Başarı Kartı */}
                    <div className="relative overflow-hidden bg-[#0A1931] group rounded-t-[2.5rem] pb-8 pt-4">
                        {/* Arkaplan Işık Efektleri */}
                        <div className="absolute top-0 right-0 w-[40rem] h-[40rem] bg-gradient-to-bl from-indigo-500/20 via-violet-500/10 to-transparent rounded-full blur-3xl -translate-y-1/2 translate-x-1/3"></div>
                        <div className="absolute bottom-0 left-0 w-64 h-64 bg-emerald-500/10 rounded-full blur-2xl translate-y-1/3 -translate-x-1/4"></div>
                        
                        <div className="relative p-8 md:p-12 flex flex-col md:flex-row items-center gap-10">
                            {/* Sol: Büyük Skor Topu */}
                            <div className="shrink-0 relative">
                                <div className="w-48 h-48 rounded-full border-[12px] border-white/5 flex flex-col items-center justify-center relative z-10 bg-[#0A1931]/50 backdrop-blur-sm shadow-inner">
                                    <span className="text-sm font-bold text-white/50 uppercase tracking-widest mb-1">PUAN</span>
                                    <span className="text-6xl font-black bg-clip-text text-transparent bg-gradient-to-br from-emerald-300 to-cyan-300 tracking-tighter">
                                        {result.score != null ? Number(result.score).toFixed(1) : "—"}
                                    </span>
                                </div>
                                {/* Dönen dış halka efekti */}
                                <div className="absolute inset-0 rounded-full border border-emerald-400/30 animate-[spin_10s_linear_infinite] -m-2 border-dashed"></div>
                            </div>

                            {/* Orta: Sınav Bilgisi & Temel Net */}
                            <div className="flex-1 text-center md:text-left">
                                <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 border border-white/10 text-white/70 text-[10px] font-bold uppercase tracking-widest mb-4">
                                    {examType ?? "Sınav Karnesi"}
                                </div>
                                <h1 className="text-3xl md:text-4xl font-black text-white tracking-tight mb-2 leading-tight">
                                    {examTitle}
                                </h1>
                                <p className="text-emerald-300 text-lg font-bold mb-8">
                                    👨‍🎓 {result.userFullName}
                                </p>

                                <div className="flex flex-wrap items-center justify-center md:justify-start gap-4">
                                    <div className="flex items-center gap-3 bg-white/5 backdrop-blur-md border border-white/10 rounded-2xl px-5 py-3">
                                        <div className="w-10 h-10 rounded-full bg-blue-500/20 text-blue-300 flex items-center justify-center font-black text-lg">
                                            🎯
                                        </div>
                                        <div>
                                            <p className="text-[10px] font-bold text-white/40 uppercase tracking-widest">Toplam Net</p>
                                            <p className="text-2xl font-black text-white">{net != null ? Number(net).toFixed(2) : "—"}</p>
                                        </div>
                                    </div>
                                    {result.rank !== null && result.rank !== undefined && (
                                        <div className="flex items-center gap-3 bg-white/5 backdrop-blur-md border border-white/10 rounded-2xl px-5 py-3">
                                            <div className="w-10 h-10 rounded-full bg-amber-500/20 text-amber-300 flex items-center justify-center font-black text-lg">
                                                🏆
                                            </div>
                                            <div>
                                                <p className="text-[10px] font-bold text-white/40 uppercase tracking-widest">Sıralama</p>
                                                <p className="text-2xl font-black text-white">{result.rank}. <span className="text-sm font-medium text-white/50">sıra</span></p>
                                            </div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="p-8 md:p-12 pt-8">
                        {/* Genel İstatistik Kartları */}
                        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
                            <div className="bg-white rounded-3xl p-5 border border-[#E2E8F0] shadow-sm flex items-center gap-4">
                                <div className="w-12 h-12 rounded-2xl bg-emerald-50 flex items-center justify-center text-emerald-600 font-bold text-xl">✓</div>
                                <div>
                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Doğru</p>
                                    <p className="text-2xl font-black text-[#0A1931]">{result.correctCount}</p>
                                </div>
                            </div>
                            <div className="bg-white rounded-3xl p-5 border border-[#E2E8F0] shadow-sm flex items-center gap-4">
                                <div className="w-12 h-12 rounded-2xl bg-rose-50 flex items-center justify-center text-rose-600 font-bold text-xl">✕</div>
                                <div>
                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Yanlış</p>
                                    <p className="text-2xl font-black text-[#0A1931]">{result.wrongCount}</p>
                                </div>
                            </div>
                            <div className="bg-white rounded-3xl p-5 border border-[#E2E8F0] shadow-sm flex items-center gap-4">
                                <div className="w-12 h-12 rounded-2xl bg-slate-100 flex items-center justify-center text-slate-500 font-bold text-xl">-</div>
                                <div>
                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Boş</p>
                                    <p className="text-2xl font-black text-[#0A1931]">{result.emptyCount}</p>
                                </div>
                            </div>
                            {result.averageScore != null && (
                        <div className="bg-white rounded-3xl p-5 border border-[#E2E8F0] shadow-sm flex items-center gap-4 hover:shadow-md transition-all">
                            <div className={`w-12 h-12 rounded-2xl flex items-center justify-center font-bold text-xl ${isAboveAvg ? "bg-emerald-50 text-emerald-600" : "bg-rose-50 text-rose-600"}`}>
                                {isAboveAvg ? "↑" : "↓"}
                            </div>
                            <div>
                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Sınıf Ort.</p>
                                <p className="text-2xl font-black text-[#0A1931]">{Number(result.averageScore).toFixed(1)}</p>
                            </div>
                        </div>
                    )}
                        </div>

                        {/* Ders Bazlı Analiz (Grid) */}
                        {result.sectionResults && Object.keys(result.sectionResults).length > 0 && (
                            <div className="mb-4">
                                <h3 className="text-[#0A1931] font-bold text-xl mb-5 flex items-center gap-3">
                                    <span className="w-8 h-8 rounded-lg bg-[#1B3B6F]/5 flex items-center justify-center text-[#1B3B6F]">📊</span>
                                    Bölüm Analizi
                                </h3>
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                                    {Object.values(result.sectionResults).map((sec: any, i: number) => {
                                        const total = sec.correctCount + sec.wrongCount + sec.emptyCount;
                                        const successRate = total > 0 ? (sec.net / total) * 100 : 0;
                                        return (
                                            <div key={i} className="bg-white rounded-3xl p-6 border border-[#E2E8F0] shadow-sm relative overflow-hidden group hover:border-[#1B3B6F]/30 hover:shadow-xl transition-all duration-300">
                                                <div className="absolute top-0 left-0 w-1.5 h-full bg-gradient-to-b from-[#1B3B6F] to-violet-500 rounded-l-3xl"></div>
                                                <div className="flex items-center justify-between mb-4">
                                                    <p className="font-bold text-[#0A1931] text-base truncate pr-2" title={sec.name}>{sec.name}</p>
                                                    <span className="shrink-0 text-xs font-bold px-2.5 py-1 rounded-full bg-slate-100 text-slate-500">{total} Soru</span>
                                                </div>
                                                
                                                <div className="flex gap-2 mb-5">
                                                    <div className="flex-1 bg-emerald-50 text-emerald-700 py-2 rounded-xl text-center border border-emerald-100">
                                                        <span className="block text-lg font-black">{sec.correctCount}</span>
                                                        <span className="text-[9px] font-bold uppercase opacity-60">Doğru</span>
                                                    </div>
                                                    <div className="flex-1 bg-rose-50 text-rose-700 py-2 rounded-xl text-center border border-rose-100">
                                                        <span className="block text-lg font-black">{sec.wrongCount}</span>
                                                        <span className="text-[9px] font-bold uppercase opacity-60">Yanlış</span>
                                                    </div>
                                                    <div className="flex-1 bg-slate-50 text-slate-500 py-2 rounded-xl text-center border border-slate-200">
                                                        <span className="block text-lg font-black">{sec.emptyCount}</span>
                                                        <span className="text-[9px] font-bold uppercase opacity-60">Boş</span>
                                                    </div>
                                                </div>
                                                
                                                <div className="pt-4 border-t border-[#E2E8F0] flex items-center justify-between">
                                                    <div>
                                                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-0.5">NET</p>
                                                        <p className="text-2xl font-black text-[#1B3B6F] bg-clip-text text-transparent bg-gradient-to-r from-[#0A1931] to-[#1B3B6F]">{Number(sec.net).toFixed(2)}</p>
                                                    </div>
                                                    <div className="w-12 h-12 rounded-full border-4 border-slate-100 flex items-center justify-center relative" 
                                                        style={{ background: `conic-gradient(#10B981 ${Math.max(0, successRate)}%, transparent 0)` }}>
                                                        <div className="absolute inset-1 bg-white rounded-full flex items-center justify-center">
                                                            <span className="text-[10px] font-bold text-[#0A1931]">{Math.max(0, Math.round(successRate))}%</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        );
                                    })}
                                </div>
                            </div>
                        )}
                    </div>
                </div>

            </div>
        </div>
    );
}
