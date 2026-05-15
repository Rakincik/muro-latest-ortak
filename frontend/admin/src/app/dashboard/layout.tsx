"use client";

import { useAuth } from "@/contexts/AuthContext";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useCallback } from "react";
import Sidebar from "@/components/Sidebar";
import { ErrorBoundary } from "@/components/ErrorBoundary";
import { useAdminHub } from "@/hooks/useAdminHub";
import { useToast } from "@/components/toast";

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
    const { user, isLoading } = useAuth();
    const router = useRouter();
    const { toast } = useToast();

    // ── Real-time SignalR notifications (global) ──
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
        onDashboardUpdate: useCallback(() => {
            // Dashboard istatistikleri güncellendi — sessiz (page kendisi handle eder)
        }, []),
    });

    const pathname = usePathname();

    useEffect(() => {
        if (!isLoading && !user) {
            router.push("/");
            return;
        }

        if (user && pathname) {
            if (!checkAccess(pathname, user.role)) {
                toast("error", "Erişim Reddedildi", "Bu sayfayı görüntüleme yetkiniz yok.");
                router.push("/dashboard");
            }
        }
    }, [user, isLoading, router, pathname, toast]);

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
        <div className="flex min-h-screen">
            <Sidebar />
            <main className="flex-1 ml-[260px] p-8">
                <ErrorBoundary pageName="Dashboard">
                    {children}
                </ErrorBoundary>
            </main>
        </div>
    );
}

