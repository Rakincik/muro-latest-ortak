"use client";

import { useEffect, useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import { notificationApi, type NotificationDto } from "@/lib/api";
import { useNotifications } from "@/hooks/useNotifications";

// ── Toast Popup ─────────────────────────────────────────────────────────────
function NotifToast({ notif, onClose }: { notif: NotificationDto; onClose: () => void }) {
    useEffect(() => {
        const t = setTimeout(onClose, 5000);
        return () => clearTimeout(t);
    }, [onClose]);

    return (
        <div className="fixed top-6 right-6 z-[200] w-72 glass-card p-4 border-l-4 border-violet-500 shadow-2xl animate-slide-in-right">
            <div className="flex items-start gap-3">
                <span className="text-xl shrink-0">🔔</span>
                <div className="flex-1 min-w-0">
                    <p className="text-[#0A1931] text-sm font-semibold truncate">{notif.title}</p>
                    <p className="text-[#A0AEC0] text-xs mt-0.5 line-clamp-2">{notif.body}</p>
                </div>
                <button onClick={onClose} className="text-[#A9A9A9] hover:text-[#0A1931] text-lg leading-none shrink-0">×</button>
            </div>
        </div>
    );
}

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

export default function NotificationsPage() {
    const router = useRouter();
    const { token, currentTenantId: tenantId } = useAuth();
    const [notifications, setNotifications] = useState<NotificationDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [toast, setToast] = useState<NotificationDto | null>(null);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const result = await notificationApi.list(token, tenantId, 1, 50);
            const items = Array.isArray(result) ? result : result.items ?? [];
            setNotifications(items);
        } catch { /* sessiz */ } finally {
            setLoading(false);
        }
    }, [token, tenantId]);

    useEffect(() => { load(); }, [load]);

    // SignalR: anlık bildirim gelince toast göster ve listeye ekle
    useNotifications({
        onReceive: (notif) => {
            setNotifications(prev => [notif, ...prev]);
            setToast(notif);
        },
    });



    const handleNotifClick = async (n: NotificationDto) => {
        if (!n.isRead && token && tenantId) {
            try {
                await notificationApi.markRead(token, tenantId, n.id);
                setNotifications(prev => prev.map(x => x.id === n.id ? { ...x, isRead: true } : x));
            } catch { /* sessiz */ }
        }

        const typeParts = n.type?.split(":");
        const courseId = typeParts?.[1];
        if (courseId) {
            router.push(`/dashboard/courses/${courseId}`);
        }
    };

    const markAllRead = async () => {
        if (!token || !tenantId) return;
        await notificationApi.markAllRead(token, tenantId);
        setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
    };

    const unread = notifications.filter(n => !n.isRead).length;
    const dateGroups = groupByDate(notifications);

    return (
        <>
            {/* Toast popup */}
            {toast && <NotifToast notif={toast} onClose={() => setToast(null)} />}

            <div className="max-w-2xl mx-auto">
                {/* Header */}
                <div className="flex items-center justify-between mb-8">
                    <div>
                        <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                            🔔 Bildirimler
                            {unread > 0 && (
                                <span className="bg-[#1B3B6F] text-[#0A1931] text-xs font-bold px-2 py-0.5 rounded-full">{unread}</span>
                            )}
                        </h1>
                        <p className="text-[#A9A9A9] text-sm mt-1">
                            {unread > 0 ? `${unread} okunmamış bildirim` : "Tüm bildirimler okundu"}
                        </p>
                    </div>
                    {unread > 0 && (
                        <button
                            onClick={markAllRead}
                            className="px-4 py-2 bg-[#1B3B6F]/15 hover:bg-white/10 border border-[#1B3B6F]/30 text-[#A0AEC0] hover:text-[#0A1931] text-xs font-medium rounded-xl transition-all"
                        >
                            ✓ Tümünü Okundu İşaretle
                        </button>
                    )}
                </div>

                {/* İçerik */}
                {loading ? (
                    <div className="space-y-3">
                        {[...Array(5)].map((_, i) => (
                            <div key={i} className="glass-card p-5 animate-pulse h-20" />
                        ))}
                    </div>
                ) : notifications.length === 0 ? (
                    <div className="glass-card text-center py-20">
                        <p className="text-5xl mb-4">🔕</p>
                        <p className="text-[#A0AEC0] font-medium">Henüz bildirim yok</p>
                        <p className="text-[#A0AEC0] text-sm mt-1">Yeni bir şey olduğunda burada görünecek</p>
                    </div>
                ) : (
                    <div className="space-y-6">
                        {dateGroups.map(([date, items]) => (
                            <div key={date}>
                                {/* Tarih başlığı */}
                                <div className="flex items-center gap-3 mb-3">
                                    <span className="text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider">{date}</span>
                                    <div className="flex-1 h-px bg-[#1B3B6F]/15" />
                                </div>

                                <div className="space-y-2">
                                    {items.map(n => {
                                        const typeParts = n.type?.split(":");
                                        const cleanType = typeParts?.[0] || "";
                                        const courseId = typeParts?.[1];
                                        const accent = TYPE_ACCENT[cleanType] ?? "border-[#1B3B6F]/20 bg-white/[0.02]";
                                        const isClickable = !n.isRead || !!courseId;
                                        return (
                                            <div
                                                key={n.id}
                                                onClick={() => handleNotifClick(n)}
                                                className={`glass-card p-4 flex items-start gap-4 transition-all
                                                    ${!n.isRead ? `border ${accent}` : "opacity-50 hover:opacity-70"}
                                                    ${isClickable ? "cursor-pointer" : ""}`}
                                            >
                                                <span className="text-xl shrink-0 mt-0.5">
                                                    {TYPE_ICON[cleanType] ?? "🔔"}
                                                </span>
                                                <div className="flex-1 min-w-0">
                                                    <div className="flex items-center justify-between gap-2 mb-1">
                                                        <p className={`text-sm font-semibold ${n.isRead ? "text-[#A9A9A9]" : "text-[#0A1931]"}`}>
                                                            {n.title}
                                                        </p>
                                                        <time className="text-[#A0AEC0] text-[11px] shrink-0">
                                                            {new Date(n.createdAt).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}
                                                        </time>
                                                    </div>
                                                    <p className="text-[#A9A9A9] text-xs leading-relaxed">{n.body}</p>
                                                </div>
                                                {!n.isRead && (
                                                    <div className="w-2 h-2 rounded-full bg-[#1B3B6F] shrink-0 mt-1.5 shadow-[0_0_6px_rgba(139,92,246,0.8)]" />
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
        </>
    );
}

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
