"use client";

import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { X, Folder, FileVideo, ChevronRight, Check, ChevronDown, MonitorPlay } from 'lucide-react';
import { mediaLibraryApi, type MediaFolderDto, type MediaAssetDto } from '@/lib/api';

const FallbackImage = ({ src }: { src: string }) => {
    const [error, setError] = useState(false);
    if (error || !src) return <MonitorPlay size={24} className="text-[#A0AEC0] opacity-50" />;
    return <img src={src} alt="" className="w-full h-full object-cover" onError={() => setError(true)} />;
};

interface LibrarySelectorModalProps {
    onClose: () => void;
    onSelect: (selectedAssetIds: string[], selectedFolderIds: string[]) => void;
}

// Rekürsif klasör ağacı bileşeni
const FolderTreeNode = ({ 
    folder, 
    level, 
    activeFolderId, 
    selectedFolderIds, 
    onSelectFolder, 
    onToggleSelect 
}: { 
    folder: MediaFolderDto, 
    level: number, 
    activeFolderId: string | null, 
    selectedFolderIds: Set<string>,
    onSelectFolder: (f: MediaFolderDto) => void,
    onToggleSelect: (id: string) => void
}) => {
    const [isExpanded, setIsExpanded] = useState(false);
    const [subFolders, setSubFolders] = useState<MediaFolderDto[]>([]);
    const [isLoading, setIsLoading] = useState(false);

    const hasChildren = folder.subFolderCount > 0;
    const isActive = activeFolderId === folder.id;
    const isSelected = selectedFolderIds.has(folder.id);

    const toggleExpand = async (e: React.MouseEvent) => {
        e.stopPropagation();
        if (!hasChildren) return;
        
        if (!isExpanded && subFolders.length === 0) {
            setIsLoading(true);
            try {
                const fetched = await mediaLibraryApi.getFolders(folder.id);
                setSubFolders(fetched);
            } catch (err) {
                console.error("Failed to load subfolders", err);
            } finally {
                setIsLoading(false);
            }
        }
        setIsExpanded(!isExpanded);
    };

    return (
        <div className="w-full">
            <div 
                className={`flex items-center gap-2 py-2 px-3 rounded-xl cursor-pointer transition-all ${isActive ? 'bg-[#1B3B6F] text-white shadow-md' : 'hover:bg-[#E2E8F0]/30 text-[#0A1931]'}`}
                style={{ paddingLeft: `${(level * 16) + 12}px` }}
                onClick={() => onSelectFolder(folder)}
            >
                {/* Expand Icon */}
                <div onClick={toggleExpand} className={`p-1 shrink-0 ${hasChildren ? 'cursor-pointer hover:bg-black/10 rounded-md' : 'opacity-0'}`}>
                    {isLoading ? (
                        <div className="w-3 h-3 border border-current border-t-transparent rounded-full animate-spin" />
                    ) : isExpanded ? (
                        <ChevronDown size={14} />
                    ) : (
                        <ChevronRight size={14} />
                    )}
                </div>

                {/* Checkbox */}
                <div 
                    className={`w-4 h-4 rounded-[4px] border flex items-center justify-center shrink-0 transition-all ${isSelected ? (isActive ? 'bg-white border-white' : 'bg-[#1B3B6F] border-[#1B3B6F]') : (isActive ? 'border-white/50 bg-white/10' : 'border-[#A0AEC0]/50 bg-white')}`}
                    onClick={(e) => { e.stopPropagation(); onToggleSelect(folder.id); }}
                >
                    {isSelected && <Check size={10} className={isActive ? 'text-[#1B3B6F]' : 'text-white'} strokeWidth={3} />}
                </div>

                {/* Folder Icon & Name */}
                <Folder size={16} className={`shrink-0 ${isActive ? 'text-white/80' : 'text-[#A0AEC0]'}`} fill="currentColor" />
                <span className="text-sm font-bold truncate">{folder.name}</span>
            </div>

            {/* Subfolders */}
            {isExpanded && subFolders.length > 0 && (
                <div className="mt-1 flex flex-col gap-1">
                    {subFolders.map(sub => (
                        <FolderTreeNode 
                            key={sub.id} 
                            folder={sub} 
                            level={level + 1} 
                            activeFolderId={activeFolderId}
                            selectedFolderIds={selectedFolderIds}
                            onSelectFolder={onSelectFolder}
                            onToggleSelect={onToggleSelect}
                        />
                    ))}
                </div>
            )}
        </div>
    );
};

