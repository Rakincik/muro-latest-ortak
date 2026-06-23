"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import { notificationApi, type NotificationDto } from "@/lib/api";
import { useNotifications } from "@/hooks/useNotifications";

const TYPE_ICON: Record<string, string> = {
    Acil: "🔴",
    Uyarı: "⚠️",
    Başarı: "✅",
    Bilgi: "ℹ️",
    RecordingReady: "📹",
    SessionStarted: "🔴",
    AssignmentGraded: "📝",
    ExamResult: "📊",
};

const TYPE_ACCENT: Record<string, string> = {
    Acil: "border-red-500/30 bg-red-500/5",
    Uyarı: "border-amber-500/30 bg-amber-500/5",
    Başarı: "border-emerald-500/30 bg-emerald-500/5",
    Bilgi: "border-blue-500/30 bg-blue-500/5",
};

// Bildirimleri tarih gruplarına ayır
function groupByDate(items: NotificationDto[]): [string, NotificationDto[]][] {
    const map = new Map<string, NotificationDto[]>();
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(today.getDate() - 1);

    for (const item of items) {
        const d = new Date(item.createdAt);
        let label: string;
        if (d.toDateString() === today.toDateString()) label = "Bugün";
        else if (d.toDateString() === yesterday.toDateString()) label = "Dün";
        else label = d.toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric" });

        if (!map.has(label)) map.set(label, []);
        map.get(label)!.push(item);
    }
    return [...map.entries()];
}

interface Props {
    onClose: () => void;
    onUnreadCountUpdate?: (count: number) => void;
}

