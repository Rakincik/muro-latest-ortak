"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import Image from "next/image";
import { usePathname } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import NotificationBell from "@/components/NotificationBell";
import { Tooltip } from "@/components/ui/Tooltip";
import { tenantApi, type TenantBrandingDto } from "@/lib/api";
import {
    LayoutDashboard, Users, FolderTree, BookOpen, FileText,
    CalendarDays, ClipboardList, Bell, MessageCircleQuestion,
    HeadphonesIcon, Mic2, BarChart3, Wallet,
    LogOut, ChevronRight, Trophy, User, CalendarCheck, Package, Shield,
    PlaySquare, ChevronDown, Building2
} from "lucide-react";

const sections = [
    {
        title: "ANA MENÜ",
        items: [
            { label: "Ana Sayfa", href: "/dashboard", icon: LayoutDashboard, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"] },
        ]
    },
    {
        title: "YÖNETİM",
        items: [
            { label: "Kullanıcılar", href: "/dashboard/users", icon: Users, roles: ["Admin", "SuperAdmin", "Assistant"] },
            { label: "Gruplar", href: "/dashboard/groups", icon: FolderTree, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "groups" },
            { label: "Paketler", href: "/dashboard/packages", icon: Package, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "packages" },
            { label: "Dersler", href: "/dashboard/courses", icon: BookOpen, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"] },
        ]
    },
    {
        title: "AKADEMİK",
        items: [
            { label: "Sınavlar", href: "/dashboard/exams", icon: FileText, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "exams" },
            { label: "Takvim", href: "/dashboard/calendar", icon: CalendarDays, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "calendar" },
            { label: "Ödevler", href: "/dashboard/assignments", icon: ClipboardList, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "assignments" },
        ]
    },
    {
        title: "İLETİŞİM",
        items: [
            { label: "Bildirimler", href: "/dashboard/notifications", icon: Bell, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "notifications" },
            { label: "Soru Sor", href: "/dashboard/questions", icon: MessageCircleQuestion, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "questions" },
            { label: "Teknik Destek", href: "/dashboard/support", icon: HeadphonesIcon, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "support" },
        ]
    },
    {
        title: "İÇERİK",
        items: [
            { label: "Medya Kütüphanesi", href: "/dashboard/media", icon: PlaySquare, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "mediaLibrary" },
            { label: "Podcast", href: "/dashboard/podcasts", icon: Mic2, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "podcast" },
        ]
    },
    {
        title: "ANALİZ",
        items: [
            { label: "Performans", href: "/dashboard/analytics", icon: BarChart3, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "analytics" },
            { label: "Sınav Sonuçları", href: "/dashboard/exam-results", icon: Trophy, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "examResults" },
            { label: "Öğrenci Karnesi", href: "/dashboard/student-scorecard", icon: User, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "studentScorecard" },
            { label: "Devam Raporu", href: "/dashboard/course-attendance", icon: CalendarCheck, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "attendance" },
            { label: "Muhasebe", href: "/dashboard/accounting", icon: Wallet, roles: ["Admin", "SuperAdmin", "Accountant"], featureKey: "accounting" },
            { label: "Güvenlik", href: "/dashboard/audit-trail", icon: Shield, roles: ["Admin", "SuperAdmin"] },
        ]
    },
    {
        title: "SİSTEM",
        items: [
            { label: "Kurum Ayarları", href: "/dashboard/settings/branding", icon: Building2, roles: ["SuperAdmin"] },
            { label: "Ders Klonlama", href: "/dashboard/courses/media-transfer", icon: FolderTree, roles: ["SuperAdmin"] }
        ]
    }
];

import { Menu, X } from "lucide-react"; // Make sure to import X

// ...

const roleTranslations: Record<string, string> = {
    "SuperAdmin": "Süper Admin",
    "Admin": "Admin",
    "Instructor": "Eğitmen",
    "Assistant": "Asistan",
    "Accountant": "Muhasebe",
    "Student": "Öğrenci",
    "Teacher": "Öğretmen"
};

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
    const { user, logout, currentTenantId, switchTenant } = useAuth();
    const [expandedSections, setExpandedSections] = useState<Record<string, boolean>>({});
    const [tenantDropdownOpen, setTenantDropdownOpen] = useState(false);

    const toggleSection = (title: string) => {
        setExpandedSections(prev => ({ ...prev, [title]: prev[title] === undefined ? false : !prev[title] }));
    };

    const [branding, setBranding] = useState<TenantBrandingDto | null>(null);

    useEffect(() => {
        tenantApi.getBranding(currentTenantId ?? undefined)
            .then(setBranding)
            .catch(() => { /* use defaults */ });
    }, [currentTenantId]);

    const brandName = branding?.name || "MURO";
    const primaryColor = branding?.primaryColor || "#0A1931";
    const accentColor = branding?.accentColor || "#1B3B6F";

    const currentTenant = user?.tenants.find(t => t.tenantId === currentTenantId);
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

    return (
        <>
            {/* Mobile Overlay */}
            {isOpen && (
                <div 
                    className="fixed inset-0 bg-black/50 z-40 lg:hidden"
                    onClick={onClose}
                />
            )}
            <aside 
                style={{ backgroundColor: primaryColor }}
                className={`flex flex-col transition-all duration-300 ease-in-out z-50 border border-white/10 ${
                    isOpen 
                        ? 'w-[260px] h-screen fixed left-0 top-0 translate-x-0' 
                        : '-translate-x-full fixed left-0 top-0 h-screen'
                } ${
                    isCollapsed 
                        ? 'lg:w-[76px] lg:h-[calc(100vh-2rem)] lg:my-4 lg:ml-4 lg:rounded-[24px] lg:shadow-2xl lg:shadow-black/40 lg:translate-x-0 lg:backdrop-blur-xl' 
                        : 'w-[260px] h-screen lg:translate-x-0 lg:rounded-none'
                }`}
            >
                {/* Logo + Bell */}
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
                                {brandName.substring(0, 1).toUpperCase()}
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
                                className="w-36 max-h-12 h-auto object-contain drop-shadow-md" 
                            />
                        )
                    )}
                    
                    {!isCollapsed && (
                        <div className="hidden lg:flex items-center gap-1.5">
                            <NotificationBell />
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
                                className="hidden lg:flex p-1.5 rounded-lg text-[#A9A9A9] hover:text-white hover:bg-white/10 transition-colors hover:scale-110 active:scale-90 duration-200"
                            >
                                <ChevronRight size={18} />
                            </button>
                        </Tooltip>
                    )}

                    <button 
                        onClick={onClose}
                        className="lg:hidden p-1.5 absolute right-4 top-1/2 -translate-y-1/2 text-[#A9A9A9] hover:text-white rounded-lg hover:bg-white/10"
                    >
                        <X size={20} />
                    </button>
                </div>

            {/* Tenant Switcher — sadece birden fazla kurum varsa göster */}
            {user && user.tenants.length > 1 && (
                <div className={`px-3 pb-3 transition-all duration-300 ${isCollapsed ? 'flex justify-center' : ''}`}>
                    <div className="relative">
                        {isCollapsed ? (
                            <Tooltip content="Kurum Değiştir" position="right">
                                <button
                                    onClick={() => setTenantDropdownOpen(!tenantDropdownOpen)}
                                    className="w-10 h-10 rounded-xl bg-white/5 border border-white/10 hover:bg-white/15 flex items-center justify-center text-white transition-all duration-200 hover:scale-110 active:scale-95 group"
                                >
                                    <Building2 size={16} className="text-[#A9A9A9] group-hover:text-white" />
                                </button>
                            </Tooltip>
                        ) : (
                            <button
                                onClick={() => setTenantDropdownOpen(!tenantDropdownOpen)}
                                className="w-full flex items-center gap-2.5 px-3 py-2.5 rounded-xl bg-white/5 border border-white/10 hover:bg-white/10 transition-all group"
                            >
                                <div className="w-7 h-7 rounded-lg bg-white/10 flex items-center justify-center shrink-0">
                                    <Building2 size={14} className="text-[#A0AEC0]" />
                                </div>
                                <div className="flex-1 min-w-0 text-left">
                                    <p className="text-[11px] text-[#A0AEC0]/70 font-medium leading-none mb-0.5">Aktif Kurum</p>
                                    <p className="text-[12px] text-white font-semibold truncate">
                                        {currentTenant?.tenantName || "Kurum Seçilmedi"}
                                    </p>
                                </div>
                                <ChevronDown
                                    size={14}
                                    className={`text-[#A0AEC0] transition-transform duration-200 ${tenantDropdownOpen ? "rotate-180" : ""}`}
                                />
                            </button>
                        )}

                        {/* Dropdown */}
                        {tenantDropdownOpen && (
                            <div className={`absolute left-0 top-full mt-1 bg-[#0F2847]/95 backdrop-blur-md border border-white/10 rounded-xl shadow-2xl shadow-black/55 overflow-hidden z-50 ${isCollapsed ? 'w-56 left-12' : 'right-0'}`}>
                                {user.tenants
                                    .filter(t => t.status === "active" || t.status === "Active")
                                    .map((tenant) => (
                                        <button
                                            key={tenant.tenantId}
                                            onClick={() => {
                                                switchTenant(tenant.tenantId);
                                                setTenantDropdownOpen(false);
                                            }}
                                            className={`w-full flex items-center gap-2.5 px-3 py-2.5 text-left transition-all ${
                                                tenant.tenantId === currentTenantId
                                                    ? "bg-white/10 text-white"
                                                    : "text-[#A0AEC0] hover:bg-white/5 hover:text-white"
                                            }`}
                                        >
                                            <div className={`w-2 h-2 rounded-full shrink-0 ${
                                                tenant.tenantId === currentTenantId ? "bg-emerald-400" : "bg-[#A0AEC0]/30"
                                            }`} />
                                            <div className="flex-1 min-w-0">
                                                <p className="text-[12px] font-semibold truncate">{tenant.tenantName}</p>
                                                <p className="text-[10px] text-[#A0AEC0]/60 font-mono uppercase">{tenant.tenantCode}</p>
                                            </div>
                                            {tenant.tenantId === currentTenantId && (
                                                <span className="text-[9px] font-bold text-emerald-400 uppercase">Aktif</span>
                                            )}
                                        </button>
                                    ))}
                            </div>
                        )}
                    </div>
                </div>
            )}

            {/* Navigation */}
            <nav className="flex-1 overflow-y-auto px-3 py-2 space-y-5 [scrollbar-width:none] [-ms-overflow-style:none] [&::-webkit-scrollbar]:hidden">
                {sections.map((section) => {
                    const filteredItems = section.items.filter(item => {
                        const hasRole = !user?.role || item.roles.includes(user.role);
                        const hasFeature = !("featureKey" in item) || featuresDict[(item as any).featureKey] !== false;
                        const finalHasFeature = branding 
                            ? hasFeature 
                            : (currentTenant?.features ? hasFeature : true);

                        return hasRole && finalHasFeature;
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
                                    {section.title !== "ANA MENÜ" && (
                                        <ChevronDown size={12} className={`text-[#A9A9A9] transition-transform duration-200 ${expandedSections[section.title] === false ? 'rotate-180' : ''}`} />
                                    )}
                                </button>
                            )}
                            <div className={`space-y-1.5 overflow-hidden transition-all duration-300 ${(!isCollapsed && expandedSections[section.title] === false) ? 'max-h-0 opacity-0' : 'max-h-[500px] opacity-100'}`}>
                                {filteredItems.map((item) => {
                                    const isActive = pathname === item.href ||
                                        (item.href !== "/dashboard" && pathname?.startsWith(item.href));
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
                                                : "text-[#A0AEC0] hover:bg-white/10 hover:text-white"
                                                }`}
                                            style={isActive ? { backgroundColor: accentColor } : undefined}
                                        >
                                            <Icon size={18} strokeWidth={isActive ? 2.5 : 1.5} className={isActive ? "text-white" : "text-[#A9A9A9] group-hover:text-white transition-colors duration-200"} />
                                            {!isCollapsed && <span className="flex-1">{item.label}</span>}
                                            {isActive && !isCollapsed && (
                                                <div className="w-1.5 h-1.5 rounded-full bg-white shadow-[0_0_8px_rgba(255,255,255,0.6)]" />
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
            </nav>

            {/* User Section */}
            <div className={`transition-all duration-300 ${
                isCollapsed 
                    ? "mx-auto mb-6 flex flex-col items-center gap-3 py-4" 
                    : "p-4 mx-3 mb-6 rounded-2xl bg-white/5 border border-white/10"
            }`}>
                {isCollapsed ? (
                    <>
                        <Tooltip content={`${user?.firstName} ${user?.lastName} (${user?.role ? (roleTranslations[user.role] || user.role) : ""})`} position="right">
                            <div className="w-10 h-10 rounded-xl flex items-center justify-center text-white text-xs font-bold bg-white/10 border border-white/10 cursor-pointer hover:scale-110 active:scale-95 transition-all duration-200 shadow-inner">
                                {user?.firstName?.[0]}{user?.lastName?.[0]}
                            </div>
                        </Tooltip>
                        <Tooltip content="Çıkış Yap" position="right">
                            <button
                                onClick={logout}
                                className="p-2 rounded-xl text-[#A9A9A9] hover:text-red-400 hover:bg-red-400/10 transition-all hover:scale-110 active:scale-90 duration-200"
                            >
                                <LogOut size={16} />
                            </button>
                        </Tooltip>
                    </>
                ) : (
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-2xl flex items-center justify-center text-white text-xs font-bold shrink-0 bg-[#1B3B6F] border border-[#A0AEC0]/10">
                            {user?.firstName?.[0]}{user?.lastName?.[0]}
                        </div>
                        <div className="flex-1 min-w-0">
                            <p className="text-[13px] font-semibold text-white truncate">
                                {user?.firstName} {user?.lastName}
                            </p>
                            <p className="text-[11px] text-[#A9A9A9] truncate">{user?.role ? (roleTranslations[user.role] || user.role) : ""}</p>
                        </div>
                        <Tooltip content="Çıkış Yap">
                            <button
                                onClick={logout}
                                className="p-1.5 rounded-lg text-[#A9A9A9] hover:text-red-400 hover:bg-red-400/10 transition-all"
                            >
                                <LogOut size={16} />
                            </button>
                        </Tooltip>
                    </div>
                )}
            </div>
        </aside>
        </>
    );
}
