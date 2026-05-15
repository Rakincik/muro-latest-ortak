"use client";

import React, { useState, useRef, DragEvent, ChangeEvent } from 'react';
import { X, UploadCloud, Film } from 'lucide-react';
import { useGlobalUpload } from './GlobalUploadManager';

interface VideoUploaderModalProps {
    courseId?: string;
    folderId?: string;
    onClose: () => void;
    onSuccess: () => void;
}

export function VideoUploaderModal({ courseId, folderId, onClose, onSuccess }: VideoUploaderModalProps) {
    const { startUpload } = useGlobalUpload();
    const [isDragging, setIsDragging] = useState(false);
    const [file, setFile] = useState<File | null>(null);
    const [title, setTitle] = useState('');
    const [error, setError] = useState('');
    const [durationSeconds, setDurationSeconds] = useState(0);
    const fileInputRef = useRef<HTMLInputElement>(null);

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
            handleFileSelection(e.dataTransfer.files[0]);
        }
    };

    const handleFileChange = (e: ChangeEvent<HTMLInputElement>) => {
        setError('');
        if (e.target.files && e.target.files.length > 0) {
            handleFileSelection(e.target.files[0]);
        }
    };

    const handleFileSelection = (selectedFile: File) => {
        if (!selectedFile.type.startsWith('video/')) {
            setError('Lütfen geçerli bir video dosyası seçin (MP4, MOV).');
            return;
        }
        
        // Removed MB limit as requested
        setFile(selectedFile);
        if (!title) {
            // Remove extension from filename to auto-populate title
            setTitle(selectedFile.name.replace(/\.[^/.]+$/, ""));
        }
        
        // Videonun süresini hesapla
        const video = document.createElement('video');
        video.preload = 'metadata';
        video.onloadedmetadata = () => {
            window.URL.revokeObjectURL(video.src);
            setDurationSeconds(Math.round(video.duration));
        };
        video.src = URL.createObjectURL(selectedFile);
    };

    const handleStartUpload = () => {
        if (!file || !title.trim()) {
            setError('Lütfen bir video dosyası seçin ve başlık girin.');
            return;
        }

        // Başlatıp modalı hemen kapat
        startUpload(courseId || null, title.trim(), file, durationSeconds, folderId);
        onSuccess(); // Sadece listeyi yenilemesi için (veya backend bitene kadar bir şey görmeyebiliriz ama olsun)
        onClose();
    };

    return (
        <div className="fixed inset-0 z-[9999] flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
            <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl w-full max-w-lg overflow-hidden flex flex-col">
                
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100 dark:border-gray-700">
                    <div className="flex items-center gap-2">
                        <div className="p-2 bg-blue-50 dark:bg-blue-900/30 rounded-lg text-blue-600 dark:text-blue-400">
                            <UploadCloud className="w-5 h-5" />
                        </div>
                        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">Video Yükle (VOD)</h3>
                    </div>
                    <button onClick={onClose} className="p-2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
                        <X className="w-5 h-5" />
                    </button>
                </div>

                {/* Body */}
                <div className="p-6 flex flex-col gap-5">
                    {error && (
                        <div className="p-3 bg-red-50 text-red-600 rounded-lg text-sm border border-red-100">
                            {error}
                        </div>
                    )}

                    {/* Drag Drop Area */}
                    <div
                        onDragOver={handleDragOver}
                        onDragLeave={handleDragLeave}
                        onDrop={handleDrop}
                        onClick={() => fileInputRef.current?.click()}
                        className={`relative group border-2 border-dashed rounded-xl p-8 flex flex-col items-center justify-center text-center cursor-pointer transition-all
                            ${isDragging ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/20' : 'border-gray-200 dark:border-gray-700 hover:border-blue-400 hover:bg-gray-50 dark:hover:bg-gray-700/50'}
                        `}
                    >
                        <input 
                            type="file" 
                            ref={fileInputRef} 
                            onChange={handleFileChange} 
                            accept="video/mp4,video/quicktime,video/x-matroska" 
                            className="hidden" 
                        />
                        
                        <div className={`p-4 rounded-full mb-4 transition-transform group-hover:scale-110 ${file ? 'bg-green-100 text-green-600' : 'bg-blue-50 dark:bg-blue-900/40 text-blue-500'}`}>
                            {file ? <Film className="w-8 h-8" /> : <UploadCloud className="w-8 h-8" />}
                        </div>

                        {file ? (
                            <>
                                <h4 className="text-sm font-semibold text-gray-900 dark:text-white line-clamp-1 px-4">{file.name}</h4>
                                <p className="text-xs text-gray-500 mt-1">{(file.size / (1024 * 1024)).toFixed(2)} MB</p>
                                <span className="mt-3 text-xs font-medium text-blue-600 dark:text-blue-400 bg-blue-50 dark:bg-blue-900/30 px-3 py-1 rounded-full">
                                    Değiştir
                                </span>
                            </>
                        ) : (
                            <>
                                <h4 className="text-sm font-semibold text-gray-900 dark:text-white">Video dosyasını sürükleyin</h4>
                                <p className="text-xs text-gray-500 mt-1">veya seçmek için tıklayın (Sadece MP4, MOV)</p>
                            </>
                        )}
                    </div>

                    {/* Meta Fields */}
                    <div className="space-y-1.5">
                        <label className="text-sm font-medium text-gray-700 dark:text-gray-300">Ders Başlığı</label>
                        <input
                            type="text"
                            value={title}
                            onChange={(e) => setTitle(e.target.value)}
                            placeholder="Örn: 1. Hafta - Temel Kavramlar"
                            className="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 rounded-lg text-sm text-gray-900 dark:text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                        />
                        <p className="text-xs text-gray-500 mt-1">Bu başlık öğrenci panelinde doğrudan görünecektir.</p>
                    </div>

                </div>

                {/* Footer */}
                <div className="px-6 py-4 bg-gray-50 dark:bg-gray-900/50 border-t border-gray-100 dark:border-gray-700 flex justify-end gap-3">
                    <button onClick={onClose} className="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors">
                        İptal
                    </button>
                    <button 
                        onClick={handleStartUpload} 
                        disabled={!file || !title.trim()}
                        className="px-5 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
                    >
                        <UploadCloud className="w-4 h-4" />
                        Arka Planda Yükle
                    </button>
                </div>
                
            </div>
        </div>
    );
}
