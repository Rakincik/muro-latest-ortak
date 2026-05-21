"use client";
import { useState, useEffect, useRef } from "react";
import { ZoomIn, ZoomOut } from "lucide-react";

interface SecurePdfViewerProps {
    url: string;
}

export default function SecurePdfViewer({ url }: SecurePdfViewerProps) {
    const [isLoading, setIsLoading] = useState(true);
    const [scale, setScale] = useState(1.25); // Mobil uyum için varsayılan ölçek
    const [error, setError] = useState<string | null>(null);
    const containerRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        let isMounted = true;
        setIsLoading(true);
        setError(null);

        const scriptId = "pdfjs-lib-script";
        let script = document.getElementById(scriptId) as HTMLScriptElement;

        const initPdf = async () => {
            if (!isMounted) return;
            try {
                // @ts-ignore
                const pdfjsLib = window.pdfjsLib;
                if (!pdfjsLib) throw new Error("PDF.js kütüphanesi yüklenemedi.");

                pdfjsLib.GlobalWorkerOptions.workerSrc = "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js";

                const loadingTask = pdfjsLib.getDocument(url);
                const pdf = await loadingTask.promise;
                
                if (!isMounted) return;
                setIsLoading(false);

                if (containerRef.current) {
                    containerRef.current.innerHTML = ''; 
                    
                    for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
                        if (!isMounted) break;
                        
                        const page = await pdf.getPage(pageNum);
                        const viewport = page.getViewport({ scale });
                        
                        const canvas = document.createElement("canvas");
                        const context = canvas.getContext("2d");
                        
                        canvas.height = viewport.height;
                        canvas.width = viewport.width;
                        canvas.className = "mb-4 rounded-xl shadow-md border border-[#E2E8F0] max-w-full h-auto";
                        // Mobilde resmin üzerine basılı tutarak "Kaydet" çıkmasını engellemek için:
                        canvas.style.webkitTouchCallout = "none";

                        containerRef.current.appendChild(canvas);

                        if (context) {
                            const renderContext = {
                                canvasContext: context,
                                viewport: viewport
                            };
                            await page.render(renderContext).promise;
                        }
                    }
                }
            } catch (err) {
                console.error("PDF Load Error:", err);
                if (isMounted) {
                    setError("Sınav kitapçığı yüklenemedi. Bağlantınızı kontrol edin.");
                    setIsLoading(false);
                }
            }
        };

        if (!script) {
            script = document.createElement("script");
            script.id = scriptId;
            script.src = "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js";
            script.async = true;
            script.onload = initPdf;
            document.body.appendChild(script);
        } else {
            // @ts-ignore
            if (window.pdfjsLib) {
                initPdf();
            } else {
                script.addEventListener("load", initPdf);
            }
        }
        
        return () => {
            isMounted = false;
            if (script) script.removeEventListener("load", initPdf);
        };
    }, [url, scale]); 

    const handleZoomIn = () => setScale(s => Math.min(s + 0.25, 3.0));
    const handleZoomOut = () => setScale(s => Math.max(s - 0.25, 0.75));

    return (
        <div 
            className="flex flex-col h-full bg-[#E2E8F0]/20 select-none relative rounded-xl overflow-hidden" 
            onContextMenu={(e) => e.preventDefault()}
        >
            {/* Araç Çubuğu (Toolbar) */}
            <div className="flex items-center justify-between p-3 bg-white border-b border-[#E2E8F0] shadow-sm z-10 shrink-0">
                <span className="text-sm font-bold text-[#1B3B6F]">
                    Sınav Kitapçığı
                </span>
                <div className="flex items-center gap-2">
                    <button onClick={handleZoomOut} className="p-1.5 hover:bg-slate-100 rounded-lg transition-colors text-[#1B3B6F]">
                        <ZoomOut size={18} />
                    </button>
                    <span className="text-xs font-semibold text-[#5A6A7A] w-10 text-center">{Math.round(scale * 100)}%</span>
                    <button onClick={handleZoomIn} className="p-1.5 hover:bg-slate-100 rounded-lg transition-colors text-[#1B3B6F]">
                        <ZoomIn size={18} />
                    </button>
                </div>
            </div>

            {/* PDF Görüntüleme Alanı */}
            <div className="flex-1 overflow-auto relative bg-slate-50 p-4 custom-scrollbar">
                {isLoading && (
                    <div className="absolute inset-0 z-20 flex flex-col items-center justify-center bg-slate-50/80 backdrop-blur-sm">
                        <div className="w-8 h-8 border-2 border-[#1B3B6F] border-t-transparent rounded-full animate-spin mb-4" />
                        <p className="font-semibold text-[#1B3B6F]">Sınav kitapçığı çiziliyor...</p>
                    </div>
                )}

                {error && (
                    <div className="absolute inset-0 z-20 flex flex-col items-center justify-center bg-slate-50">
                        <p className="font-semibold text-rose-500">{error}</p>
                    </div>
                )}
                
                {/* Canvas Konteyneri */}
                <div ref={containerRef} className="flex flex-col items-center justify-start min-h-full pb-10" />
            </div>
        </div>
    );
}
