"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import { lightTap } from "@/hooks/useHaptics";
import {
    LayoutDashboard, Users, FolderTree, BookOpen, FileText,
    CalendarDays, ClipboardList, Bell, MessageCircleQuestion,
    HeadphonesIcon, Mic2, BarChart3, Wallet,
    LogOut, Trophy, User, CalendarCheck, Package, Shield,
    PlaySquare, MoreHorizontal, X, Building2, ChevronDown
} from "lucide-react";

const allNavigationItems = [
    { label: "Ana Sayfa", href: "/dashboard", icon: LayoutDashboard, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"] },
    { label: "Kullanıcılar", href: "/dashboard/users", icon: Users, roles: ["Admin", "SuperAdmin", "Assistant"] },
    { label: "Dersler", href: "/dashboard/courses", icon: BookOpen, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"] },
    { label: "Gruplar", href: "/dashboard/groups", icon: FolderTree, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "groups" },
    { label: "Paketler", href: "/dashboard/packages", icon: Package, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "packages" },
    { label: "Sınavlar", href: "/dashboard/exams", icon: FileText, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "exams" },
    { label: "Takvim", href: "/dashboard/calendar", icon: CalendarDays, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "calendar" },
    { label: "Ödevler", href: "/dashboard/assignments", icon: ClipboardList, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "assignments" },
    { label: "Soru Sor", href: "/dashboard/questions", icon: MessageCircleQuestion, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "questions" },
    { label: "Teknik Destek", href: "/dashboard/support", icon: HeadphonesIcon, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "support" },
    { label: "Bildirimler", href: "/dashboard/notifications", icon: Bell, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "notifications" },
    { label: "Medya", href: "/dashboard/media", icon: PlaySquare, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "mediaLibrary" },
    { label: "Podcast", href: "/dashboard/podcasts", icon: Mic2, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "podcast" },
    { label: "Performans", href: "/dashboard/analytics", icon: BarChart3, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "analytics" },
    { label: "Sınav Sonuçları", href: "/dashboard/exam-results", icon: Trophy, roles: ["Admin", "SuperAdmin", "Assistant", "Instructor"], featureKey: "examResults" },
    { label: "Öğrenci Karnesi", href: "/dashboard/student-scorecard", icon: User, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "studentScorecard" },
    { label: "Devam Raporu", href: "/dashboard/course-attendance", icon: CalendarCheck, roles: ["Admin", "SuperAdmin", "Assistant"], featureKey: "attendance" },
    { label: "Muhasebe", href: "/dashboard/accounting", icon: Wallet, roles: ["Admin", "SuperAdmin", "Accountant"], featureKey: "accounting" },
    { label: "Güvenlik", href: "/dashboard/audit-trail", icon: Shield, roles: ["Admin", "SuperAdmin"] },
];

export default function MobileTabBar() {
    const pathname = usePathname();
    const { user, logout, currentTenantId, switchTenant } = useAuth();
    const [isOpen, setIsOpen] = useState(false);
    const [tenantDropdownOpen, setTenantDropdownOpen] = useState(false);

    // Close bottom sheet when route changes
    useEffect(() => {
        setIsOpen(false);
        setTenantDropdownOpen(false);
    }, [pathname]);

    if (!user) return null;

    const currentTenant = user.tenants.find(t => t.tenantId === currentTenantId);
    let featuresDict: Record<string, boolean> = {};
    if (currentTenant?.features) {
        try {
            featuresDict = JSON.parse(currentTenant.features);
        } catch { }
    }

    // Filter permitted items
    const permittedItems = allNavigationItems.filter(item => {
        const hasRole = !user.role || item.roles.includes(user.role);
        const hasFeature = !("featureKey" in item) || featuresDict[(item as any).featureKey] === true;
        const finalHasFeature = currentTenant?.features ? hasFeature : true;
        return hasRole && finalHasFeature;
    });

    // We keep first 4 items as main tabs, the rest go into "Daha Fazla" sheet.
    // If total permitted <= 5, we can show them all directly.
    const showAllDirectly = permittedItems.length <= 5;
    const mainTabs = showAllDirectly ? permittedItems : permittedItems.slice(0, 4);
    const moreItems = showAllDirectly ? [] : permittedItems.slice(4);

    const handleTabClick = () => {
        lightTap();
    };

    const handleMoreClick = () => {
        lightTap();
        setIsOpen(true);
    };

    const isActive = (href: string) => {
        if (href === "/dashboard") return pathname === "/dashboard";
        return pathname?.startsWith(href) ?? false;
    };

    return (
        <>
            {/* Tab Bar Layout */}
            <nav className="fixed bottom-0 left-0 right-0 z-40 bg-white/90 backdrop-blur-xl border-t border-slate-200/80 px-4 py-2 pb-[calc(8px+env(safe-area-inset-bottom,0px))] flex justify-around items-center shadow-lg shadow-black/5 lg:hidden select-none">
                {mainTabs.map((item) => {
                    const active = isActive(item.href);
                    const Icon = item.icon;
                    return (
                        <Link
                            key={item.href}
                            href={item.href}
                            prefetch={false}
                            onClick={handleTabClick}
                            className={`flex flex-col items-center justify-center gap-1 py-1 px-3 rounded-xl transition-all duration-200 active:scale-95 min-w-[64px] ${
                                active ? "text-[#1B3B6F]" : "text-[#A0AEC0]"
                            }`}
                        >
                            <div className="relative">
                                <Icon size={20} strokeWidth={active ? 2.5 : 1.8} className={active ? "text-[#1B3B6F]" : "text-[#A0AEC0]"} />
                            </div>
                            <span className="text-[10px] font-bold tracking-wide">{item.label}</span>
                        </Link>
                    );
                })}

                {!showAllDirectly && (
                    <button
                        onClick={handleMoreClick}
                        className={`flex flex-col items-center justify-center gap-1 py-1 px-3 rounded-xl transition-all duration-200 active:scale-95 min-w-[64px] ${
                            isOpen ? "text-[#1B3B6F]" : "text-[#A0AEC0]"
                        }`}
                    >
                        <MoreHorizontal size={20} strokeWidth={isOpen ? 2.5 : 1.8} />
                        <span className="text-[10px] font-bold tracking-wide">Daha Fazla</span>
                    </button>
                )}
            </nav>

            {/* Bottom Sheet Menu */}
            {isOpen && (
                <>
                    {/* Backdrop */}
                    <div
                        className="fixed inset-0 bg-black/60 z-50 transition-opacity duration-300 lg:hidden"
                        onClick={() => setIsOpen(false)}
                    />

                    {/* Content Container */}
                    <div className="fixed bottom-0 left-0 right-0 z-50 bg-white rounded-t-3xl max-h-[82vh] flex flex-col shadow-2xl border-t border-slate-100 transition-transform duration-300 ease-out transform translate-y-0 lg:hidden pb-[calc(16px+env(safe-area-inset-bottom,0px))]">
                        {/* Drag Handle & Header */}
                        <div className="flex flex-col items-center pt-3 pb-2 border-b border-slate-100">
                            <div className="w-12 h-1.5 bg-slate-200 rounded-full mb-3" />
                            <div className="w-full px-5 flex items-center justify-between">
                                <h3 className="text-sm font-bold text-[#0A1931] tracking-wide uppercase">Tüm Menü</h3>
                                <button
                                    onClick={() => setIsOpen(false)}
                                    className="p-1.5 rounded-full bg-slate-100 text-slate-500 active:scale-90 transition-transform"
                                >
                                    <X size={16} />
                                </button>
                            </div>
                        </div>

                        {/* Tenant Switcher inside bottom sheet (if multiple exists) */}
                        {user.tenants.length > 1 && (
                            <div className="px-5 py-3 border-b border-slate-100">
                                <div className="relative">
                                    <button
                                        onClick={() => {
                                            lightTap();
                                            setTenantDropdownOpen(!tenantDropdownOpen);
                                        }}
                                        className="w-full flex items-center gap-2.5 px-3 py-2.5 rounded-xl bg-slate-50 border border-slate-200 hover:bg-slate-100 transition-all active:scale-[0.98]"
                                    >
                                        <div className="w-7 h-7 rounded-lg bg-slate-200/60 flex items-center justify-center shrink-0">
                                            <Building2 size={14} className="text-slate-600" />
                                        </div>
                                        <div className="flex-1 min-w-0 text-left">
                                            <p className="text-[9px] text-slate-500 font-medium leading-none mb-0.5 uppercase tracking-wider">Aktif Kurum</p>
                                            <p className="text-[12px] text-slate-800 font-semibold truncate">
                                                {currentTenant?.tenantName || "Kurum Seçilmedi"}
                                            </p>
                                        </div>
                                        <ChevronDown
                                            size={14}
                                            className={`text-slate-500 transition-transform duration-200 ${tenantDropdownOpen ? "rotate-180" : ""}`}
                                        />
                                    </button>

                                    {tenantDropdownOpen && (
                                        <div className="absolute left-0 right-0 bottom-full mb-1 bg-white border border-slate-200 rounded-xl shadow-xl overflow-hidden z-50">
                                            {user.tenants
                                                .filter(t => t.status === "active" || t.status === "Active")
                                                .map((tenant) => (
                                                    <button
                                                        key={tenant.tenantId}
                                                        onClick={() => {
                                                            lightTap();
                                                            switchTenant(tenant.tenantId);
                                                            setTenantDropdownOpen(false);
                                                        }}
                                                        className={`w-full flex items-center gap-2.5 px-4 py-3 text-left transition-all border-b border-slate-50 last:border-b-0 ${
                                                            tenant.tenantId === currentTenantId
                                                                ? "bg-slate-50 text-[#1B3B6F]"
                                                                : "text-slate-700 hover:bg-slate-50"
                                                        }`}
                                                    >
                                                        <div className={`w-2 h-2 rounded-full shrink-0 ${
                                                            tenant.tenantId === currentTenantId ? "bg-emerald-500" : "bg-slate-300"
                                                        }`} />
                                                        <div className="flex-1 min-w-0">
                                                            <p className="text-[12px] font-semibold truncate">{tenant.tenantName}</p>
                                                        </div>
                                                        {tenant.tenantId === currentTenantId && (
                                                            <span className="text-[9px] font-bold text-emerald-600 bg-emerald-50 px-1.5 py-0.5 rounded uppercase">Aktif</span>
                                                        )}
                                                    </button>
                                                ))}
                                        </div>
                                    )}
                                </div>
                            </div>
                        )}

                        {/* Scrolling Link List */}
                        <div className="flex-1 overflow-y-auto px-5 py-4 space-y-2">
                            <div className="grid grid-cols-2 gap-2">
                                {moreItems.map((item) => {
                                    const active = isActive(item.href);
                                    const Icon = item.icon;
                                    return (
                                        <Link
                                            key={item.href}
                                            href={item.href}
                                            prefetch={false}
                                            onClick={handleTabClick}
                                            className={`flex items-center gap-3 px-4 py-3 rounded-2xl border text-[13px] font-bold uppercase tracking-wider transition-all duration-200 active:scale-95 ${
                                                active
                                                    ? "bg-[#1B3B6F] text-white border-[#1B3B6F] shadow-md shadow-[#1B3B6F]/20"
                                                    : "bg-slate-50 text-slate-700 border-slate-100 hover:bg-slate-100"
                                            }`}
                                        >
                                            <Icon size={18} strokeWidth={active ? 2.5 : 1.8} className={active ? "text-white" : "text-slate-500"} />
                                            <span className="truncate">{item.label}</span>
                                        </Link>
                                    );
                                })}
                            </div>

                            {/* Separator */}
                            <div className="border-t border-slate-100 my-4" />

                            {/* Logout Action */}
                            <button
                                onClick={() => {
                                    lightTap();
                                    logout();
                                }}
                                className="w-full flex items-center justify-center gap-2 py-3 px-4 rounded-2xl bg-red-50 hover:bg-red-100 text-red-600 text-[13px] font-bold uppercase tracking-wider transition-all active:scale-98"
                            >
                                <LogOut size={16} />
                                <span>Çıkış Yap</span>
                            </button>
                        </div>
                    </div>
                </>
            )}
        </>
    );
}
