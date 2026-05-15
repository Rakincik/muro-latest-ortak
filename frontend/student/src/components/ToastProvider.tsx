"use client";

import { createContext, useContext, useState, useCallback, useRef, useEffect, ReactNode } from "react";
import { successVibrate, heavyTap, mediumTap, lightTap } from "@/hooks/useHaptics";

interface Toast {
    id: number;
    message: string;
    title?: string;
    type: "success" | "error" | "info" | "warning";
}

interface ToastContextType {
    showToast: (message: string, type?: Toast["type"], title?: string) => void;
}

const ToastContext = createContext<ToastContextType | undefined>(undefined);

export function ToastProvider({ children }: { children: ReactNode }) {
    const [toasts, setToasts] = useState<Toast[]>([]);
    const counterRef = useRef(0);

    const showToast = useCallback((message: string, type: Toast["type"] = "info", title?: string) => {
        const id = ++counterRef.current;
        setToasts(prev => [...prev.slice(-4), { id, message, type, title }]); // max 5 toasts
        
        // Haptic feedback based on toast type
        if (type === "success") successVibrate();
        else if (type === "error") heavyTap();
        else if (type === "warning") mediumTap();
        else lightTap();

        setTimeout(() => {
            setToasts(prev => prev.filter(t => t.id !== id));
        }, 4500);
    }, []);

    // Listen for toast:show custom events from non-component code (AuthContext, etc.)
    useEffect(() => {
        const handler = (e: Event) => {
            const { message, type, title } = (e as CustomEvent).detail;
            showToast(message, type, title);
        };
        window.addEventListener("toast:show", handler);
        return () => window.removeEventListener("toast:show", handler);
    }, [showToast]);

    const dismiss = useCallback((id: number) => {
        setToasts(prev => prev.filter(t => t.id !== id));
    }, []);

    const config: Record<Toast["type"], { icon: string; bg: string; border: string; accent: string }> = {
        success: { icon: "✓", bg: "bg-[#0A1931]", border: "border-emerald-500/40", accent: "text-emerald-400" },
        error:   { icon: "✕", bg: "bg-[#0A1931]", border: "border-red-500/40", accent: "text-red-400" },
        warning: { icon: "⚠", bg: "bg-[#0A1931]", border: "border-amber-500/40", accent: "text-amber-400" },
        info:    { icon: "ℹ", bg: "bg-[#0A1931]", border: "border-blue-500/40", accent: "text-blue-400" },
    };

    return (
        <ToastContext.Provider value={{ showToast }}>
            {children}
            {/* Toast container — above mobile tab bar */}
            <div className="fixed bottom-20 md:bottom-6 right-4 md:right-6 z-[200] flex flex-col gap-2.5 max-w-sm w-full pointer-events-none"
                 style={{ paddingBottom: "env(safe-area-inset-bottom, 0px)" }}>
                {toasts.map(t => {
                    const c = config[t.type];
                    return (
                        <div
                            key={t.id}
                            className={`${c.bg} ${c.border} border rounded-xl px-4 py-3 flex items-start gap-3 shadow-2xl shadow-black/30 backdrop-blur-xl pointer-events-auto`}
                            style={{ animation: "toastSlideIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)" }}
                        >
                            <span className={`${c.accent} text-sm font-bold mt-0.5 shrink-0 w-5 h-5 rounded-full border ${c.border} flex items-center justify-center text-xs`}>
                                {c.icon}
                            </span>
                            <div className="flex-1 min-w-0">
                                {t.title && <p className="text-white text-xs font-bold mb-0.5">{t.title}</p>}
                                <p className="text-white/80 text-sm leading-relaxed">{t.message}</p>
                            </div>
                            <button
                                onClick={() => dismiss(t.id)}
                                className="text-white/30 hover:text-white/70 transition-colors shrink-0 mt-0.5"
                            >
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} className="w-4 h-4">
                                    <path strokeLinecap="round" d="M6 18L18 6M6 6l12 12" />
                                </svg>
                            </button>
                        </div>
                    );
                })}
            </div>
        </ToastContext.Provider>
    );
}

export function useToast() {
    const ctx = useContext(ToastContext);
    if (!ctx) throw new Error("useToast must be used within ToastProvider");
    return ctx;
}

