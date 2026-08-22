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
import { Bell, ShieldAlert } from "lucide-react";
import { notificationApi, api } from "@/lib/api";
import NotificationsModal from "@/components/NotificationsModal";
import { initSecurityKiosk } from "@/lib/security/antiDebug";

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
    const { user, isLoading, token, currentTenantId: tenantId } = useAuth();
    const router = useRouter();
    const pathname = usePathname();
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);
    const [unreadCount, setUnreadCount] = useState(0);
    const [showNotifications, setShowNotifications] = useState(false);
    const { showToast } = useToast();
    const [securityViolation, setSecurityViolation] = useState(false);

    useEffect(() => {
        if (!token || !tenantId) return;
        notificationApi.unreadCount(token, tenantId)
            .then(setUnreadCount)
            .catch(() => {});
    }, [token, tenantId]);

    // Sync isSidebarCollapsed with localStorage globally
    useEffect(() => {
        const stored = localStorage.getItem("sidebar-collapsed");
        if (stored === "true") {
            setIsSidebarCollapsed(true);
        }
    }, []);

    const setCollapsedState = (collapsed: boolean) => {
        setIsSidebarCollapsed(collapsed);
        localStorage.setItem("sidebar-collapsed", String(collapsed));
    };

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
                    } else if (window.location.hostname.endsWith("4takademi.com") || window.location.hostname.startsWith("3u.")) {
                        window.location.href = `https://3u-ad.muro.click/dashboard?_token=${encodeURIComponent(t || "")}&_refresh=${encodeURIComponent(r || "")}`;
                    } else if (!window.location.hostname.endsWith("muro.click")) {
                        // Custom / Single-domain setup -> redirect to local subpath
                        window.location.href = `/admin/dashboard?_token=${encodeURIComponent(t || "")}&_refresh=${encodeURIComponent(r || "")}`;
                    } else {
                        // Subdomain architecture for demo and other tenants
                        const currentHost = window.location.hostname;
                        let adminHost = currentHost;
                        if (currentHost.split('.').length > 2) {
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
        if (user && user.role?.toLowerCase() === "student" && token && tenantId) {
            let hasLogged = false;
            const cleanup = initSecurityKiosk(() => {
                setSecurityViolation(true);
                if (!hasLogged) {
                    hasLogged = true;
                    api("/student/security-event", {
                        method: "POST",
                        token,
                        tenantId,
                        body: JSON.stringify({
                            eventType: "DEVTOOLS_DETECTED",
                            details: `Geliştirici araçları (DevTools) açma girişimi tespit edildi. Sayfa: ${window.location.pathname}`
                        })
                    }).catch(err => console.error("Failed to log security event", err));
                }
            });
            return cleanup;
        }
    }, [user, token, tenantId]);

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
                <Sidebar 
                    isOpen={sidebarOpen} 
                    onClose={() => setSidebarOpen(false)}
                    isCollapsed={isSidebarCollapsed}
                    onToggleCollapse={() => setCollapsedState(!isSidebarCollapsed)}
                />
            </div>

            <main className={`main-content transition-all duration-300 ${isSidebarCollapsed ? 'md:ml-[76px]' : 'md:ml-[260px]'}`} key={pathname}>
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

            {/* DevTools Security Violation Screen */}
            {securityViolation && (
                <div className="fixed inset-0 bg-red-950/95 flex items-center justify-center z-[9999] backdrop-blur-sm">
                    <div className="text-center bg-black/60 p-10 rounded-3xl border border-red-500/30 max-w-md mx-4 animate-in fade-in-50 zoom-in-95 duration-200">
                        <ShieldAlert size={64} className="text-red-500 mx-auto mb-4" />
                        <h2 className="text-2xl font-bold text-white mb-2">Güvenlik İhlali</h2>
                        <p className="text-red-200 text-sm leading-relaxed">
                            Sistem kaynaklarını izinsiz kopyalama veya izleme girişimi tespit edildi. <br/><br/>
                            Geliştirici araçlarını (DevTools) kapatıp sayfayı yenileyin.
                        </p>
                    </div>
                </div>
            )}
        </div>
    );
}

