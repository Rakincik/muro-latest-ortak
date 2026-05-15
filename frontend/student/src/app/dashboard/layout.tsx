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

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
    const { user, isLoading } = useAuth();
    const router = useRouter();
    const pathname = usePathname();
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const { showToast } = useToast();

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
                        window.location.href = "/admin/dashboard";
                    }
                }
            }
        }
    }, [user, isLoading, router]);

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
            {/* Mobile hamburger button */}
            <button
                onClick={() => setSidebarOpen(true)}
                className="md:hidden fixed top-4 left-4 z-[60] w-10 h-10 rounded-xl bg-[#0A1931] border border-[#1B3B6F]/30 flex items-center justify-center shadow-lg"
                style={{
                    display: sidebarOpen ? 'none' : undefined,
                    top: 'calc(16px + env(safe-area-inset-top, 0px))',
                }}
            >
                <svg viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth={2} className="w-5 h-5">
                    <path strokeLinecap="round" d="M4 6h16M4 12h16M4 18h16" />
                </svg>
            </button>

            {/* Mobile overlay */}
            {sidebarOpen && (
                <div
                    className="md:hidden fixed inset-0 bg-black/50 z-[55] backdrop-blur-sm"
                    onClick={() => setSidebarOpen(false)}
                />
            )}

            {/* Sidebar with mobile open class */}
            <div className={sidebarOpen ? '[&>.sidebar]:translate-x-0' : ''}>
                <Sidebar />
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
        </div>
    );
}