export default function NotificationsModal({ onClose, onUnreadCountUpdate }: Props) {
    const router = useRouter();
    const { token, currentTenantId: tenantId } = useAuth();
    const [notifications, setNotifications] = useState<NotificationDto[]>([]);
    const [loading, setLoading] = useState(true);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const result = await notificationApi.list(token, tenantId, 1, 50);
            const items = Array.isArray(result) ? result : result.items ?? [];
            setNotifications(items);
            if (onUnreadCountUpdate) {
                onUnreadCountUpdate(items.filter(n => !n.isRead).length);
            }
        } catch { /* sessiz */ } finally {
            setLoading(false);
        }
    }, [token, tenantId, onUnreadCountUpdate]);

    useEffect(() => { load(); }, [load]);

    // SignalR: anlık bildirim gelince listeye ekle
    useNotifications({
        onReceive: (notif) => {
            setNotifications(prev => {
                const newItems = [notif, ...prev];
                if (onUnreadCountUpdate) {
                    onUnreadCountUpdate(newItems.filter(n => !n.isRead).length);
                }
                return newItems;
            });
        },
    });



    const handleNotifClick = async (n: NotificationDto) => {
        if (!n.isRead && token && tenantId) {
            try {
                await notificationApi.markRead(token, tenantId, n.id);
                setNotifications(prev => {
                    const newItems = prev.map(x => x.id === n.id ? { ...x, isRead: true } : x);
                    if (onUnreadCountUpdate) {
                        onUnreadCountUpdate(newItems.filter(x => !x.isRead).length);
                    }
                    return newItems;
                });
            } catch { /* sessiz */ }
        }

        const typeParts = n.type?.split(":");
        const courseId = typeParts?.[1];
        if (courseId) {
            onClose();
            router.push(`/dashboard/courses/${courseId}`);
        }
    };

    const markAllRead = async () => {
        if (!token || !tenantId) return;
        await notificationApi.markAllRead(token, tenantId);
        setNotifications(prev => {
            const newItems = prev.map(n => ({ ...n, isRead: true }));
            if (onUnreadCountUpdate) {
                onUnreadCountUpdate(0);
            }
            return newItems;
        });
    };

    const unread = notifications.filter(n => !n.isRead).length;
    const dateGroups = groupByDate(notifications);

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm" onClick={onClose}>
            <div 
                className="bg-white rounded-3xl w-full max-w-xl max-h-[85vh] flex flex-col shadow-2xl overflow-hidden animate-slide-up"
                onClick={e => e.stopPropagation()}
            >
                {/* Header */}
                <div className="px-6 py-5 border-b border-[#E2E8F0] flex items-center justify-between shrink-0 bg-slate-50/50">
                    <div>
                        <h2 className="text-xl font-bold text-[#0A1931] flex items-center gap-2">
                            🔔 Bildirimler
                            {unread > 0 && (
                                <span className="bg-[#1B3B6F] text-white text-[10px] font-bold px-2 py-0.5 rounded-full">{unread} yeni</span>
                            )}
                        </h2>
                    </div>
                    <div className="flex items-center gap-3">
                        {unread > 0 && (
                            <button
                                onClick={markAllRead}
                                className="text-xs font-semibold text-violet-600 hover:text-violet-700 hover:underline transition-all"
                            >
                                ✓ Tümünü Okundu İşaretle
                            </button>
                        )}
                        <button onClick={onClose} className="w-8 h-8 flex items-center justify-center bg-slate-100 hover:bg-slate-200 rounded-full text-slate-500 transition-colors">
                            ✕
                        </button>
                    </div>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-6 bg-white">
                    {loading ? (
                        <div className="space-y-4">
                            {[...Array(4)].map((_, i) => (
                                <div key={i} className="h-20 bg-slate-100 rounded-2xl animate-pulse" />
                            ))}
                        </div>
                    ) : notifications.length === 0 ? (
                        <div className="text-center py-16">
                            <p className="text-6xl mb-4">🔕</p>
                            <p className="text-[#0A1931] font-bold text-lg">Henüz bildirim yok</p>
                            <p className="text-[#A0AEC0] text-sm mt-1">Yeni bir şey olduğunda burada görünecek</p>
                        </div>
                    ) : (
                        <div className="space-y-8">
                            {dateGroups.map(([date, items]) => (
                                <div key={date}>
                                    <div className="flex items-center gap-3 mb-4">
                                        <span className="text-xs font-bold text-slate-400 uppercase tracking-widest">{date}</span>
                                        <div className="flex-1 h-px bg-slate-100" />
                                    </div>
                                    <div className="space-y-3">
                                        {items.map(n => {
                                            const typeParts = n.type?.split(":");
                                            const cleanType = typeParts?.[0] || "";
                                            const courseId = typeParts?.[1];
                                            const accent = TYPE_ACCENT[cleanType] ?? "border-slate-200 bg-white hover:bg-slate-50";
                                            const isClickable = !n.isRead || !!courseId;
                                            return (
                                                <div
                                                    key={n.id}
                                                    onClick={() => handleNotifClick(n)}
                                                    className={`p-4 rounded-2xl flex items-start gap-4 transition-all duration-300
                                                        ${!n.isRead ? `border shadow-sm ${accent}` : "bg-white border border-slate-100 opacity-60 hover:opacity-100"}
                                                        ${isClickable ? "cursor-pointer" : ""}`}
                                                >
                                                    <span className="text-2xl shrink-0">
                                                        {TYPE_ICON[cleanType] ?? "🔔"}
                                                    </span>
                                                    <div className="flex-1 min-w-0 pt-1">
                                                        <div className="flex items-start justify-between gap-2 mb-1">
                                                            <p className={`text-sm leading-tight ${!n.isRead ? "font-bold text-[#0A1931]" : "font-semibold text-slate-600"}`}>
                                                                {n.title}
                                                            </p>
                                                            <time className="text-slate-400 text-[10px] font-mono shrink-0 whitespace-nowrap mt-0.5">
                                                                {new Date(n.createdAt).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}
                                                            </time>
                                                        </div>
                                                        <p className="text-slate-500 text-xs leading-relaxed">{n.body}</p>
                                                    </div>
                                                    {!n.isRead && (
                                                        <div className="w-2 h-2 rounded-full bg-violet-500 shrink-0 mt-2 shadow-[0_0_8px_rgba(139,92,246,0.6)]" />
                                                    )}
                                                </div>
                                            );
                                        })}
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
