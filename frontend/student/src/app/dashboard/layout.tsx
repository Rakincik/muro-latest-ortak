"use client";

import { useAuth } from "@/contexts/AuthContext";
import { useRouter, usePathname } from "next/navigation";
import { useEffect, useState, useCallback } from "react";
import Sidebar from "@/components/Sidebar";
import MobileTabBar from "@/components/MobileTabBar";
import PullToRefresh from "@/components/PullToRefresh";
import { ErrorBoundary } from "@/components/ErrorBoundary";
import { useCapacitorPush } from "@/hooks/useCapacitorPush";
import { useDeepLink } from "@/hooks/useDeepLink";
import { useStudentHub } from "@/hooks/useStudentHub";
import { useToast } from "@/components/ToastProvider";
import { Bell } from "lucide-react";
import { notificationApi } from "@/lib/api";
import NotificationsModal from "@/components/NotificationsModal";

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
    const { user, isLoading, token, currentTenantId: tenantId } = useAuth();
    const router = useRouter();
    const pathname = usePathname();
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [unreadCount, setUnreadCount] = useState(0);
    const [showNotifications, setShowNotifications] = useState(false);
    const { showToast } = useToast();

    useEffect(() => {
        if (!token || !tenantId) return;
        notificationApi.unreadCount(token, tenantId)
            .then(setUnreadCount)
            .catch(() => {});
    }, [token, tenantId]);

    const getPageTitle = (path: string) => {
        if (!path) return "ÖĞRENCİ PORTALI";
        if (path === "/dashboard") return "ANA SAYFA";
        if (path.startsWith("/dashboard/courses")) {
            if (path.includes("/watch/")) return "DERS İZLE";
            return "DERSLERİM";
        }
        if (path.startsWith("/dashboard/live")) return "CANLI DERSLER";
        if (path.startsWith("/dashboard/calendar")) return "TAKVİM";
        if (path.startsWith("/dashboard/assignments")) return "ÖDEVLERİM";
        if (path.startsWith("/dashboard/exams")) return "SINAVLARIM";
        if (path.startsWith("/dashboard/notes")) return "NOTLARIM";
        if (path.startsWith("/dashboard/attendance")) return "DEVAM TAKİBİM";
        if (path.startsWith("/dashboard/podcast")) return "PODCAST";
        if (path.startsWith("/dashboard/questions")) return "SORU SOR";
        if (path.startsWith("/dashboard/support")) return "TEKNİK DESTEK";
        if (path.startsWith("/dashboard/profile")) return "PROFİL";
        if (path.startsWith("/dashboard/notifications")) return "BİLDİRİMLER";
        return "ÖĞRENCİ PORTALI";
    };

    // Initialize push notifications on native platforms
    useCapacitorPush();

    // Initialize deep linking + Android back button handling
    useDeepLink();

    // ── Real-time SignalR notifications ──
    useStudentHub({
        onLiveSessionStarted: useCallback((data: { sessionTitle: string; courseTitle: string; courseId: string; sessionId: string }) => {
            showToast(`${data.courseTitle} — ${data.sessionTitle}`, "success", "🔴 Canlı Ders Başladı!");
        }, [showToast]),
        onLiveSessionEnded: useCallback((data: { sessionTitle: string }) => {
            showToast(`${data.sessionTitle} sona erdi.`, "info", "Canlı Ders Bitti");
        }, [showToast]),
        onNewNotification: useCallback((data: { title: string; body: string }) => {
            showToast(data.body, "info", data.title);
        }, [showToast]),
    });

    useEffect(() => {
        if (!isLoading) {
            if (!user) {
                router.push("/");
            } else {
                const role = user.role?.toLowerCase();
                if (role === "admin" || role === "superadmin" || role === "teacher" || role === "instructor" || role === "assistant" || role === "accountant") {
                    const t = localStorage.getItem("muro_student_token");
                    const r = localStorage.getItem("muro_student_refresh");
                    if (t) localStorage.setItem("muro_token", t);
                    if (r) localStorage.setItem("muro_refresh", r);

                    const isDev = window.location.hostname === "localhost";
                    if (isDev) {
                        window.location.href = `http://localhost:3001/admin/dashboard?_token=${encodeURIComponent(t || "")}&_refresh=${encodeURIComponent(r || "")}`;
                    } else {
                        const currentHost = window.location.hostname;
                        let adminHost = currentHost;
                        if (currentHost.startsWith("3u.")) {
                          adminHost = currentHost.replace("3u.", "3u-ad.");
                        } else if (currentHost.split('.').length > 2) {
                           const parts = currentHost.split('.');
                           parts[0] = parts[0] + '-adm';
                           adminHost = parts.join('.');
                        } else {
                           adminHost = "admin." + currentHost;
                        }
                        window.location.href = `https://${adminHost}/dashboard`;
                    }
                }
            }
        }
    }, [user, isLoading, router]);

    // Anti-DevTools Koruması (Sadece Öğrenci Paneli için)
    useEffect(() => {
        // Eğer kullanıcı öğrenci ise ve sayfaya eriştiginde çalışır
        if (user && user.role?.toLowerCase() === "student") {
            const handleContextMenu = (e: MouseEvent) => {
                e.preventDefault();
            };

            const handleKeyDown = (e: KeyboardEvent) => {
                // F12 tuşu
                if (e.key === "F12") {
                    e.preventDefault();
                }
                // Ctrl+Shift+I (Windows) veya Cmd+Option+I (Mac)
                if ((e.ctrlKey && e.shiftKey && e.key.toLowerCase() === "i") || 
                    (e.metaKey && e.altKey && e.key.toLowerCase() === "i")) {
                    e.preventDefault();
                }
                // Ctrl+Shift+J (Windows) veya Cmd+Option+J (Mac)
                if ((e.ctrlKey && e.shiftKey && e.key.toLowerCase() === "j") || 
                    (e.metaKey && e.altKey && e.key.toLowerCase() === "j")) {
                    e.preventDefault();
                }
                // Ctrl+Shift+C (Windows) veya Cmd+Option+C (Mac) - Inspector
                if ((e.ctrlKey && e.shiftKey && e.key.toLowerCase() === "c") || 
                    (e.metaKey && e.altKey && e.key.toLowerCase() === "c")) {
                    e.preventDefault();
                }
                // Ctrl+U (Windows) veya Cmd+Option+U (Mac) - Kaynak Kodu
                if ((e.ctrlKey && e.key.toLowerCase() === "u") || 
                    (e.metaKey && e.altKey && e.key.toLowerCase() === "u")) {
                    e.preventDefault();
                }
            };

            document.addEventListener("contextmenu", handleContextMenu);
            document.addEventListener("keydown", handleKeyDown);

            return () => {
                document.removeEventListener("contextmenu", handleContextMenu);
                document.removeEventListener("keydown", handleKeyDown);
            };
        }
    }, [user]);

    // Sayfa değiştiğinde sidebar'ı kapat (mobil)
    useEffect(() => {
        setSidebarOpen(false);
    }, [pathname]);

    if (isLoading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-[#f8fafc]">
                <div className="flex flex-col items-center gap-3">
                    <div className="w-10 h-10 border-2 border-[#1B3B6F] border-t-transparent rounded-full animate-spin" />
                    <p className="text-[#A9A9A9] text-sm">Yükleniyor...</p>
                </div>
            </div>
        );
    }

    if (!user) return null;

    const role = user.role?.toLowerCase();
    if (role === "admin" || role === "superadmin" || role === "teacher" || role === "instructor" || role === "assistant" || role === "accountant") {
        return null; // Yönlendirme bekleniyor...
    }

    return (
        <div className="min-h-screen bg-[#f8fafc]">
            {/* Mobile Header Bar */}
            <header className="mobile-header md:hidden">
                <button
                    onClick={() => setSidebarOpen(true)}
                    className="w-10 h-10 rounded-xl bg-white border border-[#E2E8F0] flex items-center justify-center text-[#0A1931] shadow-sm active:scale-95 transition-all"
                >
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} className="w-5 h-5">
                        <path strokeLinecap="round" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                </button>
                
                <h1 className="text-sm font-bold text-[#0A1931] tracking-wider truncate max-w-[60%]">
                    {getPageTitle(pathname)}
                </h1>
                
                <button
                    onClick={() => setShowNotifications(true)}
                    className="relative w-10 h-10 rounded-xl bg-white border border-[#E2E8F0] flex items-center justify-center text-[#A0AEC0] active:scale-95 transition-all"
                    title="Bildirimler"
                >
                    <Bell size={18} className="text-[#0A1931]" />
                    {unreadCount > 0 && (
                        <span className="absolute top-2 right-2 w-2.5 h-2.5 bg-red-500 rounded-full border border-white shadow-[0_0_8px_rgba(239,68,68,0.6)] animate-pulse" />
                    )}
                </button>
            </header>

            {/* Mobile overlay */}
            {sidebarOpen && (
                <div
                    className="md:hidden fixed inset-0 bg-black/50 z-[55] backdrop-blur-sm"
                    onClick={() => setSidebarOpen(false)}
                />
            )}

            {/* Sidebar */}
            <div className="relative z-[60]">
                <Sidebar isOpen={sidebarOpen} />
            </div>

            <main className="main-content" key={pathname}>
                <ErrorBoundary pageName="Öğrenci Paneli">
                    <PullToRefresh>
                        <div className="animate-fade-in">
                            {children}
                        </div>
                    </PullToRefresh>
                </ErrorBoundary>
            </main>

            {/* Mobile bottom tab bar */}
            <MobileTabBar />

            {/* Notifications Modal */}
            {showNotifications && (
                <NotificationsModal 
                    onClose={() => setShowNotifications(false)} 
                    onUnreadCountUpdate={setUnreadCount}
                />
            )}
        </div>
    );
}

