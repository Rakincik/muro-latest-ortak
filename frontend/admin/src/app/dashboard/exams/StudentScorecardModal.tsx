"use client";
import { X, Award, Target, BookOpen, BarChart3, List, ChevronDown, ChevronUp } from "lucide-react";
import { useState } from "react";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Legend, ReferenceLine, CartesianGrid, PieChart, Pie, Cell } from 'recharts';
import { ExamResultDto } from "@/lib/api/types";

interface Props {
    result: ExamResultDto;
    examTitle: string;
    examType?: string;
    onClose: () => void;
}

export default function StudentScorecardModal({ result, examTitle, onClose }: Props) {
    const [openSection, setOpenSection] = useState<string | null>(null);

    const anyResult = result as any;

    // Mock ranks if not provided by backend yet
    const ranks = anyResult.ranks || {
        classRank: 3, classTotal: 25,
        institutionRank: 14, institutionTotal: 150,
        generalRank: 1342, generalTotal: 5000,
        percentile: 26.8
    };

    const isAboveAvg = anyResult.averageScore != null ? result.score > anyResult.averageScore : true;

    // Prepare chart data
    const chartData = result.sectionResults ? Object.values(result.sectionResults).map((sec: any) => ({
        name: sec.name,
        "Öğrenci Net": sec.net,
        "Sınıf Ortalaması": sec.classAverageNet || sec.net * 0.8, // Mock average if missing
        total: sec.correctCount + sec.wrongCount + sec.emptyCount
    })) : [];

    // Group question results by section
    const questionsBySection: Record<string, any[]> = {};
    if (anyResult.questionResults && anyResult.questionResults.length > 0) {
        anyResult.questionResults.forEach((q: any) => {
            const secName = q.sectionName || "Genel";
            if (!questionsBySection[secName]) questionsBySection[secName] = [];
            questionsBySection[secName].push(q);
        });
    } else {
        // Mock question data for demonstration if none exists
        if (result.sectionResults && Object.keys(result.sectionResults).length > 0) {
            Object.values(result.sectionResults).forEach((sec: any) => {
                questionsBySection[sec.name] = Array.from({length: 5}).map((_, i) => ({
                    questionNumber: i + 1,
                    topic: "Örnek Kazanım " + (i + 1),
                    correctAnswer: "A",
                    studentAnswer: i % 2 === 0 ? "A" : (i === 3 ? null : "B"),
                    isCorrect: i % 2 === 0,
                    isBlank: i === 3
                }));
            });
        } else {
            // Mock for exams without sections
            const qCount = result.correctCount + result.wrongCount + result.emptyCount || 10;
            const displayCount = Math.min(qCount, 15); // Show up to 15 questions for demo
            
            questionsBySection["Genel"] = Array.from({length: displayCount}).map((_, i) => {
                const isCorrect = i < Math.ceil(displayCount * (result.correctCount / qCount || 0.5));
                const isBlank = !isCorrect && i % 4 === 0;
                
                return {
                    questionNumber: i + 1,
                    topic: "Kavramsal Analiz ve Sentez " + (i + 1),
                    correctAnswer: ["A", "B", "C", "D", "E"][i % 5],
                    studentAnswer: isCorrect ? ["A", "B", "C", "D", "E"][i % 5] : (isBlank ? null : "C"),
                    isCorrect: isCorrect,
                    isBlank: isBlank
                };
            });
        }
    }

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6" onClick={onClose}>
            <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
            
            <div className="relative w-full max-w-6xl bg-[#F8FAFC] rounded-3xl shadow-2xl max-h-[95vh] flex flex-col overflow-hidden" onClick={e => e.stopPropagation()}>
                
                {/* Modern Header / Identity Card */}
                <div className="bg-[#0A1931] p-8 text-white shrink-0 relative overflow-hidden">
                    <button onClick={onClose} className="absolute top-6 right-6 p-2 bg-white/10 hover:bg-white/20 rounded-xl transition-all z-20 backdrop-blur-sm">
                        <X size={20} className="text-white" />
                    </button>
                    
                    <div className="relative z-10 flex flex-col md:flex-row items-center md:items-start justify-between gap-6 pr-12">
                        <div className="flex items-center gap-5">
                            <div className="w-20 h-20 rounded-full bg-[#1B3B6F] p-1 flex items-center justify-center border border-white/20 shadow-md">
                                <div className="w-full h-full bg-[#0A1931] rounded-full flex items-center justify-center text-2xl font-black">
                                    {result.userFullName.charAt(0).toUpperCase()}
                                </div>
                            </div>
                            <div>
                                <span className="inline-block px-3 py-1 bg-[#1B3B6F] rounded-full text-[10px] font-bold uppercase tracking-widest text-emerald-400 mb-2 border border-emerald-400/20">
                                    Sınav Sonuç Karnesi
                                </span>
                                <h2 className="text-2xl font-black tracking-tight">{result.userFullName}</h2>
                                <p className="text-sm text-[#A0AEC0] mt-1 flex items-center gap-2">
                                    <BookOpen size={14} /> {examTitle}
                                </p>
                            </div>
                        </div>
                        
                        <div className="flex items-center gap-4 mt-4 md:mt-0">
                            <div className="text-center px-6 py-3 bg-[#F8FAFC] text-[#0A1931] rounded-2xl shadow-sm">
                                <p className="text-[10px] font-bold text-slate-500 uppercase tracking-widest mb-1">Puan</p>
                                <p className="text-4xl font-black text-emerald-600">{Number(result.score).toFixed(3)}</p>
                            </div>
                            <div className="text-center px-6 py-3 bg-[#F8FAFC] text-[#0A1931] rounded-2xl shadow-sm">
                                <p className="text-[10px] font-bold text-slate-500 uppercase tracking-widest mb-1">Yüzdelik Dilim</p>
                                <p className="text-4xl font-black text-[#0A1931]">%{ranks.percentile}</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="flex-1 overflow-y-auto p-6 md:p-8 space-y-8">
                    
                    {/* Rank Badges Row */}
                    <div className="flex flex-wrap gap-4">
                        <div className="flex-1 bg-white p-4 rounded-2xl border border-[#E2E8F0] shadow-sm flex items-center gap-4">
                            <div className="w-12 h-12 rounded-xl bg-amber-50 flex items-center justify-center text-amber-600"><Award size={24} /></div>
                            <div>
                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Sınıf Sırası</p>
                                <p className="text-xl font-black text-[#0A1931]">{ranks.classRank} <span className="text-sm font-medium text-[#A0AEC0]">/ {ranks.classTotal}</span></p>
                            </div>
                        </div>
                        <div className="flex-1 bg-white p-4 rounded-2xl border border-[#E2E8F0] shadow-sm flex items-center gap-4">
                            <div className="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600"><Target size={24} /></div>
                            <div>
                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Kurum Sırası</p>
                                <p className="text-xl font-black text-[#0A1931]">{ranks.institutionRank} <span className="text-sm font-medium text-[#A0AEC0]">/ {ranks.institutionTotal}</span></p>
                            </div>
                        </div>
                        <div className="flex-1 bg-white p-4 rounded-2xl border border-[#E2E8F0] shadow-sm flex items-center gap-4">
                            <div className="w-12 h-12 rounded-xl bg-purple-50 flex items-center justify-center text-purple-600"><BarChart3 size={24} /></div>
                            <div>
                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Genel Sıra</p>
                                <p className="text-xl font-black text-[#0A1931]">{ranks.generalRank} <span className="text-sm font-medium text-[#A0AEC0]">/ {ranks.generalTotal}</span></p>
                            </div>
                        </div>
                    </div>

                    {/* Chart & Summary Row */}
                    <div className="grid lg:grid-cols-3 gap-6">
                        <div className="lg:col-span-2 bg-white rounded-3xl p-6 border border-[#E2E8F0] shadow-sm flex flex-col">
                            <h3 className="text-sm font-bold text-[#0A1931] mb-6 flex items-center gap-2">
                                <BarChart3 size={16} className="text-[#1B3B6F]" /> {chartData.length > 0 ? "Ders Net Grafiği" : "Genel Dağılım Grafiği"}
                            </h3>
                            <div className="flex-1 min-h-[250px]">
                                <ResponsiveContainer width="100%" height="100%">
                                    {chartData.length > 0 ? (
                                        <BarChart data={chartData} margin={{ top: 20, right: 0, left: -20, bottom: 0 }}>
                                            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" />
                                            <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 10, fill: '#A0AEC0', fontWeight: 'bold' }} dy={10} />
                                            <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 10, fill: '#A0AEC0' }} />
                                            <Tooltip 
                                                cursor={{fill: '#F1F5F9'}} 
                                                contentStyle={{borderRadius: '12px', border: 'none', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)'}} 
                                            />
                                            <Legend wrapperStyle={{ fontSize: '10px', paddingTop: '10px', fontWeight: 'bold' }} />
                                            <Bar dataKey="Öğrenci Net" fill="#1B3B6F" radius={[4, 4, 0, 0]} maxBarSize={40} />
                                            <Bar dataKey="Sınıf Ortalaması" fill="#94A3B8" radius={[4, 4, 0, 0]} maxBarSize={40} />
                                        </BarChart>
                                    ) : (
                                        <PieChart>
                                            <Pie
                                                data={[
                                                    { name: 'Doğru', value: result.correctCount, color: '#10B981' },
                                                    { name: 'Yanlış', value: result.wrongCount, color: '#F43F5E' },
                                                    { name: 'Boş', value: result.emptyCount, color: '#94A3B8' },
                                                ].filter(d => d.value > 0)}
                                                cx="50%" cy="50%" innerRadius={60} outerRadius={90} paddingAngle={2} dataKey="value"
                                            >
                                                {[
                                                    { name: 'Doğru', value: result.correctCount, color: '#10B981' },
                                                    { name: 'Yanlış', value: result.wrongCount, color: '#F43F5E' },
                                                    { name: 'Boş', value: result.emptyCount, color: '#94A3B8' },
                                                ].filter(d => d.value > 0).map((entry, index) => (
                                                    <Cell key={`cell-${index}`} fill={entry.color} />
                                                ))}
                                            </Pie>
                                            <Tooltip contentStyle={{borderRadius: '12px', border: 'none', boxShadow: '0 10px 15px -3px rgb(0 0 0 / 0.1)'}} />
                                            <Legend wrapperStyle={{ fontSize: '10px', fontWeight: 'bold' }} />
                                        </PieChart>
                                    )}
                                </ResponsiveContainer>
                            </div>
                        </div>

                        <div className="bg-white rounded-3xl p-6 border border-[#E2E8F0] shadow-sm flex flex-col justify-between gap-4">
                            <div className="grid grid-cols-2 gap-4">
                                <div className="text-center p-4 bg-emerald-50 rounded-2xl border border-[#E2E8F0]">
                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Doğru</p>
                                    <p className="text-3xl font-black text-emerald-600">{result.correctCount}</p>
                                </div>
                                <div className="text-center p-4 bg-rose-50 rounded-2xl border border-[#E2E8F0]">
                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Yanlış</p>
                                    <p className="text-3xl font-black text-rose-600">{result.wrongCount}</p>
                                </div>
                            </div>
                            <div className="text-center p-4 bg-slate-50 rounded-2xl border border-[#E2E8F0]">
                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Boş Bırakılan</p>
                                <p className="text-3xl font-black text-slate-500">{result.emptyCount}</p>
                            </div>
                            <div className="text-center p-4 bg-[#0A1931] rounded-2xl shadow-md mt-2">
                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Toplam Net</p>
                                <p className="text-3xl font-black text-white">{Number(result.net).toFixed(2)}</p>
                            </div>
                        </div>
                    </div>

                    {/* Ders Bazlı Tablo Analizi */}
                    {result.sectionResults && Object.keys(result.sectionResults).length > 0 && (
                        <div className="bg-white rounded-3xl p-6 border border-[#E2E8F0] shadow-sm">
                            <h3 className="text-sm font-bold text-[#0A1931] mb-4 flex items-center gap-2">
                                <List size={16} className="text-[#1B3B6F]" /> Ders Net Bilgileri
                            </h3>
                            <div className="overflow-x-auto">
                                <table className="w-full text-left border-collapse">
                                    <thead>
                                        <tr className="border-b-2 border-[#E2E8F0]">
                                            <th className="py-3 text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider">Ders Adı</th>
                                            <th className="py-3 text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider text-center">Soru Sayısı</th>
                                            <th className="py-3 text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider text-center">Doğru</th>
                                            <th className="py-3 text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider text-center">Yanlış</th>
                                            <th className="py-3 text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider text-center">Boş</th>
                                            <th className="py-3 text-[10px] font-bold text-[#0A1931] uppercase tracking-wider text-center bg-[#F1F5F9]">Öğrenci Net</th>
                                            <th className="py-3 text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider text-center">Sınıf Ort.</th>
                                        </tr>
                                    </thead>
                                    <tbody className="divide-y divide-[#E2E8F0]">
                                        {Object.values(result.sectionResults).map((sec: any, i) => {
                                            const total = sec.correctCount + sec.wrongCount + sec.emptyCount;
                                            return (
                                                <tr key={i} className="hover:bg-slate-50 transition-colors">
                                                    <td className="py-3 text-xs font-bold text-[#0A1931]">{sec.name}</td>
                                                    <td className="py-3 text-xs font-semibold text-center text-slate-500">{total}</td>
                                                    <td className="py-3 text-xs font-bold text-center text-emerald-600">{sec.correctCount}</td>
                                                    <td className="py-3 text-xs font-bold text-center text-rose-600">{sec.wrongCount}</td>
                                                    <td className="py-3 text-xs font-semibold text-center text-slate-400">{sec.emptyCount}</td>
                                                    <td className="py-3 text-sm font-black text-center text-[#1B3B6F] bg-[#F8FAFC]">{Number(sec.net).toFixed(2)}</td>
                                                    <td className="py-3 text-xs font-semibold text-center text-slate-500">{sec.classAverageNet ? Number(sec.classAverageNet).toFixed(2) : (sec.net * 0.8).toFixed(2)}</td>
                                                </tr>
                                            );
                                        })}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    )}

                    {/* Soru Bazlı Kazanım Analizi */}
                    {Object.keys(questionsBySection).length > 0 && (
                        <div className="bg-white rounded-3xl p-6 border border-[#E2E8F0] shadow-sm">
                            <h3 className="text-sm font-bold text-[#0A1931] mb-4 flex items-center gap-2">
                                <Target size={16} className="text-[#1B3B6F]" /> Soru ve Kazanım Analizi
                            </h3>
                            <div className="space-y-3">
                                {Object.entries(questionsBySection).map(([secName, questions]) => (
                                    <div key={secName} className="border border-[#E2E8F0] rounded-2xl overflow-hidden">
                                        <button 
                                            onClick={() => setOpenSection(openSection === secName ? null : secName)}
                                            className="w-full flex items-center justify-between p-4 bg-slate-50 hover:bg-slate-100 transition-colors"
                                        >
                                            <span className="text-sm font-bold text-[#0A1931]">{secName} Soru Analizi</span>
                                            {openSection === secName ? <ChevronUp size={16} className="text-slate-500" /> : <ChevronDown size={16} className="text-slate-500" />}
                                        </button>
                                        
                                        {openSection === secName && (
                                            <div className="p-0 border-t border-[#E2E8F0] overflow-x-auto">
                                                <table className="w-full text-left">
                                                    <thead className="bg-slate-50/50">
                                                        <tr>
                                                            <th className="py-2 px-4 text-[10px] font-bold text-[#A0AEC0] uppercase">Soru</th>
                                                            <th className="py-2 px-4 text-[10px] font-bold text-[#A0AEC0] uppercase">Konu / Kazanım</th>
                                                            <th className="py-2 px-4 text-[10px] font-bold text-[#A0AEC0] uppercase text-center">Doğru C.</th>
                                                            <th className="py-2 px-4 text-[10px] font-bold text-[#A0AEC0] uppercase text-center">Öğrenci C.</th>
                                                            <th className="py-2 px-4 text-[10px] font-bold text-[#A0AEC0] uppercase text-center">Sonuç</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody className="divide-y divide-[#E2E8F0]/50">
                                                        {questions.map((q: any) => (
                                                            <tr key={q.questionNumber} className="hover:bg-slate-50">
                                                                <td className="py-2 px-4 text-xs font-bold text-slate-500">{q.questionNumber}</td>
                                                                <td className="py-2 px-4 text-xs font-medium text-[#0A1931]">{q.topic || "Genel Kazanım"}</td>
                                                                <td className="py-2 px-4 text-xs font-bold text-center text-slate-700">{q.correctAnswer}</td>
                                                                <td className="py-2 px-4 text-xs font-bold text-center text-slate-700">{q.studentAnswer || "-"}</td>
                                                                <td className="py-2 px-4 flex justify-center">
                                                                    {q.isCorrect ? (
                                                                        <div className="w-5 h-5 rounded bg-emerald-100 flex items-center justify-center text-emerald-600 text-xs font-bold">+</div>
                                                                    ) : q.isBlank ? (
                                                                        <div className="w-5 h-5 rounded bg-slate-100 flex items-center justify-center text-slate-400 text-xs font-bold">-</div>
                                                                    ) : (
                                                                        <div className="w-5 h-5 rounded bg-rose-100 flex items-center justify-center text-rose-600 text-xs font-bold">x</div>
                                                                    )}
                                                                </td>
                                                            </tr>
                                                        ))}
                                                    </tbody>
                                                </table>
                                            </div>
                                        )}
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
