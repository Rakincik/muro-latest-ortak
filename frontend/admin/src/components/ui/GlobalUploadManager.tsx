"use client";

import React, { createContext, useContext, useState, useCallback, ReactNode } from 'react';
import { uploadApi } from '@/lib/api/upload';
import { courseApi } from '@/lib/api/courses';
import { useAuth } from '@/contexts/AuthContext';
import { X, UploadCloud, CheckCircle2, AlertCircle } from 'lucide-react';

export interface UploadTask {
    id: string;
    courseId?: string;
    folderId?: string;
    title: string;
    file: File;
    progress: number;
    status: 'pending' | 'uploading' | 'processing' | 'completed' | 'error';
    error?: string;
}

interface GlobalUploadContextType {
    tasks: UploadTask[];
    startUpload: (courseId: string | null, title: string, file: File, durationSeconds: number, folderId?: string) => void;
    dismissTask: (id: string) => void;
}

const GlobalUploadContext = createContext<GlobalUploadContextType | undefined>(undefined);

export function useGlobalUpload() {
    const ctx = useContext(GlobalUploadContext);
    if (!ctx) throw new Error("useGlobalUpload must be used within GlobalUploadProvider");
    return ctx;
}

export function GlobalUploadProvider({ children }: { children: ReactNode }) {
    const { token, currentTenantId: tenantId } = useAuth();
    const [tasks, setTasks] = useState<UploadTask[]>([]);

    const updateTask = useCallback((id: string, updates: Partial<UploadTask>) => {
        setTasks(prev => prev.map(t => t.id === id ? { ...t, ...updates } : t));
    }, []);

    const startUpload = useCallback(async (courseId: string | null, title: string, file: File, durationSeconds: number, folderId?: string) => {
        if (!token || !tenantId) return;

        const taskId = Math.random().toString(36).substring(7);
        const newTask: UploadTask = {
            id: taskId,
            courseId: courseId || undefined,
            folderId,
            title,
            file,
            progress: 0,
            status: 'uploading'
        };

        setTasks(prev => [...prev, newTask]);

        try {
            // 1. Presigned URL al
            const presigned = await uploadApi.getPresignedUrl(token, tenantId, file.name, file.type);
            
            // 2. XMLHttpRequest ile progress'li yükleme
            await uploadApi.uploadMediaWithProgress(presigned.uploadUrl, file, (progress) => {
                updateTask(taskId, { progress });
            });

            // 3. Yükleme bitince Backend'e Session+MediaAsset kaydı yap (İşleniyor durumuna geçer)
            updateTask(taskId, { status: 'processing', progress: 100 });
            
            if (courseId) {
                await courseApi.addVodToCourse(token, tenantId, courseId, title, presigned.publicUrl, durationSeconds);
            } else {
                // Sadece Kütüphane'ye yüklüyorsak
                await fetch(`${process.env.NEXT_PUBLIC_API_URL || "http://localhost:5292/api/v1"}/media/assets`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'Authorization': `Bearer ${token}`, 'X-Tenant-Id': tenantId },
                    body: JSON.stringify({ title, filePath: presigned.publicUrl, folderId })
                });
            }
            
            // 4. Bitti
            updateTask(taskId, { status: 'completed' });
            
            // Başarı sesi çal (çift bip)
            try {
                const audioCtx = new (window.AudioContext || (window as any).webkitAudioContext)();
                const playBeep = (freq: number, timeOffset: number) => {
                    const osc = audioCtx.createOscillator();
                    const gain = audioCtx.createGain();
                    osc.connect(gain);
                    gain.connect(audioCtx.destination);
                    osc.type = 'sine';
                    osc.frequency.setValueAtTime(freq, audioCtx.currentTime + timeOffset);
                    gain.gain.setValueAtTime(0.1, audioCtx.currentTime + timeOffset);
                    osc.start(audioCtx.currentTime + timeOffset);
                    gain.gain.exponentialRampToValueAtTime(0.00001, audioCtx.currentTime + timeOffset + 0.2);
                    osc.stop(audioCtx.currentTime + timeOffset + 0.2);
                };
                playBeep(659.25, 0);    // E5
                playBeep(880.00, 0.15); // A5
            } catch (e) { }
            
            // Başarılıysa 5 saniye sonra gizle
            setTimeout(() => dismissTask(taskId), 5000);

        } catch (err: any) {
            updateTask(taskId, { status: 'error', error: err.message || 'Yükleme başarısız' });
        }
    }, [token, tenantId, updateTask]);

    const dismissTask = useCallback((id: string) => {
        setTasks(prev => prev.filter(t => t.id !== id));
    }, []);

    return (
        <GlobalUploadContext.Provider value={{ tasks, startUpload, dismissTask }}>
            {children}
            {/* Sağ Alt Köşe Widget */}
            <div className="fixed bottom-6 right-6 z-50 flex flex-col gap-3">
                {tasks.map(task => (
                    <div key={task.id} className="bg-white dark:bg-gray-800 rounded-xl shadow-2xl border border-gray-100 dark:border-gray-700 w-80 p-4 transition-all animate-in slide-in-from-bottom-5">
                        <div className="flex items-start justify-between">
                            <div className="flex items-center gap-3">
                                {task.status === 'uploading' && <UploadCloud className="w-5 h-5 text-blue-500 animate-pulse" />}
                                {task.status === 'processing' && <UploadCloud className="w-5 h-5 text-indigo-500 animate-bounce" />}
                                {task.status === 'completed' && <CheckCircle2 className="w-5 h-5 text-green-500" />}
                                {task.status === 'error' && <AlertCircle className="w-5 h-5 text-red-500" />}
                                
                                <div>
                                    <h4 className="text-sm font-semibold text-gray-900 dark:text-white line-clamp-1">{task.title}</h4>
                                    <p className="text-xs text-gray-500">
                                        {task.status === 'uploading' && `%${task.progress} Yükleniyor...`}
                                        {task.status === 'processing' && 'İşleniyor (Kaydediliyor)...'}
                                        {task.status === 'completed' && 'Yükleme Tamamlandı'}
                                        {task.status === 'error' && <span className="text-red-500">{task.error}</span>}
                                    </p>
                                </div>
                            </div>
                            <button onClick={() => dismissTask(task.id)} className="text-gray-400 hover:text-gray-600 transition-colors">
                                <X className="w-4 h-4" />
                            </button>
                        </div>
                        
                        {(task.status === 'uploading' || task.status === 'processing') && (
                            <div className="mt-3 h-1.5 w-full bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
                                <div 
                                    className={`h-full transition-all duration-300 ease-out ${task.status === 'processing' ? 'bg-indigo-500 w-full animate-pulse' : 'bg-blue-500'}`}
                                    style={{ width: task.status === 'uploading' ? `${task.progress}%` : undefined }}
                                />
                            </div>
                        )}
                    </div>
                ))}
            </div>
        </GlobalUploadContext.Provider>
    );
}
