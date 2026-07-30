"use client";

import { useAuth } from "@/contexts/AuthContext";
import { usePathname, useRouter } from "next/navigation";
import { useState, useEffect, useCallback } from "react";
import { Menu } from "lucide-react";
import Sidebar from "@/components/Sidebar";
import MobileTabBar from "@/components/MobileTabBar";
import { ErrorBoundary } from "@/components/ErrorBoundary";
import { useAdminHub } from "@/hooks/useAdminHub";
import { useToast } from "@/components/toast";
import { GlobalUploadProvider } from "@/components/ui/GlobalUploadManager";
import NotificationBell from "@/components/NotificationBell";
import { Tooltip } from "@/components/ui/Tooltip";
import { tenantApi, type TenantBrandingDto } from "@/lib/api";

const routeRoles: Record<string, string[]> = {
    "/dashboard/users": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/groups": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/packages": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/courses": ["Admin", "SuperAdmin", "Assistant", "Instructor"],
    "/dashboard/exams": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/calendar": ["Admin", "SuperAdmin", "Assistant", "Instructor"],
    "/dashboard/assignments": ["Admin", "SuperAdmin", "Assistant", "Instructor"],
    "/dashboard/notifications": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/questions": ["Admin", "SuperAdmin", "Assistant", "Instructor"],
    "/dashboard/support": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/podcasts": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/analytics": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/exam-results": ["Admin", "SuperAdmin", "Assistant", "Instructor"],
    "/dashboard/student-scorecard": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/course-attendance": ["Admin", "SuperAdmin", "Assistant"],
    "/dashboard/accounting": ["Admin", "SuperAdmin", "Assistant", "Accountant"],
    "/dashboard/audit-trail": ["Admin", "SuperAdmin"],
};

function checkAccess(pathname: string, userRole: string): boolean {
    if (pathname === "/dashboard") return true;
    for (const [route, allowedRoles] of Object.entries(routeRoles)) {
        if (pathname.startsWith(route)) {
            return allowedRoles.includes(userRole);
        }
    }
    return true; 
}

export default function DashboardLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    const { user, isLoading, currentTenantId } = useAuth();
    const router = useRouter();
    const { toast } = useToast();
    const [isSidebarOpen, setIsSidebarOpen] = useState(false);
    const [isSidebarCollapsed, setIsSidebarCollapsed] = useState(false);
    const pathname = usePathname();
    const currentTenant = user?.tenants?.find(t => t.tenantId === currentTenantId);

    const [branding, setBranding] = useState<TenantBrandingDto | null>(null);

    useEffect(() => {
        tenantApi.getBranding(currentTenantId ?? undefined)
            .then(setBranding)
            .catch(() => { /* use defaults */ });
    }, [currentTenantId]);

    // Sync isSidebarCollapsed with localStorage globally
    useEffect(() => {
        const stored = localStorage.getItem("sidebar-collapsed");
        if (stored === "true") {
            setIsSidebarCollapsed(true);
        }
    }, [pathname]);

    const setCollapsedState = (collapsed: boolean) => {
        setIsSidebarCollapsed(collapsed);
        localStorage.setItem("sidebar-collapsed", String(collapsed));
    };

    useAdminHub({
        onLiveSessionUpdate: useCallback((session: Record<string, unknown>) => {
            const title = (session.title || session.sessionTitle || "Canlı Ders") as string;
            const status = (session.status || "") as string;
            if (status === "Live" || status === "Started") {
                toast("success", "🔴 Canlı Ders Başladı", title);
            } else if (status === "Ended") {
                toast("info", "Canlı Ders Bitti", title);
            }
        }, [toast]),
        onDashboardUpdate: useCallback(() => {}, []),
    });

    // Close sidebar on route change on mobile
    useEffect(() => {
        setIsSidebarOpen(false);
    }, [pathname]);

    useEffect(() => {
        if (!isLoading && !user) {
            router.push("/");
            return;
        }

        // Birden fazla kurumu var ama henüz kurum seçilmemiş → kurum seçim sayfasına yönlendir
        if (!isLoading && user && user.tenants.length > 1 && !currentTenantId) {
            router.replace("/select-tenant");
            return;
        }

        if (user && pathname) {
            if (!checkAccess(pathname, user.role)) {
                toast("error", "Erişim Reddedildi", "Bu sayfayı görüntüleme yetkiniz yok.");
                router.push("/dashboard");
            }
        }
    }, [user, isLoading, router, pathname, toast, currentTenantId]);

    if (isLoading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-[#E2E8F0]/20">
                <div className="flex flex-col items-center gap-4">
                    <div className="w-10 h-10 border-4 border-[#1B3B6F] border-t-transparent rounded-full animate-spin" />
                    <p className="text-[#A9A9A9] text-sm">Yükleniyor...</p>
                </div>
            </div>
        );
    }

    if (!user) return null;

    return (
        <GlobalUploadProvider>
            <div className="flex min-h-screen bg-[#F8FAFC]">
                <Sidebar 
                    isOpen={isSidebarOpen} 
                    onClose={() => setIsSidebarOpen(false)} 
                    isCollapsed={isSidebarCollapsed}
                    onToggleCollapse={() => setCollapsedState(!isSidebarCollapsed)}
                />

                <div className={`flex-1 flex flex-col min-w-0 transition-all duration-300 ${isSidebarCollapsed ? 'lg:ml-[76px]' : 'lg:ml-[260px]'}`}>
                    {/* Mobile Header */}
                    <header className="lg:hidden flex items-center justify-between px-4 py-3 bg-white border-b border-[#E2E8F0] sticky top-0 z-30 shadow-sm">
                        <div className="flex items-center gap-3">
                            {branding?.logoUrl || branding?.sidebarLogoUrl ? (
                                <img 
                                    src={branding.logoUrl || branding.sidebarLogoUrl} 
                                    alt={currentTenant?.tenantName || "Yönetim Paneli"} 
                                    className="max-h-8 w-auto object-contain pl-1" 
                                />
                            ) : (
                                <h1 className="text-lg font-bold text-[#1B3B6F] tracking-tight pl-1">
                                    {currentTenant?.tenantName || "Yönetim Paneli"}
                                </h1>
                            )}
                        </div>
                        <NotificationBell />
                    </header>

                    <main className="flex-1 p-4 pb-24 lg:p-8 lg:pb-8 overflow-x-hidden">
                        <ErrorBoundary pageName="Dashboard">
                            {children}
                        </ErrorBoundary>
                    </main>
                </div>
            </div>
            {/* Mobile Bottom Tab Bar */}
            <MobileTabBar />
        </GlobalUploadProvider>
    );
}
