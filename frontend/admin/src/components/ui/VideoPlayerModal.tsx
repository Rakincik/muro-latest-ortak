"use client";

import React, { useEffect, useRef, useState } from 'react';
import { X, Loader2 } from 'lucide-react';
import Hls from 'hls.js';
import type { MediaAssetDto } from '@/lib/api';

interface VideoPlayerModalProps {
    asset: MediaAssetDto | null;
    onClose: () => void;
}

export function VideoPlayerModal({ asset, onClose }: VideoPlayerModalProps) {
    const videoRef = useRef<HTMLVideoElement>(null);
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        if (!asset || !videoRef.current) return;

        const video = videoRef.current;
        setIsLoading(true);
        setError(null);

        let videoSrc = asset.hlsPath || asset.filePath;

        if (!videoSrc) {
            setError("Bu video için oynatılabilir bir dosya bulunamadı.");
            setIsLoading(false);
            return;
        }

        // If the path is relative, prepend the API URL or origin
        if (videoSrc.startsWith('/')) {
            const baseUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:5292/api/v1";
            // If it's just an API path, it might need to resolve to the host
            // Let's use a safe absolute URL converter
            try {
                // Remove /api/v1 if the path is actually a static file path, or handle appropriately
                // Often, if the path starts with /uploads, it's served from the backend root
                const backendHost = baseUrl.replace('/api/v1', '');
                videoSrc = `${backendHost}${videoSrc}`;
            } catch (e) {
                console.error(e);
            }
        }

        let hls: Hls | null = null;

        if (asset.hlsPath && Hls.isSupported()) {
            hls = new Hls({
                maxBufferLength: 30,
                enableWorker: true
            });
            hls.loadSource(videoSrc);
            hls.attachMedia(video);
            
            hls.on(Hls.Events.MANIFEST_PARSED, () => {
                setIsLoading(false);
                video.play().catch(console.error);
            });

            hls.on(Hls.Events.ERROR, (event, data) => {
                if (data.fatal) {
                    console.error("HLS Error:", data);
                    setError(`Videonun oynatılmasında bir hata oluştu. (Yol: ${videoSrc})`);
                    setIsLoading(false);
                }
            });
        } else if (video.canPlayType('application/vnd.apple.mpegurl') || asset.filePath) {
            // Native HLS support (Safari) or fallback to MP4
            video.src = videoSrc;
            video.addEventListener('loadedmetadata', () => {
                setIsLoading(false);
                video.play().catch(console.error);
            });
            video.addEventListener('error', () => {
                setError("Video yüklenirken hata oluştu.");
                setIsLoading(false);
            });
        } else {
            setError("Tarayıcınız bu videoyu desteklemiyor.");
            setIsLoading(false);
        }

        return () => {
            if (hls) {
                hls.destroy();
            }
        };
    }, [asset]);

    if (!asset) return null;

    return (
        <div className="fixed inset-0 z-[120] flex items-center justify-center bg-black/90 backdrop-blur-sm animate-in fade-in duration-200">
            <div className="absolute top-4 right-4">
                <button 
                    onClick={onClose}
                    className="p-2 bg-white/10 hover:bg-white/20 text-white rounded-full transition-colors backdrop-blur-md"
                    title="Kapat"
                >
                    <X size={24} />
                </button>
            </div>

            <div className="w-full max-w-5xl mx-auto px-4 flex flex-col">
                <div className="mb-4">
                    <h2 className="text-white text-xl font-medium tracking-tight">{asset.title}</h2>
                    <p className="text-gray-400 text-sm mt-1">{asset.status}</p>
                </div>

                <div className="relative aspect-video w-full bg-black rounded-2xl overflow-hidden border border-white/10 shadow-2xl">
                    {isLoading && !error && (
                        <div className="absolute inset-0 flex items-center justify-center bg-gray-900 z-10">
                            <div className="flex flex-col items-center gap-3">
                                <Loader2 className="w-8 h-8 text-blue-500 animate-spin" />
                                <span className="text-gray-400 text-sm">Yükleniyor...</span>
                            </div>
                        </div>
                    )}
                    
                    {error && (
                        <div className="absolute inset-0 flex items-center justify-center bg-gray-900 z-10 p-6 text-center">
                            <div className="bg-red-500/10 text-red-400 p-4 rounded-xl border border-red-500/20">
                                {error}
                            </div>
                        </div>
                    )}

                    <video 
                        ref={videoRef}
                        controls
                        controlsList="nodownload"
                        className="w-full h-full object-contain outline-none"
                        poster={asset.thumbnailPath}
                    />
                </div>
            </div>
        </div>
    );
}
