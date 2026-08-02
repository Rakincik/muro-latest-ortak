"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import { useEffect, useState } from "react";
import { notificationApi, tenantApi, type UserTenantDto, type TenantBrandingDto } from "@/lib/api";
import NotificationsModal from "./NotificationsModal";
import { Tooltip } from "@/components/ui/Tooltip";
import {
    LayoutDashboard, BookOpen, Radio, CalendarDays,
    ClipboardList, FileText, BookMarked, CalendarCheck,
    Mic2, MessageCircleQuestion, Bell, LogOut, ChevronDown, ChevronRight, Headset, X
} from "lucide-react";

const sections = [
    {
        title: "ÖĞRENİM",
        items: [
            { href: "/dashboard", label: "Ana Sayfa", icon: LayoutDashboard },
            { href: "/dashboard/courses", label: "Derslerim", icon: BookOpen },
            { href: "/dashboard/live", label: "Canlı Dersler", icon: Radio, liveIndicator: true },
            { href: "/dashboard/calendar", label: "Takvim", icon: CalendarDays, featureKey: "calendar" },
        ]
    },
    {
        title: "AKADEMİK",
        items: [
            { href: "/dashboard/assignments", label: "Ödevlerim", icon: ClipboardList, featureKey: "assignments" },
            { href: "/dashboard/exams", label: "Sınavlarım", icon: FileText, featureKey: "exams" },
            { href: "/dashboard/notes", label: "Notlarım", icon: BookMarked },
            { href: "/dashboard/attendance", label: "Devam Takibim", icon: CalendarCheck, featureKey: "attendance" },
        ]
    },
    {
        title: "İLETİŞİM & EKSTRA",
        items: [
            { href: "/dashboard/podcast", label: "Podcast", icon: Mic2, featureKey: "podcast" },
            { href: "/dashboard/questions", label: "Soru Sor", icon: MessageCircleQuestion, featureKey: "questions" },
            { href: "/dashboard/support", label: "Teknik Destek", icon: Headset, featureKey: "support" },
        ]
    }
];

