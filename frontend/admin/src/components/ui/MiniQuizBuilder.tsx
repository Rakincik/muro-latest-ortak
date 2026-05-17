"use client";

import React, { useState, useRef } from 'react';
import { X, Check, Plus, Trash2, ImagePlus, Loader2 } from 'lucide-react';
import { examApi, uploadApi } from '@/lib/api';
import { useAuth } from '@/contexts/AuthContext';
import { useToast } from '@/components/toast';

interface MiniQuizBuilderProps {
    onClose: () => void;
    onSuccess: (examId: string) => void;
}

interface QuizQuestion {
    id: string;
    type: "multiple_choice" | "true_false" | "fill_blank";
    text: string;
    imageUrl?: string;
    options: string[];
    optionImages: (string | null)[];
    correctIndex: number;
    correctText?: string;
    isUploading?: boolean;
}

export function MiniQuizBuilder({ onClose, onSuccess }: MiniQuizBuilderProps) {
    const { token, currentTenantId } = useAuth();
    const { toast: showToast } = useToast();
    const [isSaving, setIsSaving] = useState(false);
    const [title, setTitle] = useState("");
    
    const [questions, setQuestions] = useState<QuizQuestion[]>([
        { id: "1", type: "multiple_choice", text: "", options: ["", "", "", ""], optionImages: [null, null, null, null], correctIndex: 0, correctText: "" }
    ]);

    const fileInputRef = useRef<HTMLInputElement>(null);
    const [uploadTarget, setUploadTarget] = useState<{ qId: string, optIndex?: number } | null>(null);

    const handleAddQuestion = () => {
        setQuestions([
            ...questions,
            { 
                id: Math.random().toString(36).substring(7), 
                type: "multiple_choice",
                text: "", 
                options: ["", "", "", ""], 
                optionImages: [null, null, null, null],
                correctIndex: 0,
                correctText: ""
            }
        ]);
    };

    const handleRemoveQuestion = (id: string) => {
        if (questions.length === 1) return;
        setQuestions(questions.filter(q => q.id !== id));
    };

    const handleQuestionChange = (id: string, text: string) => {
        setQuestions(questions.map(q => q.id === id ? { ...q, text } : q));
    };

    const handleQuestionImageChange = (id: string, imageUrl: string | undefined) => {
        setQuestions(questions.map(q => q.id === id ? { ...q, imageUrl, isUploading: false } : q));
    };

    const handleOptionChange = (qId: string, optIndex: number, val: string) => {
        setQuestions(questions.map(q => {
            if (q.id === qId) {
                const newOpts = [...q.options];
                newOpts[optIndex] = val;
                return { ...q, options: newOpts };
            }
            return q;
        }));
    };

    const handleOptionImageChange = (qId: string, optIndex: number, val: string | null) => {
        setQuestions(questions.map(q => {
            if (q.id === qId) {
                const newOptsImg = [...q.optionImages];
                newOptsImg[optIndex] = val;
                return { ...q, optionImages: newOptsImg, isUploading: false };
            }
            return q;
        }));
    };

    const handleCorrectChange = (qId: string, correctIndex: number) => {
        setQuestions(questions.map(q => q.id === qId ? { ...q, correctIndex } : q));
    };

    const triggerUpload = (qId: string, optIndex?: number) => {
        setUploadTarget({ qId, optIndex });
        setQuestions(questions.map(q => q.id === qId ? { ...q, isUploading: true } : q));
        if (fileInputRef.current) {
            fileInputRef.current.click();
        }
    };

    const onFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file || !uploadTarget || !token || !currentTenantId) {
            if (uploadTarget) setQuestions(questions.map(q => q.id === uploadTarget.qId ? { ...q, isUploading: false } : q));
            return;
        }

        try {
            const ext = file.name.split('.').pop() || 'png';
            const fileName = `quiz-${Date.now()}.${ext}`;
            const { uploadUrl, publicUrl } = await uploadApi.getPresignedUrl(token, currentTenantId, fileName, file.type);
            
            await uploadApi.uploadMediaWithProgress(uploadUrl, file, () => {});
            
            if (uploadTarget.optIndex !== undefined) {
                handleOptionImageChange(uploadTarget.qId, uploadTarget.optIndex, publicUrl);
            } else {
                handleQuestionImageChange(uploadTarget.qId, publicUrl);
            }
        } catch (error) {
            console.error("Upload failed", error);
            showToast("error", "Hata", "Görsel yüklenirken bir hata oluştu.");
            setQuestions(questions.map(q => q.id === uploadTarget.qId ? { ...q, isUploading: false } : q));
        }

        if (fileInputRef.current) fileInputRef.current.value = "";
        setUploadTarget(null);
    };

    const handleSave = async () => {
        if (!token || !currentTenantId) return;
        
        let finalTitle = title.trim();
        if (!finalTitle) {
            finalTitle = `Hızlı Quiz - ${new Date().toLocaleDateString()}`;
        }

        // Validate
        for (let i = 0; i < questions.length; i++) {
            const q = questions[i];
            // En azından ya soru metni ya da görsel olmalı
            if (!q.text.trim() && !q.imageUrl) {
                showToast("warning", "Uyarı", `${i + 1}. sorunun metni veya görseli olmak zorundadır.`);
                return;
            }
            for (let j = 0; j < q.options.length; j++) {
                if (!q.options[j].trim() && !q.optionImages[j]) {
                    showToast("warning", "Uyarı", `${i + 1}. sorunun ${String.fromCharCode(65 + j)} şıkkı (metin veya görsel) boş bırakılamaz.`);
                    return;
                }
            }
        }

        setIsSaving(true);
        try {
            // 1. Prepare Data
            const answerKey: Record<number, string> = {};
            const digitalQuestions = questions.map((q, i) => {
                answerKey[i + 1] = q.type === "fill_blank" ? (q.correctText?.trim() || "") : String.fromCharCode(65 + q.correctIndex); // 0 -> A, 1 -> B ...
                return {
                    type: q.type,
                    text: q.text,
                    imageUrl: q.imageUrl || null,
                    options: q.options,
                    optionImages: q.optionImages,
                    correct: q.correctIndex,
                    correctText: q.correctText
                };
            });

            // 2. Create Exam
            const newExam = await examApi.create(token, currentTenantId, {
                title: finalTitle,
                description: "Sistem tarafından otomatik oluşturulmuş mini quiz.",
                examType: "Quiz",
                questionCount: questions.length,
                optionCount: 4,
                showResults: true,
                resultMode: "immediate",
                digitalQuestionsJson: JSON.stringify(digitalQuestions)
            });

            // 3. Set Answer Key
            await examApi.updateAnswerKey(token, currentTenantId, newExam.id, answerKey);

            // 4. Set Status to Published
            await examApi.updateStatus(token, currentTenantId, newExam.id, "Yayında");

            showToast("success", "Başarılı", "Mini quiz oluşturuldu ve yayına alındı.");
            onSuccess(newExam.id);
        } catch (error: any) {
            console.error("Quiz creation error:", error);
            showToast("error", "Hata", `Quiz oluşturulurken bir hata oluştu: ${error?.message || JSON.stringify(error)}`);
        } finally {
            setIsSaving(false);
        }
    };

    return (
        <div className="flex-1 overflow-y-auto p-6 md:p-8 bg-[#F1F5F9]/30">
            <input 
                type="file" 
                ref={fileInputRef} 
                onChange={onFileSelect} 
                accept="image/*" 
                className="hidden" 
            />

            <div className="max-w-4xl mx-auto space-y-6 pb-20">
                {/* Title Input */}
                <div className="bg-white p-6 rounded-2xl border border-[#E2E8F0]/80 shadow-sm">
                    <label className="block text-sm font-black text-[#0A1931] uppercase tracking-widest mb-2">
                        Quiz Başlığı
                    </label>
                    <input 
                        type="text" 
                        value={title}
                        onChange={e => setTitle(e.target.value)}
                        placeholder="Örn: Hücre Bölünmesi Kavrama Testi"
                        className="w-full bg-[#F8FAFC] border-2 border-[#E2E8F0] rounded-xl px-4 py-3 text-sm font-bold text-[#0A1931] focus:outline-none focus:border-[#1B3B6F] focus:ring-4 focus:ring-[#1B3B6F]/10 transition-all"
                    />
                </div>

                {/* Questions */}
                <div className="space-y-4">
                    {questions.map((q, index) => (
                        <div key={q.id} className="bg-white p-6 rounded-2xl border border-[#E2E8F0]/80 shadow-sm relative group transition-all hover:border-[#1B3B6F]/30">
                            {questions.length > 1 && (
                                <button 
                                    onClick={() => handleRemoveQuestion(q.id)}
                                    className="absolute -right-3 -top-3 w-8 h-8 bg-white border border-[#E2E8F0] rounded-full flex items-center justify-center text-red-500 hover:bg-red-50 hover:border-red-200 transition-all shadow-sm opacity-0 group-hover:opacity-100 z-10"
                                    title="Soruyu Sil"
                                >
                                    <Trash2 size={14} />
                                </button>
                            )}

                            <div className="flex items-center justify-between mb-4">
                                <div className="flex items-center gap-3">
                                    <div className="w-8 h-8 rounded-lg bg-[#F1F5F9] text-[#1B3B6F] flex items-center justify-center font-black text-sm shrink-0 border border-[#E2E8F0]">
                                        {index + 1}
                                    </div>
                                    <h3 className="text-base font-black text-[#0A1931]">Soru Metni / Görseli</h3>
                                    <select
                                        value={q.type}
                                        onChange={(e) => {
                                            const val = e.target.value as any;
                                            setQuestions(questions.map(item => item.id === q.id ? { 
                                                ...item, 
                                                type: val, 
                                                options: val === "true_false" ? ["Doğru", "Yanlış"] : (val === "multiple_choice" ? ["", "", "", ""] : []),
                                                optionImages: val === "true_false" ? [null, null] : (val === "multiple_choice" ? [null, null, null, null] : []),
                                                correctIndex: 0,
                                                correctText: ""
                                            } : item));
                                        }}
                                        className="text-sm font-semibold bg-[#F1F5F9] border border-[#E2E8F0] outline-none rounded-lg px-3 py-1.5 text-slate-700 ml-4 cursor-pointer hover:bg-slate-200 transition-colors"
                                    >
                                        <option value="multiple_choice">Çoktan Seçmeli</option>
                                        <option value="true_false">Doğru / Yanlış</option>
                                        <option value="fill_blank">Boşluk Doldurma</option>
                                    </select>
                                </div>
                                <button 
                                    onClick={() => triggerUpload(q.id)}
                                    className="text-xs font-bold text-[#1B3B6F] flex items-center gap-1.5 bg-[#F1F5F9] hover:bg-[#E2E8F0] px-3 py-1.5 rounded-lg transition-colors border border-[#E2E8F0]"
                                >
                                    {q.isUploading && uploadTarget?.qId === q.id && uploadTarget.optIndex === undefined ? (
                                        <Loader2 size={14} className="animate-spin" />
                                    ) : (
                                        <ImagePlus size={14} />
                                    )}
                                    Görsel Ekle
                                </button>
                            </div>

                            {q.imageUrl && (
                                <div className="relative mb-4 group/img inline-block max-w-full">
                                    <img src={q.imageUrl} alt="Soru Görseli" className="max-h-48 rounded-xl border-2 border-[#E2E8F0] object-contain bg-[#F8FAFC]" />
                                    <button 
                                        onClick={() => handleQuestionImageChange(q.id, undefined)}
                                        className="absolute -top-2 -right-2 w-6 h-6 bg-white border border-[#E2E8F0] rounded-full flex items-center justify-center text-red-500 hover:bg-red-50 shadow-sm opacity-0 group-hover/img:opacity-100 transition-all"
                                    >
                                        <X size={12} strokeWidth={3} />
                                    </button>
                                </div>
                            )}

                            <textarea 
                                value={q.text}
                                onChange={e => handleQuestionChange(q.id, e.target.value)}
                                placeholder="Soru metnini buraya yazın..."
                                rows={2}
                                className="w-full bg-[#F8FAFC] border-2 border-[#E2E8F0] rounded-xl px-4 py-3 text-sm font-medium text-[#0A1931] focus:outline-none focus:border-[#1B3B6F] focus:ring-4 focus:ring-[#1B3B6F]/10 transition-all resize-none mb-6"
                            />

                            {q.type === "fill_blank" ? (
                                <div className="p-5 bg-emerald-50 border border-emerald-200 rounded-xl">
                                    <label className="block text-xs font-bold text-emerald-800 uppercase tracking-widest mb-2">Beklenen Doğru Cevap (Boşluk Doldurma)</label>
                                    <input
                                        type="text"
                                        value={q.correctText || ""}
                                        onChange={e => setQuestions(questions.map(item => item.id === q.id ? { ...item, correctText: e.target.value } : item))}
                                        placeholder="Cevap metnini buraya yazın..."
                                        className="w-full bg-white border-2 border-emerald-200 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-emerald-500 focus:ring-4 focus:ring-emerald-500/20 transition-all"
                                    />
                                    <p className="text-xs text-emerald-600 mt-2 font-medium">Not: Öğrencilerin girdiği cevaplar, büyük-küçük harf duyarlılığı olmadan kontrol edilecektir. (Örn: "Ankara" ile "ankara" aynı sayılır)</p>
                                </div>
                            ) : (
                                <div className="space-y-3">
                                    {q.options.map((opt, optIndex) => {
                                        const isCorrect = q.correctIndex === optIndex;
                                        const letter = String.fromCharCode(65 + optIndex);
                                        const optImageUrl = q.optionImages[optIndex];
                                        const isTrueFalse = q.type === "true_false";

                                        return (
                                            <div key={optIndex} className={`flex flex-col gap-2 p-3 rounded-xl border-2 transition-all ${isCorrect ? 'bg-emerald-50 border-emerald-500/30' : 'bg-transparent border-transparent hover:bg-[#F8FAFC]'}`}>
                                                <div className="flex items-center gap-3">
                                                    <button 
                                                        onClick={() => handleCorrectChange(q.id, optIndex)}
                                                        className={`w-8 h-8 rounded-lg flex items-center justify-center font-black text-xs shrink-0 transition-all border-2 ${isCorrect ? 'bg-emerald-500 border-emerald-500 text-white shadow-md shadow-emerald-500/20' : 'bg-white border-[#E2E8F0] text-[#A0AEC0] hover:border-emerald-500/50 hover:text-emerald-500'}`}
                                                        title="Doğru Cevap Olarak İşaretle"
                                                    >
                                                        {isCorrect ? <Check size={14} strokeWidth={4} /> : letter}
                                                    </button>
                                                    
                                                    <div className="flex-1 flex items-center gap-2">
                                                        <input 
                                                            type="text" 
                                                            value={opt}
                                                            readOnly={isTrueFalse}
                                                            onChange={e => handleOptionChange(q.id, optIndex, e.target.value)}
                                                            placeholder={`${letter} şıkkı metni...`}
                                                            className={`flex-1 ${isTrueFalse ? 'bg-slate-50 opacity-80 cursor-not-allowed' : 'bg-white'} border-2 rounded-xl px-4 py-2 text-sm font-medium focus:outline-none transition-all ${isCorrect ? 'border-emerald-500/30 text-emerald-900 focus:border-emerald-500 focus:ring-4 focus:ring-emerald-500/10' : 'border-[#E2E8F0] text-[#0A1931] focus:border-[#1B3B6F] focus:ring-4 focus:ring-[#1B3B6F]/10'}`}
                                                        />
                                                        {!isTrueFalse && (
                                                        <button 
                                                            onClick={() => triggerUpload(q.id, optIndex)}
                                                            className="w-10 h-10 shrink-0 flex items-center justify-center rounded-xl border-2 border-[#E2E8F0] bg-white text-[#A0AEC0] hover:text-[#1B3B6F] hover:border-[#1B3B6F]/30 transition-all"
                                                            title="Görsel Ekle"
                                                        >
                                                            {q.isUploading && uploadTarget?.qId === q.id && uploadTarget.optIndex === optIndex ? (
                                                                <Loader2 size={16} className="animate-spin" />
                                                            ) : (
                                                                <ImagePlus size={16} />
                                                            )}
                                                        </button>
                                                        )}
                                                    </div>
                                                </div>

                                                {optImageUrl && !isTrueFalse && (
                                                    <div className="pl-11 relative group/optimg inline-block max-w-full">
                                                        <img src={optImageUrl} alt={`Şık ${letter} Görseli`} className="max-h-24 rounded-lg border border-[#E2E8F0] object-contain bg-white" />
                                                        <button 
                                                            onClick={() => handleOptionImageChange(q.id, optIndex, null)}
                                                            className="absolute -top-2 -right-2 w-5 h-5 bg-white border border-[#E2E8F0] rounded-full flex items-center justify-center text-red-500 hover:bg-red-50 shadow-sm opacity-0 group-hover/optimg:opacity-100 transition-all"
                                                        >
                                                            <X size={10} strokeWidth={3} />
                                                        </button>
                                                    </div>
                                                )}
                                            </div>
                                        );
                                    })}
                                </div>
                            )}
                        </div>
                    ))}
                </div>

                {/* Add Question Button */}
                <button 
                    onClick={handleAddQuestion}
                    className="w-full py-4 rounded-2xl border-2 border-dashed border-[#A0AEC0]/40 text-[#A0AEC0] font-bold hover:bg-[#F1F5F9] hover:text-[#1B3B6F] hover:border-[#1B3B6F]/40 transition-all flex items-center justify-center gap-2"
                >
                    <Plus size={20} />
                    Yeni Soru Ekle
                </button>
            </div>

            {/* Sticky Action Footer */}
            <div className="fixed bottom-0 left-0 right-0 p-4 sm:p-6 sm:pb-8 bg-gradient-to-t from-[#0A1931]/90 to-[#0A1931]/0 pointer-events-none z-10 flex justify-center">
                <div className="pointer-events-auto bg-white p-2 sm:p-3 rounded-2xl shadow-2xl flex items-center gap-2 sm:gap-4 border border-[#E2E8F0]/80">
                    <button 
                        onClick={onClose}
                        disabled={isSaving}
                        className="px-6 py-3 rounded-xl text-[#A0AEC0] font-bold hover:text-[#0A1931] hover:bg-[#F8FAFC] transition-colors"
                    >
                        Vazgeç
                    </button>
                    <button 
                        onClick={handleSave}
                        disabled={isSaving}
                        className="px-8 py-3 rounded-xl bg-[#1B3B6F] hover:bg-[#152a51] text-white font-bold shadow-lg shadow-[#1B3B6F]/20 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
                    >
                        {isSaving ? (
                            <div className="w-5 h-5 border-[3px] border-white/30 border-t-white rounded-full animate-spin" />
                        ) : (
                            <Check size={18} />
                        )}
                        Kaydet ve Kursa Ekle
                    </button>
                </div>
            </div>
        </div>
    );
}
