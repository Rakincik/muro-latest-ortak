"use client";

import React, { createContext, useContext, useState, ReactNode } from 'react';
import { uploadApi } from '@/lib/api/upload';
import { courseApi } from '@/lib/api/courses';
import { mediaLibraryApi } from '@/lib/api/mediaLibrary';
import { useAuth } from '@/contexts/AuthContext';
import { UploadCloud, CheckCircle2, XCircle, X, ChevronUp, ChevronDown, Loader2 } from 'lucide-react';

interface UploadTask {
    id: string;
    file: File;
    title: string;
    progress: number;
    status: 'pending' | 'uploading' | 'processing' | 'success' | 'error';
    courseId: string | null;
    folderId?: string;
    error?: string;
    assetId?: string;
    assetStatus?: string;
}

interface GlobalUploadContextType {
    uploads: UploadTask[];
    startUpload: (courseId: string | null, title: string, file: File, durationSeconds: number, folderId?: string) => void;
    removeUpload: (id: string) => void;
    clearCompleted: () => void;
}

const GlobalUploadContext = createContext<GlobalUploadContextType | undefined>(undefined);

export function GlobalUploadProvider({ children }: { children: ReactNode }) {
    const [uploads, setUploads] = useState<UploadTask[]>([]);
    const [isMinimized, setIsMinimized] = useState(false);
    const { currentTenantId, token } = useAuth();

    // Poll for asset status if there are any uploads in "success" state but not "Ready"
    React.useEffect(() => {
        const pollingUploads = uploads.filter(u => u.status === 'success' && u.assetId && u.assetStatus !== 'Ready');
        if (pollingUploads.length === 0) return;

        const interval = setInterval(async () => {
            for (const upload of pollingUploads) {
                try {
                    const asset = await mediaLibraryApi.getAsset(upload.assetId!);
                    if (asset.status !== upload.assetStatus) {
                        setUploads(prev => prev.map(t => t.id === upload.id ? { ...t, assetStatus: asset.status } : t));
                    }
                } catch (e) {
                    console.error("Polling failed for asset", upload.assetId, e);
                }
            }
        }, 5000);

        return () => clearInterval(interval);
    }, [uploads]);

    const startUpload = async (courseId: string | null, title: string, file: File, durationSeconds: number, folderId?: string) => {
        const id = Math.random().toString(36).substring(7);
        const newTask: UploadTask = { id, file, title, progress: 0, status: 'pending', courseId, folderId };
        
        setUploads(prev => [...prev, newTask]);
        setIsMinimized(false);

        try {
            if (!token) throw new Error("Oturum süresi dolmuş veya geçersiz.");

            setUploads(prev => prev.map(t => t.id === id ? { ...t, status: 'uploading' } : t));
            
            // 1. Get presigned URL
            const presigned = await uploadApi.getPresignedUrl(token, currentTenantId ?? "", file.name, file.type);

            // 2. Upload file directly to BunnyCDN
            await uploadApi.uploadMediaWithProgress(presigned.uploadUrl, file, (progress) => {
                setUploads(prev => prev.map(t => t.id === id ? { ...t, progress } : t));
            });

            setUploads(prev => prev.map(t => t.id === id ? { ...t, status: 'processing', progress: 100 } : t));

            // 3. Create Media Asset in Database
            const asset = await mediaLibraryApi.createAsset({
                title: title,
                type: 'Video',
                filePath: presigned.publicUrl,
                durationSeconds: durationSeconds,
                folderId: folderId || null
            });

            // 4. Assign to course if courseId is provided
            if (courseId) {
                await mediaLibraryApi.assignMediaToCourse(courseId, asset.id);
            }

            setUploads(prev => prev.map(t => t.id === id ? { ...t, status: 'success', assetId: asset.id, assetStatus: asset.status } : t));
        } catch (error: any) {
            console.error("Upload failed:", error);
            const errorMessage = error instanceof Error ? error.message : "Yükleme başarısız oldu.";
            setUploads(prev => prev.map(t => t.id === id ? { ...t, status: 'error', error: errorMessage } : t));
        }
    };

    const removeUpload = (id: string) => setUploads(prev => prev.filter(t => t.id !== id));
    const clearCompleted = () => setUploads(prev => prev.filter(t => t.status !== 'success' && t.status !== 'error'));

    const activeUploadsCount = uploads.filter(u => u.status === 'uploading' || u.status === 'pending' || u.status === 'processing').length;
    const completedUploadsCount = uploads.filter(u => u.status === 'success').length;
    const totalUploadsCount = uploads.length;

    return (
        <GlobalUploadContext.Provider value={{ uploads, startUpload, removeUpload, clearCompleted }}>
            {children}
            {totalUploadsCount > 0 && (
                <div className={`fixed bottom-6 right-6 z-[9999] w-[360px] bg-white dark:bg-[#09090B] border border-gray-200 dark:border-white/10 rounded-2xl shadow-2xl transition-all duration-300 flex flex-col overflow-hidden ${isMinimized ? 'h-[64px]' : 'h-auto max-h-[400px]'}`}>
                    
                    {/* Header */}
                    <div 
                        className="h-[64px] px-5 py-3 flex items-center justify-between cursor-pointer hover:bg-gray-50 dark:hover:bg-white/5 transition-colors border-b border-gray-100 dark:border-white/5 shrink-0"
                        onClick={() => setIsMinimized(!isMinimized)}
                    >
                        <div className="flex items-center gap-3">
                            <div className="p-2 bg-blue-50 dark:bg-blue-500/10 rounded-lg text-blue-600 dark:text-blue-400">
                                {activeUploadsCount > 0 ? <Loader2 className="w-5 h-5 animate-spin" /> : <CheckCircle2 className="w-5 h-5 text-green-500" />}
                            </div>
                            <div>
                                <h4 className="text-sm font-semibold text-gray-900 dark:text-white">
                                    {activeUploadsCount > 0 ? `${totalUploadsCount} öğeden ${completedUploadsCount}'si yüklendi` : `${completedUploadsCount} öğe yüklendi`}
                                </h4>
                                <p className="text-[11px] text-gray-500 dark:text-[#A0AEC0]">
                                    {activeUploadsCount > 0 ? 'Arka planda yükleniyor...' : 'Tüm yüklemeler tamamlandı'}
                                </p>
                            </div>
                        </div>
                        <div className="flex items-center gap-1">
                            <button className="p-1.5 text-gray-400 hover:text-gray-900 dark:hover:text-white rounded-lg transition-colors">
                                {isMinimized ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                            </button>
                            <button onClick={(e) => { e.stopPropagation(); setUploads([]); }} className="p-1.5 text-gray-400 hover:text-red-500 rounded-lg transition-colors">
                                <X className="w-4 h-4" />
                            </button>
                        </div>
                    </div>

                    {/* Body */}
                    {!isMinimized && (
                        <div className="p-2 overflow-y-auto flex-1 space-y-1 scrollbar-thin scrollbar-thumb-gray-200 dark:scrollbar-thumb-white/10">
                            {uploads.map(upload => (
                                <div key={upload.id} className="p-3 bg-gray-50 dark:bg-white/5 rounded-xl border border-transparent dark:border-white/5 flex items-center justify-between group hover:border-gray-200 dark:hover:border-white/10 transition-colors">
                                    <div className="flex items-center gap-3 min-w-0 flex-1">
                                        {upload.status === 'pending' && <UploadCloud className="w-5 h-5 text-gray-400" />}
                                        {upload.status === 'uploading' && <Loader2 className="w-5 h-5 text-blue-500 animate-spin" />}
                                        {upload.status === 'processing' && <Loader2 className="w-5 h-5 text-purple-500 animate-spin" />}
                                        {upload.status === 'success' && <CheckCircle2 className="w-5 h-5 text-green-500" />}
                                        {upload.status === 'error' && <XCircle className="w-5 h-5 text-red-500" />}
                                        
                                        <div className="min-w-0 flex-1">
                                            <p className="text-[13px] font-medium text-gray-900 dark:text-white truncate">{upload.title}</p>
                                            {upload.status === 'uploading' && (
                                                <div className="mt-1.5 h-1 w-full bg-gray-200 dark:bg-gray-800 rounded-full overflow-hidden">
                                                    <div className="h-full bg-blue-500 rounded-full transition-all duration-300" style={{ width: `${upload.progress}%` }} />
                                                </div>
                                            )}
                                            {upload.status === 'processing' && <p className="text-[11px] text-purple-500 mt-0.5">Sisteme kaydediliyor...</p>}
                                            {upload.status === 'success' && upload.assetStatus !== 'Ready' && <p className="text-[11px] text-green-600 dark:text-green-400 mt-0.5">Yüklendi • Arka planda işleniyor</p>}
                                            {upload.status === 'success' && upload.assetStatus === 'Ready' && <p className="text-[11px] text-blue-600 dark:text-blue-400 mt-0.5">İşlem tamamlandı, yayına hazır ✨</p>}
                                            {upload.status === 'error' && <p className="text-[11px] text-red-500 mt-0.5 truncate">{upload.error}</p>}
                                        </div>
                                    </div>
                                    <button onClick={() => removeUpload(upload.id)} className="ml-3 p-1.5 text-gray-400 opacity-0 group-hover:opacity-100 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 rounded-lg transition-all shrink-0">
                                        <X className="w-4 h-4" />
                                    </button>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            )}
        </GlobalUploadContext.Provider>
    );
}

export function useGlobalUpload() {
    const context = useContext(GlobalUploadContext);
    if (context === undefined) {
        throw new Error('useGlobalUpload must be used within a GlobalUploadProvider');
    }
    return context;
}
