"use client";
import { useEffect, useState, useCallback, useRef, useMemo, useReducer } from "react";
import Image from "next/image";
import { useAuth } from "@/contexts/AuthContext";
import { examApi, getFileUrl, type ExamDetailDto, type MyExamResultDto } from "@/lib/api";
import { X, Clock, FileText, ExternalLink, ChevronRight, ChevronLeft, Check, AlertTriangle, Award, ChevronDown, ChevronUp } from "lucide-react";
import 'katex/dist/katex.min.css';
import { InlineMath, BlockMath } from 'react-katex';

interface Props { examId: string; examTitle: string; isOpen: boolean; onClose: () => void; }
interface DigitalQuestion { type?: "multiple_choice" | "true_false" | "fill_blank"; text?: string; imageUrl?: string; options?: string[]; optionImages?: (string|null)[]; correct?: number; }

const LABELS = ["A", "B", "C", "D", "E", "F"];
const fmt = (s: number) => `${Math.floor(s/60).toString().padStart(2,"0")}:${(s%60).toString().padStart(2,"0")}`;
type Phase = "loading"|"ready"|"solving"|"confirm"|"done"|"error"|"already_submitted"|"missing_key";

// #17 — useReducer for answers
type AnswerAction = { type: "set"; q: number; v: string|undefined } | { type: "reset" };
function answerReducer(state: Record<number,string>, action: AnswerAction): Record<number,string> {
    if (action.type === "reset") return {};
    if (action.v === undefined) { const next = {...state}; delete next[action.q]; return next; }
    return { ...state, [action.q]: action.v };
}

// #8 — LaTeX Text Renderer Helper
function renderTextWithKatex(text: string) {
    if (!text) return null;
    const parts = text.split(/(\$\$[\s\S]+?\$\$|\$[\s\S]+?\$)/g);
    return parts.map((part, i) => {
        if (part.startsWith('$$') && part.endsWith('$$')) {
            return <BlockMath key={i} math={part.slice(2, -2)} />;
        }
        if (part.startsWith('$') && part.endsWith('$')) {
            return <InlineMath key={i} math={part.slice(1, -1)} />;
        }
        return <span key={i} className="whitespace-pre-wrap">{part}</span>;
    });
}

