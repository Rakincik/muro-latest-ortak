"use client";

import { useState, useEffect } from "react";
import { FolderPlus, FileVideo, ChevronRight, Folder, MoreVertical, Trash2, Edit2, Play, Search, Grid, List as ListIcon, UploadCloud, BookOpen } from "lucide-react";
import { mediaLibraryApi, type MediaFolderDto, type MediaAssetDto } from "@/lib/api";
import { useToast } from "@/components/toast";
import { VideoUploaderModal } from "@/components/ui/VideoUploaderModal";
import { CourseSelectorModal } from "@/components/ui/CourseSelectorModal";
import { FolderTree } from "@/components/ui/FolderTree";
import { ConfirmModal } from "@/components/ui/ConfirmModal";
import { VideoPlayerModal } from "@/components/ui/VideoPlayerModal";

const FallbackImage = ({ src }: { src: string }) => {
    const [error, setError] = useState(false);
    if (error || !src) return <FileVideo size={20} className="text-gray-400" />;
    return <img src={src} alt="" className="w-full h-full object-cover" onError={() => setError(true)} />;
};

export default function MediaLibraryPage() {
    const [folders, setFolders] = useState<MediaFolderDto[]>([]);
    const [assets, setAssets] = useState<MediaAssetDto[]>([]);
    const [currentFolderId, setCurrentFolderId] = useState<string | null>(null);
    const [breadcrumbs, setBreadcrumbs] = useState<{id: string | null, name: string}[]>([{ id: null, name: "Kütüphane" }]);
    const [loading, setLoading] = useState(true);
    const [refreshTrigger, setRefreshTrigger] = useState(0);
    const { success, error: toastError } = useToast();

    const [viewMode, setViewMode] = useState<"grid" | "list">("grid");
    const [searchQuery, setSearchQuery] = useState("");

    const [isCreateFolderModalOpen, setIsCreateFolderModalOpen] = useState(false);
    const [newFolderName, setNewFolderName] = useState("");

    const [isRenameModalOpen, setIsRenameModalOpen] = useState(false);
    const [renameTarget, setRenameTarget] = useState<{ id: string, type: 'folder' | 'asset', currentName: string } | null>(null);
    const [newName, setNewName] = useState("");

    const [isUploadModalOpen, setIsUploadModalOpen] = useState(false);

    const [isCourseModalOpen, setIsCourseModalOpen] = useState(false);
    const [courseAssignTarget, setCourseAssignTarget] = useState<{ id: string, type: 'folder' | 'asset' } | null>(null);
    const [initialCourseIds, setInitialCourseIds] = useState<string[]>([]);
    
    // Drag and Drop state
    const [draggedAssetId, setDraggedAssetId] = useState<string | null>(null);
    const [dragOverFolderId, setDragOverFolderId] = useState<string | null>(null);

    // Confirm Modal state
    const [confirmModal, setConfirmModal] = useState<{isOpen: boolean, title: string, message: string, onConfirm: () => void}>({isOpen: false, title: "", message: "", onConfirm: () => {}});

    // Video Player Modal state
    const [playingAsset, setPlayingAsset] = useState<MediaAssetDto | null>(null);

    useEffect(() => {
        loadData();
    }, [currentFolderId]);

    const loadData = async () => {
        setLoading(true);
        try {
            // Load folders
            const f = await mediaLibraryApi.getFolders(currentFolderId || undefined);
            setFolders(f);
            
            const a = await mediaLibraryApi.getAssets(currentFolderId || undefined);
            setAssets(a);
            
        } catch (error) {
            toastError("Hata", "Veriler yüklenirken bir hata oluştu.");
        } finally {
            setLoading(false);
        }
    };

    const triggerTreeRefresh = () => setRefreshTrigger(prev => prev + 1);

    const handleTreeAction = (action: 'rename' | 'delete' | 'assign' | 'createSub', folder: MediaFolderDto | null) => {
        if (action === 'createSub') {
            setCurrentFolderId(folder?.id || null);
            setIsCreateFolderModalOpen(true);
        } else if (action === 'rename' && folder) {
            setRenameTarget({ id: folder.id, type: 'folder', currentName: folder.name });
            setNewName(folder.name);
            setIsRenameModalOpen(true);
        } else if (action === 'assign' && folder) {
            setCourseAssignTarget({ id: folder.id, type: 'folder' });
            setInitialCourseIds([]);
            setIsCourseModalOpen(true);
        } else if (action === 'delete' && folder) {
            handleRemoveFolder(folder);
        }
    };

    const handleCreateFolder = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!newFolderName.trim()) return;

        try {
            await mediaLibraryApi.createFolder({ name: newFolderName, parentFolderId: currentFolderId || undefined });
            success("Klasör oluşturuldu");
            setNewFolderName("");
            setIsCreateFolderModalOpen(false);
            triggerTreeRefresh();
            loadData();
        } catch (error) {
            toastError("Hata", "Klasör oluşturulamadı");
        }
    };

    const handleTreeSelect = (folderId: string | null, path: {id: string | null, name: string}[]) => {
        setCurrentFolderId(folderId);
        setBreadcrumbs(path);
    };

    const handleOpenAssetCourseModal = async (asset: MediaAssetDto) => {
        setCourseAssignTarget({ id: asset.id, type: 'asset' });
        try {
            const courseIds = await mediaLibraryApi.getAssetCourses(asset.id);
            setInitialCourseIds(courseIds);
        } catch {
            setInitialCourseIds([]);
        }
        setIsCourseModalOpen(true);
    };

    const handleRemoveAsset = async (asset: MediaAssetDto) => {
        setConfirmModal({
            isOpen: true,
            title: "Videoyu Sil",
            message: `"${asset.title}" videosunu tamamen silmek istediğinize emin misiniz? Bu işlem geri alınamaz.`,
            onConfirm: async () => {
                setConfirmModal(prev => ({...prev, isOpen: false}));
                try {
                    await mediaLibraryApi.deleteAsset(asset.id);
                    success("Video silindi");
                    loadData();
                } catch (error) {
                    toastError("Hata", "Video silinemedi");
                }
            }
        });
    };

    const handleRemoveFolder = async (folder: MediaFolderDto) => {
        setConfirmModal({
            isOpen: true,
            title: "Klasörü Sil",
            message: `"${folder.name}" klasörünü ve içindeki tüm içerikleri silmek istediğinize emin misiniz? Bu işlem geri alınamaz.`,
            onConfirm: async () => {
                setConfirmModal(prev => ({...prev, isOpen: false}));
                try {
                    await mediaLibraryApi.deleteFolder(folder.id);
                    success("Klasör silindi");
                    if (currentFolderId === folder.id) {
                        setCurrentFolderId(null);
                        setBreadcrumbs([{ id: null, name: "Kök Dizin" }]);
                    }
                    triggerTreeRefresh();
                    loadData();
                } catch (error) {
                    toastError("Hata", "Klasör silinemedi");
                }
            }
        });
    };

    const handleRenameSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!renameTarget || !newName.trim()) return;

        try {
            if (renameTarget.type === 'folder') {
                await mediaLibraryApi.updateFolder(renameTarget.id, { name: newName });
                success("Klasör adı güncellendi");
            } else {
                await mediaLibraryApi.updateAsset(renameTarget.id, { title: newName });
                success("Video adı güncellendi");
            }
            setIsRenameModalOpen(false);
            if (renameTarget.type === 'folder') triggerTreeRefresh();
            loadData();
        } catch (error) {
            toastError("Hata", "Yeniden adlandırma başarısız oldu.");
        }
    };

    // --- Drag & Drop ---
    const handleDragStartAsset = (e: React.DragEvent, assetId: string) => {
        setDraggedAssetId(assetId);
    };

    const handleDragOverFolder = (e: React.DragEvent, folderId: string | null) => {
        e.preventDefault();
        if (draggedAssetId) {
            setDragOverFolderId(folderId);
        }
    };

    const handleDragLeaveFolder = (e: React.DragEvent) => {
        e.preventDefault();
        setDragOverFolderId(null);
    };

    const handleDropOnFolder = async (e: React.DragEvent, folderId: string | null) => {
        e.preventDefault();
        setDragOverFolderId(null);
        if (!draggedAssetId) return;

        try {
            await mediaLibraryApi.updateAsset(draggedAssetId, { folderId });
            success("Video taşındı");
            triggerTreeRefresh();
            loadData();
        } catch (error) {
            toastError("Hata", "Video taşınamadı");
        } finally {
            setDraggedAssetId(null);
        }
    };

    const handleAssignToCourse = async (addedCourseIds: string[], removedCourseIds?: string[]) => {
        if (!courseAssignTarget) return;
        try {
            if (courseAssignTarget.type === 'folder') {
                for (const courseId of addedCourseIds) {
                    await mediaLibraryApi.bulkAssignFolderToCourse(courseId, courseAssignTarget.id);
                }
            } else {
                for (const courseId of addedCourseIds) {
                    await mediaLibraryApi.assignMediaToCourse(courseId, courseAssignTarget.id);
                }
                if (removedCourseIds && removedCourseIds.length > 0) {
                    for (const courseId of removedCourseIds) {
                        await mediaLibraryApi.removeMediaFromCourse(courseId, courseAssignTarget.id);
                    }
                }
            }
            success(`İçerik başarıyla kurslara tanımlandı.`);
            setIsCourseModalOpen(false);
            setCourseAssignTarget(null);
            setInitialCourseIds([]);
        } catch (error) {
            toastError("Hata", "Kurslara tanımlanırken bir hata oluştu.");
        }
    };

    const filteredFolders = folders.filter(f => f.name.toLowerCase().includes(searchQuery.toLowerCase()));
    const filteredAssets = assets.filter(a => a.title.toLowerCase().includes(searchQuery.toLowerCase()));

    return (
        <div className="max-w-[1600px] mx-auto h-[calc(100vh-64px)] flex overflow-hidden">
            {/* Left Pane (30%): Folder Tree */}
            <div className="w-[30%] min-w-[250px] max-w-[400px] flex-shrink-0 border-r border-gray-200">
                <FolderTree 
                    activeFolderId={currentFolderId}
                    onSelect={handleTreeSelect}
                    onAction={handleTreeAction}
                    refreshTrigger={refreshTrigger}
                    dragOverFolderId={dragOverFolderId}
                    onDragOverFolder={handleDragOverFolder}
                    onDragLeaveFolder={handleDragLeaveFolder}
                    onDropOnFolder={handleDropOnFolder}
                />
            </div>

            {/* Right Pane (70%): Content */}
            <div className="flex-1 bg-gray-50 flex flex-col h-full overflow-hidden p-4 md:p-6">
                
                {/* Header Section */}
                <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
                    <div>
                        <div className="flex items-center flex-wrap gap-1 text-sm font-medium text-gray-500 mb-2">
                            {breadcrumbs.map((crumb, idx) => (
                                <div key={idx} className="flex items-center">
                                    <button 
                                        onClick={() => handleTreeSelect(crumb.id, breadcrumbs.slice(0, idx + 1))}
                                        className={`hover:text-blue-600 transition-colors ${idx === breadcrumbs.length - 1 ? 'text-gray-900 font-bold' : ''}`}
                                    >
                                        {crumb.name}
                                    </button>
                                    {idx < breadcrumbs.length - 1 && <ChevronRight size={16} className="mx-1 text-gray-400" />}
                                </div>
                            ))}
                        </div>
                        <h1 className="text-2xl font-bold text-gray-900 tracking-tight">
                            {currentFolderId 
                                ? breadcrumbs[breadcrumbs.length - 1]?.name || "Klasör İçeriği" 
                                : "Kök Dizin"}
                        </h1>
                    </div>
                    <div className="flex gap-3 w-full md:w-auto">
                        <button 
                            onClick={() => setIsCreateFolderModalOpen(true)}
                            className="flex items-center justify-center gap-2 px-4 py-2 bg-white hover:bg-gray-50 text-gray-700 border border-gray-200 rounded-xl font-medium transition-all flex-1 md:flex-none shadow-sm"
                        >
                            <FolderPlus size={16} />
                            <span>Yeni Klasör</span>
                        </button>
                        <button 
                            onClick={() => setIsUploadModalOpen(true)}
                            className="flex items-center justify-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-all flex-1 md:flex-none shadow-sm shadow-blue-500/20 border border-blue-500"
                        >
                            <UploadCloud size={16} />
                            <span>Video Yükle</span>
                        </button>
                    </div>
                </div>

                {/* Top Toolbar */}
                <div className="flex flex-col sm:flex-row items-center justify-between gap-4 p-3 rounded-2xl bg-white border border-gray-200 shadow-sm mb-4">
                    {/* Search */}
                    <div className="relative w-full sm:w-64 shrink-0">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
                        <input
                            type="text"
                            placeholder="Kütüphanede ara..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full pl-9 pr-4 py-2 text-sm border border-gray-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 bg-gray-50/50"
                        />
                    </div>

                    {/* View Modes */}
                    <div className="flex items-center p-1 bg-gray-100 rounded-xl w-full sm:w-auto shrink-0">
                        <button
                            onClick={() => setViewMode("grid")}
                            className={`flex-1 sm:flex-none p-1.5 rounded-lg flex items-center justify-center transition-all ${viewMode === "grid" ? "bg-white shadow-sm text-blue-600" : "text-gray-500 hover:text-gray-700"}`}
                        >
                            <Grid size={16} />
                        </button>
                        <button
                            onClick={() => setViewMode("list")}
                            className={`flex-1 sm:flex-none p-1.5 rounded-lg flex items-center justify-center transition-all ${viewMode === "list" ? "bg-white shadow-sm text-blue-600" : "text-gray-500 hover:text-gray-700"}`}
                        >
                            <ListIcon size={16} />
                        </button>
                    </div>
                </div>

                {/* Content Area */}
                {loading ? (
                    <div className="flex-1 flex justify-center items-center">
                        <div className="w-10 h-10 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
                    </div>
                ) : (
                    <div className="flex-1 overflow-y-auto min-h-0 pb-12 pr-1">

                        {filteredAssets.length > 0 && (
                            <div>
                                <h2 className="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3 px-1">Videolar</h2>
                                <div className={viewMode === "grid" ? "grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4" : "flex flex-col gap-2"}>
                                    {filteredAssets.map(asset => (
                                        <div 
                                            key={asset.id}
                                            draggable
                                            onDragStart={(e) => handleDragStartAsset(e, asset.id)}
                                            className={`group bg-white rounded-2xl border border-gray-200 overflow-hidden hover:border-blue-400 hover:shadow-lg transition-all cursor-move ${viewMode === "list" ? "flex items-center h-20" : "flex flex-col"}`}
                                        >
                                            <div 
                                                className={`${viewMode === "list" ? "w-32 h-full shrink-0" : "aspect-video w-full"} bg-gray-900 relative group-hover:opacity-90 transition-opacity cursor-pointer`}
                                                onClick={() => setPlayingAsset(asset)}
                                            >
                                                <FallbackImage src={asset.thumbnailPath || ""} />
                                                {asset.durationSeconds && (
                                                    <div className="absolute bottom-2 right-2 px-1.5 py-0.5 bg-black/80 text-white text-[10px] font-medium rounded-md backdrop-blur-sm">
                                                        {Math.floor(asset.durationSeconds / 60)}:{String(asset.durationSeconds % 60).padStart(2, '0')}
                                                    </div>
                                                )}
                                                <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all bg-black/30">
                                                    <div className="w-12 h-12 bg-white/95 rounded-full flex items-center justify-center shadow-2xl transform scale-90 group-hover:scale-100 transition-transform">
                                                        <Play className="w-5 h-5 text-blue-600 translate-x-0.5" fill="currentColor" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div className={`p-4 flex-1 min-w-0 flex items-center justify-between ${viewMode === "list" ? "" : "flex-col items-start gap-3"}`}>
                                                <div className="w-full min-w-0">
                                                    <h3 className="font-semibold text-gray-900 truncate" title={asset.title}>{asset.title}</h3>
                                                    <div className="flex items-center gap-2 mt-1">
                                                        <div className={`w-1.5 h-1.5 rounded-full ${asset.status === 'Ready' ? 'bg-green-500' : 'bg-amber-500 animate-pulse'}`} />
                                                        <p className="text-[11px] text-gray-500 font-medium">{asset.status}</p>
                                                    </div>
                                                </div>
                                                <div className={`flex gap-1 ${viewMode === "list" ? "opacity-0 group-hover:opacity-100" : "w-full justify-end border-t border-gray-50 pt-3"}`}>
                                                    <button 
                                                        onClick={() => { setRenameTarget({ id: asset.id, type: 'asset', currentName: asset.title }); setNewName(asset.title); setIsRenameModalOpen(true); }}
                                                        className="p-2 text-gray-400 hover:text-gray-700 hover:bg-gray-100 rounded-lg"
                                                        title="Yeniden Adlandır"
                                                    >
                                                        <Edit2 size={16} />
                                                    </button>
                                                    <button 
                                                        onClick={() => handleOpenAssetCourseModal(asset)}
                                                        className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg"
                                                        title="Derse Tanımla"
                                                    >
                                                        <BookOpen size={16} />
                                                    </button>
                                                    <button 
                                                        onClick={() => handleRemoveAsset(asset)}
                                                        className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg"
                                                        title="Sil"
                                                    >
                                                        <Trash2 size={16} />
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            </div>
                        )}

                        {filteredAssets.length === 0 && (
                            <div className="flex flex-col items-center justify-center py-24 text-center">
                                <div className="w-20 h-20 rounded-full bg-blue-50 flex items-center justify-center mb-6">
                                    <FolderPlus size={32} className="text-blue-600" />
                                </div>
                                <h3 className="text-xl font-bold text-gray-900 mb-2">Burası boş görünüyor</h3>
                                <p className="text-gray-500 max-w-sm mx-auto mb-8">
                                    İçeriklerinizi düzenlemeye başlamak için sol taraftan yeni bir klasör oluşturun veya ilk videonuzu yükleyin.
                                </p>
                            </div>
                        )}
                    </div>
                )}
            </div>

            {/* Create Folder Modal */}
            {isCreateFolderModalOpen && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
                    <div className="bg-white border border-gray-200 rounded-2xl w-full max-w-md p-6 shadow-2xl animate-in fade-in zoom-in-95 duration-200">
                        <h2 className="text-xl font-bold text-gray-900 mb-4">Yeni Klasör Oluştur</h2>
                        <form onSubmit={handleCreateFolder}>
                            <div className="mb-6">
                                <label className="block text-sm font-medium text-gray-700 mb-2">Klasör Adı</label>
                                <input
                                    type="text"
                                    required
                                    autoFocus
                                    value={newFolderName}
                                    onChange={(e) => setNewFolderName(e.target.value)}
                                    className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 focus:outline-none focus:bg-white focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                                    placeholder="Örn: 2026 Matematik Videoları"
                                />
                            </div>
                            <div className="flex justify-end gap-3">
                                <button
                                    type="button"
                                    onClick={() => setIsCreateFolderModalOpen(false)}
                                    className="px-5 py-2.5 rounded-xl text-gray-500 hover:text-gray-900 hover:bg-gray-100 font-medium transition-colors"
                                >
                                    İptal
                                </button>
                                <button
                                    type="submit"
                                    disabled={!newFolderName.trim()}
                                    className="px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-medium disabled:opacity-50 disabled:cursor-not-allowed transition-colors shadow-sm"
                                >
                                    Oluştur
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
            {/* Rename Modal */}
            {isRenameModalOpen && renameTarget && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm">
                    <div className="bg-white border border-gray-200 rounded-2xl w-full max-w-md p-6 shadow-2xl animate-in fade-in zoom-in-95 duration-200">
                        <h2 className="text-xl font-bold text-gray-900 mb-4">Yeniden Adlandır</h2>
                        <form onSubmit={handleRenameSubmit}>
                            <div className="mb-6">
                                <label className="block text-sm font-medium text-gray-700 mb-2">Yeni Ad</label>
                                <input
                                    type="text"
                                    required
                                    autoFocus
                                    value={newName}
                                    onChange={(e) => setNewName(e.target.value)}
                                    className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-gray-900 focus:outline-none focus:bg-white focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all"
                                />
                            </div>
                            <div className="flex justify-end gap-3">
                                <button
                                    type="button"
                                    onClick={() => setIsRenameModalOpen(false)}
                                    className="px-5 py-2.5 rounded-xl text-gray-500 hover:text-gray-900 hover:bg-gray-100 font-medium transition-colors"
                                >
                                    İptal
                                </button>
                                <button
                                    type="submit"
                                    disabled={!newName.trim() || newName.trim() === renameTarget.currentName}
                                    className="px-5 py-2.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-medium disabled:opacity-50 disabled:cursor-not-allowed transition-colors shadow-sm"
                                >
                                    Kaydet
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}

            {isUploadModalOpen && (
                <VideoUploaderModal 
                    folderId={currentFolderId || undefined}
                    onClose={() => setIsUploadModalOpen(false)}
                    onSuccess={() => loadData()}
                />
            )}

            {/* Course Selector Modal */}
            {isCourseModalOpen && (
                <CourseSelectorModal 
                    initialSelectedCourseIds={initialCourseIds}
                    onClose={() => {
                        setIsCourseModalOpen(false);
                        setCourseAssignTarget(null);
                        setInitialCourseIds([]);
                    }}
                    onSelect={handleAssignToCourse}
                />
            )}

            {/* Confirm Modal */}
            <ConfirmModal 
                isOpen={confirmModal.isOpen}
                title={confirmModal.title}
                message={confirmModal.message}
                onConfirm={confirmModal.onConfirm}
                onCancel={() => setConfirmModal(prev => ({...prev, isOpen: false}))}
                type="danger"
            />

            {/* Video Player Modal */}
            <VideoPlayerModal 
                asset={playingAsset}
                onClose={() => setPlayingAsset(null)}
            />
        </div>
    );
}