export default function Sidebar({ 
    isOpen, 
    onClose, 
    isCollapsed = false, 
    onToggleCollapse 
}: { 
    isOpen?: boolean; 
    onClose?: () => void; 
    isCollapsed?: boolean; 
    onToggleCollapse?: () => void; 
}) {
    const pathname = usePathname();
    const router = useRouter();
    const { user, logout, token, currentTenantId } = useAuth();
    const [unreadCount, setUnreadCount] = useState(0);
    const [branding, setBranding] = useState<TenantBrandingDto | null>(null);
    const [showNotifications, setShowNotifications] = useState(false);
    const [expandedSections, setExpandedSections] = useState<Record<string, boolean>>({});

    const toggleSection = (title: string) => {
        setExpandedSections(prev => ({ ...prev, [title]: prev[title] === undefined ? false : !prev[title] }));
    };

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
    const primaryColor = branding?.primaryColor || "#0A1931";
    const accentColor = branding?.accentColor || "#1B3B6F";

    const currentTenant = user?.tenants?.find((t: UserTenantDto) => t.tenantId === currentTenantId);
    let featuresDict: Record<string, boolean> = {};
    if (branding?.featuresJson) {
        try {
            featuresDict = JSON.parse(branding.featuresJson);
        } catch { }
    } else if (currentTenant?.features) {
        try {
            featuresDict = JSON.parse(currentTenant.features);
        } catch { }
    }

    const handleLogout = () => {
        logout();
        window.location.href = "/?action=logout";
    };

    return (
        <>
        {/* Mobile Overlay */}
        {isOpen && (
            <div 
                className="fixed inset-0 bg-black/50 z-[55] md:hidden backdrop-blur-sm"
                onClick={onClose}
            />
        )}
        <aside 
            className={`sidebar flex flex-col h-screen fixed left-0 top-0 z-[60] border-r border-[#1B3B6F]/20 transition-all duration-300 ${
                isOpen 
                    ? "w-[280px] translate-x-0" 
                    : "-translate-x-full md:translate-x-0"
            } ${
                isCollapsed 
                    ? "md:w-[76px]" 
                    : "md:w-[260px]"
            }`}
            style={{ backgroundColor: primaryColor }}
        >
            {/* Logo + Notifications/Collapse */}
            <div className={`px-4 py-7 flex ${isCollapsed ? 'flex-col items-center gap-4' : 'items-center justify-between px-6'} relative transition-all duration-300`}>
                {isCollapsed ? (
                    branding?.faviconUrl ? (
                        <img 
                            src={branding.faviconUrl} 
                            alt={brandName} 
                            className="w-10 h-10 object-contain rounded-xl shadow-lg border border-white/15 shrink-0 cursor-pointer hover:scale-110 active:scale-95 transition-all duration-200"
                            onClick={onToggleCollapse}
                            title={brandName}
                        />
                    ) : (
                        <div 
                            style={{ backgroundColor: accentColor }} 
                            className="w-10 h-10 rounded-xl flex items-center justify-center text-white text-base font-extrabold shadow-lg border border-white/15 shrink-0 cursor-pointer hover:scale-110 active:scale-95 transition-all duration-200"
                            onClick={onToggleCollapse}
                            title={brandName}
                        >
                            {brandInitial}
                        </div>
                    )
                ) : (
                    branding?.useWhiteLogoBackground ? (
                        <div className="bg-white/95 backdrop-blur-sm px-4 py-2 rounded-xl shadow-sm border border-white/20 flex items-center justify-center shrink-0">
                            <img 
                                src={branding?.sidebarLogoUrl || branding?.logoUrl || "/logo.png"} 
                                alt={brandName} 
                                className="w-32 max-h-10 h-auto object-contain" 
                            />
                        </div>
                    ) : (
                        <img 
                            src={branding?.sidebarLogoUrl || branding?.logoUrl || "/logo.png"} 
                            alt={brandName} 
                            className="w-36 h-auto object-contain drop-shadow-md" 
                        />
                    )
                )}

                {!isCollapsed && (
                    <div className="hidden md:flex items-center gap-1.5">
                        <button
                            onClick={() => setShowNotifications(true)}
                            className="relative p-2 text-[#A0AEC0] hover:text-white hover:bg-[#1B3B6F]/30 rounded-xl transition-all"
                            title="Bildirimler"
                        >
                            <Bell size={20} />
                            {unreadCount > 0 && (
                                <span className="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full border border-[#0A1931] shadow-[0_0_8px_rgba(239,68,68,0.6)] animate-pulse" />
                            )}
                        </button>
                        {onToggleCollapse && (
                            <Tooltip content="Menüyü Gizle" position="bottom">
                                <button
                                    onClick={onToggleCollapse}
                                    className="p-1.5 rounded-lg text-[#A9A9A9] hover:text-white hover:bg-white/10 transition-colors"
                                >
                                    <ChevronRight size={18} className="rotate-180" />
                                </button>
                            </Tooltip>
                        )}
                    </div>
                )}

                {isCollapsed && onToggleCollapse && (
                    <Tooltip content="Menüyü Genişlet" position="right">
                        <button
                            onClick={onToggleCollapse}
                            className="hidden md:flex p-1.5 rounded-lg text-[#A9A9A9] hover:text-white hover:bg-white/10 transition-colors hover:scale-110 active:scale-90 duration-200"
                        >
                            <ChevronRight size={18} />
                        </button>
                    </Tooltip>
                )}

                {onClose && (
                    <button 
                        onClick={onClose}
                        className="md:hidden p-1.5 absolute right-4 top-1/2 -translate-y-1/2 text-[#A9A9A9] hover:text-white rounded-lg hover:bg-white/10"
                    >
                        <X size={20} />
                    </button>
                )}
            </div>

            {/* Nav */}
            <nav className="flex-1 overflow-y-auto px-3 py-2 space-y-5 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
                {sections.map((section) => {
                    const filteredItems = section.items.filter(item => {
                        const hasFeature = !("featureKey" in item) || featuresDict[(item as any).featureKey] !== false;
                        const finalHasFeature = branding 
                            ? hasFeature 
                            : (currentTenant?.features ? hasFeature : true);
                        return finalHasFeature;
                    });

                    if (filteredItems.length === 0) return null;

                    return (
                        <div key={section.title}>
                            {isCollapsed ? (
                                <div className="w-8 h-px bg-white/10 mx-auto my-4 first:hidden" />
                            ) : (
                                <button 
                                    onClick={() => toggleSection(section.title)}
                                    className="w-full flex items-center justify-between px-3 mb-2 group"
                                >
                                    <p className="text-xs font-bold tracking-wider text-[#A9A9A9] uppercase group-hover:text-white transition-colors">
                                        {section.title}
                                    </p>
                                    <ChevronDown size={12} className={`text-[#A9A9A9] transition-transform duration-200 ${expandedSections[section.title] === false ? 'rotate-180' : ''}`} />
                                </button>
                            )}
                            <div className={`space-y-0.5 overflow-hidden transition-all duration-300 ${(!isCollapsed && expandedSections[section.title] === false) ? 'max-h-0 opacity-0' : 'max-h-[500px] opacity-100'}`}>
                                {filteredItems.map((item) => {
                                    const isActive = item.href === "/dashboard"
                                        ? pathname === "/dashboard"
                                        : pathname.startsWith(item.href);
                                    const Icon = item.icon;
                                    
                                    const linkContent = (
                                        <Link
                                            key={item.href}
                                            href={item.href}
                                            prefetch={false}
                                            className={`group relative flex items-center rounded-xl text-[13px] font-bold uppercase tracking-wider transition-all duration-200 ${
                                                isCollapsed ? "justify-center w-11 h-11 mx-auto hover:scale-115 active:scale-90" : "px-4 py-2.5 gap-3"
                                            } ${isActive
                                                ? "text-white shadow-lg shadow-black/20"
                                                : "text-[#A0AEC0] hover:bg-[#1B3B6F]/20 hover:text-[#E2E8F0]"
                                                }`}
                                            style={isActive ? { backgroundColor: accentColor } : undefined}
                                        >
                                            <Icon size={18} strokeWidth={isActive ? 2.5 : 1.5} className={isActive ? "text-white" : "text-[#A9A9A9] group-hover:text-[#E2E8F0]"} />
                                            {!isCollapsed && <span className="flex-1">{item.label}</span>}
                                            {item.liveIndicator && (
                                                <span className={`rounded-full bg-red-500 animate-pulse flex-shrink-0 shadow-[0_0_8px_rgba(239,68,68,0.6)] ${
                                                    isCollapsed ? "absolute top-1 right-1 w-2 h-2" : "w-1.5 h-1.5"
                                                }`} />
                                            )}
                                            {isActive && !isCollapsed && (
                                                <div className="absolute right-4 w-1.5 h-1.5 rounded-full bg-[#A9A9A9] shadow-[0_0_8px_rgba(169,169,169,0.5)]" />
                                            )}
                                            {isActive && isCollapsed && (
                                                <div className="absolute right-0.5 top-1/2 -translate-y-1/2 w-1 h-3.5 rounded-full bg-white shadow-[0_0_8px_rgba(255,255,255,0.9)] animate-pulse" />
                                            )}
                                        </Link>
                                    );

                                    if (isCollapsed) {
                                        return (
                                            <Tooltip key={item.href} content={item.label} position="right">
                                                {linkContent}
                                            </Tooltip>
                                        );
                                    }

                                    return linkContent;
                                })}
                            </div>
                        </div>
                    );
                })}

                {/* SİSTEM Area Section */}
                <div>
                    {isCollapsed ? (
                        <div className="w-8 h-px bg-white/10 mx-auto my-4" />
                    ) : (
                        <button 
                            onClick={() => toggleSection('SİSTEM')}
                            className="w-full flex items-center justify-between px-3 mb-2 group"
                        >
                            <p className="text-xs font-bold tracking-wider text-[#A9A9A9] uppercase group-hover:text-white transition-colors">
                                SİSTEM
                            </p>
                            <ChevronDown size={12} className={`text-[#A9A9A9] transition-transform duration-200 ${expandedSections['SİSTEM'] === false ? 'rotate-180' : ''}`} />
                        </button>
                    )}
                    <div className={`space-y-0.5 overflow-hidden transition-all duration-300 ${(!isCollapsed && expandedSections['SİSTEM'] === false) ? 'max-h-0 opacity-0' : 'max-h-[500px] opacity-100'}`}>
                        {isCollapsed ? (
                            <Tooltip content="Bildirimler" position="right">
                                <button
                                    onClick={() => setShowNotifications(true)}
                                    className={`group relative flex items-center justify-center w-11 h-11 mx-auto rounded-xl text-[13px] font-bold uppercase tracking-wider transition-all duration-200 ${showNotifications
                                        ? "text-white shadow-lg shadow-black/20"
                                        : "text-[#A0AEC0] hover:bg-[#1B3B6F]/20 hover:text-[#E2E8F0]"
                                        }`}
                                    style={showNotifications ? { backgroundColor: accentColor } : undefined}
                                >
                                    <Bell size={18} strokeWidth={showNotifications ? 2.5 : 1.5} className={showNotifications ? "text-white" : "text-[#A9A9A9] group-hover:text-[#E2E8F0]"} />
                                    {unreadCount > 0 && (
                                        <span className="absolute top-1 right-1 px-1.5 py-0.5 bg-red-500 text-white text-[9px] rounded-full font-bold min-w-[14px] text-center flex-shrink-0 shadow-sm leading-none scale-90">
                                            {unreadCount > 9 ? "9+" : unreadCount}
                                        </span>
                                    )}
                                </button>
                            </Tooltip>
                        ) : (
                            <button
                                onClick={() => setShowNotifications(true)}
                                className={`w-full text-left group relative flex items-center gap-3 px-4 py-2.5 rounded-xl text-[13px] font-bold uppercase tracking-wider transition-all duration-200 ${showNotifications
                                    ? "text-white shadow-lg shadow-[#0A1931]/40"
                                    : "text-[#A0AEC0] hover:bg-[#1B3B6F]/20 hover:text-[#E2E8F0]"
                                    }`}
                                style={showNotifications ? { backgroundColor: accentColor } : undefined}
                            >
                                <Bell size={18} strokeWidth={showNotifications ? 2.5 : 1.5} className={showNotifications ? "text-white" : "text-[#A9A9A9] group-hover:text-[#E2E8F0]"} />
                                <span className="flex-1">Bildirimler</span>
                                {unreadCount > 0 && (
                                    <span className="px-1.5 py-0.5 bg-[#1B3B6F] border border-[#1B3B6F]/50 text-white text-xs rounded-full font-medium min-w-[18px] text-center flex-shrink-0 shadow-sm">
                                        {unreadCount > 9 ? "9+" : unreadCount}
                                    </span>
                                )}
                            </button>
                        )}
                    </div>
                </div>
            </nav>

            {/* User footer */}
            <div className={`transition-all duration-300 ${
                isCollapsed 
                    ? "mx-auto mb-6 flex flex-col items-center gap-3 py-4" 
                    : "p-4 mx-3 mb-6 rounded-2xl bg-[#1B3B6F]/15 border border-[#1B3B6F]/20"
            }`}>
                {isCollapsed ? (
                    <>
                        <Tooltip content={`${user?.firstName} ${user?.lastName} (Öğrenci)`} position="right">
                            <Link href="/dashboard/profile" className="w-10 h-10 rounded-xl flex items-center justify-center text-white text-xs font-bold bg-[#1B3B6F] border border-[#A0AEC0]/10 cursor-pointer hover:scale-110 active:scale-95 transition-all duration-200 shadow-inner shrink-0">
                                {user?.firstName?.[0]}{user?.lastName?.[0]}
                            </Link>
                        </Tooltip>
                        <Tooltip content="Çıkış Yap" position="right">
                            <button
                                onClick={handleLogout}
                                className="p-2 rounded-xl text-[#A9A9A9] hover:text-red-400 hover:bg-red-400/10 transition-all hover:scale-110 active:scale-90 duration-200"
                            >
                                <LogOut size={16} />
                            </button>
                        </Tooltip>
                    </>
                ) : (
                    <div className="flex items-center gap-3">
                        <Link href="/dashboard/profile" className="flex items-center gap-3 flex-1 min-w-0 group cursor-pointer">
                            <div className="w-10 h-10 rounded-2xl flex items-center justify-center text-white text-xs font-bold shrink-0 bg-[#1B3B6F] border border-[#A0AEC0]/10 transition-transform group-hover:scale-105">
                                {user?.firstName?.[0]}{user?.lastName?.[0]}
                            </div>
                            <div className="flex-1 min-w-0">
                                <p className="text-[13px] font-semibold text-white truncate group-hover:text-blue-200 transition-colors">
                                    {user?.firstName} {user?.lastName}
                                </p>
                                <p className="text-[11px] text-[#A9A9A9] truncate">Öğrenci</p>
                            </div>
                        </Link>
                        <Tooltip content="Çıkış Yap">
                            <button
                                onClick={handleLogout}
                                className="p-1.5 rounded-lg text-[#A9A9A9] hover:text-red-400 hover:bg-red-400/10 transition-all shrink-0"
                                title="Çıkış Yap"
                            >
                                <LogOut size={16} />
                            </button>
                        </Tooltip>
                    </div>
                )}
            </div>
        </aside>

        {showNotifications && (
            <NotificationsModal 
                onClose={() => setShowNotifications(false)} 
                onUnreadCountUpdate={setUnreadCount}
            />
        )}
        </>
    );
}