export default function InlineQuizModal({ examId, examTitle, isOpen, onClose }: Props) {
    const { token, currentTenantId: tenantId } = useAuth();
    const [exam, setExam] = useState<ExamDetailDto|null>(null);
    const [phase, setPhase] = useState<Phase>("loading");
    const [answers, dispatchAnswer] = useReducer(answerReducer, {});
    const [result, setResult] = useState<MyExamResultDto|null>(null);
    const [submitting, setSubmitting] = useState(false);
    const [timeLeft, setTimeLeft] = useState<number|null>(null);
    const [activeQ, setActiveQ] = useState(1);
    const [exitConfirm, setExitConfirm] = useState(false);
    const [expandedReview, setExpandedReview] = useState<number|null>(null);
    const [digitalQuestionsJsonStr, setDigitalQuestionsJsonStr] = useState<string | null>(null);
    const startedAt = useRef(new Date().toISOString());
    const timerRef = useRef<NodeJS.Timeout|null>(null);

    const digitalQuestions = useMemo<DigitalQuestion[]>(() => {
        if (!digitalQuestionsJsonStr) return [];
        try { return JSON.parse(digitalQuestionsJsonStr); } catch { return []; }
    }, [digitalQuestionsJsonStr]);

    const hasDigital = digitalQuestions.length > 0;

    const sections = useMemo<{name:string;start:number;end:number}[]|null>(() => {
        if (!exam?.sectionsJson) return null;
        try { return JSON.parse(exam.sectionsJson); } catch { return null; }
    }, [exam?.sectionsJson]);

    useEffect(() => {
        if (!isOpen || !token || !tenantId || !examId) return;
        setPhase("loading"); dispatchAnswer({type:"reset"}); setResult(null); setActiveQ(1);
        Promise.all([
            examApi.getById(token, tenantId, examId),
            examApi.myResults(token, tenantId).catch(() => []),
            examApi.getDigitalQuestions(token, tenantId, examId).catch(() => "[]")
        ]).then(([e, results, dqStr]) => {
            setExam(e);
            setDigitalQuestionsJsonStr(dqStr);
            const existing = results.find((r: MyExamResultDto) => r.examId === examId);
            if (existing) { setResult(existing); setPhase("done"); }
            else if (!e.answerKey || Object.keys(e.answerKey).length === 0) setPhase("missing_key");
            else setPhase("ready");
        }).catch(() => setPhase("error"));
    }, [isOpen, token, tenantId, examId]);

    useEffect(() => {
        if (phase !== "solving" || timeLeft === null) return;
        timerRef.current = setInterval(() => {
            setTimeLeft(t => { if (t===null||t<=1) { clearInterval(timerRef.current!); handleSubmit(true); return 0; } return t-1; });
        }, 1000);
        return () => { if (timerRef.current) clearInterval(timerRef.current); };
    }, [phase]);

    useEffect(() => { if (!isOpen && timerRef.current) clearInterval(timerRef.current); }, [isOpen]);

    // #15 — Preload next question image
    useEffect(() => {
        if (phase !== "solving" || !hasDigital) return;
        const nextDq = digitalQuestions[activeQ]; // activeQ is 1-based, so [activeQ] = next
        if (nextDq?.imageUrl) { const img = new window.Image(); img.src = getFileUrl(nextDq.imageUrl); }
        if (nextDq?.optionImages) { nextDq.optionImages.forEach(u => { if (u) { const img = new window.Image(); img.src = getFileUrl(u); } }); }
    }, [activeQ, phase, hasDigital, digitalQuestions]);

    const startExam = () => { startedAt.current = new Date().toISOString(); if (exam?.durationMinutes) setTimeLeft(exam.durationMinutes*60); setPhase("solving"); };

    const handleSubmit = useCallback(async (auto=false) => {
        if (!token||!tenantId||!exam) return;
        if (!auto && phase !== "confirm") { setPhase("confirm"); return; }
        setSubmitting(true);
        try {
            const res = await examApi.submitAnswers(token, tenantId, examId, answers, startedAt.current);
            setResult(res); setPhase("done"); if (timerRef.current) clearInterval(timerRef.current);
        } catch { setPhase("solving"); } finally { setSubmitting(false); }
    }, [token, tenantId, exam, examId, answers, phase]);

    const handleClose = () => {
        if (phase === "solving" || phase === "confirm") { setExitConfirm(true); return; }
        if (timerRef.current) clearInterval(timerRef.current);
        onClose();
    };
    const confirmExit = () => {
        setExitConfirm(false);
        if (timerRef.current) clearInterval(timerRef.current);
        onClose();
    };

    if (!isOpen) return null;
    const total = exam?.questionCount ?? 0;
    const optCount = exam?.optionCount ?? 5;
    const options = LABELS.slice(0, optCount);
    const answered = Object.keys(answers).length;

    const Overlay = ({ children, click }: { children: React.ReactNode; click?: boolean }) => (
        <div className="fixed inset-0 z-[200] bg-black/60 backdrop-blur-sm flex items-center justify-center p-4" onClick={click ? handleClose : undefined}>
            <div onClick={e => e.stopPropagation()}>{children}</div>
        </div>
    );

    // ── LOADING ──
    if (phase === "loading") return (
        <Overlay click><div className="bg-white rounded-3xl p-12 shadow-2xl text-center">
            <div className="w-12 h-12 border-4 border-[#1B3B6F] border-t-transparent rounded-full animate-spin mx-auto mb-4"/>
            <p className="text-[#A0AEC0] text-sm">Yükleniyor...</p>
        </div></Overlay>
    );

    // ── ERROR / MISSING KEY ──
    if (phase === "error" || !exam) return (
        <Overlay click><div className="bg-white rounded-3xl p-10 shadow-2xl text-center max-w-sm">
            <AlertTriangle size={40} className="text-amber-500 mx-auto mb-4"/>
            <p className="text-[#0A1931] font-bold mb-2">Sınav yüklenemedi</p>
            <button onClick={handleClose} className="px-6 py-2.5 bg-[#0A1931] text-white font-semibold rounded-xl">Kapat</button>
        </div></Overlay>
    );
    if (phase === "missing_key") return (
        <Overlay click><div className="bg-white rounded-3xl p-10 shadow-2xl text-center max-w-sm">
            <div className="text-5xl mb-4">🔑</div>
            <p className="text-[#0A1931] font-bold mb-2">Cevap anahtarı henüz girilmemiş</p>
            <button onClick={handleClose} className="px-6 py-2.5 bg-[#0A1931] text-white font-semibold rounded-xl">Kapat</button>
        </div></Overlay>
    );

    // ── READY ──
    if (phase === "ready") return (
        <Overlay click>
        <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full overflow-hidden" style={{animation:"popIn .25s ease-out"}}>
            <div className="p-10 text-center">
                <h2 className="text-2xl font-bold text-[#0A1931] mb-1">{exam.title}</h2>
                {exam.description && <p className="text-slate-400 text-sm mb-6">{exam.description}</p>}
                <div className="grid grid-cols-2 gap-4 mb-8">
                    <div className="bg-slate-50 rounded-2xl p-5 text-center border border-slate-200">
                        <p className="text-3xl font-black text-[#0A1931]">{exam.questionCount}</p>
                        <p className="text-[10px] text-slate-400 font-bold uppercase mt-1">Soru</p>
                    </div>
                    <div className="bg-slate-50 rounded-2xl p-5 text-center border border-slate-200">
                        <p className="text-3xl font-black text-[#0A1931]">{exam.durationMinutes ? `${exam.durationMinutes} dk` : "∞"}</p>
                        <p className="text-[10px] text-slate-400 font-bold uppercase mt-1">Süre</p>
                    </div>
                </div>
                {!hasDigital && exam.pdfUrl && (
                    <a href={getFileUrl(exam.pdfUrl)} target="_blank" rel="noopener noreferrer"
                        className="flex items-center justify-center gap-2 px-4 py-2.5 bg-slate-50 border border-slate-200 text-slate-700 text-sm rounded-xl hover:bg-slate-100 transition-all mb-4 font-medium">
                        <ExternalLink size={14}/> Sınav Kağıdını Aç (PDF)
                    </a>
                )}
                <div className="flex gap-3">
                    <button onClick={handleClose} className="flex-1 py-3.5 bg-slate-100 text-slate-400 font-semibold rounded-xl hover:bg-slate-200 transition-all">Vazgeç</button>
                    <button onClick={startExam} className="flex-1 py-3.5 bg-[#1B3B6F] hover:bg-[#0A1931] text-white font-bold rounded-xl shadow-lg shadow-[#1B3B6F]/25 transition-all flex items-center justify-center gap-2">
                        Başla <ChevronRight size={16}/>
                    </button>
                </div>
            </div>
        </div>
        <style>{`@keyframes popIn{from{opacity:0;transform:scale(.92)}to{opacity:1;transform:scale(1)}}`}</style>
        </Overlay>
    );

    // ── SOLVING + CONFIRM ──
    if (phase === "solving" || phase === "confirm") {
        const dq = hasDigital ? digitalQuestions[activeQ - 1] : null;
        const qOptions = dq?.options && dq.options.length > 0 ? dq.options : null;
        return (
        <div className="fixed inset-0 z-[200] bg-black/60 backdrop-blur-sm flex items-center justify-center p-3">
        <div className="bg-white rounded-3xl shadow-2xl w-full max-w-5xl h-[90vh] flex flex-col overflow-hidden" style={{animation:"popIn .2s ease-out"}}>
            {/* Header */}
            <div className="flex items-center justify-between px-5 py-3 bg-gradient-to-r from-[#0A1931] to-[#1B3B6F] text-white shrink-0">
                <div className="flex items-center gap-3 min-w-0">
                    <div className="w-8 h-8 rounded-lg bg-white/15 flex items-center justify-center shrink-0"><FileText size={14}/></div>
                    <div className="min-w-0">
                        <h2 className="text-sm font-bold truncate">{exam.title}</h2>
                        <p className="text-[10px] text-white/50">{answered}/{total} cevaplandı</p>
                    </div>
                </div>
                <div className="flex items-center gap-2 shrink-0">
                    {timeLeft !== null && (
                        <div className={`px-3 py-1.5 rounded-lg font-mono text-sm font-bold ${timeLeft<300 ? "bg-red-500/20 text-red-300 animate-pulse" : "bg-white/10 text-white"}`}>
                            <Clock size={12} className="inline mr-1.5"/>{fmt(timeLeft)}
                        </div>
                    )}
                    {!hasDigital && exam.pdfUrl && (
                        <a href={getFileUrl(exam.pdfUrl)} target="_blank" rel="noopener noreferrer"
                            className="p-2 rounded-lg bg-white/10 hover:bg-white/20 text-white/70 hover:text-white transition-colors" title="Sınav Kağıdı">
                            <ExternalLink size={14}/>
                        </a>
                    )}
                    <button onClick={handleClose} className="p-2 rounded-lg hover:bg-red-500/20 text-white/50 hover:text-red-300 transition-colors"><X size={16}/></button>
                </div>
            </div>

            {/* #12 — Progress Bar */}
            <div className="h-1 bg-slate-200 shrink-0">
                <div className="h-full bg-[#1B3B6F] transition-all duration-300 ease-out" style={{width:`${total>0?(answered/total)*100:0}%`}}/>
            </div>

            {/* Body — horizontal split */}
            <div className="flex-1 overflow-hidden flex">
                {/* LEFT: Question content */}
                <div className="flex-1 overflow-y-auto p-6 border-r border-slate-200">
                    {/* #9 — Animated question content */}
                    <div key={activeQ} style={{animation:"fadeSlideIn .2s ease-out"}}>
                    {/* Question header */}
                    <div className="flex items-center gap-3 mb-4">
                        <div className="w-9 h-9 rounded-lg bg-[#1B3B6F] flex items-center justify-center text-white font-bold text-sm">{activeQ}</div>
                        <p className="text-sm text-slate-400 font-medium">Soru {activeQ} / {total}</p>
                        {sections && <span className="text-[10px] text-[#1B3B6F] bg-blue-50 px-2 py-0.5 rounded-md">{sections.find(s=>activeQ>=s.start&&activeQ<=s.end)?.name}</span>}
                    </div>
                    {dq?.text && <div className="bg-slate-50 rounded-2xl p-5 mb-4 border border-slate-100"><div className="text-[#0A1931] text-sm leading-relaxed">{renderTextWithKatex(dq.text)}</div></div>}
                    {dq?.imageUrl && (
                        <div className="rounded-2xl overflow-hidden border border-slate-200">
                            <Image 
                                src={getFileUrl(dq.imageUrl)} 
                                alt={`Soru ${activeQ}`} 
                                width={800} height={400} 
                                className="w-full h-auto max-h-[50vh] object-contain bg-white"
                                unoptimized
                            />
                        </div>
                    )}
                    {!hasDigital && <div className="bg-amber-50 border border-amber-200 rounded-2xl p-4 text-center"><p className="text-amber-700 text-xs font-medium">Soruları görmek için üstteki PDF butonunu kullanın</p></div>}
                    </div>
                </div>

                {/* RIGHT: Options + navigator */}
                <div className="w-[380px] shrink-0 flex flex-col overflow-hidden">
                    {/* Options */}
                    <div className="flex-1 overflow-y-auto p-4 space-y-2">
                        {dq?.type === "fill_blank" ? (
                            <div className="p-4 bg-blue-50 rounded-xl border border-[#1B3B6F]/20">
                                <label className="block text-xs font-bold text-[#1B3B6F] uppercase tracking-widest mb-3">Cevabınız</label>
                                <input
                                    type="text"
                                    value={answers[activeQ] || ""}
                                    onChange={(e) => dispatchAnswer({ type: "set", q: activeQ, v: e.target.value })}
                                    placeholder="Cevabınızı buraya yazın..."
                                    className="w-full bg-white border-2 border-[#1B3B6F]/20 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#1B3B6F] focus:ring-4 focus:ring-[#1B3B6F]/10 transition-all text-[#0A1931]"
                                />
                                <p className="text-[10px] text-[#1B3B6F]/70 font-medium mt-2">Not: Büyük-küçük harf duyarlılığı yoktur.</p>
                            </div>
                        ) : (
                            (dq?.type === "true_false" ? LABELS.slice(0, 2) : options).map((label, idx) => {
                                const selected = answers[activeQ] === label;
                                const optText = qOptions ? qOptions[idx] : undefined;
                                const optImg = dq?.optionImages ? dq.optionImages[idx] : null;
                                return (
                                    <button key={idx} onClick={() => dispatchAnswer({ type: "set", q: activeQ, v: selected ? undefined : label })}
                                        className={`w-full flex items-center gap-3 p-3 rounded-xl border-2 text-left transition-all group ${
                                            selected ? "border-[#1B3B6F] bg-blue-50" : "border-slate-200 bg-white hover:border-[#1B3B6F]/40"
                                        }`}>
                                        <div className={`w-9 h-9 rounded-lg flex items-center justify-center font-bold text-sm shrink-0 transition-all ${
                                            selected ? "bg-[#1B3B6F] text-white" : "bg-slate-100 text-slate-400 group-hover:text-[#1B3B6F]"
                                        }`}>{selected ? <Check size={14}/> : label}</div>
                                        <div className="flex-1 min-w-0">
                                            {optText && <div className="text-sm font-medium text-[#0A1931]">{renderTextWithKatex(optText)}</div>}
                                            {!optText && !optImg && <p className={`text-sm ${selected ? "text-[#0A1931] font-medium" : "text-slate-400"}`}>{label} Şıkkı</p>}
                                            {optImg && (
                                                <Image 
                                                    src={getFileUrl(optImg)} 
                                                    alt={`${label} şıkkı`} 
                                                    width={400} height={200}
                                                    className="w-full h-auto max-h-24 rounded-lg object-contain mt-1"
                                                    unoptimized
                                                />
                                            )}
                                        </div>
                                    </button>
                                );
                            })
                        )}
                    </div>
                    {/* Question navigator mini */}
                    <div className="px-4 py-3 border-t border-slate-200 bg-slate-50">
                        <div className="flex flex-wrap gap-1.5 justify-center">
                            {Array.from({length:total},(_,i)=>i+1).map(n => (
                                <button key={n} onClick={() => setActiveQ(n)}
                                    className={`w-8 h-8 rounded-lg text-[11px] font-bold transition-all ${
                                        activeQ===n ? "bg-[#1B3B6F] text-white" :
                                        answers[n] ? "bg-blue-100 text-[#1B3B6F] border border-blue-200" :
                                        "bg-white text-slate-400 border border-slate-200"
                                    }`}>{n}</button>
                            ))}
                        </div>
                    </div>
                    {/* Nav arrows */}
                    <div className="flex gap-2 px-4 pb-3">
                        <button onClick={()=>setActiveQ(Math.max(1,activeQ-1))} disabled={activeQ<=1} className="flex-1 py-2 rounded-lg bg-slate-100 text-slate-400 hover:bg-slate-200 disabled:opacity-30 transition-all text-xs font-medium flex items-center justify-center gap-1"><ChevronLeft size={14}/> Önceki</button>
                        <button onClick={()=>setActiveQ(Math.min(total,activeQ+1))} disabled={activeQ>=total} className="flex-1 py-2 rounded-lg bg-slate-100 text-slate-400 hover:bg-slate-200 disabled:opacity-30 transition-all text-xs font-medium flex items-center justify-center gap-1">Sonraki <ChevronRight size={14}/></button>
                    </div>
                </div>
            </div>

            {/* Footer */}
            <div className="px-5 py-3 border-t border-slate-200 bg-slate-50/80 flex items-center justify-between shrink-0">
                <div className="flex items-center gap-3">
                    <div className="flex -space-x-1">
                        {Array.from({length: Math.min(total,20)},(_,i)=>i+1).map(n => (
                            <div key={n} className={`w-3 h-3 rounded-full border-2 border-white ${answers[n] ? "bg-[#1B3B6F]" : "bg-slate-200"}`}/>
                        ))}
                    </div>
                    <span className="text-xs text-slate-400 font-medium">{answered}/{total}</span>
                </div>
                <button onClick={()=>handleSubmit(false)} className="px-6 py-2.5 bg-[#1B3B6F] hover:bg-[#0A1931] text-white text-sm font-bold rounded-xl shadow-lg shadow-[#1B3B6F]/20 transition-all">
                    Sınavı Bitir
                </button>
            </div>
        </div>

        {/* Confirm Dialog */}
        {phase === "confirm" && (
            <div className="fixed inset-0 z-[210] bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
                <div className="bg-white rounded-3xl p-8 shadow-2xl max-w-sm w-full text-center" style={{animation:"popIn .15s ease-out"}}>
                    <AlertTriangle size={40} className="text-amber-500 mx-auto mb-4"/>
                    <h3 className="text-lg font-bold text-[#0A1931] mb-2">Sınavı Bitir?</h3>
                    <div className="flex gap-4 justify-center text-sm mb-2">
                        <span className="text-emerald-500 font-medium">✓ {answered} cevap</span>
                        <span className="text-slate-400">— {total-answered} boş</span>
                    </div>
                    <p className="text-slate-400 text-xs mb-6">Gönderildikten sonra değiştirilemez.</p>
                    <div className="flex gap-3">
                        <button onClick={()=>setPhase("solving")} className="flex-1 py-2.5 bg-slate-100 text-slate-400 rounded-xl text-sm hover:bg-slate-200 transition-all font-semibold">Geri Dön</button>
                        <button onClick={()=>handleSubmit(true)} disabled={submitting} className="flex-1 py-2.5 bg-[#1B3B6F] hover:bg-[#0A1931] disabled:opacity-50 text-white rounded-xl text-sm font-bold transition-all">
                            {submitting ? "Gönderiliyor..." : "Gönder ✓"}
                        </button>
                    </div>
                </div>
            </div>
        )}
        {/* Exit Confirm */}
        {exitConfirm && (
            <div className="fixed inset-0 z-[220] bg-black/50 backdrop-blur-sm flex items-center justify-center p-4">
                <div className="bg-white rounded-3xl p-8 shadow-2xl max-w-sm w-full text-center" style={{animation:"popIn .15s ease-out"}}>
                    <div className="w-14 h-14 rounded-2xl bg-amber-50 border border-amber-200 flex items-center justify-center mx-auto mb-4">
                        <AlertTriangle size={24} className="text-amber-500"/>
                    </div>
                    <h3 className="text-lg font-bold text-[#0A1931] mb-2">Sınavdan Çık</h3>
                    <p className="text-slate-400 text-sm mb-6">Sınavdan çıkmak istediğinize emin misiniz? Cevaplarınız kaydedilmeyecektir.</p>
                    <div className="flex gap-3">
                        <button onClick={() => setExitConfirm(false)} className="flex-1 py-2.5 bg-slate-100 text-slate-500 rounded-xl text-sm hover:bg-slate-200 transition-all font-semibold">Devam Et</button>
                        <button onClick={confirmExit} className="flex-1 py-2.5 bg-red-500 hover:bg-red-600 text-white rounded-xl text-sm font-bold transition-all">Çık</button>
                    </div>
                </div>
            </div>
        )}
        <style>{`@keyframes popIn{from{opacity:0;transform:scale(.92)}to{opacity:1;transform:scale(1)}}@keyframes fadeSlideIn{from{opacity:0;transform:translateX(12px)}to{opacity:1;transform:translateX(0)}}`}</style>
        </div>
        );
    }

    // ── DONE ──
    if (phase === "done") {
        const answerKey = exam.answerKey || {};
        return (
        <div className="fixed inset-0 z-[200] bg-black/60 backdrop-blur-sm flex items-center justify-center p-3">
        <div className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col overflow-hidden" style={{animation:"popIn .25s ease-out"}}>
            {/* Header */}
            <div className="px-6 py-4 border-b border-slate-200 shrink-0">
                <h3 className="text-lg font-bold text-[#0A1931]">{exam.title} — Sonuç</h3>
            </div>

            {/* Stats */}
            {result && (
            <div className="px-6 py-4 border-b border-slate-100 shrink-0">
                <div className="grid grid-cols-3 gap-3">
                    <div className="bg-emerald-50 border border-emerald-100 rounded-xl p-3 text-center">
                        <p className="text-2xl font-black text-emerald-600">{result.correctCount}</p>
                        <p className="text-[10px] text-emerald-500 font-bold uppercase">Doğru</p>
                    </div>
                    <div className="bg-rose-50 border border-rose-100 rounded-xl p-3 text-center">
                        <p className="text-2xl font-black text-rose-600">{result.wrongCount}</p>
                        <p className="text-[10px] text-rose-500 font-bold uppercase">Yanlış</p>
                    </div>
                    <div className="bg-slate-50 border border-slate-200 rounded-xl p-3 text-center">
                        <p className="text-2xl font-black text-slate-500">{result.emptyCount}</p>
                        <p className="text-[10px] text-slate-400 font-bold uppercase">Boş</p>
                    </div>
                </div>
            </div>
            )}

            {/* Question Review */}
            <div className="flex-1 overflow-y-auto px-6 py-4">
                <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mb-3">Soru Bazlı Analiz</p>
                <div className="space-y-2">
                    {Array.from({length: total}, (_, i) => i + 1).map(qNum => {
                        const studentAns = answers[qNum];
                        const correctAns = answerKey[qNum];
                        const isCorrect = studentAns === correctAns;
                        const isEmpty = !studentAns;
                        const dq = hasDigital ? digitalQuestions[qNum - 1] : null;
                        const isExpanded = expandedReview === qNum;
                        
                        return (
                            <div key={qNum} className={`flex flex-col rounded-xl border transition-all overflow-hidden ${
                                isEmpty ? "bg-slate-50 border-slate-200" :
                                isCorrect ? "bg-emerald-50 border-emerald-200" : "bg-rose-50 border-rose-200"
                            }`}>
                                <button 
                                    onClick={() => setExpandedReview(isExpanded ? null : qNum)}
                                    className="flex items-center gap-3 p-3 w-full text-left"
                                >
                                    {/* Question number */}
                                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm shrink-0 ${
                                        isEmpty ? "bg-slate-200 text-slate-500" :
                                        isCorrect ? "bg-emerald-500 text-white" : "bg-rose-500 text-white"
                                    }`}>{qNum}</div>

                                    {/* Question text preview */}
                                    <div className="flex-1 min-w-0">
                                        {dq?.text ? (
                                            <p className={`text-xs truncate ${isEmpty ? "text-slate-600" : isCorrect ? "text-emerald-900" : "text-rose-900"}`}>
                                                {dq.text.replace(/(\$\$[\s\S]+?\$\$|\$[\s\S]+?\$)/g, '[Formül]')}
                                            </p>
                                        ) : (
                                            <p className={`text-xs ${isEmpty ? "text-slate-500" : isCorrect ? "text-emerald-700" : "text-rose-700"}`}>Soru {qNum}</p>
                                        )}
                                    </div>

                                    {/* Answer info */}
                                    <div className="flex items-center gap-2 shrink-0">
                                        {!isEmpty && !isCorrect && (
                                            <span className="text-xs bg-rose-100 text-rose-600 px-2 py-1 rounded-lg font-medium line-through">{studentAns}</span>
                                        )}
                                        {correctAns && (
                                            <span className={`text-xs px-2 py-1 rounded-lg font-bold ${
                                                isCorrect ? "bg-emerald-100 text-emerald-700" : "bg-emerald-100 text-emerald-700"
                                            }`}>
                                                {isCorrect ? "✓" : ""} {correctAns}
                                            </span>
                                        )}
                                        {isEmpty && <span className="text-[10px] text-slate-400 font-medium">Boş</span>}
                                        {dq && (
                                            <div className="ml-1 text-slate-400">
                                                {isExpanded ? <ChevronUp size={16}/> : <ChevronDown size={16}/>}
                                            </div>
                                        )}
                                    </div>
                                </button>
                                
                                {/* Expanded Review Detail */}
                                {isExpanded && dq && (
                                    <div className="p-4 border-t border-slate-200/50 bg-white">
                                        {dq.text && (
                                            <div className="text-sm text-[#0A1931] mb-4 leading-relaxed">
                                                {renderTextWithKatex(dq.text)}
                                            </div>
                                        )}
                                        {dq.imageUrl && (
                                            <div className="rounded-xl overflow-hidden border border-slate-100 mb-4 bg-slate-50">
                                                <Image 
                                                    src={getFileUrl(dq.imageUrl)} 
                                                    alt={`Soru ${qNum} Görseli`} 
                                                    width={800} height={400} 
                                                    className="w-full h-auto max-h-48 object-contain"
                                                    unoptimized
                                                />
                                            </div>
                                        )}
                                        <div className="space-y-2">
                                            {dq.type === "fill_blank" ? (
                                                <div className="flex flex-col gap-2">
                                                    <div className="p-3 bg-emerald-50 border border-emerald-200 rounded-lg flex items-start gap-3">
                                                        <div className="w-6 h-6 rounded-md bg-emerald-500 text-white flex items-center justify-center shrink-0"><Check size={14} /></div>
                                                        <div>
                                                            <p className="text-[10px] font-bold text-emerald-600 uppercase tracking-wider mb-0.5">Doğru Cevap</p>
                                                            <p className="text-sm font-medium text-emerald-900">{correctAns}</p>
                                                        </div>
                                                    </div>
                                                    {!isCorrect && !isEmpty && (
                                                        <div className="p-3 bg-rose-50 border border-rose-200 rounded-lg flex items-start gap-3">
                                                            <div className="w-6 h-6 rounded-md bg-rose-500 text-white flex items-center justify-center shrink-0"><X size={14} /></div>
                                                            <div>
                                                                <p className="text-[10px] font-bold text-rose-600 uppercase tracking-wider mb-0.5">Sizin Cevabınız</p>
                                                                <p className="text-sm font-medium text-rose-900 line-through">{studentAns}</p>
                                                            </div>
                                                        </div>
                                                    )}
                                                </div>
                                            ) : (
                                                (dq.type === "true_false" ? LABELS.slice(0, 2) : options).map((optLabel, idx) => {
                                                    const optText = dq.type === "true_false" ? (idx === 0 ? "Doğru" : "Yanlış") : (dq.options ? dq.options[idx] : undefined);
                                                    const optImg = dq.type === "true_false" ? null : (dq.optionImages ? dq.optionImages[idx] : null);
                                                    const isThisCorrect = optLabel === correctAns;
                                                    const isThisSelected = optLabel === studentAns;
                                                    
                                                    let stateClass = "border-slate-100 bg-slate-50 text-slate-500";
                                                    let icon = null;
                                                    
                                                    if (isThisCorrect) {
                                                        stateClass = "border-emerald-200 bg-emerald-50 text-emerald-900";
                                                        icon = <Check size={14} className="text-emerald-500" />;
                                                    } else if (isThisSelected && !isCorrect) {
                                                        stateClass = "border-rose-200 bg-rose-50 text-rose-900";
                                                        icon = <X size={14} className="text-rose-500" />;
                                                    }
                                                    
                                                    return (
                                                        <div key={idx} className={`flex items-start gap-3 p-3 rounded-lg border ${stateClass}`}>
                                                            <div className={`w-6 h-6 rounded-md flex items-center justify-center font-bold text-xs shrink-0 ${
                                                                isThisCorrect ? "bg-emerald-500 text-white" : 
                                                                isThisSelected && !isCorrect ? "bg-rose-500 text-white" : 
                                                                "bg-slate-200 text-slate-600"
                                                            }`}>
                                                                {icon || optLabel}
                                                            </div>
                                                            <div className="flex-1 min-w-0 pt-0.5">
                                                                {optText && <div className="text-xs font-medium">{renderTextWithKatex(optText)}</div>}
                                                                {!optText && !optImg && <p className="text-xs">{optLabel} Şıkkı</p>}
                                                                {optImg && (
                                                                    <Image 
                                                                        src={getFileUrl(optImg)} 
                                                                        alt={`${optLabel} şıkkı`} 
                                                                        width={200} height={100}
                                                                        className="w-full h-auto max-h-16 rounded border border-slate-200 object-contain mt-1 bg-white"
                                                                        unoptimized
                                                                    />
                                                                )}
                                                            </div>
                                                        </div>
                                                    );
                                                })
                                            )}
                                        </div>
                                    </div>
                                )}
                            </div>
                        );
                    })}
                </div>
            </div>

            {/* Footer */}
            <div className="px-6 py-4 border-t border-slate-200 shrink-0">
                <button onClick={handleClose} className="w-full py-3 bg-[#0A1931] hover:bg-[#1B3B6F] text-white font-bold rounded-xl transition-all">Kapat</button>
            </div>
        </div>
        <style>{`@keyframes popIn{from{opacity:0;transform:scale(.92)}to{opacity:1;transform:scale(1)}}`}</style>
        </div>
        );
    }
    return null;
}
