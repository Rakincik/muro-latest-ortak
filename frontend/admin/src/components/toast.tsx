"use client";

import { createContext, useContext, useState, useCallback, useEffect, ReactNode } from "react";
import { CheckCircle, XCircle, Info, AlertTriangle, X } from "lucide-react";

type ToastType = "success" | "error" | "info" | "warning";

interface Toast {
    id: string;
    type: ToastType;
    title: string;
    message?: string;
}

interface ToastContextType {
    toast: (type: ToastType, title: string, message?: string) => void;
    success: (title: string, message?: string) => void;
    error: (title: string, message?: string) => void;
}

const ToastContext = createContext<ToastContextType | undefined>(undefined);

const icons = { success: CheckCircle, error: XCircle, info: Info, warning: AlertTriangle };
const colors: Record<ToastType, { bg: string; border: string; icon: string }> = {
    success: { bg: "#f0fdf4", border: "#86efac", icon: "#16a34a" },
    error: { bg: "#fef2f2", border: "#fca5a5", icon: "#dc2626" },
    info: { bg: "#eff6ff", border: "#93c5fd", icon: "#2563eb" },
    warning: { bg: "#fffbeb", border: "#fcd34d", icon: "#d97706" },
};

export function ToastProvider({ children }: { children: ReactNode }) {
    const [toasts, setToasts] = useState<Toast[]>([]);

    const addToast = useCallback((type: ToastType, title: string, message?: string) => {
        const id = Date.now().toString();
        setToasts(prev => [...prev, { id, type, title, message }]);
        setTimeout(() => {
            setToasts(prev => prev.filter(t => t.id !== id));
        }, 4000);
    }, []);

    // Listen for toast:show custom events (from AuthContext etc.)
    useEffect(() => {
        const handler = (e: Event) => {
            const { type, title, message } = (e as CustomEvent).detail;
            addToast(type || "info", title, message);
        };
        window.addEventListener("toast:show", handler);
        return () => window.removeEventListener("toast:show", handler);
    }, [addToast]);

    const remove = (id: string) => setToasts(prev => prev.filter(t => t.id !== id));

    const ctx: ToastContextType = {
        toast: addToast,
        success: (title, message) => addToast("success", title, message),
        error: (title, message) => addToast("error", title, message),
    };

    return (
        <ToastContext.Provider value={ctx}>
            {children}
            {/* Toast Container */}
            <div className="fixed top-6 right-6 z-[200] flex flex-col gap-3 pointer-events-none" style={{ width: '380px' }}>
                {toasts.map((t) => {
                    const Icon = icons[t.type];
                    const c = colors[t.type];
                    return (
                        <div key={t.id}
                            className="pointer-events-auto animate-fade-in rounded-xl shadow-lg border px-4 py-3 flex items-start gap-3"
                            style={{ background: c.bg, borderColor: c.border }}>
                            <Icon size={20} className="shrink-0 mt-0.5" style={{ color: c.icon }} />
                            <div className="flex-1 min-w-0">
                                <p className="text-sm font-semibold text-[#0A1931]">{t.title}</p>
                                {t.message && <p className="text-xs text-[#A9A9A9] mt-0.5">{t.message}</p>}
                            </div>
                            <button onClick={() => remove(t.id)}
                                className="shrink-0 text-[#A0AEC0] hover:text-[#1B3B6F] transition-colors">
                                <X size={16} />
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
