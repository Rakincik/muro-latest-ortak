"use client";

import React, { useState, useEffect, useMemo, useCallback } from "react";
import { createPortal } from "react-dom";
import { 
    X, Search, Clock, Video, Loader2, Link2, ExternalLink, 
    Calendar, Check, Sparkles, RefreshCw, AlertCircle, CheckCircle2,
    Filter, ArrowRight, Layers
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { adminBbbApi, type BbbRecordingInfo } from "@/lib/api";

interface MappedSession {
    id: string;
    title: string;
    date: string;
    time: string;
    duration: string;
    status: "scheduled" | "live" | "ended";
    hasRecording: boolean;
}

interface BbbSyncModalProps {
    isOpen: boolean;
    onClose: () => void;
    courseId: string;
    sessions: MappedSession[];
    onSuccess: () => void;
}

// ── Türkçe Karakter Normalizasyonu & Kelime Benzerliği ─────────────────────
function normalizeText(text: string): string {
    return (text || "")
        .toLowerCase()
        .replace(/ğ/g, "g")
        .replace(/ü/g, "u")
        .replace(/ş/g, "s")
        .replace(/ı/g, "i")
        .replace(/ö/g, "o")
        .replace(/ç/g, "c")
        .replace(/[^a-z0-9]/g, " ")
        .replace(/\s+/g, " ")
        .trim();
}

// Sayı ve kelime bazlı eşleştirme skorlayıcı
function calculateMatchScore(recTitle: string, sessionTitle: string): number {
    const normRec = normalizeText(recTitle);
    const normSes = normalizeText(sessionTitle);

    if (normRec === normSes) return 100;
    if (normRec.includes(normSes) || normSes.includes(normRec)) return 80;

    // Sayıları çıkar (DERS-16, 2. Ders vs.)
    const recNumbers: string[] = normRec.match(/\d+/g) || [];
    const sesNumbers: string[] = normSes.match(/\d+/g) || [];
    const numberMatch = recNumbers.length > 0 && sesNumbers.length > 0 && recNumbers.some(n => sesNumbers.includes(n));

    // Kelime kümesi benzerliği
    const recWords = normRec.split(" ").filter(w => w.length > 2);
    const sesWords = normSes.split(" ").filter(w => w.length > 2);

    let matchCount = 0;
    for (const w of recWords) {
        if (sesWords.includes(w)) matchCount++;
    }

    let score = recWords.length > 0 ? (matchCount / Math.max(recWords.length, sesWords.length)) * 60 : 0;
    if (numberMatch) score += 35;

    return Math.min(score, 100);
}

export function BbbSyncModal({ isOpen, onClose, courseId, sessions = [], onSuccess }: BbbSyncModalProps) {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [mounted, setMounted] = useState(false);
    const [activeTab, setActiveTab] = useState<"server" | "manual">("server");
    const [recordings, setRecordings] = useState<BbbRecordingInfo[]>([]);
    const [loading, setLoading] = useState(false);
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedSessions, setSelectedSessions] = useState<Record<string, string>>({}); // recordingId -> sessionId
    const [assigning, setAssigning] = useState<string | null>(null);
    const [selectedRecordingIds, setSelectedRecordingIds] = useState<string[]>([]);
    const [bulkAssigning, setBulkAssigning] = useState(false);
    const [dateFilter, setDateFilter] = useState<"all" | "today" | "yesterday" | "week" | "month">("all");
    const [onlyUnmatched, setOnlyUnmatched] = useState(false);

    // Manual form state
    const [manualUrl, setManualUrl] = useState("");
    const [manualDuration, setManualDuration] = useState("");
    const [manualSessionId, setManualSessionId] = useState("");
    const [manualSubmitting, setManualSubmitting] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);

    // Body scroll kilidi
    useEffect(() => {
        if (isOpen) {
            document.body.style.overflow = "hidden";
        } else {
            document.body.style.overflow = "unset";
        }
        return () => {
            document.body.style.overflow = "unset";
        };
    }, [isOpen]);

    // ESC ile kapatma
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if (e.key === "Escape" && isOpen) {
                onClose();
            }
        };
        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [isOpen, onClose]);

    // Sunucudan kayıtları yükle
    const loadRecordings = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const data = await adminBbbApi.listRecordings(token, tenantId);
            const list = data || [];
            setRecordings(list);

            // Akıllı eşleşmeleri otomatik tespit et
            const autoSuggestions: Record<string, string> = {};
            const availableSessions = sessions.filter(s => !s.hasRecording);

            list.forEach(rec => {
                const recName = rec.name || rec.meetingId || "";
                let bestSessionId = "";
                let maxScore = 0;

                availableSessions.forEach(ses => {
                    const score = calculateMatchScore(recName, ses.title);
                    if (score > maxScore && score >= 50) {
                        maxScore = score;
                        bestSessionId = ses.id;
                    }
                });

                if (bestSessionId) {
                    autoSuggestions[rec.recordingId] = bestSessionId;
                }
            });

            setSelectedSessions(prev => ({ ...autoSuggestions, ...prev }));
        } catch (err: any) {
            toastError("Hata", "BBB sunucusundan ders kayıtları çekilemedi.");
        } finally {
            setLoading(false);
        }
    }, [token, tenantId, sessions, toastError]);

    useEffect(() => {
        if (isOpen && activeTab === "server") {
            loadRecordings();
        }
    }, [isOpen, activeTab, loadRecordings]);

    // Filtreleme mantığı
    const filteredRecordings = useMemo(() => {
        let result = recordings;

        // Tarih filtresi
        if (dateFilter !== "all") {
            const now = new Date();
            const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());

            result = result.filter(r => {
                if (!r.startTime) return false;
                const recDate = new Date(r.startTime);

                if (dateFilter === "today") {
                    return recDate >= startOfToday;
                } else if (dateFilter === "yesterday") {
                    const startOfYesterday = new Date(startOfToday);
                    startOfYesterday.setDate(startOfYesterday.getDate() - 1);
                    return recDate >= startOfYesterday && recDate < startOfToday;
                } else if (dateFilter === "week") {
                    const startOfWeek = new Date(startOfToday);
                    startOfWeek.setDate(startOfWeek.getDate() - 7);
                    return recDate >= startOfWeek;
                } else if (dateFilter === "month") {
                    const startOfMonth = new Date(startOfToday);
                    startOfMonth.setDate(startOfMonth.getDate() - 30);
                    return recDate >= startOfMonth;
                }
                return true;
            });
        }

        // Arama filtresi
        if (searchQuery.trim()) {
            const q = searchQuery.toLowerCase().trim();
            result = result.filter(r => 
                (r.meetingId && r.meetingId.toLowerCase().includes(q)) ||
                (r.recordingId && r.recordingId.toLowerCase().includes(q)) ||
                (r.name && r.name.toLowerCase().includes(q))
            );
        }

        // Sadece atanmamış olanlar
        if (onlyUnmatched) {
            result = result.filter(r => !selectedSessions[r.recordingId]);
        }

        return result;
    }, [recordings, searchQuery, dateFilter, onlyUnmatched, selectedSessions]);

    const handleToggleSelect = (recordingId: string) => {
        setSelectedRecordingIds(prev => 
            prev.includes(recordingId) 
                ? prev.filter(id => id !== recordingId) 
                : [...prev, recordingId]
        );
    };

    const handleToggleSelectAll = () => {
        if (selectedRecordingIds.length === filteredRecordings.length) {
            setSelectedRecordingIds([]);
        } else {
            setSelectedRecordingIds(filteredRecordings.map(r => r.recordingId));
        }
    };

    // Akıllı Otomatik Eşleştirme Butonu
    const handleAutoMatch = () => {
        const availableSessions = sessions.filter(s => !s.hasRecording);
        if (availableSessions.length === 0) {
            toastError("Bilgi", "Bu kurstaki tüm oturumların zaten bir kaydı var.");
            return;
        }

        const targetRecs = selectedRecordingIds.length > 0
            ? recordings.filter(r => selectedRecordingIds.includes(r.recordingId))
            : filteredRecordings;

        if (targetRecs.length === 0) {
            toastError("Uyarı", "Eşleştirilecek kayıt bulunamadı.");
            return;
        }

        const newSelected = { ...selectedSessions };
        let matchCount = 0;
        const usedSessionIds = new Set(Object.values(newSelected).filter(v => v !== "direct-course"));

        // 1. İsim & Numara benzerliği ile eşleştir
        targetRecs.forEach(rec => {
            const recName = rec.name || rec.meetingId || "";
            let bestSessionId = "";
            let maxScore = 0;

            availableSessions.forEach(ses => {
                if (usedSessionIds.has(ses.id)) return;
                const score = calculateMatchScore(recName, ses.title);
                if (score > maxScore && score >= 40) {
                    maxScore = score;
                    bestSessionId = ses.id;
                }
            });

            if (bestSessionId) {
                newSelected[rec.recordingId] = bestSessionId;
                usedSessionIds.add(bestSessionId);
                matchCount++;
            }
        });

        // 2. Kalanları kronolojik sırayla eşleştir
        const unmatchedRecs = targetRecs.filter(r => !newSelected[r.recordingId]);
        const remainingSessions = availableSessions.filter(s => !usedSessionIds.has(s.id));

        unmatchedRecs.forEach((rec, idx) => {
            if (idx < remainingSessions.length) {
                newSelected[rec.recordingId] = remainingSessions[idx].id;
                usedSessionIds.add(remainingSessions[idx].id);
                matchCount++;
            } else {
                newSelected[rec.recordingId] = "direct-course";
            }
        });

        setSelectedSessions(newSelected);
        if (selectedRecordingIds.length === 0) {
            setSelectedRecordingIds(targetRecs.map(r => r.recordingId));
        }

        success("Eşleştirme Tamamlandı", `${matchCount} kayıt ilgili oturumlarla eşleştirildi. Kontrol edip onaylayabilirsiniz.`);
    };

    // Toplu Atama
    const handleBulkAssign = async () => {
        if (selectedRecordingIds.length === 0 || !token || !tenantId) return;

        const unassignedCount = selectedRecordingIds.filter(id => !selectedSessions[id]).length;
        if (unassignedCount > 0) {
            toastError("Eksik Seçim", `${unassignedCount} kayıt için henüz hedef oturum belirlenmemiş.`);
            return;
        }

        setBulkAssigning(true);
        let successCount = 0;
        let failCount = 0;

        try {
            for (const recId of selectedRecordingIds) {
                const targetValue = selectedSessions[recId];
                const rec = recordings.find(r => r.recordingId === recId);
                if (!rec) continue;

                try {
                    if (targetValue === "direct-course") {
                        await adminBbbApi.assignRecording(token, tenantId, {
                            courseId: courseId,
                            sessionId: null,
                            recordingId: rec.recordingId,
                            playbackUrl: rec.playbackUrl || "",
                            durationSeconds: rec.durationSeconds
                        });
                    } else {
                        await adminBbbApi.assignRecording(token, tenantId, {
                            sessionId: targetValue,
                            courseId: null,
                            recordingId: rec.recordingId,
                            playbackUrl: rec.playbackUrl || "",
                            durationSeconds: rec.durationSeconds
                        });
                    }
                    successCount++;
                } catch {
                    failCount++;
                }
            }

            if (successCount > 0) {
                success("Başarılı", `${successCount} ders kaydı kursa/oturumlara bağlandı.`);
            }
            if (failCount > 0) {
                toastError("Uyarı", `${failCount} kayıtta aktarma hatası oluştu.`);
            }

            setSelectedRecordingIds([]);
            onSuccess();
            loadRecordings();
        } catch {
            toastError("Hata", "Toplu kayıt bağlama sırasında beklenmeyen bir hata oluştu.");
        } finally {
            setBulkAssigning(false);
        }
    };

    // Tekli Atama
    const handleAssignServerRecording = async (rec: BbbRecordingInfo) => {
        const targetValue = selectedSessions[rec.recordingId];
        if (!targetValue || !token || !tenantId) {
            toastError("Uyarı", "Lütfen kaydı bağlamak için bir hedef oturum veya ders seçin.");
            return;
        }

        setAssigning(rec.recordingId);
        try {
            if (targetValue === "direct-course") {
                await adminBbbApi.assignRecording(token, tenantId, {
                    courseId: courseId,
                    sessionId: null,
                    recordingId: rec.recordingId,
                    playbackUrl: rec.playbackUrl || "",
                    durationSeconds: rec.durationSeconds
                });
                success("Başarılı", "Kayıt doğrudan derse bağımsız video olarak eklendi.");
            } else {
                await adminBbbApi.assignRecording(token, tenantId, {
                    sessionId: targetValue,
                    courseId: null,
                    recordingId: rec.recordingId,
                    playbackUrl: rec.playbackUrl || "",
                    durationSeconds: rec.durationSeconds
                });
                success("Başarılı", "Ders kaydı ilgili oturuma başarıyla bağlandı.");
            }
            onSuccess();
            loadRecordings();
        } catch (err: any) {
            toastError("Hata", err.message || "Kayıt bağlanamadı.");
        } finally {
            setAssigning(null);
        }
    };

    // Manuel Video Ekleme
    const handleAssignManual = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!manualUrl.trim()) {
            toastError("Uyarı", "Lütfen geçerli bir oynatma URL'i girin.");
            return;
        }
        if (!manualSessionId) {
            toastError("Uyarı", "Lütfen hedef oturumu veya dersi seçin.");
            return;
        }
        if (!token || !tenantId) return;

        const durationMinutes = parseInt(manualDuration) || 0;
        const durationSeconds = durationMinutes * 60;

        setManualSubmitting(true);
        try {
            if (manualSessionId === "direct-course") {
                await adminBbbApi.assignRecording(token, tenantId, {
                    courseId: courseId,
                    sessionId: null,
                    recordingId: null,
                    playbackUrl: manualUrl.trim(),
                    durationSeconds: durationSeconds
                });
                success("Başarılı", "Video derse doğrudan eklendi.");
            } else {
                await adminBbbApi.assignRecording(token, tenantId, {
                    sessionId: manualSessionId,
                    courseId: null,
                    recordingId: null,
                    playbackUrl: manualUrl.trim(),
                    durationSeconds: durationSeconds
                });
                success("Başarılı", "Manuel video kaydı oturuma bağlandı.");
            }
            setManualUrl("");
            setManualDuration("");
            setManualSessionId("");
            onSuccess();
            onClose();
        } catch (err: any) {
            toastError("Hata", err.message || "Video kaydedilemedi.");
        } finally {
            setManualSubmitting(false);
        }
    };

    if (!isOpen || !mounted) return null;

    const modalContent = (
        <div 
            className="fixed inset-0 z-[99999] flex items-center justify-center p-3 sm:p-6 bg-[#0A1931]/60 backdrop-blur-md transition-all animate-in fade-in duration-150"
            onClick={onClose}
        >
            <div 
                className="bg-white rounded-3xl shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col overflow-hidden border border-slate-200/80 animate-in zoom-in-95 duration-150"
                onClick={e => e.stopPropagation()}
            >
                {/* ── Header ────────────────────────────────────────────── */}
                <div className="relative overflow-hidden px-6 py-4.5 border-b border-slate-100 bg-gradient-to-r from-slate-50 to-white shrink-0">
                    <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-[#0A1931] via-[#1B3B6F] to-[#0A1931]" />
                    <div className="flex items-center justify-between relative z-10">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-2xl flex items-center justify-center shadow-sm border border-slate-200/80 bg-white text-[#0A1931]">
                                <Video size={20} className="stroke-[2.2]" />
                            </div>
                            <div>
                                <div className="flex items-center gap-2">
                                    <h3 className="text-base sm:text-lg font-black text-[#0A1931] tracking-tight">BBB Kayıt Aktarma Sihirbazı</h3>
                                    <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#0A1931] text-white">YÖNETİCİ</span>
                                </div>
                                <p className="text-[11px] font-medium text-slate-500 mt-0.5">Sunucudaki canlı ders kayıtlarını tek tıkla kursa ve ilgili oturumlara eşleyin.</p>
                            </div>
                        </div>
                        <button 
                            onClick={onClose}
                            className="w-8 h-8 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-400 hover:text-slate-700 hover:border-slate-300 shadow-sm transition-all"
                            title="Kapat (ESC)"
                        >
                            <X size={15} strokeWidth={2.5} />
                        </button>
                    </div>
                </div>

                {/* ── Tabs ──────────────────────────────────────────────── */}
                <div className="flex border-b border-slate-200/80 px-6 bg-slate-50/50 shrink-0 gap-2">
                    <button 
                        onClick={() => setActiveTab("server")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${
                            activeTab === "server" 
                                ? "border-[#0A1931] text-[#0A1931] bg-white rounded-t-xl" 
                                : "border-transparent text-slate-400 hover:text-slate-700"
                        }`}
                    >
                        <Video size={14} /> Sunucudaki Kayıtlar
                        {recordings.length > 0 && (
                            <span className={`px-1.5 py-0.2 rounded-full text-[10px] font-bold ${activeTab === "server" ? "bg-[#0A1931] text-white" : "bg-slate-200 text-slate-600"}`}>
                                {recordings.length}
                            </span>
                        )}
                    </button>
                    <button 
                        onClick={() => setActiveTab("manual")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-2 ${
                            activeTab === "manual" 
                                ? "border-[#0A1931] text-[#0A1931] bg-white rounded-t-xl" 
                                : "border-transparent text-slate-400 hover:text-slate-700"
                        }`}
                    >
                        <Link2 size={14} /> Manuel Video URL Ekle
                    </button>
                </div>

                {/* ── Content ───────────────────────────────────────────── */}
                <div className="flex-1 overflow-y-auto p-4 sm:p-6 bg-slate-50/30">
                    {activeTab === "server" ? (
                        <div className="space-y-4 flex flex-col h-full">
                            {/* Arama & Hızlı Filtre Barı */}
                            <div className="flex flex-col gap-3 shrink-0 bg-white p-3.5 rounded-2xl border border-slate-200/80 shadow-sm">
                                <div className="flex items-center gap-2 sm:gap-3">
                                    <div className="relative flex-1">
                                        <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                                        <input 
                                            type="text" 
                                            placeholder="Ders adı, kayıt kimliği veya meetingID ile ara..."
                                            value={searchQuery}
                                            onChange={e => setSearchQuery(e.target.value)}
                                            className="w-full pl-10 pr-4 py-2 text-xs font-medium border border-slate-200 rounded-xl text-slate-800 bg-slate-50/50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all"
                                        />
                                    </div>
                                    <button 
                                        onClick={loadRecordings} 
                                        disabled={loading}
                                        className="px-3.5 py-2 bg-slate-50 hover:bg-slate-100 text-xs font-bold border border-slate-200 text-slate-700 rounded-xl transition-all flex items-center gap-1.5 shadow-sm disabled:opacity-50 shrink-0"
                                        title="Sunucudaki kayıtları yeniden çek"
                                    >
                                        <RefreshCw size={13} className={loading ? "animate-spin text-[#0A1931]" : ""} />
                                        <span className="hidden sm:inline">Yenile</span>
                                    </button>
                                </div>

                                {/* Tarih & Durum Filtreleri */}
                                <div className="flex items-center justify-between flex-wrap gap-2 pt-1 border-t border-slate-100">
                                    <div className="flex items-center gap-1.5 overflow-x-auto">
                                        <span className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider mr-1 shrink-0 flex items-center gap-1">
                                            <Filter size={11} /> Tarih:
                                        </span>
                                        {(["all", "today", "yesterday", "week", "month"] as const).map(f => {
                                            const label = f === "all" ? "Tümü" : f === "today" ? "Bugün" : f === "yesterday" ? "Dün" : f === "week" ? "Son 7 Gün" : "Son 30 Gün";
                                            return (
                                                <button
                                                    key={f}
                                                    type="button"
                                                    onClick={() => setDateFilter(f)}
                                                    className={`px-2.5 py-1 text-[11px] font-bold rounded-lg transition-all border shrink-0 ${
                                                        dateFilter === f
                                                            ? "bg-[#0A1931] border-[#0A1931] text-white shadow-sm"
                                                            : "bg-white border-slate-200 text-slate-500 hover:text-slate-800 hover:bg-slate-50"
                                                    }`}
                                                >
                                                    {label}
                                                </button>
                                            );
                                        })}
                                    </div>

                                    <button
                                        type="button"
                                        onClick={handleAutoMatch}
                                        disabled={loading || recordings.length === 0}
                                        className="px-3 py-1 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 border border-indigo-200 text-[11px] font-bold rounded-lg transition-all flex items-center gap-1.5 shadow-sm disabled:opacity-50"
                                        title="Kayıt isimlerini ve ders tarihlerini akıllı algoritmayla eşle"
                                    >
                                        <Sparkles size={12} className="text-indigo-600" /> Akıllı Otomatik Eşleştir
                                    </button>
                                </div>
                            </div>

                            {/* Toplu İşlem Çubuğu */}
                            {filteredRecordings.length > 0 && (
                                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3 bg-gradient-to-r from-indigo-50/80 to-blue-50/80 border border-indigo-100 rounded-2xl shrink-0">
                                    <div className="flex items-center gap-2.5">
                                        <input 
                                            type="checkbox"
                                            checked={filteredRecordings.length > 0 && selectedRecordingIds.length === filteredRecordings.length}
                                            onChange={handleToggleSelectAll}
                                            className="w-4 h-4 text-indigo-600 border-slate-300 rounded focus:ring-indigo-500 cursor-pointer"
                                        />
                                        <span className="text-xs font-bold text-indigo-950">
                                            {selectedRecordingIds.length > 0 
                                                ? `${selectedRecordingIds.length} / ${filteredRecordings.length} kayıt seçildi`
                                                : `Tümünü Seç (${filteredRecordings.length} Kayıt)`
                                            }
                                        </span>
                                    </div>
                                    
                                    {selectedRecordingIds.length > 0 && (
                                        <div className="flex items-center gap-2 flex-wrap">
                                            <button
                                                type="button"
                                                onClick={handleBulkAssign}
                                                disabled={bulkAssigning}
                                                className="px-3.5 py-1.5 bg-[#0A1931] hover:bg-[#1B3B6F] text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center gap-1.5 disabled:opacity-50"
                                            >
                                                {bulkAssigning ? <Loader2 size={13} className="animate-spin" /> : <CheckCircle2 size={13} />}
                                                Seçilenleri Toplu Bağla ({selectedRecordingIds.length})
                                            </button>
                                            <button
                                                type="button"
                                                onClick={() => setSelectedRecordingIds([])}
                                                className="px-2.5 py-1.5 text-slate-400 hover:text-slate-600 text-xs font-semibold"
                                            >
                                                Seçimi Kaldır
                                            </button>
                                        </div>
                                    )}
                                </div>
                            )}

                            {/* Kayıt Listesi */}
                            <div className="flex-1 min-h-[320px] overflow-y-auto space-y-2.5 pr-1">
                                {loading ? (
                                    <div className="flex flex-col items-center justify-center py-20 text-slate-400">
                                        <Loader2 size={36} className="animate-spin text-[#0A1931] mb-3" />
                                        <p className="text-xs font-bold text-slate-600">BBB sunucusundan kayıtlar taranıyor...</p>
                                        <p className="text-[11px] text-slate-400 mt-0.5">Lütfen bekleyin</p>
                                    </div>
                                ) : filteredRecordings.length === 0 ? (
                                    <div className="text-center py-20 text-slate-400 bg-white border border-slate-200/80 rounded-2xl p-6">
                                        <Video size={36} className="mx-auto opacity-20 mb-2.5 text-[#0A1931]" />
                                        <p className="text-sm font-bold text-slate-700">BBB sunucusunda aranan kriterde kayıt bulunamadı.</p>
                                        <p className="text-xs text-slate-400 mt-1">Farklı bir tarih filtresi seçebilir veya arama kelimesini temizleyebilirsiniz.</p>
                                    </div>
                                ) : (
                                    filteredRecordings.map(rec => {
                                        const dateStr = rec.startTime ? new Date(rec.startTime).toLocaleDateString("tr-TR", { 
                                            day: "numeric", month: "long", year: "numeric", hour: "2-digit", minute: "2-digit" 
                                        }) : "-";
                                        
                                        const totalMinutes = Math.round(rec.durationSeconds / 60);
                                        const durationText = totalMinutes >= 60 
                                            ? `${Math.floor(totalMinutes / 60)} sa ${totalMinutes % 60} dk` 
                                            : `${totalMinutes} dakika`;

                                        const isSelected = selectedRecordingIds.includes(rec.recordingId);
                                        const currentTarget = selectedSessions[rec.recordingId] || "";
                                        const isAutoSuggested = currentTarget && currentTarget !== "direct-course";

                                        return (
                                            <div 
                                                key={rec.recordingId} 
                                                className={`flex flex-col md:flex-row md:items-center justify-between gap-3.5 p-4 rounded-2xl border transition-all shadow-sm ${
                                                    isSelected 
                                                        ? 'bg-indigo-50/30 border-indigo-300 ring-1 ring-indigo-200' 
                                                        : 'bg-white border-slate-200/90 hover:border-slate-300'
                                                }`}
                                            >
                                                {/* Sol: Seçim & Bilgi */}
                                                <div className="flex items-start gap-3 flex-1 min-w-0">
                                                    <input 
                                                        type="checkbox"
                                                        checked={isSelected}
                                                        onChange={() => handleToggleSelect(rec.recordingId)}
                                                        className="mt-1 w-4 h-4 text-[#0A1931] border-slate-300 rounded focus:ring-[#0A1931] cursor-pointer"
                                                    />
                                                    <div className="flex-1 min-w-0">
                                                        <div className="flex items-center gap-2 mb-1 flex-wrap">
                                                            <span className="text-[10px] font-mono font-bold bg-slate-100 border border-slate-200 text-slate-600 px-2 py-0.5 rounded-md">
                                                                ID: {rec.recordingId.substring(0, 10)}...
                                                            </span>
                                                            <span className="text-[10px] font-bold bg-emerald-50 border border-emerald-200 text-emerald-700 px-2 py-0.5 rounded-md uppercase">
                                                                {rec.status}
                                                            </span>
                                                            {isAutoSuggested && (
                                                                <span className="text-[10px] font-bold bg-indigo-50 border border-indigo-100 text-indigo-700 px-2 py-0.5 rounded-md flex items-center gap-1">
                                                                    <Sparkles size={10} /> Önerilen
                                                                </span>
                                                            )}
                                                        </div>

                                                        <p className="text-sm font-bold text-slate-900 truncate" title={rec.name || rec.meetingId}>
                                                            {rec.name || rec.meetingId}
                                                        </p>

                                                        <p className="text-[11px] text-slate-400 font-mono truncate mt-0.5" title={rec.meetingId}>
                                                            Toplantı ID: {rec.meetingId}
                                                        </p>

                                                        <div className="flex items-center gap-3.5 text-[11px] text-slate-500 font-medium mt-1.5 flex-wrap">
                                                            <span className="flex items-center gap-1"><Calendar size={12} className="text-slate-400" /> {dateStr}</span>
                                                            <span className="flex items-center gap-1"><Clock size={12} className="text-slate-400" /> {durationText}</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                {/* Sağ: Hedef Seçimi & Butonlar */}
                                                <div className="flex items-center gap-2 shrink-0 pt-2 md:pt-0 border-t md:border-t-0 border-slate-100">
                                                    {rec.playbackUrl && (
                                                        <a 
                                                            href={rec.playbackUrl} 
                                                            target="_blank" 
                                                            rel="noopener noreferrer" 
                                                            className="p-2 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-xl transition-all border border-transparent hover:border-blue-100"
                                                            title="Oynatıcıyı Yeni Sekmede Test Et"
                                                        >
                                                            <ExternalLink size={15} />
                                                        </a>
                                                    )}
                                                    
                                                    {/* Hedef Oturum / Ders Dropdown */}
                                                    <select 
                                                        value={currentTarget}
                                                        onChange={e => setSelectedSessions(prev => ({ ...prev, [rec.recordingId]: e.target.value }))}
                                                        className={`px-3 py-2 text-xs font-bold border rounded-xl text-slate-800 focus:outline-none transition-all cursor-pointer w-52 sm:w-60 truncate ${
                                                            currentTarget 
                                                                ? "bg-indigo-50/50 border-indigo-200 text-indigo-900" 
                                                                : "bg-slate-50 border-slate-200 focus:bg-white"
                                                        }`}
                                                    >
                                                        <option value="">— Hedef Oturum Seçin —</option>
                                                        <option value="direct-course">📂 Doğrudan Derse Bağımsız Video Ekle</option>
                                                        {sessions.length > 0 && (
                                                            <optgroup label="Canlı Ders Oturumları">
                                                                {sessions.map(s => (
                                                                    <option key={s.id} value={s.id}>
                                                                        {s.hasRecording ? "✓ " : "○ "} {s.title} ({s.date})
                                                                    </option>
                                                                ))}
                                                            </optgroup>
                                                        )}
                                                    </select>

                                                    <button 
                                                        onClick={() => handleAssignServerRecording(rec)}
                                                        disabled={assigning === rec.recordingId || !currentTarget}
                                                        className={`px-3.5 py-2 text-xs font-bold rounded-xl flex items-center gap-1.5 transition-all shadow-sm shrink-0 ${
                                                            !currentTarget 
                                                                ? "bg-slate-100 text-slate-400 border border-slate-200 cursor-not-allowed" 
                                                                : "bg-[#0A1931] hover:bg-[#1B3B6F] text-white active:scale-95"
                                                        }`}
                                                    >
                                                        {assigning === rec.recordingId ? <Loader2 size={13} className="animate-spin" /> : <Check size={13} strokeWidth={2.5} />}
                                                        Bağla
                                                    </button>
                                                </div>
                                            </div>
                                        );
                                    })
                                )}
                            </div>
                        </div>
                    ) : (
                        /* ── Tab 2: Diskten Manuel Video Ekle Formu ─────────────── */
                        <form onSubmit={handleAssignManual} className="space-y-4 max-w-xl mx-auto bg-white p-6 border border-slate-200 rounded-3xl shadow-sm my-4">
                            <div className="flex items-center gap-2 border-b border-slate-100 pb-3 mb-2">
                                <div className="w-8 h-8 rounded-xl bg-slate-100 flex items-center justify-center text-slate-700">
                                    <Link2 size={16} />
                                </div>
                                <div>
                                    <h4 className="text-sm font-bold text-slate-900">Diskten Taşınan / Harici Kayıt Ekleme</h4>
                                    <p className="text-[11px] text-slate-500">Doğrudan bir BBB veya MP4/HLS oynatma URL'ini derse bağlayın.</p>
                                </div>
                            </div>
                            
                            <div>
                                <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                    Kayıt Oynatma URL'i (Playback URL) <span className="text-red-500">*</span>
                                </label>
                                <input 
                                    type="url" 
                                    required
                                    placeholder="https://canli.domain.com/playback/presentation/2.3/..."
                                    value={manualUrl} 
                                    onChange={e => setManualUrl(e.target.value)}
                                    className="w-full px-4 py-2.5 text-xs font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50/60 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white placeholder:text-slate-400 placeholder:font-normal transition-all" 
                                />
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
                                <div>
                                    <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                        Video Süresi (Dakika)
                                    </label>
                                    <input 
                                        type="number" 
                                        placeholder="Örn: 60"
                                        value={manualDuration} 
                                        onChange={e => setManualDuration(e.target.value)}
                                        className="w-full px-4 py-2.5 text-xs font-semibold border border-slate-200 rounded-xl text-slate-900 bg-slate-50/60 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white placeholder:text-slate-400 transition-all" 
                                    />
                                </div>
                                <div>
                                    <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                        Hedef Oturum / Ders <span className="text-red-500">*</span>
                                    </label>
                                    <select 
                                        required
                                        value={manualSessionId} 
                                        onChange={e => setManualSessionId(e.target.value)}
                                        className="w-full px-4 py-2.5 text-xs font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50/60 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all cursor-pointer"
                                    >
                                        <option value="">— Hedef Seçin —</option>
                                        <option value="direct-course">📂 Doğrudan Derse Bağımsız Video Ekle</option>
                                        {sessions.length > 0 && (
                                            <optgroup label="Canlı Oturumlar">
                                                {sessions.map(s => (
                                                    <option key={s.id} value={s.id}>
                                                        {s.hasRecording ? "✓ " : "○ "} {s.title} ({s.date})
                                                    </option>
                                                ))}
                                            </optgroup>
                                        )}
                                    </select>
                                </div>
                            </div>

                            <div className="pt-3 flex justify-end">
                                <button 
                                    type="submit"
                                    disabled={manualSubmitting}
                                    className="px-5 py-2.5 bg-[#0A1931] text-white hover:bg-[#1B3B6F] text-xs font-bold rounded-xl transition-all shadow-md flex items-center gap-1.5 active:scale-95 disabled:opacity-50"
                                >
                                    {manualSubmitting ? <Loader2 size={14} className="animate-spin" /> : <Check size={14} strokeWidth={2.5} />}
                                    Video Kaydını Bağla
                                </button>
                            </div>
                        </form>
                    )}
                </div>
            </div>
        </div>
    );

    return createPortal(modalContent, document.body);
}
