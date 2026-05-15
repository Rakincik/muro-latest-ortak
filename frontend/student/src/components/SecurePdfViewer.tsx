"use client";

import { useState, useRef, useEffect } from "react";
import { Document, Page, pdfjs } from "react-pdf";

// Next.js client ortamında pdf worker ayarı
pdfjs.GlobalWorkerOptions.workerSrc = `//unpkg.com/pdfjs-dist@${pdfjs.version}/build/pdf.worker.min.mjs`;

interface SecurePdfViewerProps {
    url: string;
}

export default function SecurePdfViewer({ url }: SecurePdfViewerProps) {
    const [numPages, setNumPages] = useState<number>();
    const [pageNumber, setPageNumber] = useState<number>(1);
    const [scale, setScale] = useState<number>(1.0);
    const [containerWidth, setContainerWidth] = useState<number>();
    const containerRef = useRef<HTMLDivElement>(null);

    // Konteynerin genişliğini takip et (Responsive Fit-to-Width)
    useEffect(() => {
        const observer = new ResizeObserver((entries) => {
            if (entries[0]?.contentRect.width) {
                // Yanlardan boşluk bırakmak için 40px çıkarıyoruz
                setContainerWidth(entries[0].contentRect.width - 40);
            }
        });

        if (containerRef.current) {
            observer.observe(containerRef.current);
        }
        return () => observer.disconnect();
    }, []);

    const onDocumentLoadSuccess = ({ numPages }: { numPages: number }) => {
        setNumPages(numPages);
        setPageNumber(1);
    };

    const changePage = (offset: number) => {
        setPageNumber((prev) => Math.min(Math.max(1, prev + offset), numPages || 1));
    };

    const zoomIn = () => setScale(s => Math.min(s + 0.3, 3.0));
    const zoomOut = () => setScale(s => Math.max(s - 0.2, 0.6));

    return (
        <div className="flex flex-col h-full bg-[#E2E8F0]/20 select-none" onContextMenu={(e) => e.preventDefault()}>
            {/* Araç Çubuğu (Toolbar) */}
            <div className="flex items-center justify-between p-3 bg-white border-b border-[#E2E8F0] shadow-sm z-10 shrink-0 rounded-t-xl">
                <div className="flex items-center gap-2">
                    <button 
                        onClick={() => changePage(-1)} 
                        disabled={pageNumber <= 1}
                        className="w-8 h-8 flex items-center justify-center rounded-lg bg-[#E2E8F0]/50 hover:bg-[#E2E8F0] text-[#0A1931] disabled:opacity-30 transition-all font-bold"
                    >
                        ◀
                    </button>
                    <span className="text-sm font-bold text-[#1B3B6F] min-w-[60px] text-center">
                        {pageNumber} / {numPages || "-"}
                    </span>
                    <button 
                        onClick={() => changePage(1)} 
                        disabled={numPages === undefined || pageNumber >= numPages}
                        className="w-8 h-8 flex items-center justify-center rounded-lg bg-[#E2E8F0]/50 hover:bg-[#E2E8F0] text-[#0A1931] disabled:opacity-30 transition-all font-bold"
                    >
                        ▶
                    </button>
                </div>

                <div className="flex items-center gap-2">
                    <button 
                        onClick={zoomOut}
                        disabled={scale <= 0.5}
                        className="w-8 h-8 flex items-center justify-center rounded-lg bg-violet-100 hover:bg-violet-200 text-violet-700 disabled:opacity-30 transition-all font-bold text-lg"
                    >
                        -
                    </button>
                    <button
                        onClick={() => setScale(1.0)}
                        className="px-2 h-8 flex items-center justify-center rounded-lg hover:bg-slate-100 text-[#1B3B6F] transition-all font-semibold text-xs border border-transparent hover:border-slate-200"
                        title="Ekrana Sığdır"
                    >
                        {Math.round(scale * 100)}%
                    </button>
                    <button 
                        onClick={zoomIn}
                        disabled={scale >= 3.0}
                        className="w-8 h-8 flex items-center justify-center rounded-lg bg-violet-100 hover:bg-violet-200 text-violet-700 disabled:opacity-30 transition-all font-bold text-lg"
                    >
                        +
                    </button>
                </div>
            </div>

            {/* PDF Görüntüleme Alanı */}
            <div ref={containerRef} className="flex-1 overflow-auto flex justify-center p-4 custom-scrollbar bg-slate-50 relative rounded-b-xl">
                <Document
                    file={url}
                    onLoadSuccess={onDocumentLoadSuccess}
                    loading={
                        <div className="flex flex-col items-center justify-center text-[#A9A9A9] h-full mt-20">
                            <div className="w-8 h-8 border-2 border-violet-500 border-t-transparent rounded-full animate-spin mb-4" />
                            <p className="font-semibold">Sınav kitapçığı işleniyor...</p>
                        </div>
                    }
                    error={
                        <div className="flex flex-col items-center justify-center text-red-500 h-full mt-20">
                            <p className="text-4xl mb-3">⚠️</p>
                            <p className="font-bold">PDF yüklenemedi veya erişim engellendi.</p>
                        </div>
                    }
                >
                    {/* Page Wrapper for Watermark Alignment */}
                    <div className="relative shadow-xl border border-[#E2E8F0] bg-white inline-block">
                        <Page 
                            pageNumber={pageNumber} 
                            width={containerWidth}
                            scale={scale} 
                            // Güvenlik: Yazı katmanı ve tıklanabilir linkleri tamamen kapatıyoruz ki PDF sadece bir resim olsun.
                            renderTextLayer={false}
                            renderAnnotationLayer={false}
                            className="bg-white"
                        />
                    </div>
                </Document>
            </div>
        </div>
    );
}
