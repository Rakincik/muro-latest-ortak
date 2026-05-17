"use client";

import React, { useState, useRef, DragEvent, ChangeEvent } from 'react';
import { X, UploadCloud, Film, Trash2 } from 'lucide-react';
import { useGlobalUpload } from './GlobalUploadManager';

interface VideoUploaderModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: () => void;
    courseId?: string;
    folderId?: string | null;
}

interface SelectedFile {
    id: string;
    file: File;
    title: string;
    durationSeconds: number;
}

export function VideoUploaderModal({ isOpen, onClose, onSuccess, courseId, folderId }: VideoUploaderModalProps) {
    const { startUpload } = useGlobalUpload();
    const [selectedFiles, setSelectedFiles] = useState<SelectedFile[]>([]);
    const [isDragging, setIsDragging] = useState(false);
    const [error, setError] = useState('');
    const fileInputRef = useRef<HTMLInputElement>(null);

    if (!isOpen) return null;

    const handleDragOver = (e: DragEvent<HTMLDivElement>) => {
        e.preventDefault();
        setIsDragging(true);
    };

    const handleDragLeave = (e: DragEvent<HTMLDivElement>) => {
        e.preventDefault();
        setIsDragging(false);
    };

    const handleDrop = (e: DragEvent<HTMLDivElement>) => {
        e.preventDefault();
        setIsDragging(false);
        setError('');

        if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
            handleFilesSelection(Array.from(e.dataTransfer.files));
        }
    };

    const handleFileChange = (e: ChangeEvent<HTMLInputElement>) => {
        setError('');
        if (e.target.files && e.target.files.length > 0) {
            handleFilesSelection(Array.from(e.target.files));
        }
    };

    const handleFilesSelection = (files: File[]) => {
        const videoFiles = files.filter(f => f.type.startsWith('video/'));
        if (videoFiles.length === 0) {
            setError('Lütfen geçerli video dosyaları seçin (MP4, MOV).');
            return;
        }
        
        videoFiles.forEach(file => {
            const id = Math.random().toString(36).substring(7);
            const title = file.name.replace(/\.[^/.]+$/, "");
            
            const video = document.createElement('video');
            video.preload = 'metadata';
            video.onloadedmetadata = () => {
                window.URL.revokeObjectURL(video.src);
                setSelectedFiles(prev => [...prev, { id, file, title, durationSeconds: Math.round(video.duration) }]);
            };
            video.src = URL.createObjectURL(file);
        });
    };

    const removeFile = (id: string) => {
        setSelectedFiles(prev => prev.filter(f => f.id !== id));
    };

    const updateTitle = (id: string, newTitle: string) => {
        setSelectedFiles(prev => prev.map(f => f.id === id ? { ...f, title: newTitle } : f));
    };

    const handleStartUpload = () => {
        if (selectedFiles.length === 0) {
            setError('Lütfen en az bir video dosyası seçin.');
            return;
        }

        const invalidFiles = selectedFiles.filter(f => !f.title.trim());
        if (invalidFiles.length > 0) {
            setError('Lütfen tüm videolar için başlık girin.');
            return;
        }

        selectedFiles.forEach(sf => {
            startUpload(courseId || null, sf.title.trim(), sf.file, sf.durationSeconds, folderId || undefined);
        });

        onSuccess();
        onClose();
        setSelectedFiles([]);
    };

    return (
        <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
            <div className="bg-white dark:bg-[#09090B] border border-white/10 rounded-2xl shadow-2xl w-full max-w-2xl max-h-[90vh] flex flex-col">
                
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100 dark:border-white/10">
                    <div className="flex items-center gap-3">
                        <div className="p-2 bg-blue-50 dark:bg-blue-500/10 rounded-xl text-blue-600 dark:text-blue-400">
                            <UploadCloud className="w-5 h-5" />
                        </div>
                        <div>
                            <h3 className="text-[16px] font-semibold text-gray-900 dark:text-white">Toplu Video Yükle</h3>
                            <p className="text-[12px] text-gray-500 dark:text-[#A0AEC0]">Videoları seçin, başlıklarını düzenleyin ve arka planda yükleyin.</p>
                        </div>
                    </div>
                    <button onClick={onClose} className="p-2 text-gray-400 hover:text-gray-600 dark:hover:text-white rounded-xl hover:bg-gray-100 dark:hover:bg-white/5 transition-colors">
                        <X className="w-5 h-5" />
                    </button>
                </div>

                {/* Body */}
                <div className="p-6 overflow-y-auto flex-1 space-y-5 scrollbar-thin scrollbar-thumb-gray-300 dark:scrollbar-thumb-white/10">
                    {error && (
                        <div className="p-3 bg-red-50 dark:bg-red-500/10 text-red-600 dark:text-red-400 rounded-xl text-sm border border-red-100 dark:border-red-500/20">
                            {error}
                        </div>
                    )}

                    {/* Drag Drop Area */}
                    <div
                        onDragOver={handleDragOver}
                        onDragLeave={handleDragLeave}
                        onDrop={handleDrop}
                        onClick={() => fileInputRef.current?.click()}
                        className={`relative group border-2 border-dashed rounded-2xl p-8 flex flex-col items-center justify-center text-center cursor-pointer transition-all
                            ${isDragging ? 'border-blue-500 bg-blue-50 dark:bg-blue-500/10' : 'border-gray-200 dark:border-white/10 hover:border-blue-400 hover:bg-gray-50 dark:hover:bg-white/5'}
                        `}
                    >
                        <input 
                            type="file" 
                            ref={fileInputRef} 
                            onChange={handleFileChange} 
                            accept="video/mp4,video/quicktime,video/x-matroska" 
                            multiple
                            className="hidden" 
                        />
                        
                        <div className="p-4 rounded-full mb-4 bg-blue-50 dark:bg-blue-500/10 text-blue-500 group-hover:scale-110 transition-transform">
                            <UploadCloud className="w-8 h-8" />
                        </div>
                        <h4 className="text-[15px] font-semibold text-gray-900 dark:text-white">Videoları buraya sürükleyin</h4>
                        <p className="text-[13px] text-gray-500 dark:text-[#A0AEC0] mt-1">veya seçmek için tıklayın (Çoklu seçim yapabilirsiniz)</p>
                    </div>

                    {/* File List */}
                    {selectedFiles.length > 0 && (
                        <div className="space-y-3">
                            <h4 className="text-sm font-semibold text-gray-900 dark:text-white flex items-center gap-2">
                                Seçilen Videolar <span className="bg-blue-100 dark:bg-blue-500/20 text-blue-600 dark:text-blue-400 py-0.5 px-2 rounded-full text-xs">{selectedFiles.length}</span>
                            </h4>
                            <div className="space-y-2">
                                {selectedFiles.map(file => (
                                    <div key={file.id} className="flex gap-3 items-start p-3 bg-gray-50 dark:bg-white/5 border border-gray-100 dark:border-white/10 rounded-xl">
                                        <div className="p-2 bg-blue-100 dark:bg-blue-500/20 rounded-lg text-blue-600 dark:text-blue-400 shrink-0">
                                            <Film className="w-4 h-4" />
                                        </div>
                                        <div className="flex-1 space-y-2">
                                            <div className="flex items-center justify-between">
                                                <p className="text-xs text-gray-500 dark:text-[#A0AEC0] line-clamp-1">{file.file.name}</p>
                                                <p className="text-xs text-gray-400 shrink-0">{(file.file.size / (1024 * 1024)).toFixed(1)} MB</p>
                                            </div>
                                            <input
                                                type="text"
                                                value={file.title}
                                                onChange={(e) => updateTitle(file.id, e.target.value)}
                                                placeholder="Ders Başlığı"
                                                className="w-full px-3 py-2 bg-white dark:bg-[#09090B] border border-gray-200 dark:border-white/10 rounded-lg text-sm text-gray-900 dark:text-white placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-blue-500 transition-all"
                                            />
                                        </div>
                                        <button onClick={() => removeFile(file.id)} className="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 rounded-lg transition-colors shrink-0">
                                            <Trash2 className="w-4 h-4" />
                                        </button>
                                    </div>
                                ))}
                            </div>
                        </div>
                    )}
                </div>

                {/* Footer */}
                <div className="px-6 py-4 bg-gray-50 dark:bg-white/5 border-t border-gray-100 dark:border-white/10 flex justify-end gap-3 shrink-0 rounded-b-2xl">
                    <button onClick={onClose} className="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-white/10 rounded-xl transition-colors">
                        İptal
                    </button>
                    <button 
                        onClick={handleStartUpload} 
                        disabled={selectedFiles.length === 0}
                        className="px-6 py-2 text-sm font-medium text-white bg-blue-600 rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all shadow-lg shadow-blue-500/25 flex items-center gap-2"
                    >
                        <UploadCloud className="w-4 h-4" />
                        Arka Planda Yükle ({selectedFiles.length})
                    </button>
                </div>
                
            </div>
        </div>
    );
}
