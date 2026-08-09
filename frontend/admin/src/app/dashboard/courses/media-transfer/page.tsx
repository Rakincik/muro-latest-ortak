"use client";

import React, { useState, useEffect, useMemo } from "react";
import { ArrowLeft, Search, Building2, Check, Loader2, MoveRight, Layers, Video, Info, X } from "lucide-react";
import { courseApi, mediaLibraryApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { CustomSelect } from "@/components/ui/CustomSelect";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { CourseListDto, CourseMediaDto } from "@/lib/api/types";

export default function MediaTransferPage() {
    const { token, currentTenantId: tenantId, user } = useAuth();
    const { success, error: toastError } = useToast();
    const router = useRouter();

    const [courses, setCourses] = useState<CourseListDto[]>([]);
    const [loadingCourses, setLoadingCourses] = useState(false);

    // Selected courses
    const [sourceCourseId, setSourceCourseId] = useState<string>("");
    const [targetCourseId, setTargetCourseId] = useState<string>("");

    // Medias list
    const [sourceMedias, setSourceMedias] = useState<CourseMediaDto[]>([]);
    const [targetMedias, setTargetMedias] = useState<CourseMediaDto[]>([]);
    const [loadingSource, setLoadingSource] = useState(false);
    const [loadingTarget, setLoadingTarget] = useState(false);

    // Search queries
    const [sourceSearch, setSourceSearch] = useState("");
    const [targetSearch, setTargetSearch] = useState("");

    // Drag and drop visual state
    const [isDragOver, setIsDragOver] = useState(false);
    const [transferring, setTransferring] = useState<string | null>(null);
    const [selectedSourceIds, setSelectedSourceIds] = useState<string[]>([]);
    const [bulkTransferring, setBulkTransferring] = useState(false);

    // Security Guard: Only SuperAdmin allowed
    const isSuperAdmin = user?.role === "SuperAdmin";

    // Fetch all courses
    useEffect(() => {
        if (!isSuperAdmin) return;
        if (!token || !tenantId) return;

        setLoadingCourses(true);
        courseApi.list(token, tenantId, { pageSize: 1000 })
            .then(res => setCourses(res.items || []))
            .catch(() => toastError("Hata", "Kurs listesi yüklenemedi."))
            .finally(() => setLoadingCourses(false));
    }, [token, tenantId, isSuperAdmin]);

    // Fetch source course medias
    useEffect(() => {
        if (!token || !tenantId || !sourceCourseId) {
            setSourceMedias([]);
            return;
        }
        setLoadingSource(true);
        mediaLibraryApi.getCourseMedias(sourceCourseId)
            .then(res => setSourceMedias(res || []))
            .catch(() => {})
            .finally(() => setLoadingSource(false));
    }, [sourceCourseId, token, tenantId]);

    // Fetch target course medias
    useEffect(() => {
        if (!token || !tenantId || !targetCourseId) {
            setTargetMedias([]);
            return;
        }
        setLoadingTarget(true);
        mediaLibraryApi.getCourseMedias(targetCourseId)
            .then(res => setTargetMedias(res || []))
            .catch(() => {})
            .finally(() => setLoadingTarget(false));
    }, [targetCourseId, token, tenantId]);

    // Reset selection when source course changes
    useEffect(() => {
        setSelectedSourceIds([]);
    }, [sourceCourseId]);

    // Filter source medias - must have mediaAssetId
    const filteredSourceMedias = useMemo(() => {
        const list = sourceMedias.filter(m => !!m.mediaAssetId);
        if (!sourceSearch) return list;
        const q = sourceSearch.toLowerCase();
        return list.filter(m => 
            (m.mediaAsset?.title && m.mediaAsset.title.toLowerCase().includes(q)) ||
            (m.customTitle && m.customTitle.toLowerCase().includes(q))
        );
    }, [sourceMedias, sourceSearch]);

    // Filter target medias
    const filteredTargetMedias = useMemo(() => {
        if (!targetSearch) return targetMedias;
        const q = targetSearch.toLowerCase();
        return targetMedias.filter(m => 
            (m.mediaAsset?.title && m.mediaAsset.title.toLowerCase().includes(q)) ||
            (m.customTitle && m.customTitle.toLowerCase().includes(q))
        );
    }, [targetMedias, targetSearch]);

    const courseOptions = useMemo(() => {
        const mapped = courses.map(c => ({
            label: c.title,
            value: c.id
        }));
        return [
            { label: "Kurs Seçiniz...", value: "" },
            ...mapped
        ];
    }, [courses]);

    const handleToggleSelect = (mediaAssetId: string) => {
        setSelectedSourceIds(prev => 
            prev.includes(mediaAssetId) 
                ? prev.filter(id => id !== mediaAssetId) 
                : [...prev, mediaAssetId]
        );
    };

    const handleToggleSelectAll = () => {
        const validIds = filteredSourceMedias
            .map(m => m.mediaAssetId)
            .filter((id): id is string => !!id);

        if (selectedSourceIds.length === validIds.length) {
            setSelectedSourceIds([]);
        } else {
            setSelectedSourceIds(validIds);
        }
    };

    // Drag handlers
    const handleDragStart = (e: React.DragEvent, mediaAssetId: string, title: string) => {
        e.dataTransfer.setData("mediaAssetId", mediaAssetId);
        e.dataTransfer.setData("title", title);
        e.dataTransfer.effectAllowed = "copy";
    };

    const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault();
        if (targetCourseId && sourceCourseId !== targetCourseId) {
            setIsDragOver(true);
        }
    };

    const handleDragLeave = () => {
        setIsDragOver(false);
    };

    const handleDrop = async (e: React.DragEvent) => {
        e.preventDefault();
        setIsDragOver(false);
        const mediaAssetId = e.dataTransfer.getData("mediaAssetId");
        const title = e.dataTransfer.getData("title");
        if (mediaAssetId) {
            await handleTransfer(mediaAssetId, title);
        }
    };

    // Main Transfer Execution
    const handleTransfer = async (mediaAssetId: string, title: string) => {
        if (!targetCourseId) {
            toastError("Hata", "Lütfen önce sağ sütundan hedef kursu seçin.");
            return;
        }

        if (sourceCourseId === targetCourseId) {
            toastError("Hata", "Aynı kursun içine kendisinden video transfer edemezsiniz.");
            return;
        }

        const alreadyExists = targetMedias.some(m => m.mediaAssetId === mediaAssetId);
        if (alreadyExists) {
            toastError("Uyarı", `"${title}" videosu hedef kursta zaten ekli.`);
            return;
        }

        setTransferring(mediaAssetId);
        try {
            await mediaLibraryApi.assignMediaToCourse(targetCourseId, mediaAssetId);
            success("Başarılı", `"${title}" ders kaydı hedef kursa başarıyla kopyalandı.`);
            
            // Reload target list
            if (token && tenantId) {
                setLoadingTarget(true);
                const updated = await mediaLibraryApi.getCourseMedias(targetCourseId);
                setTargetMedias(updated || []);
                setLoadingTarget(false);
            }
        } catch (err: any) {
            toastError("Hata", err.message || "Video kopyalanamadı.");
        } finally {
            setTransferring(null);
        }
    };

    // Bulk Transfer Execution
    const handleBulkTransfer = async () => {
        if (selectedSourceIds.length === 0) return;
        if (!targetCourseId) {
            toastError("Hata", "Lütfen önce sağ sütundan hedef kursu seçin.");
            return;
        }

        if (sourceCourseId === targetCourseId) {
            toastError("Hata", "Aynı kursun içine kendisinden video transfer edemezsiniz.");
            return;
        }

        setBulkTransferring(true);
        let successCount = 0;
        let failCount = 0;

        try {
            const existingIds = new Set(targetMedias.map(m => m.mediaAssetId));

            for (const mediaAssetId of selectedSourceIds) {
                if (existingIds.has(mediaAssetId)) {
                    continue; // Skip already mapped
                }

                try {
                    await mediaLibraryApi.assignMediaToCourse(targetCourseId, mediaAssetId);
                    successCount++;
                } catch {
                    failCount++;
                }
            }

            if (successCount > 0) {
                success("Başarılı", `${successCount} ders kaydı hedef kursa başarıyla kopyalandı.`);
            }
            if (failCount > 0) {
                toastError("Hata", `${failCount} ders kaydı kopyalanırken hata oluştu.`);
            }

            setSelectedSourceIds([]);
            
            // Reload target list
            if (token && tenantId) {
                setLoadingTarget(true);
                const updated = await mediaLibraryApi.getCourseMedias(targetCourseId);
                setTargetMedias(updated || []);
                setLoadingTarget(false);
            }
        } catch (err) {
            toastError("Hata", "Toplu aktarım sırasında bir hata oluştu.");
        } finally {
            setBulkTransferring(false);
        }
    };

    if (!isSuperAdmin) {
        return (
            <div className="flex flex-col items-center justify-center min-h-[60vh] text-center p-8">
                <Info size={48} className="text-red-500 mb-4 animate-bounce" />
                <h3 className="text-xl font-black text-[#0A1931]">Erişim Engellendi</h3>
                <p className="text-xs text-slate-500 font-bold mt-1 max-w-md">
                    Bu araç sadece Süper Admin özel yetkileriyle erişilebilir. Lütfen ana sayfaya dönün.
                </p>
                <Link href="/dashboard" className="mt-6 px-4 py-2 bg-[#0A1931] text-white text-xs font-bold rounded-xl shadow-md hover:bg-[#1b3b6f] transition-all">
                    Ana Sayfaya Dön
                </Link>
            </div>
        );
    }

    return (
        <div className="flex flex-col min-h-screen bg-[#F8FAFC] pb-12">
            {/* Page Header */}
            <div className="px-6 py-5 border-b border-[#E2E8F0] bg-white shrink-0 shadow-sm flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <Link href="/dashboard/courses" className="w-9 h-9 border border-[#E2E8F0] rounded-xl flex items-center justify-center hover:bg-slate-50 text-slate-500 transition-colors shadow-sm">
                        <ArrowLeft size={16} />
                    </Link>
                    <div>
                        <h3 className="text-lg font-black text-[#0A1931] tracking-tight">Süper Admin Ders Klonlama Paneli</h3>
                        <p className="text-[10px] font-extrabold text-[#64748B] uppercase tracking-widest mt-0.5">Sürükle-Bırak Müfredat Kopyalayıcı</p>
                    </div>
                </div>
            </div>

            {/* Split View Workspace */}
            <div className="p-6 grid grid-cols-1 lg:grid-cols-2 gap-6 items-stretch flex-1">
                
                {/* Source Column */}
                <div className="bg-white border border-[#E2E8F0] rounded-2xl shadow-sm flex flex-col p-6 overflow-hidden min-h-[600px]">
                    <div className="flex items-center gap-2 mb-4">
                        <div className="w-8 h-8 rounded-xl bg-indigo-50 border border-indigo-100 flex items-center justify-center text-indigo-700">
                            <Layers size={14} />
                        </div>
                        <div>
                            <h4 className="text-sm font-black text-[#0A1931]">Kaynak Kurs (Videoların Alınacağı Yer)</h4>
                            <p className="text-[10px] font-bold text-slate-400">Ders videosunu sağdaki kursa kopyalamak için sürükleyin veya oka basın</p>
                        </div>
                    </div>

                    {/* Source Course Dropdown */}
                    <div className="mb-4">
                        <label className="text-[10px] font-extrabold text-[#64748B] uppercase tracking-widest block mb-1.5">Kurs Seçin</label>
                        <CustomSelect
                            value={sourceCourseId}
                            onChange={(val) => {
                                setSourceCourseId(val as string);
                                setSourceSearch("");
                            }}
                            options={courseOptions}
                            placeholder="Kaynak Kursu Seçiniz"
                            searchable={true}
                            className="w-full"
                        />
                    </div>

                    {/* Source Search, Bulk Actions & List */}
                    {sourceCourseId && (
                        <div className="flex-1 flex flex-col min-h-0 space-y-3">
                            <div className="relative">
                                <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                                <input 
                                    type="text"
                                    placeholder="Ders adı ile filtrele..."
                                    value={sourceSearch}
                                    onChange={e => setSourceSearch(e.target.value)}
                                    className="w-full pl-9 pr-4 py-2.5 text-xs font-semibold border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-white focus:outline-none focus:ring-2 focus:ring-slate-100 focus:border-slate-300 transition-all"
                                />
                            </div>

                            {/* Bulk Selection Bar */}
                            {filteredSourceMedias.length > 0 && (
                                <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3 bg-indigo-50/50 border border-indigo-100 rounded-xl animate-in fade-in duration-200">
                                    <div className="flex items-center gap-2">
                                        <input 
                                            type="checkbox"
                                            checked={filteredSourceMedias.length > 0 && selectedSourceIds.length === filteredSourceMedias.length}
                                            onChange={handleToggleSelectAll}
                                            className="w-4 h-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500 cursor-pointer"
                                        />
                                        <span className="text-xs font-bold text-indigo-900">
                                            {selectedSourceIds.length > 0 
                                                ? `${selectedSourceIds.length} / ${filteredSourceMedias.length} ders seçildi`
                                                : "Tümünü Seç"
                                            }
                                        </span>
                                    </div>
                                    
                                    {selectedSourceIds.length > 0 && (
                                        <button
                                            type="button"
                                            onClick={handleBulkTransfer}
                                            disabled={!targetCourseId || bulkTransferring}
                                            className="px-3 py-1.5 bg-[#0A1931] hover:bg-[#1b3b6f] text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center gap-1.5 disabled:opacity-50"
                                        >
                                            {bulkTransferring ? <Loader2 size={12} className="animate-spin" /> : <Check size={12} />}
                                            Seçilenleri Kopyala ({selectedSourceIds.length})
                                        </button>
                                    )}
                                </div>
                            )}

                            <div className="flex-1 overflow-y-auto space-y-2 pr-1 min-h-[300px]">
                                {loadingSource ? (
                                    <div className="flex flex-col items-center justify-center py-20 text-slate-400">
                                        <Loader2 size={32} className="animate-spin text-[#0A1931] mb-2" />
                                        <p className="text-xs font-bold">Dersler yükleniyor...</p>
                                    </div>
                                ) : filteredSourceMedias.length === 0 ? (
                                    <div className="text-center py-16 text-slate-400 bg-slate-50 border border-dashed border-[#E2E8F0] rounded-xl">
                                        <Video size={24} className="mx-auto opacity-30 mb-2" />
                                        <p className="text-xs font-bold">Ders videosu bulunamadı.</p>
                                    </div>
                                ) : (
                                    filteredSourceMedias.map((item, index) => {
                                        const title = item.customTitle || item.mediaAsset?.title || "İsimsiz Video";
                                        const durationMin = item.mediaAsset?.durationSeconds ? Math.round(item.mediaAsset.durationSeconds / 60) : 0;
                                        const isSelected = selectedSourceIds.includes(item.mediaAssetId || "");
                                        
                                        return (
                                            <div 
                                                key={item.id}
                                                draggable
                                                onDragStart={(e) => handleDragStart(e, item.mediaAssetId || "", title)}
                                                className={`group flex items-center justify-between p-3 rounded-xl border transition-all select-none ${
                                                    isSelected 
                                                        ? 'bg-indigo-50/20 border-indigo-300 ring-2 ring-indigo-50/50 hover:border-indigo-400' 
                                                        : 'border-slate-200 bg-white hover:border-indigo-400 hover:shadow-md cursor-grab active:cursor-grabbing'
                                                }`}
                                            >
                                                <div className="flex items-center gap-3 min-w-0">
                                                    <input 
                                                        type="checkbox"
                                                        checked={isSelected}
                                                        onChange={() => handleToggleSelect(item.mediaAssetId || "")}
                                                        className="w-4 h-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500 cursor-pointer shrink-0"
                                                    />
                                                    <div className="w-7 h-7 rounded-lg bg-indigo-50 border border-indigo-100 flex items-center justify-center text-xs font-bold text-indigo-700 shrink-0">
                                                        {index + 1}
                                                    </div>
                                                    <div className="min-w-0">
                                                        <p className="text-xs font-bold text-[#0A1931] truncate">{title}</p>
                                                        {durationMin > 0 && <p className="text-[10px] font-semibold text-slate-400">{durationMin} dakika</p>}
                                                    </div>
                                                </div>

                                                <button
                                                    onClick={() => handleTransfer(item.mediaAssetId || "", title)}
                                                    disabled={!targetCourseId || transferring === item.mediaAssetId}
                                                    className="p-1.5 rounded-lg border border-slate-200 hover:border-indigo-500 hover:bg-indigo-50 text-slate-400 hover:text-indigo-700 disabled:opacity-30 disabled:pointer-events-none transition-all flex items-center gap-1.5"
                                                    title="Hedef Kursa Aktar"
                                                >
                                                    {transferring === item.mediaAssetId ? <Loader2 size={12} className="animate-spin" /> : <MoveRight size={12} />}
                                                </button>
                                            </div>
                                        );
                                    })
                                )}
                            </div>
                        </div>
                    )}
                </div>

                {/* Target Column */}
                <div className="bg-white border border-[#E2E8F0] rounded-2xl shadow-sm flex flex-col p-6 overflow-hidden min-h-[600px]">
                    <div className="flex items-center gap-2 mb-4">
                        <div className="w-8 h-8 rounded-xl bg-emerald-50 border border-emerald-100 flex items-center justify-center text-emerald-700">
                            <Layers size={14} />
                        </div>
                        <div>
                            <h4 className="text-sm font-black text-[#0A1931]">Hedef Kurs (Videoların Ekleneceği Yer)</h4>
                            <p className="text-[10px] font-bold text-slate-400">Soldan bir videoyu bu bölgeye sürükleyip bırakarak 21. ders olarak ekleyebilirsiniz</p>
                        </div>
                    </div>

                    {/* Target Course Dropdown */}
                    <div className="mb-4">
                        <label className="text-[10px] font-extrabold text-[#64748B] uppercase tracking-widest block mb-1.5">Kurs Seçin</label>
                        <CustomSelect
                            value={targetCourseId}
                            onChange={(val) => {
                                setTargetCourseId(val as string);
                                setTargetSearch("");
                            }}
                            options={courseOptions}
                            placeholder="Hedef Kursu Seçiniz"
                            searchable={true}
                            className="w-full"
                        />
                    </div>

                    {/* Target Search, Drag Drop Area, and List */}
                    {targetCourseId && (
                        <div 
                            onDragOver={handleDragOver}
                            onDragLeave={handleDragLeave}
                            onDrop={handleDrop}
                            className={`flex-1 flex flex-col min-h-0 space-y-3 p-1 rounded-2xl transition-all duration-300 ${
                                isDragOver 
                                    ? "bg-indigo-50/50 border-2 border-dashed border-indigo-400 ring-4 ring-indigo-50 scale-[1.01]" 
                                    : "border-2 border-transparent"
                            }`}
                        >
                            <div className="relative">
                                <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
                                <input 
                                    type="text"
                                    placeholder="Ders adı ile filtrele..."
                                    value={targetSearch}
                                    onChange={e => setTargetSearch(e.target.value)}
                                    className="w-full pl-9 pr-4 py-2.5 text-xs font-semibold border border-[#E2E8F0] rounded-xl text-[#0A1931] bg-white focus:outline-none focus:ring-2 focus:ring-slate-100 focus:border-slate-300 transition-all"
                                />
                            </div>

                            {/* Existing lessons in target */}
                            <div className="flex-1 overflow-y-auto space-y-2 pr-1 min-h-[300px]">
                                {loadingTarget ? (
                                    <div className="flex flex-col items-center justify-center py-20 text-slate-400">
                                        <Loader2 size={32} className="animate-spin text-[#0A1931] mb-2" />
                                        <p className="text-xs font-bold">Dersler yükleniyor...</p>
                                    </div>
                                ) : filteredTargetMedias.length === 0 ? (
                                    <div className="text-center py-20 text-slate-400 bg-slate-50/50 border border-dashed border-[#E2E8F0] rounded-xl flex flex-col items-center justify-center">
                                        <Video size={32} className="opacity-20 mb-2" />
                                        <p className="text-xs font-bold">Bu kursta henüz hiç ders videosu yok.</p>
                                        <p className="text-[10px] text-slate-400 font-bold mt-1">Videoları buraya sürükleyip bırakın.</p>
                                    </div>
                                ) : (
                                    <div className="space-y-2">
                                        {filteredTargetMedias.map((item, index) => {
                                            const title = item.customTitle || item.mediaAsset?.title || "İsimsiz Video";
                                            const durationMin = item.mediaAsset?.durationSeconds ? Math.round(item.mediaAsset.durationSeconds / 60) : 0;
                                            
                                            return (
                                                <div 
                                                    key={item.id}
                                                    className="flex items-center justify-between p-3 rounded-xl border border-[#E2E8F0] bg-slate-50 transition-all"
                                                >
                                                    <div className="flex items-center gap-3 min-w-0">
                                                        <div className="w-7 h-7 rounded-lg bg-slate-100 border border-slate-200 flex items-center justify-center text-xs font-bold text-slate-600 shrink-0">
                                                            {index + 1}
                                                        </div>
                                                        <div className="min-w-0">
                                                            <p className="text-xs font-bold text-[#0A1931] truncate">{title}</p>
                                                            {durationMin > 0 && <p className="text-[10px] font-semibold text-slate-400">{durationMin} dakika</p>}
                                                        </div>
                                                    </div>
                                                    <span className="text-[9px] font-extrabold bg-emerald-50 border border-emerald-100 text-emerald-600 px-2 py-0.5 rounded-lg flex items-center gap-1 shadow-sm shrink-0">
                                                        <Check size={10} strokeWidth={3} /> Yayında
                                                    </span>
                                                </div>
                                            );
                                        })}
                                        
                                        {/* Dynamic Dropzone indicator at the bottom of the list */}
                                        {isDragOver && (
                                            <div className="border-2 border-dashed border-indigo-400 bg-indigo-50/20 text-indigo-700 py-6 rounded-xl flex items-center justify-center text-xs font-bold animate-pulse">
                                                Buraya Bırakarak Sonuna Ekle
                                            </div>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>
                    )}
                </div>

            </div>
        </div>
    );
}
