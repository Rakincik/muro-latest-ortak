"use client";

import React, { useState, useEffect, useMemo } from "react";
import { ArrowLeft, Search, Check, Loader2, MoveRight, Layers, Video, Info, X, GripVertical, Undo2, Folder, ChevronDown, ChevronRight } from "lucide-react";
import { courseApi, mediaLibraryApi } from "@/lib/api";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { CustomSelect } from "@/components/ui/CustomSelect";
import Link from "next/link";
import { useRouter } from "next/navigation";
import type { CourseListDto, CourseMediaDto, MediaFolderDto } from "@/lib/api/types";

export default function MediaTransferPage() {
    const { token, currentTenantId: tenantId, user } = useAuth();
    const { success, error: toastError } = useToast();
    const router = useRouter();

    const [courses, setCourses] = useState<CourseListDto[]>([]);
    const [loadingCourses, setLoadingCourses] = useState(false);
    
    // We need folder names for grouping
    const [folders, setFolders] = useState<Record<string, string>>({});

    // Selected courses
    const [sourceCourseId, setSourceCourseId] = useState<string>("");
    const [targetCourseIds, setTargetCourseIds] = useState<string[]>([]);

    // Medias list
    const [sourceMedias, setSourceMedias] = useState<CourseMediaDto[]>([]);
    const [targetMedias, setTargetMedias] = useState<CourseMediaDto[]>([]); // for the primary target course
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
    
    // Undo Stack
    const [undoStack, setUndoStack] = useState<{ targetCourseIds: string[], mediaAssetIds: string[], timestamp: number } | null>(null);
    const [isUndoing, setIsUndoing] = useState(false);
    
    // Folder Collapsed State
    const [collapsedFolders, setCollapsedFolders] = useState<Record<string, boolean>>({});

    // Security Guard: SuperAdmin and Admin allowed
    const isAllowed = user?.role === "SuperAdmin" || user?.role === "Admin";

    // Fetch all courses & folders
    useEffect(() => {
        if (!isAllowed) return;
        if (!token || !tenantId) return;

        setLoadingCourses(true);
        courseApi.list(token, tenantId, { pageSize: 1000 })
            .then(res => setCourses(res.items || []))
            .catch(() => toastError("Hata", "Kurs listesi yüklenemedi."))
            .finally(() => setLoadingCourses(false));
            
        mediaLibraryApi.getFolders(undefined, undefined, true).then(res => {
            const map: Record<string, string> = {};
            res.forEach(f => map[f.id] = f.name);
            setFolders(map);
        }).catch(() => {});
    }, [token, tenantId, isAllowed]);

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

    // Fetch primary target course medias
    useEffect(() => {
        if (!token || !tenantId || targetCourseIds.length === 0) {
            setTargetMedias([]);
            return;
        }
        setLoadingTarget(true);
        mediaLibraryApi.getCourseMedias(targetCourseIds[0])
            .then(res => setTargetMedias(res || []))
            .catch(() => {})
            .finally(() => setLoadingTarget(false));
    }, [targetCourseIds, token, tenantId]);

    // Reset selection when source course changes
    useEffect(() => {
        setSelectedSourceIds([]);
    }, [sourceCourseId]);

    // Clear Undo stack after 15 seconds
    useEffect(() => {
        if (!undoStack) return;
        const timer = setTimeout(() => {
            setUndoStack(null);
        }, 15000);
        return () => clearTimeout(timer);
    }, [undoStack]);

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
    
    // Group source medias by folder
    const groupedSourceMedias = useMemo(() => {
        const groups: Record<string, CourseMediaDto[]> = {};
        filteredSourceMedias.forEach(m => {
            const fId = m.mediaAsset?.folderId || "ungrouped";
            if (!groups[fId]) groups[fId] = [];
            groups[fId].push(m);
        });
        return groups;
    }, [filteredSourceMedias]);

    const courseOptions = useMemo(() => {
        const mapped = courses.map(c => ({
            label: c.title,
            value: c.id
        }));
        return mapped; 
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
    
    const handleToggleFolderSelect = (folderId: string) => {
        const folderMedias = groupedSourceMedias[folderId] || [];
        const validIds = folderMedias.map(m => m.mediaAssetId).filter((id): id is string => !!id);
        
        const allSelected = validIds.every(id => selectedSourceIds.includes(id));
        
        if (allSelected) {
            setSelectedSourceIds(prev => prev.filter(id => !validIds.includes(id)));
        } else {
            setSelectedSourceIds(prev => {
                const newSet = new Set([...prev, ...validIds]);
                return Array.from(newSet);
            });
        }
    };
    
    const toggleFolderCollapse = (folderId: string) => {
        setCollapsedFolders(prev => ({ ...prev, [folderId]: !prev[folderId] }));
    };

    // Drag handlers
    const handleDragStart = (e: React.DragEvent, mediaAssetId: string, title: string) => {
        e.dataTransfer.setData("mediaAssetId", mediaAssetId);
        e.dataTransfer.setData("title", title);
        e.dataTransfer.effectAllowed = "copy";
    };

    const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault();
        if (targetCourseIds.length > 0 && !targetCourseIds.includes(sourceCourseId)) {
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
        if (targetCourseIds.length === 0) {
            toastError("Hata", "Lütfen önce sağ sütundan en az bir hedef kurs seçin.");
            return;
        }

        if (targetCourseIds.includes(sourceCourseId)) {
            toastError("Hata", "Aynı kursun içine kendisinden video transfer edemezsiniz. Lütfen hedef kurslardan kaynak kursu çıkarın.");
            return;
        }

        setTransferring(mediaAssetId);
        let successCount = 0;
        let failCount = 0;
        
        try {
            for (const tId of targetCourseIds) {
                // To avoid duplicate checks on primary target, we can check targetMedias if tId == targetCourseIds[0]
                if (tId === targetCourseIds[0]) {
                    const alreadyExists = targetMedias.some(m => m.mediaAssetId === mediaAssetId);
                    if (alreadyExists) continue;
                }
                
                try {
                    await mediaLibraryApi.assignMediaToCourse(tId, mediaAssetId);
                    successCount++;
                } catch {
                    failCount++;
                }
            }

            if (successCount > 0) {
                success("Başarılı", `"${title}" ders kaydı ${successCount} farklı kursa kopyalandı.`);
                setUndoStack({ targetCourseIds, mediaAssetIds: [mediaAssetId], timestamp: Date.now() });
            }
            if (failCount > 0) {
                toastError("Uyarı", `Bazı kurslara aktarım başarısız oldu (Hata Sayısı: ${failCount}).`);
            }
            
            // Reload target list
            if (token && tenantId && targetCourseIds.length > 0) {
                setLoadingTarget(true);
                const updated = await mediaLibraryApi.getCourseMedias(targetCourseIds[0]);
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
        if (targetCourseIds.length === 0) {
            toastError("Hata", "Lütfen önce sağ sütundan en az bir hedef kurs seçin.");
            return;
        }

        if (targetCourseIds.includes(sourceCourseId)) {
            toastError("Hata", "Aynı kursun içine kendisinden video transfer edemezsiniz.");
            return;
        }

        setBulkTransferring(true);
        let successCount = 0;
        let failCount = 0;

        try {
            for (const tId of targetCourseIds) {
                const existingIds = new Set(
                    tId === targetCourseIds[0] ? targetMedias.map(m => m.mediaAssetId) : []
                );

                for (const mediaAssetId of selectedSourceIds) {
                    if (existingIds.has(mediaAssetId)) {
                        continue; // Skip already mapped
                    }

                    try {
                        await mediaLibraryApi.assignMediaToCourse(tId, mediaAssetId);
                        successCount++;
                    } catch {
                        failCount++;
                    }
                }
            }

            if (successCount > 0) {
                success("Başarılı", `${selectedSourceIds.length} ders kaydı ${targetCourseIds.length} kursa kopyalandı.`);
                setUndoStack({ targetCourseIds, mediaAssetIds: selectedSourceIds, timestamp: Date.now() });
            }
            if (failCount > 0) {
                toastError("Hata", `${failCount} ders kaydı kopyalanırken hata oluştu.`);
            }

            setSelectedSourceIds([]);
            
            // Reload target list
            if (token && tenantId && targetCourseIds.length > 0) {
                setLoadingTarget(true);
                const updated = await mediaLibraryApi.getCourseMedias(targetCourseIds[0]);
                setTargetMedias(updated || []);
                setLoadingTarget(false);
            }
        } catch (err) {
            toastError("Hata", "Toplu aktarım sırasında bir hata oluştu.");
        } finally {
            setBulkTransferring(false);
        }
    };
    
    const handleUndo = async () => {
        if (!undoStack) return;
        setIsUndoing(true);
        
        try {
            for (const cId of undoStack.targetCourseIds) {
                for (const mId of undoStack.mediaAssetIds) {
                    try {
                        await mediaLibraryApi.removeMediaFromCourse(cId, mId);
                    } catch {
                        // ignore if not found
                    }
                }
            }
            success("Geri Alındı", "Son kopyalama işlemi başarıyla geri alındı.");
            setUndoStack(null);
            
            // Reload target list
            if (token && tenantId && targetCourseIds.length > 0) {
                setLoadingTarget(true);
                const updated = await mediaLibraryApi.getCourseMedias(targetCourseIds[0]);
                setTargetMedias(updated || []);
                setLoadingTarget(false);
            }
        } catch {
            toastError("Hata", "İşlem geri alınırken hata oluştu.");
        } finally {
            setIsUndoing(false);
        }
    };

    if (!isAllowed) {
        return (
            <div className="flex flex-col items-center justify-center min-h-[60vh] text-center p-8">
                <Info size={48} className="text-red-500 mb-4 animate-bounce" />
                <h3 className="text-xl font-black text-[#0A1931]">Erişim Engellendi</h3>
                <p className="text-xs text-slate-500 font-bold mt-1 max-w-md">
                    Bu araç sadece Yönetici yetkileriyle erişilebilir. Lütfen ana sayfaya dönün.
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
                        <h3 className="text-lg font-black text-[#0A1931] tracking-tight">Video Taşıma Paneli</h3>
                        <p className="text-[10px] font-extrabold text-[#64748B] uppercase tracking-widest mt-0.5">Sürükle-Bırak Müfredat Kopyalayıcı (Çoklu Hedef Destekli)</p>
                    </div>
                </div>
            </div>
            
            {/* Undo Banner */}
            {undoStack && (
                <div className="mx-6 mt-6 p-4 bg-emerald-500 text-white rounded-2xl shadow-lg flex items-center justify-between animate-in slide-in-from-top-4 duration-300 relative overflow-hidden">
                    <div className="flex items-center gap-3 relative z-10">
                        <div className="w-8 h-8 rounded-full bg-white/20 flex items-center justify-center backdrop-blur-sm">
                            <Check size={18} strokeWidth={3} />
                        </div>
                        <div>
                            <p className="text-sm font-bold">Kopyalama İşlemi Tamamlandı!</p>
                            <p className="text-xs text-emerald-100 font-medium">{undoStack.mediaAssetIds.length} video, {undoStack.targetCourseIds.length} kursa eklendi.</p>
                        </div>
                    </div>
                    <button 
                        onClick={handleUndo} 
                        disabled={isUndoing}
                        className="relative z-10 flex items-center gap-2 px-4 py-2 bg-white/20 hover:bg-white/30 active:bg-white/40 transition-colors rounded-xl text-sm font-bold backdrop-blur-sm disabled:opacity-50"
                    >
                        {isUndoing ? <Loader2 size={16} className="animate-spin" /> : <Undo2 size={16} />}
                        Geri Al
                    </button>
                    {/* Progress Bar for Timeout */}
                    <div className="absolute bottom-0 left-0 h-1 bg-white/30 animate-[shrink_15s_linear_forwards]" style={{ width: '100%' }} />
                </div>
            )}

            {/* Split View Workspace */}
            <div className="p-6 grid grid-cols-1 lg:grid-cols-2 gap-6 items-stretch flex-1">
                
                {/* Source Column */}
                <div className="bg-white/80 backdrop-blur-md border border-[#E2E8F0] rounded-3xl shadow-sm flex flex-col p-6 min-h-[600px] relative z-20">
                    <div className="flex items-center gap-2 mb-4">
                        <div className="w-8 h-8 rounded-xl bg-indigo-50 border border-indigo-100 flex items-center justify-center text-indigo-700">
                            <Layers size={14} />
                        </div>
                        <div>
                            <h4 className="text-sm font-black text-[#0A1931]">Kaynak Kurs (Videoların Alınacağı Yer)</h4>
                            <p className="text-[10px] font-bold text-slate-400">Ders videolarını çoklu seçmek için klasör başlıklarını kullanabilirsiniz</p>
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
                            options={[{label: "Kaynak Kursu Seçiniz", value: ""}, ...courseOptions]}
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
                                <div className="sticky top-0 z-10 flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3.5 bg-indigo-50/90 backdrop-blur-md border border-indigo-200/60 rounded-2xl animate-in fade-in duration-200 shadow-sm mb-1">
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
                                            disabled={targetCourseIds.length === 0 || bulkTransferring}
                                            className="px-3 py-1.5 bg-[#0A1931] hover:bg-[#1b3b6f] text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center gap-1.5 disabled:opacity-50"
                                        >
                                            {bulkTransferring ? <Loader2 size={12} className="animate-spin" /> : <Check size={12} />}
                                            Seçilenleri Kopyala ({selectedSourceIds.length})
                                        </button>
                                    )}
                                </div>
                            )}

                            <div className="flex-1 overflow-y-auto space-y-4 pr-1 min-h-[300px] custom-scrollbar pb-20">
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
                                    Object.entries(groupedSourceMedias).map(([folderId, medias]) => {
                                        const folderName = folderId === "ungrouped" ? "Gruplanmamış Videolar" : (folders[folderId] || "Bilinmeyen Klasör");
                                        const isCollapsed = collapsedFolders[folderId] || false;
                                        const validFolderIds = medias.map(m => m.mediaAssetId).filter((id): id is string => !!id);
                                        const isAllFolderSelected = validFolderIds.length > 0 && validFolderIds.every(id => selectedSourceIds.includes(id));
                                        const isSomeFolderSelected = validFolderIds.some(id => selectedSourceIds.includes(id));
                                        
                                        return (
                                            <div key={folderId} className="space-y-1">
                                                {/* Folder Header */}
                                                <div className="flex items-center justify-between p-2 hover:bg-slate-50 rounded-xl transition-colors">
                                                    <div className="flex items-center gap-2">
                                                        <input 
                                                            type="checkbox"
                                                            checked={isAllFolderSelected}
                                                            ref={input => { if(input) input.indeterminate = isSomeFolderSelected && !isAllFolderSelected }}
                                                            onChange={() => handleToggleFolderSelect(folderId)}
                                                            className="w-4 h-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500 cursor-pointer"
                                                        />
                                                        <button 
                                                            onClick={() => toggleFolderCollapse(folderId)}
                                                            className="flex items-center gap-2 group text-left"
                                                        >
                                                            {isCollapsed ? <ChevronRight size={16} className="text-slate-400 group-hover:text-[#0A1931]" /> : <ChevronDown size={16} className="text-slate-400 group-hover:text-[#0A1931]" />}
                                                            <Folder size={14} className="text-indigo-500" />
                                                            <span className="text-xs font-bold text-[#0A1931]">{folderName} <span className="text-slate-400 font-medium">({medias.length})</span></span>
                                                        </button>
                                                    </div>
                                                </div>
                                                
                                                {/* Folder Content */}
                                                {!isCollapsed && (
                                                    <div className="space-y-1.5 pl-6">
                                                        {medias.map((item, index) => {
                                                            const title = item.customTitle || item.mediaAsset?.title || "İsimsiz Video";
                                                            const durationMin = item.mediaAsset?.durationSeconds ? Math.round(item.mediaAsset.durationSeconds / 60) : 0;
                                                            const isSelected = selectedSourceIds.includes(item.mediaAssetId || "");
                                                            
                                                            return (
                                                                <div 
                                                                    key={item.id}
                                                                    draggable
                                                                    onDragStart={(e) => handleDragStart(e, item.mediaAssetId || "", title)}
                                                                    className={`group flex items-center justify-between p-2.5 rounded-xl border transition-all select-none ${
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
                                                                        <GripVertical size={14} className="text-slate-300 group-hover:text-slate-500 cursor-grab shrink-0" />
                                                                        <div className="min-w-0">
                                                                            <p className="text-xs font-bold text-[#0A1931] truncate">{title}</p>
                                                                            {durationMin > 0 && <p className="text-[10px] font-semibold text-slate-400">{durationMin} dk</p>}
                                                                        </div>
                                                                    </div>

                                                                    <button
                                                                        onClick={() => handleTransfer(item.mediaAssetId || "", title)}
                                                                        disabled={targetCourseIds.length === 0 || transferring === item.mediaAssetId}
                                                                        className="p-1.5 rounded-lg border border-slate-200 hover:border-indigo-500 hover:bg-indigo-50 text-slate-400 hover:text-indigo-700 disabled:opacity-30 disabled:pointer-events-none transition-all flex items-center gap-1.5 shrink-0"
                                                                        title="Seçili Hedef Kurslara Aktar"
                                                                    >
                                                                        {transferring === item.mediaAssetId ? <Loader2 size={12} className="animate-spin" /> : <MoveRight size={12} />}
                                                                    </button>
                                                                </div>
                                                            );
                                                        })}
                                                    </div>
                                                )}
                                            </div>
                                        )
                                    })
                                )}
                            </div>
                        </div>
                    )}
                </div>

                {/* Target Column */}
                <div className="bg-white/80 backdrop-blur-md border border-[#E2E8F0] rounded-3xl shadow-sm flex flex-col p-6 min-h-[600px] relative z-10">
                    <div className="flex items-center gap-2 mb-4">
                        <div className="w-8 h-8 rounded-xl bg-emerald-50 border border-emerald-100 flex items-center justify-center text-emerald-700">
                            <Layers size={14} />
                        </div>
                        <div>
                            <h4 className="text-sm font-black text-[#0A1931]">Hedef Kurslar (Videoların Ekleneceği Yer)</h4>
                            <p className="text-[10px] font-bold text-slate-400">Birden fazla kurs seçerek videoları tek seferde çoklayabilirsiniz</p>
                        </div>
                    </div>

                    {/* Target Course Dropdown (Multi Select) */}
                    <div className="mb-4">
                        <label className="text-[10px] font-extrabold text-[#64748B] uppercase tracking-widest block mb-1.5">Hedef Kursları Seçin (Çoklu Seçim)</label>
                        <CustomSelect
                            value={targetCourseIds}
                            onChange={(val) => {
                                setTargetCourseIds(val as string[]);
                                setTargetSearch("");
                            }}
                            options={courseOptions}
                            placeholder="Bir veya birden fazla kurs seçin..."
                            searchable={true}
                            isMulti={true}
                            className="w-full"
                        />
                    </div>

                    {/* Target Search, Drag Drop Area, and List */}
                    {targetCourseIds.length > 0 && (
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
                            {targetCourseIds.length > 1 && (
                                <div className="p-3 bg-slate-50 border border-slate-200 rounded-xl mb-1">
                                    <p className="text-xs text-slate-500 font-semibold leading-relaxed">
                                        <span className="text-[#0A1931] font-bold">{targetCourseIds.length} adet</span> hedef kurs seçtiniz. 
                                        Aşağıdaki liste, seçtiğiniz <span className="font-bold underline">ilk kursun</span> mevcut içerikleridir. 
                                        Yaptığınız aktarımlar tüm seçili kurslara uygulanacaktır.
                                    </p>
                                </div>
                            )}
                            
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

                            {/* Existing lessons in primary target */}
                            <div className="flex-1 overflow-y-auto space-y-2 pr-1 min-h-[300px] custom-scrollbar pb-20">
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
            
            <style jsx global>{`
                @keyframes shrink {
                    from { width: 100%; }
                    to { width: 0%; }
                }
            `}</style>
        </div>
    );
}
