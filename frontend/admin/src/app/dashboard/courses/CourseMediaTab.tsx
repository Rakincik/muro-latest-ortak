import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { mediaLibraryApi, type CourseMediaDto } from "@/lib/api";
import { GripVertical, Plus, Trash2, Video, Play, Users, Check } from "lucide-react";
import { useToast } from "@/components/toast";
import { LibrarySelectorModal } from "@/components/ui/LibrarySelectorModal";

export function CourseMediaTab({ 
    courseId, 
    recordings = [], 
    onViewAttendance,
    onPlay 
}: { 
    courseId: string;
    recordings?: any[];
    onViewAttendance?: (sessionId: string) => void;
    onPlay?: (title: string, url: string, type: "video" | "iframe") => void;
}) {
    const { success, error: toastError } = useToast();
    const [medias, setMedias] = useState<CourseMediaDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [draggedItemIndex, setDraggedItemIndex] = useState<number | null>(null);
    const [isLibraryModalOpen, setIsLibraryModalOpen] = useState(false);
    const [selectedItems, setSelectedItems] = useState<Set<string>>(new Set());
    
    // Inline confirmation states
    const [inlineDeleteConfirm, setInlineDeleteConfirm] = useState<string | null>(null);
    const [bulkDeleteConfirm, setBulkDeleteConfirm] = useState(false);

    const [filter, setFilter] = useState<'all' | 'video' | 'recording'>('all');
    const [pageSize, setPageSize] = useState<number>(20);
    const [currentPage, setCurrentPage] = useState<number>(1);

    useEffect(() => {
        loadMedias();
    }, [courseId]);

    const loadMedias = async () => {
        setLoading(true);
        try {
            const data = await mediaLibraryApi.getCourseMedias(courseId);
            setMedias(data);
        } catch (error) {
            toastError("Hata", "Videolar yüklenemedi.");
        } finally {
            setLoading(false);
        }
    };

    const handleDragStart = (globalIndex: number) => {
        setDraggedItemIndex(globalIndex);
    };

    const handleDragOver = (e: React.DragEvent, globalIndex: number) => {
        e.preventDefault();
        if (draggedItemIndex === null || draggedItemIndex === globalIndex) return;

        const newMedias = [...medias];
        const draggedItem = newMedias[draggedItemIndex];
        newMedias.splice(draggedItemIndex, 1);
        newMedias.splice(globalIndex, 0, draggedItem);

        // Update local orderIndex before saving
        const ordered = newMedias.map((m, i) => ({ ...m, orderIndex: i }));
        setMedias(ordered);
        setDraggedItemIndex(globalIndex);
    };

    const handleDrop = async () => {
        setDraggedItemIndex(null);
        // Save new order to backend
        try {
            await mediaLibraryApi.reorderCourseMedias(courseId, medias.map(m => m.id));
            success("Sıralama güncellendi.");
        } catch (error) {
            toastError("Hata", "Sıralama kaydedilirken hata oluştu.");
            loadMedias(); // Revert
        }
    };

    const handleBulkRemoveClick = () => {
        if (selectedItems.size > 0) {
            setBulkDeleteConfirm(true);
        }
    };

    const confirmBulkRemove = async () => {
        if (selectedItems.size === 0) return;
        const ids = Array.from(selectedItems);
        try {
            for (const id of ids) {
                await mediaLibraryApi.removeMediaFromCourse(courseId, id);
            }
            setMedias(medias.filter(m => !ids.includes(m.mediaAssetId)));
            setSelectedItems(new Set());
            success(`${ids.length} içerik kurstan kaldırıldı.`);
        } catch (error) {
            toastError("Hata", "İçerikler kaldırılırken hata oluştu.");
        } finally {
            setBulkDeleteConfirm(false);
        }
    };

    const confirmInlineRemove = async (mediaAssetId: string) => {
        try {
            await mediaLibraryApi.removeMediaFromCourse(courseId, mediaAssetId);
            setMedias(medias.filter(m => m.mediaAssetId !== mediaAssetId));
            setSelectedItems(prev => {
                const newSet = new Set(prev);
                newSet.delete(mediaAssetId);
                return newSet;
            });
            success("İçerik kurstan kaldırıldı.");
        } catch (error) {
            toastError("Hata", "İçerik kaldırılırken hata oluştu.");
        } finally {
            setInlineDeleteConfirm(null);
        }
    };

    const toggleItemSelection = (id: string) => {
        const newSet = new Set(selectedItems);
        if (newSet.has(id)) newSet.delete(id);
        else newSet.add(id);
        setSelectedItems(newSet);
    };

    const handleLibrarySelect = async (selectedAssetIds: string[], selectedFolderIds: string[]) => {
        try {
            // Assign folders
            for (const folderId of selectedFolderIds) {
                await mediaLibraryApi.bulkAssignFolderToCourse(courseId, folderId);
            }
            // Assign individual assets
            for (const assetId of selectedAssetIds) {
                await mediaLibraryApi.assignMediaToCourse(courseId, assetId);
            }
            
            success("Seçilen içerikler kursa eklendi.");
            setIsLibraryModalOpen(false);
            loadMedias();
        } catch (error) {
            toastError("Hata", "İçerikler atanırken bir hata oluştu.");
        }
    };

    const filteredMedias = medias.filter(media => {
        const recording = recordings.find(r => r.mediaAssetId && r.mediaAssetId === media.mediaAsset.id);
        const isRecording = !!recording;
        if (filter === 'video' && isRecording) return false;
        if (filter === 'recording' && !isRecording) return false;
        return true;
    });

    const totalPages = Math.ceil(filteredMedias.length / pageSize);
    const paginatedMedias = pageSize === -1 ? filteredMedias : filteredMedias.slice((currentPage - 1) * pageSize, currentPage * pageSize);
    const isReorderEnabled = filter === 'all' && pageSize === -1;

    // Reset to page 1 if filter or page size changes
    useEffect(() => {
        setCurrentPage(1);
    }, [filter, pageSize]);

    if (loading) {
        return <div className="p-8 text-center text-gray-500">Yükleniyor...</div>;
    }

    return (
        <div className="relative">
            <div className="bg-white rounded-[2rem] border border-[#E2E8F0]/60 p-6 flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6 shadow-sm">
                <div>
                    <h2 className="text-xl font-black text-[#0A1931] mb-1">Medya ve Kayıtlar</h2>
                    {isReorderEnabled ? (
                        <p className="text-sm font-medium text-[#A0AEC0]">Tüm video ve ders kayıtlarının sıralamasını sürükle-bırak ile değiştirebilirsiniz.</p>
                    ) : (
                        <p className="text-sm font-medium text-amber-500">Sıralama değiştirmek için görünümü 'Tümü' (Hem Filtre Hem Gösterim) yapmalısınız.</p>
                    )}
                </div>
                <div className="flex items-center gap-3 flex-wrap">
                    {selectedItems.size > 0 && (
                        bulkDeleteConfirm ? (
                            <div className="flex items-center gap-2 animate-in fade-in slide-in-from-right-2">
                                <span className="text-sm font-bold text-red-600 px-2">{selectedItems.size} seçili öğeyi sil:</span>
                                <button 
                                    onClick={confirmBulkRemove}
                                    className="px-4 py-2.5 bg-red-500 text-white text-xs font-bold rounded-2xl hover:bg-red-600 transition-all shadow-md flex items-center gap-1"
                                >
                                    <Check size={14} /> Eminim
                                </button>
                                <button 
                                    onClick={() => setBulkDeleteConfirm(false)}
                                    className="px-4 py-2.5 bg-[#F8FAFC] text-[#A0AEC0] text-xs font-bold rounded-2xl border border-[#E2E8F0] hover:bg-[#E2E8F0] transition-all"
                                >
                                    Vazgeç
                                </button>
                            </div>
                        ) : (
                            <button 
                                onClick={handleBulkRemoveClick}
                                className="flex items-center gap-2 bg-red-50 hover:bg-red-100 text-red-600 px-5 py-2.5 rounded-2xl font-bold transition-all border border-red-200"
                            >
                                <Trash2 size={16} />
                                Seçilenleri Kaldır ({selectedItems.size})
                            </button>
                        )
                    )}
                    <select 
                        value={filter}
                        onChange={(e) => setFilter(e.target.value as any)}
                        className="py-2.5 px-4 text-xs font-bold rounded-2xl border border-[#E2E8F0] bg-gray-50 focus:outline-none cursor-pointer text-[#1B3B6F]"
                    >
                        <option value="all">Filtre: Tümü</option>
                        <option value="video">Filtre: Videolar</option>
                        <option value="recording">Filtre: Kayıtlar</option>
                    </select>
                    <select 
                        value={pageSize}
                        onChange={(e) => setPageSize(Number(e.target.value))}
                        className="py-2.5 px-4 text-xs font-bold rounded-2xl border border-[#E2E8F0] bg-gray-50 focus:outline-none cursor-pointer text-[#1B3B6F]"
                    >
                        <option value={10}>10'lu Göster</option>
                        <option value={20}>20'li Göster</option>
                        <option value={50}>50'li Göster</option>
                        <option value={-1}>Tümü (Sıralamaya İzin Ver)</option>
                    </select>
                    <button 
                        onClick={() => setIsLibraryModalOpen(true)}
                        className="flex items-center gap-2 bg-[#1B3B6F] hover:bg-[#152a51] text-white px-5 py-2.5 rounded-2xl font-bold transition-all shadow-md active:scale-95"
                    >
                        <Plus size={16} />
                        Kütüphaneden Ekle
                    </button>
                </div>
            </div>


            {filteredMedias.length === 0 ? (
                <div className="text-center py-16 border border-dashed border-[#E2E8F0] rounded-[2rem] bg-white shadow-sm">
                    <Video size={48} className="mx-auto text-[#A0AEC0] opacity-30 mb-4" />
                    <p className="text-sm font-bold text-[#A0AEC0]">Bu kursa henüz video veya kayıt eklenmemiş.</p>
                </div>
            ) : (
                <div className="space-y-3">
                    {paginatedMedias.map((media, displayIndex) => {
                        const globalIndex = medias.findIndex(m => m.id === media.id);
                        const recording = recordings.find(r => r.mediaAssetId && r.mediaAssetId === media.mediaAsset.id);
                        const isRecording = !!recording;

                        return (
                            <div
                                key={media.id}
                                draggable={isReorderEnabled}
                                onDragStart={isReorderEnabled ? () => handleDragStart(globalIndex) : undefined}
                                onDragOver={isReorderEnabled ? (e) => handleDragOver(e, globalIndex) : undefined}
                                onDrop={isReorderEnabled ? handleDrop : undefined}
                                onDragEnd={isReorderEnabled ? handleDrop : undefined}
                                className={`flex items-center gap-5 bg-white border border-[#E2E8F0]/60 shadow-sm hover:shadow-md p-4 rounded-2xl transition-all group ${draggedItemIndex === globalIndex ? 'opacity-50 scale-[1.02] border-blue-500 ring-2 ring-blue-500/20' : 'hover:border-blue-300'} ${isReorderEnabled ? 'cursor-grab active:cursor-grabbing' : ''}`}
                            >
                                <div 
                                    className="p-2 cursor-pointer shrink-0" 
                                    onClick={(e) => { e.stopPropagation(); toggleItemSelection(media.mediaAssetId); }}
                                >
                                    <div className={`w-5 h-5 rounded-md border-2 flex items-center justify-center transition-all ${selectedItems.has(media.mediaAssetId) ? 'bg-[#1B3B6F] border-[#1B3B6F] text-white' : 'border-[#A0AEC0]/40 text-transparent hover:border-[#1B3B6F]/50'}`}>
                                        <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="4" strokeLinecap="round" strokeLinejoin="round" className={selectedItems.has(media.mediaAssetId) ? 'opacity-100' : 'opacity-0'}><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    </div>
                                </div>
                                {isReorderEnabled ? (
                                    <div className="text-[#A0AEC0] p-1 cursor-grab group-hover:text-blue-500 transition-colors">
                                        <GripVertical size={20} />
                                    </div>
                                ) : (
                                    <div className="w-5" /> // placeholder
                                )}
                                
                                <button 
                                    onClick={() => {
                                        if (onPlay) {
                                            const url = media.mediaAsset.hlsPath || media.mediaAsset.filePath;
                                            if (url) {
                                                onPlay(
                                                    media.mediaAsset.title, 
                                                    url, 
                                                    media.mediaAsset.hlsPath ? "video" : "iframe"
                                                );
                                            }
                                        }
                                    }}
                                    className={`w-14 h-14 rounded-xl flex items-center justify-center shrink-0 shadow-inner transition-all hover:scale-105 active:scale-95 cursor-pointer ${isRecording ? 'bg-red-50 text-red-500 hover:bg-red-100' : 'bg-blue-50 text-blue-600 hover:bg-blue-100'}`}
                                    title="Oynat"
                                >
                                    {isRecording ? <Video size={24} /> : <Play size={24} />}
                                </button>
                                
                                <div className="flex-1 min-w-0">
                                    <div className="flex items-center gap-2 mb-1">
                                        <p className="text-[#0A1931] font-bold text-base truncate">{media.mediaAsset.title}</p>
                                        {isRecording && (
                                            <span className="px-2 py-0.5 rounded-md bg-red-100 text-red-700 text-[10px] font-black uppercase tracking-wider">
                                                CANLI DERS
                                            </span>
                                        )}
                                    </div>
                                    <p className="text-xs font-medium text-[#A0AEC0] flex items-center gap-2">
                                        {media.mediaAsset.durationSeconds ? `${Math.floor(media.mediaAsset.durationSeconds / 60)} dk` : 'Süre bilinmiyor'} 
                                        <span className="w-1 h-1 rounded-full bg-[#E2E8F0]" /> 
                                        <span className={media.mediaAsset.status === 'Ready' ? 'text-emerald-500' : 'text-amber-500'}>{media.mediaAsset.status}</span>
                                    </p>
                                </div>

                                <div className="flex items-center gap-2">
                                    {isRecording && recording && onViewAttendance && (
                                        <button 
                                            onClick={() => onViewAttendance(recording.sessionId)}
                                            className="p-3 text-[#A0AEC0] hover:text-blue-500 hover:bg-blue-50 rounded-xl transition-all"
                                            title="Yoklama Gör"
                                        >
                                            <Users size={18} />
                                        </button>
                                    )}
                                    {inlineDeleteConfirm === media.mediaAssetId ? (
                                        <div className="flex items-center gap-1 animate-in fade-in slide-in-from-right-2">
                                            <button 
                                                onClick={() => confirmInlineRemove(media.mediaAssetId)}
                                                className="px-3 py-2 bg-red-500 text-white text-xs font-bold rounded-xl hover:bg-red-600 transition-all shadow-md flex items-center gap-1"
                                            >
                                                <Check size={14} /> Onayla
                                            </button>
                                            <button 
                                                onClick={() => setInlineDeleteConfirm(null)}
                                                className="px-3 py-2 bg-[#F8FAFC] text-[#A0AEC0] border border-[#E2E8F0] text-xs font-bold rounded-xl hover:bg-[#E2E8F0] transition-all"
                                            >
                                                İptal
                                            </button>
                                        </div>
                                    ) : (
                                        <button 
                                            onClick={() => setInlineDeleteConfirm(media.mediaAssetId)}
                                            className="p-3 text-[#A0AEC0] hover:text-red-500 hover:bg-red-50 rounded-xl transition-all"
                                            title="Kurstan Çıkar"
                                        >
                                            <Trash2 size={18} />
                                        </button>
                                    )}
                                </div>
                            </div>
                        );
                    })}

                    {/* Pagination Controls */}
                    {pageSize !== -1 && totalPages > 1 && (
                        <div className="flex items-center justify-between bg-white border border-[#E2E8F0] p-4 rounded-[2rem] shadow-sm mt-4">
                            <span className="text-sm font-bold text-[#A0AEC0]">
                                Toplam <span className="text-[#0A1931]">{filteredMedias.length}</span> içerik, Sayfa {currentPage} / {totalPages}
                            </span>
                            <div className="flex gap-2">
                                <button 
                                    onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                                    disabled={currentPage === 1}
                                    className="px-4 py-2 bg-gray-50 hover:bg-gray-100 disabled:opacity-50 rounded-xl font-bold text-[#1B3B6F] transition-all"
                                >
                                    Önceki
                                </button>
                                <button 
                                    onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                                    disabled={currentPage === totalPages}
                                    className="px-4 py-2 bg-gray-50 hover:bg-gray-100 disabled:opacity-50 rounded-xl font-bold text-[#1B3B6F] transition-all"
                                >
                                    Sonraki
                                </button>
                            </div>
                        </div>
                    )}
                </div>
            )}

            {isLibraryModalOpen && (
                <LibrarySelectorModal 
                    onClose={() => setIsLibraryModalOpen(false)}
                    onSelect={handleLibrarySelect}
                />
            )}
        </div>
    );
}
