"use client";

import React, { useState, useEffect, useMemo } from "react";
import { X, Search, Clock, Video, Loader2, Link2, ExternalLink, Calendar, Check } from "lucide-react";
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

export function BbbSyncModal({ isOpen, onClose, courseId, sessions, onSuccess }: BbbSyncModalProps) {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [activeTab, setActiveTab] = useState<"server" | "manual">("server");
    const [recordings, setRecordings] = useState<BbbRecordingInfo[]>([]);
    const [loading, setLoading] = useState(false);
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedSessions, setSelectedSessions] = useState<Record<string, string>>({}); // recordingId -> sessionId
    const [assigning, setAssigning] = useState<string | null>(null); // active recordingId being assigned

    // Manual form state
    const [manualUrl, setManualUrl] = useState("");
    const [manualDuration, setManualDuration] = useState("");
    const [manualSessionId, setManualSessionId] = useState("");
    const [manualSubmitting, setManualSubmitting] = useState(false);

    // Fetch BBB server recordings
    const loadRecordings = async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const data = await adminBbbApi.listRecordings(token, tenantId);
            setRecordings(data || []);
        } catch (err: any) {
            toastError("Hata", "BBB sunucusundan ders kayıtları çekilemedi.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (isOpen && activeTab === "server") {
            loadRecordings();
        }
    }, [isOpen, activeTab]);

    // Filter recordings
    const filteredRecordings = useMemo(() => {
        if (!searchQuery) return recordings;
        const q = searchQuery.toLowerCase();
        return recordings.filter(r => 
            (r.meetingId && r.meetingId.toLowerCase().includes(q)) ||
            (r.recordingId && r.recordingId.toLowerCase().includes(q))
        );
    }, [recordings, searchQuery])    // Handle server recording assignment
    const handleAssignServerRecording = async (rec: BbbRecordingInfo) => {
        const targetValue = selectedSessions[rec.recordingId];
        if (!targetValue || !token || !tenantId) {
            toastError("Uyarı", "Lütfen videoyu bağlamak için bir oturum veya ders seçin.");
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
                success("Başarılı", "Video kaydı doğrudan derse eklendi.");
            } else {
                await adminBbbApi.assignRecording(token, tenantId, {
                    sessionId: targetValue,
                    courseId: null,
                    recordingId: rec.recordingId,
                    playbackUrl: rec.playbackUrl || "",
                    durationSeconds: rec.durationSeconds
                });
                success("Başarılı", "Video kaydı oturuma başarıyla bağlandı.");
            }
            onSuccess();
            // Refresh recordings list to update status or remove if necessary
            loadRecordings();
        } catch (err: any) {
            toastError("Hata", err.message || "Video kaydı bağlanamadı.");
        } finally {
            setAssigning(null);
        }
    };

    // Handle manual URL assignment
    const handleAssignManual = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!manualUrl.trim()) {
            toastError("Uyarı", "Lütfen video URL adresini girin.");
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
                success("Başarılı", "Manuel video doğrudan derse eklendi.");
            } else {
                await adminBbbApi.assignRecording(token, tenantId, {
                    sessionId: manualSessionId,
                    courseId: null,
                    recordingId: null,
                    playbackUrl: manualUrl.trim(),
                    durationSeconds: durationSeconds
                });
                success("Başarılı", "Manuel video kaydı oturuma başarıyla bağlandı.");
            }
            setManualUrl("");
            setManualDuration("");
            setManualSessionId("");
            onSuccess();
            onClose();
        } catch (err: any) {
            toastError("Hata", err.message || "Video kaydı tanımlanamadı.");
        } finally {
            setManualSubmitting(false);
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm" onClick={onClose}>
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-4xl max-h-[85vh] flex flex-col overflow-hidden" onClick={e => e.stopPropagation()}>
                {/* Header */}
                <div className="relative overflow-hidden px-6 py-5 border-b border-[#E2E8F0] bg-[#F8FAFC] shrink-0">
                    <div className="absolute top-0 left-0 w-full h-1 bg-[#0A1931]" />
                    <div className="flex items-center justify-between relative z-10">
                        <div className="flex items-center gap-3">
                            <div className="w-10 h-10 rounded-xl flex items-center justify-center shadow-sm border border-[#E2E8F0] bg-white text-[#0A1931]">
                                <Video size={18} />
                            </div>
                            <div>
                                <h3 className="text-lg font-black text-[#0A1931] tracking-tight">BBB Kayıt Aktarma Sihirbazı</h3>
                                <p className="text-[10px] font-extrabold text-[#64748B] uppercase tracking-widest mt-0.5">Süper Admin Özel Paneli</p>
                            </div>
                        </div>
                        <button onClick={onClose} className="w-8 h-8 flex items-center justify-center rounded-full bg-white border border-[#E2E8F0] text-[#64748B] hover:text-[#0A1931] shadow-sm transition-colors"><X size={14} strokeWidth={3} /></button>
                    </div>
                </div>

                {/* Tabs */}
                <div className="flex border-b border-[#E2E8F0] px-6 bg-[#F8FAFC] shrink-0">
                    <button 
                        onClick={() => setActiveTab("server")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-1.5 ${activeTab === "server" ? "border-[#0A1931] text-[#0A1931]" : "border-transparent text-slate-400 hover:text-slate-600"}`}
                    >
                        <Video size={14} /> Sunucudaki Ders Kayıtları
                    </button>
                    <button 
                        onClick={() => setActiveTab("manual")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-1.5 ${activeTab === "manual" ? "border-[#0A1931] text-[#0A1931]" : "border-transparent text-slate-400 hover:text-slate-600"}`}
                    >
                        <Link2 size={14} /> Diskten Manuel Video Ekle
                    </button>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-6 bg-[#F8FAFC]">
                    {activeTab === "server" ? (
                        <div className="space-y-4 h-full flex flex-col">
                            {/* Search bar & Refresh */}
                            <div className="flex items-center gap-3 shrink-0">
                                <div className="relative flex-1">
                                    <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                                    <input 
                                        type="text" 
                                        placeholder="Kayıt kimliği veya meetingID ile ara..."
                                        value={searchQuery}
                                        onChange={e => setSearchQuery(e.target.value)}
                                        className="w-full pl-9 pr-4 py-2 text-xs font-medium border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-white focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] transition-all outline-none"
                                    />
                                </div>
                                <button 
                                    onClick={loadRecordings} 
                                    disabled={loading}
                                    className="px-3 py-2 bg-white text-xs font-bold border border-[#E2E8F0] hover:bg-slate-50 text-[#64748B] rounded-xl transition-all flex items-center gap-1.5 shadow-sm"
                                >
                                    Yenile
                                </button>
                            </div>

                            {/* Recordings List */}
                            <div className="flex-1 min-h-[300px] overflow-y-auto space-y-2 pr-1">
                                {loading ? (
                                    <div className="flex flex-col items-center justify-center py-20 text-slate-400">
                                        <Loader2 size={32} className="animate-spin text-[#0A1931] mb-2" />
                                        <p className="text-xs font-bold">Kayıtlar sunucudan yükleniyor...</p>
                                    </div>
                                ) : filteredRecordings.length === 0 ? (
                                    <div className="text-center py-20 text-slate-400 bg-white border border-[#E2E8F0] rounded-2xl">
                                        <Video size={32} className="mx-auto opacity-20 mb-2" />
                                        <p className="text-sm font-bold">BBB sunucusunda kayıt bulunamadı.</p>
                                    </div>
                                ) : (
                                    filteredRecordings.map(rec => {
                                        const dateStr = rec.startTime ? new Date(rec.startTime).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric", hour: "2-digit", minute: "2-digit" }) : "-";
                                        const durationMin = Math.round(rec.durationSeconds / 60);
                                        const isAssigned = false; // Add duplicate check if needed

                                        return (
                                            <div key={rec.recordingId} className="flex flex-col md:flex-row md:items-center justify-between gap-4 p-4 rounded-xl bg-white border border-[#E2E8F0] hover:border-slate-300 transition-all shadow-sm">
                                                <div className="flex-1 min-w-0">
                                                    <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                                                        <span className="text-[10px] font-mono bg-slate-100 border border-slate-200 text-slate-600 px-1.5 py-0.5 rounded">
                                                            Kayıt ID: {rec.recordingId.substring(0, 8)}...
                                                        </span>
                                                        <span className="text-[10px] font-bold bg-indigo-50 border border-indigo-100 text-indigo-700 px-1.5 py-0.5 rounded">
                                                            {rec.status}
                                                        </span>
                                                    </div>
                                                    <p className="text-sm font-bold text-[#0A1931] truncate" title={rec.name || rec.meetingId}>
                                                        {rec.name || rec.meetingId}
                                                    </p>
                                                    <p className="text-[10px] text-[#A0AEC0] truncate mt-0.5" title={rec.meetingId}>
                                                        Toplantı ID: {rec.meetingId}
                                                    </p>
                                                    <div className="flex items-center gap-3 text-[11px] text-[#A0AEC0] mt-1">
                                                        <span className="flex items-center gap-1"><Calendar size={12} /> {dateStr}</span>
                                                        <span className="flex items-center gap-1"><Clock size={12} /> {durationMin} dakika</span>
                                                    </div>
                                                </div>

                                                {/* Actions */}
                                                <div className="flex items-center gap-2 shrink-0">
                                                    {rec.playbackUrl && (
                                                        <a href={rec.playbackUrl} target="_blank" rel="noopener noreferrer" 
                                                            className="p-2 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all"
                                                            title="Oynatmayı Test Et">
                                                            <ExternalLink size={15} />
                                                        </a>
                                                    )}
                                                    
                                                    {/* Dropdown to select session */}
                                                    <select 
                                                        value={selectedSessions[rec.recordingId] || ""}
                                                        onChange={e => setSelectedSessions(prev => ({ ...prev, [rec.recordingId]: e.target.value }))}
                                                        className="px-3 py-1.5 text-xs font-medium border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-slate-50 focus:outline-none focus:bg-white transition-all cursor-pointer w-48"
                                                    >
                                                        <option value="">— Hedef Oturum / Ders —</option>
                                                        <option value="direct-course">— Doğrudan Derse Video Olarak Ekle —</option>
                                                        {sessions.length > 0 && (
                                                            <optgroup label="Canlı Oturumlar">
                                                                {sessions.map(s => (
                                                                    <option key={s.id} value={s.id}>
                                                                        {s.title} ({s.date})
                                                                    </option>
                                                                ))}
                                                            </optgroup>
                                                        )}
                                                    </select>

                                                    <button 
                                                        onClick={() => handleAssignServerRecording(rec)}
                                                        disabled={assigning === rec.recordingId || !selectedSessions[rec.recordingId]}
                                                        className={`px-3 py-1.5 text-xs font-bold rounded-xl flex items-center gap-1 transition-all ${
                                                            !selectedSessions[rec.recordingId] 
                                                                ? "bg-slate-100 text-slate-400 border border-slate-200 cursor-not-allowed" 
                                                                : "bg-[#0A1931] hover:bg-[#1B3B6F] text-white shadow-sm"
                                                        }`}
                                                    >
                                                        {assigning === rec.recordingId ? <Loader2 size={12} className="animate-spin" /> : <Check size={12} />}
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
                        /* Tab 2: Manual URL Form */
                        <form onSubmit={handleAssignManual} className="space-y-4 max-w-xl mx-auto bg-white p-6 border border-[#E2E8F0] rounded-2xl shadow-sm">
                            <h4 className="text-sm font-bold text-[#0A1931] mb-2 flex items-center gap-1.5 border-b border-slate-100 pb-2">
                                <Link2 size={16} className="text-[#0A1931]" /> Diskten Taşınan Kayıt Parametreleri
                            </h4>
                            
                            {/* URL */}
                            <div>
                                <label className="text-[11px] font-extrabold text-[#64748B] uppercase tracking-widest block mb-1.5">BBB Kayıt Oynatma URL'i <span className="text-red-500">*</span></label>
                                <input 
                                    type="url" 
                                    required
                                    placeholder="Örn: https://canli.uzeminiz.com/playback/presentation/2.3/..."
                                    value={manualUrl} 
                                    onChange={e => setManualUrl(e.target.value)}
                                    className="w-full px-4 py-3 text-sm font-bold border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-[#F8FAFC] focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white placeholder:text-[#A0AEC0] placeholder:font-medium transition-all" 
                                />
                            </div>

                            {/* Duration & Target Session side-by-side */}
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label className="text-[11px] font-extrabold text-[#64748B] uppercase tracking-widest block mb-1.5">Süre (Dakika)</label>
                                    <input 
                                        type="number" 
                                        placeholder="Örn: 60"
                                        value={manualDuration} 
                                        onChange={e => setManualDuration(e.target.value)}
                                        className="w-full px-4 py-3 text-sm border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-[#F8FAFC] focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white placeholder:text-[#A0AEC0] transition-all" 
                                    />
                                </div>
                                <div>
                                    <label className="text-[11px] font-extrabold text-[#64748B] uppercase tracking-widest block mb-1.5">Hedef Oturum <span className="text-red-500">*</span></label>
                                    <select 
                                        required
                                        value={manualSessionId} 
                                        onChange={e => setManualSessionId(e.target.value)}
                                        className="w-full px-4 py-3 text-sm font-medium border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-[#F8FAFC] focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all cursor-pointer"
                                    >
                                        <option value="">— Hedef Oturum / Ders Seçin —</option>
                                        <option value="direct-course">— Doğrudan Derse Video Olarak Ekle —</option>
                                        {sessions.length > 0 && (
                                            <optgroup label="Canlı Oturumlar">
                                                {sessions.map(s => (
                                                    <option key={s.id} value={s.id}>
                                                        {s.title} ({s.date})
                                                    </option>
                                                ))}
                                            </optgroup>
                                        )}
                                    </select>
                                </div>
                            </div>

                            {/* Submit */}
                            <div className="pt-4 flex justify-end">
                                <button 
                                    type="submit"
                                    disabled={manualSubmitting}
                                    className="px-5 py-2.5 bg-[#0A1931] text-white hover:bg-[#1B3B6F] text-xs font-bold rounded-xl transition-all shadow-md flex items-center gap-1.5"
                                >
                                    {manualSubmitting ? <Loader2 size={14} className="animate-spin" /> : <Check size={14} />}
                                    Video Kaydını Bağla
                                </button>
                            </div>
                        </form>
                    )}
                </div>
            </div>
        </div>
    );
}
