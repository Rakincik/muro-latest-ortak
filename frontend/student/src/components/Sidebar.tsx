"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import { useEffect, useState } from "react";
import { notificationApi, tenantApi, type UserTenantDto, type TenantBrandingDto } from "@/lib/api";
import NotificationsModal from "./NotificationsModal";

const navItems = [
    {
        href: "/dashboard",
        label: "Ana Sayfa",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="m3 12 2-2m0 0 7-7 7 7M5 10v10a1 1 0 0 0 1 1h3m10-11 2 2m-2-2v10a1 1 0 0 1-1 1h-3m-6 0a1 1 0 0 0 1-1v-4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v4a1 1 0 0 0 1 1m-6 0h6" />
            </svg>
        ),
    },
    {
        href: "/dashboard/courses",
        label: "Derslerim",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 6.042A8.967 8.967 0 0 0 6 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 0 1 6 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 0 1 6-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0 0 18 18a8.967 8.967 0 0 0-6 2.292m0-14.25v14.25" />
            </svg>
        ),
    },
    {
        href: "/dashboard/live",
        label: "Canlı Dersler",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="m15.75 10.5 4.72-4.72a.75.75 0 0 1 1.28.53v11.38a.75.75 0 0 1-1.28.53l-4.72-4.72M4.5 18.75h9a2.25 2.25 0 0 0 2.25-2.25v-9a2.25 2.25 0 0 0-2.25-2.25h-9A2.25 2.25 0 0 0 2.25 7.5v9a2.25 2.25 0 0 0 2.25 2.25Z" />
            </svg>
        ),
        liveIndicator: true,
    },
    {
        href: "/dashboard/calendar",
        label: "Takvim",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z" />
            </svg>
        ),
    },
    {
        href: "/dashboard/assignments",
        label: "Ödevlerim",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25ZM6.75 12h.008v.008H6.75V12Zm0 3h.008v.008H6.75V15Zm0 3h.008v.008H6.75V18Z" />
            </svg>
        ),
    },
    {
        href: "/dashboard/exams",
        label: "Sınavlarım",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 0 1 3 19.875v-6.75ZM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V8.625ZM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 0 1-1.125-1.125V4.125Z" />
            </svg>
        ),
    },
    {
        href: "/dashboard/notes",
        label: "Notlarım",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10" />
            </svg>
        ),
    },
    {
        href: "/dashboard/attendance",
        label: "Devam Takibim",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" />
            </svg>
        ),
    },
    {
        href: "/dashboard/podcast",
        label: "Podcast",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 18.75a6 6 0 0 0 6-6v-1.5m-6 7.5a6 6 0 0 1-6-6v-1.5m6 7.5v3.75m-3.75 0h7.5M12 15.75a3 3 0 0 1-3-3V4.5a3 3 0 1 1 6 0v8.25a3 3 0 0 1-3 3Z" />
            </svg>
        ),
    },
    {
        href: "/dashboard/questions",
        label: "Soru Sor",
        icon: (
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.879 7.519c1.171-1.025 3.071-1.025 4.242 0 1.172 1.025 1.172 2.687 0 3.712-.203.179-.43.326-.67.442-.745.361-1.45.999-1.45 1.827v.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Zm-9 5.25h.008v.008H12v-.008Z" />
            </svg>
        ),
    },
];


