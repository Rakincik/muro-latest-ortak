"use client";

import React from "react";

export interface KpiItem {
    label: string;
    value: string | number;
    subValue?: string;
    icon: React.ElementType;
    colorClass?: string;
    bgClass?: string;
    iconColorClass?: string;
}

interface KpiGridProps {
    items: KpiItem[];
    className?: string;
}

export function KpiGrid({ items, className = "" }: KpiGridProps) {
    const desktopClass = className 
        ? className.replace(/\bflex\b/g, 'hidden md:flex')
        : "hidden md:grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-5 shrink-0";

    return (
        <>
            {/* Desktop / Tablet Grid View */}
            <div className={desktopClass}>
                {items.map((s, idx) => {
                    let glowColor = "rgba(226, 232, 240, 0.5)"; // default slate
                    if (s.bgClass) {
                        if (s.bgClass.includes('indigo') || s.bgClass.includes('blue')) glowColor = "rgba(59, 130, 246, 0.15)";
                        else if (s.bgClass.includes('emerald') || s.bgClass.includes('green')) glowColor = "rgba(16, 185, 129, 0.15)";
                        else if (s.bgClass.includes('amber') || s.bgClass.includes('orange')) glowColor = "rgba(245, 158, 11, 0.15)";
                        else if (s.bgClass.includes('teal')) glowColor = "rgba(20, 184, 166, 0.15)";
                        else if (s.bgClass.includes('red') || s.bgClass.includes('rose')) glowColor = "rgba(239, 68, 68, 0.15)";
                        else if (s.bgClass.includes('violet') || s.bgClass.includes('purple')) glowColor = "rgba(139, 92, 246, 0.15)";
                    }

                    return (
                        <div key={idx} className="glass-card p-4 sm:p-5 flex flex-col gap-3 sm:gap-4 relative overflow-hidden group">
                            <div 
                                className="absolute -right-4 -top-4 w-20 h-20 sm:w-24 sm:h-24 rounded-full blur-2xl transition-all group-hover:scale-110" 
                                style={{ backgroundColor: glowColor }}
                            ></div>
                            
                            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between relative z-10 gap-2 sm:gap-0">
                                <div className={`w-10 h-10 sm:w-12 sm:h-12 rounded-xl sm:rounded-2xl ${s.bgClass || "bg-[#E2E8F0]/50"} flex items-center justify-center ring-1 ring-black/5`}>
                                    <s.icon size={20} className={`transition-transform group-hover:scale-110 ${s.iconColorClass || s.colorClass || "text-[#A0AEC0]"}`} />
                                </div>
                                <div className="text-left sm:text-right mt-1 sm:mt-0 w-full sm:w-auto">
                                    <p className={`text-[1.3rem] sm:text-3xl font-black tracking-tight leading-none ${s.colorClass || "text-[#0A1931]"}`}>{s.value}</p>
                                    {s.subValue && <p className="text-[10px] sm:text-xs text-[#A0AEC0] font-medium mt-1">{s.subValue}</p>}
                                </div>
                            </div>
                            <p className="text-[9px] sm:text-[11px] font-extrabold uppercase tracking-widest text-[#64748B] relative z-10 mt-auto">{s.label}</p>
                        </div>
                    );
                })}
            </div>

            {/* Mobile List View (Option 1) */}
            <div className="flex md:hidden flex-col bg-white rounded-2xl border border-[#E2E8F0] p-4 divide-y divide-[#E2E8F0]/60 shrink-0">
                {items.map((s, idx) => {
                    const Icon = s.icon;
                    return (
                        <div key={idx} className="flex items-center justify-between py-3.5 first:pt-0 last:pb-0">
                            <div className="flex items-center gap-3">
                                <div className={`w-9 h-9 rounded-xl ${s.bgClass || "bg-[#E2E8F0]/50"} flex items-center justify-center shrink-0`}>
                                    <Icon size={18} className={`${s.iconColorClass || s.colorClass || "text-[#A0AEC0]"}`} />
                                </div>
                                <div className="text-left">
                                    <p className="text-[10px] font-extrabold uppercase tracking-widest text-[#64748B] leading-none">{s.label}</p>
                                    {s.subValue && <p className="text-[10px] text-[#A0AEC0] font-medium mt-1 leading-none">{s.subValue}</p>}
                                </div>
                            </div>
                            <span className={`text-[15px] font-black tracking-tight ${s.colorClass || "text-[#0A1931]"}`}>{s.value}</span>
                        </div>
                    );
                })}
            </div>
        </>
    );
}