export function LibrarySelectorModal({ onClose, onSelect }: LibrarySelectorModalProps) {
    const [rootFolders, setRootFolders] = useState<MediaFolderDto[]>([]);
    const [assets, setAssets] = useState<MediaAssetDto[]>([]);
    const [currentFolderId, setCurrentFolderId] = useState<string | null>(null);
    const [currentFolderName, setCurrentFolderName] = useState<string>("Tüm Dosyalar");
    const [loadingAssets, setLoadingAssets] = useState(true);
    const [loadingTree, setLoadingTree] = useState(true);

    const [selectedAssetIds, setSelectedAssetIds] = useState<Set<string>>(new Set());
    const [selectedFolderIds, setSelectedFolderIds] = useState<Set<string>>(new Set());

    // Load Root Tree
    useEffect(() => {
        const fetchTree = async () => {
            setLoadingTree(true);
            try {
                const f = await mediaLibraryApi.getFolders(undefined);
                setRootFolders(f);
            } catch (err) {
                console.error(err);
            } finally {
                setLoadingTree(false);
            }
        };
        fetchTree();
    }, []);

    // Load Assets for Current Folder
    useEffect(() => {
        const fetchAssets = async () => {
            setLoadingAssets(true);
            try {
                const a = await mediaLibraryApi.getAssets(currentFolderId || undefined);
                setAssets(a);
            } catch (err) {
                console.error(err);
            } finally {
                setLoadingAssets(false);
            }
        };
        fetchAssets();
    }, [currentFolderId]);

    const handleSelectFolder = (folder: MediaFolderDto | null) => {
        if (folder) {
            setCurrentFolderId(folder.id);
            setCurrentFolderName(folder.name);
        } else {
            setCurrentFolderId(null);
            setCurrentFolderName("Tüm Dosyalar");
        }
    };

    const toggleAsset = (id: string) => {
        const newSet = new Set(selectedAssetIds);
        if (newSet.has(id)) newSet.delete(id);
        else newSet.add(id);
        setSelectedAssetIds(newSet);
    };

    const toggleFolder = (id: string) => {
        const newSet = new Set(selectedFolderIds);
        if (newSet.has(id)) newSet.delete(id);
        else newSet.add(id);
        setSelectedFolderIds(newSet);
    };

    const handleConfirm = () => {
        onSelect(Array.from(selectedAssetIds), Array.from(selectedFolderIds));
    };

    const modalContent = (
        <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 sm:p-6 bg-[#0A1931]/60 backdrop-blur-md">
            <div className="bg-white rounded-[2.5rem] w-full max-w-[1200px] h-[85vh] flex flex-col shadow-2xl overflow-hidden animate-in fade-in zoom-in-95 duration-300 border border-[#E2E8F0]/40">
                {/* Header */}
                <div className="flex items-center justify-between px-8 py-5 bg-white border-b border-[#E2E8F0]/60 z-10 relative shadow-sm">
                    <div>
                        <h2 className="text-xl font-black text-[#0A1931] tracking-tight">Kütüphaneden Ekle</h2>
                        <p className="text-sm font-medium text-[#A0AEC0]">Videoları veya klasörleri seçerek kursa dahil edin.</p>
                    </div>
                    <button onClick={onClose} className="p-2 text-[#A0AEC0] hover:text-[#0A1931] rounded-2xl hover:bg-[#E2E8F0]/50 transition-all active:scale-95">
                        <X size={24} />
                    </button>
                </div>

                {/* Split Pane */}
                <div className="flex-1 flex overflow-hidden">
                    {/* Left Pane: Folder Tree (30%) */}
                    <div className="w-[320px] shrink-0 border-r border-[#E2E8F0]/60 bg-[#F8FAFC] flex flex-col h-full relative z-0">
                        <div className="p-5 border-b border-[#E2E8F0]/60 bg-white">
                            <h3 className="text-[10px] font-black text-[#A0AEC0] uppercase tracking-widest">Klasör Gezgini</h3>
                        </div>
                        <div className="flex-1 overflow-y-auto p-4 space-y-1">
                            <div 
                                className={`flex items-center gap-3 py-3 px-4 rounded-xl cursor-pointer transition-all ${currentFolderId === null ? 'bg-[#1B3B6F] text-white shadow-md' : 'hover:bg-[#E2E8F0]/40 text-[#0A1931]'}`}
                                onClick={() => handleSelectFolder(null)}
                            >
                                <Folder size={18} className={currentFolderId === null ? 'text-white' : 'text-[#A0AEC0]'} fill="currentColor" />
                                <span className="text-sm font-bold">Kök Dizin (Ana Kütüphane)</span>
                            </div>
                            
                            {loadingTree ? (
                                <div className="p-8 flex justify-center">
                                    <div className="w-6 h-6 border-2 border-[#1B3B6F] border-t-transparent rounded-full animate-spin" />
                                </div>
                            ) : (
                                <div className="mt-4 flex flex-col gap-1">
                                    {rootFolders.map(folder => (
                                        <FolderTreeNode 
                                            key={folder.id} 
                                            folder={folder} 
                                            level={0} 
                                            activeFolderId={currentFolderId}
                                            selectedFolderIds={selectedFolderIds}
                                            onSelectFolder={handleSelectFolder}
                                            onToggleSelect={toggleFolder}
                                        />
                                    ))}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Right Pane: Asset Grid (70%) */}
                    <div className="flex-1 flex flex-col bg-[#F1F5F9]/30 h-full relative z-0">
                        <div className="px-8 py-5 border-b border-[#E2E8F0]/60 bg-white flex items-center justify-between">
                            <div className="flex items-center gap-3">
                                <div className="w-8 h-8 rounded-xl bg-indigo-50 flex items-center justify-center text-indigo-500">
                                    <Folder size={16} fill="currentColor" />
                                </div>
                                <div>
                                    <h3 className="text-base font-black text-[#0A1931]">{currentFolderName}</h3>
                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">{assets.length} Video</p>
                                </div>
                            </div>
                            {/* Klasörü Komple Seç Butonu */}
                            {currentFolderId && (
                                <button 
                                    onClick={() => toggleFolder(currentFolderId)}
                                    className={`px-4 py-2 text-xs font-bold rounded-xl transition-all flex items-center gap-2 border shadow-sm ${selectedFolderIds.has(currentFolderId) ? 'bg-[#1B3B6F] text-white border-[#1B3B6F]' : 'bg-white text-[#0A1931] border-[#E2E8F0] hover:bg-[#F8FAFC]'}`}
                                >
                                    {selectedFolderIds.has(currentFolderId) ? <Check size={14} /> : <Folder size={14} />}
                                    {selectedFolderIds.has(currentFolderId) ? 'Tüm Klasör Seçildi' : 'Bu Klasörü Toplu Ekle'}
                                </button>
                            )}
                        </div>

                        <div className="flex-1 overflow-y-auto p-8">
                            {loadingAssets ? (
                                <div className="flex justify-center items-center h-full">
                                    <div className="w-10 h-10 border-[3px] border-[#1B3B6F] border-t-transparent rounded-full animate-spin" />
                                </div>
                            ) : assets.length === 0 ? (
                                <div className="flex flex-col items-center justify-center h-full text-center">
                                    <div className="w-24 h-24 rounded-full bg-[#E2E8F0]/30 flex items-center justify-center mb-6">
                                        <MonitorPlay size={40} className="text-[#A0AEC0]/50" />
                                    </div>
                                    <h3 className="text-lg font-black text-[#0A1931]">Bu klasörde video yok</h3>
                                    <p className="text-sm font-medium text-[#A0AEC0] mt-1 max-w-[250px]">Kütüphaneden başka bir klasör seçebilir veya buraya video yükleyebilirsiniz.</p>
                                </div>
                            ) : (
                                <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                                    {assets.map(asset => {
                                        const isSelected = selectedAssetIds.has(asset.id);
                                        return (
                                            <div 
                                                key={asset.id} 
                                                onClick={() => toggleAsset(asset.id)}
                                                className={`group relative bg-white rounded-2xl border transition-all cursor-pointer overflow-hidden shadow-sm hover:shadow-xl ${isSelected ? 'border-[#1B3B6F] ring-2 ring-[#1B3B6F]/20' : 'border-[#E2E8F0]/60 hover:border-[#A0AEC0]/40 hover:-translate-y-1'}`}
                                            >
                                                <div className="aspect-video relative bg-[#F8FAFC]">
                                                    <FallbackImage src={asset.thumbnailPath || ''} />
                                                    <div className={`absolute inset-0 transition-opacity duration-300 ${isSelected ? 'bg-[#1B3B6F]/20' : 'bg-black/0 group-hover:bg-black/10'}`} />
                                                    
                                                    {/* Checkbox */}
                                                    <div className={`absolute top-3 left-3 w-6 h-6 rounded-lg flex items-center justify-center shadow-md transition-all ${isSelected ? 'bg-[#1B3B6F] text-white scale-110' : 'bg-white/90 text-transparent border border-gray-200 group-hover:border-gray-400'}`}>
                                                        <Check size={14} strokeWidth={3} className={isSelected ? 'opacity-100' : 'opacity-0'} />
                                                    </div>

                                                    {/* Duration */}
                                                    {asset.durationSeconds && (
                                                        <div className="absolute bottom-3 right-3 px-2 py-1 bg-black/60 backdrop-blur-md text-white text-[10px] font-bold rounded-md tracking-widest">
                                                            {Math.floor(asset.durationSeconds / 60)}:{String(asset.durationSeconds % 60).padStart(2, '0')}
                                                        </div>
                                                    )}
                                                </div>
                                                <div className="p-4">
                                                    <h4 className={`text-sm font-bold line-clamp-2 transition-colors ${isSelected ? 'text-[#1B3B6F]' : 'text-[#0A1931]'}`}>
                                                        {asset.title}
                                                    </h4>
                                                    <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mt-2 flex items-center gap-1.5">
                                                        <div className={`w-1.5 h-1.5 rounded-full ${asset.status === 'Ready' ? 'bg-emerald-500' : 'bg-amber-500'}`} />
                                                        {asset.status === 'Ready' ? 'Hazır' : 'İşleniyor'}
                                                    </p>
                                                </div>
                                            </div>
                                        );
                                    })}
                                </div>
                            )}
                        </div>
                    </div>
                </div>

                {/* Footer */}
                <div className="px-8 py-5 border-t border-[#E2E8F0]/80 bg-white flex justify-between items-center relative z-10">
                    <div className="flex items-center gap-6">
                        <div className="flex flex-col">
                            <span className="text-[10px] font-black text-[#A0AEC0] uppercase tracking-widest mb-0.5">Seçilen Videolar</span>
                            <span className="text-base font-black text-[#1B3B6F]">{selectedAssetIds.size}</span>
                        </div>
                        <div className="w-px h-8 bg-[#E2E8F0]" />
                        <div className="flex flex-col">
                            <span className="text-[10px] font-black text-[#A0AEC0] uppercase tracking-widest mb-0.5">Seçilen Klasörler</span>
                            <span className="text-base font-black text-[#1B3B6F]">{selectedFolderIds.size}</span>
                        </div>
                    </div>
                    <div className="flex gap-4">
                        <button onClick={onClose} className="px-8 py-3 rounded-2xl text-[#A0AEC0] font-bold hover:text-[#0A1931] hover:bg-[#F8FAFC] transition-colors">
                            Vazgeç
                        </button>
                        <button 
                            onClick={handleConfirm}
                            disabled={selectedAssetIds.size === 0 && selectedFolderIds.size === 0}
                            className="px-8 py-3 rounded-2xl bg-[#1B3B6F] hover:bg-[#152a51] text-white font-bold shadow-lg shadow-[#1B3B6F]/20 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed disabled:active:scale-100 flex items-center gap-2"
                        >
                            <Check size={18} />
                            Kursa Ekle
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );

    if (typeof document !== 'undefined') {
        return createPortal(modalContent, document.body);
    }
    return null;
}