export default function Sidebar() {
    const pathname = usePathname();
    const router = useRouter();
    const { user, logout, token, currentTenantId } = useAuth();
    const [unreadCount, setUnreadCount] = useState(0);
    const [branding, setBranding] = useState<TenantBrandingDto | null>(null);
    const [showNotifications, setShowNotifications] = useState(false);

    useEffect(() => {
        if (!token || !currentTenantId) return;
        notificationApi.unreadCount(token, currentTenantId)
            .then(setUnreadCount)
            .catch(() => { });
    }, [token, currentTenantId]);

    useEffect(() => {
        tenantApi.getBranding(currentTenantId ?? undefined)
            .then(setBranding)
            .catch(() => { });
    }, [currentTenantId]);

    const brandName = branding?.name || "MURO";
    const brandInitial = brandName.charAt(0).toUpperCase();
    const primaryColor = branding?.primaryColor || "#1B3B6F";

    const tenantName = user?.tenants?.find((t: UserTenantDto) => t.tenantId === currentTenantId)?.tenantName
        || user?.tenants?.[0]?.tenantName
        || "Öğrenci Portalı";

    const initials = `${user?.firstName?.[0] ?? ""}${user?.lastName?.[0] ?? ""}`.toUpperCase();

    const handleLogout = () => {
        logout();
        router.push("/");
    };

    return (
        <aside className="sidebar">
            {/* Logo + Tenant + Bell */}
            <div className="p-5 border-b border-[#1B3B6F]/20 flex items-center gap-3">
                {branding?.logoUrl ? (
                    <img src={branding.logoUrl} alt={brandName} className="w-9 h-9 rounded-xl object-cover shadow-lg shadow-[#0A1931]/40 flex-shrink-0" />
                ) : (
                    <div className="w-9 h-9 rounded-xl flex items-center justify-center text-white font-black text-sm shadow-lg shadow-[#0A1931]/40 flex-shrink-0"
                        style={{ backgroundColor: primaryColor }}>
                        {brandInitial}
                    </div>
                )}
                <div className="flex-1 min-w-0 pr-1">
                    <p className="text-white font-semibold text-sm leading-tight truncate">{brandName}</p>
                    <p className="text-[#A9A9A9] text-xs truncate">{tenantName}</p>
                </div>
                <button
                    onClick={() => setShowNotifications(true)}
                    className="relative p-2 text-[#A9A9A9] hover:text-white hover:bg-[#1B3B6F]/20 rounded-xl transition-all flex-shrink-0"
                >
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-5 h-5">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
                    </svg>
                    {unreadCount > 0 && (
                        <span className="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-[#0A1931]" />
                    )}
                </button>
            </div>

            {/* Nav */}
            <nav className="flex-1 p-3 space-y-0.5 mt-1 overflow-y-auto">
                {navItems.map((item) => {
                    const isActive = item.href === "/dashboard"
                        ? pathname === "/dashboard"
                        : pathname.startsWith(item.href);
                    return (
                        <Link
                            key={item.href}
                            href={item.href}
                            prefetch={false}
                            className={`nav-item relative ${isActive ? "active" : ""}`}
                        >
                            <span className={`flex-shrink-0 ${isActive ? "text-[#A0AEC0]" : "text-[#A9A9A9]"}`}>
                                {item.icon}
                            </span>
                            <span className="flex-1">{item.label}</span>
                            {item.liveIndicator && (
                                <span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse flex-shrink-0" />
                            )}
                            {isActive && (
                                <span className="absolute right-0 top-1/2 -translate-y-1/2 w-0.5 h-5 bg-[#A9A9A9] rounded-l-full" />
                            )}
                        </Link>
                    );
                })}

                {/* Bildirimler — unread badge */}
                <button
                    onClick={() => setShowNotifications(true)}
                    className={`w-full text-left nav-item relative ${showNotifications ? "active" : ""}`}
                >
                    <span className={`flex-shrink-0 ${showNotifications ? "text-[#A0AEC0]" : "text-[#A9A9A9]"}`}>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5">
                            <path strokeLinecap="round" strokeLinejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
                        </svg>
                    </span>
                    <span className="flex-1">Bildirimler</span>
                    {unreadCount > 0 && (
                        <span className="px-1.5 py-0.5 bg-[#1B3B6F] text-white text-xs rounded-full font-medium min-w-[18px] text-center flex-shrink-0 shadow-sm">
                            {unreadCount > 9 ? "9+" : unreadCount}
                        </span>
                    )}
                    {showNotifications && (
                        <span className="absolute right-0 top-1/2 -translate-y-1/2 w-0.5 h-5 bg-[#A9A9A9] rounded-l-full" />
                    )}
                </button>
            </nav>

            {/* User footer */}
            <div className="p-4 border-t border-[#1B3B6F]/20">
                {/* Profil linki */}
                <Link
                    href="/dashboard/profile"
                    className={`flex items-center gap-3 px-3 py-2.5 rounded-xl border mb-2 transition-all ${pathname === "/dashboard/profile"
                        ? "bg-[#1B3B6F]/20 border-[#1B3B6F]/40"
                        : "bg-[#1B3B6F]/8 border-[#1B3B6F]/15 hover:bg-[#1B3B6F]/15 hover:border-[#1B3B6F]/25"
                        }`}
                >
                    <div className="relative flex-shrink-0">
                        <div className="w-8 h-8 rounded-full bg-[#1B3B6F] flex items-center justify-center text-white text-xs font-bold ring-2 ring-[#A0AEC0]/30 ring-offset-1 ring-offset-[#0A1931]">
                            {initials || "?"}
                        </div>
                        <span className="absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 bg-green-400 rounded-full border-2 border-[#0A1931]" />
                    </div>
                    <div className="flex-1 min-w-0">
                        <p className="text-white text-xs font-semibold truncate">{user?.firstName} {user?.lastName}</p>
                        <p className="text-[#A9A9A9] text-xs truncate">{user?.email}</p>
                    </div>
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-3.5 h-3.5 text-[#A9A9A9] flex-shrink-0">
                        <path strokeLinecap="round" strokeLinejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
                    </svg>
                </Link>
                <button
                    onClick={handleLogout}
                    className="w-full text-left nav-item text-[#A9A9A9] hover:text-red-400 hover:bg-red-500/8 group"
                >
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={1.8} className="w-4.5 h-4.5 flex-shrink-0 group-hover:text-red-400">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0 0 13.5 3h-6a2.25 2.25 0 0 0-2.25 2.25v13.5A2.25 2.25 0 0 0 7.5 21h6a2.25 2.25 0 0 0 2.25-2.25V15m3 0 3-3m0 0-3-3m3 3H9" />
                    </svg>
                    <span>Çıkış Yap</span>
                </button>
            </div>

            {showNotifications && (
                <NotificationsModal 
                    onClose={() => setShowNotifications(false)} 
                    onUnreadCountUpdate={setUnreadCount}
                />
            )}
        </aside>
    );
}
