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
    const gridClass = className || "grid grid-cols-2 lg:grid-cols-4 gap-3 sm:gap-5 shrink-0";

    return (
        <div className={gridClass}>
            {items.map((s, idx) => {
                // Try to map tailwind color classes to actual colors for the glow effect if possible,
                // or just use a default if it's not straightforward.
                let glowColor = "rgba(226, 232, 240, 0.5)"; // default slate
                if (s.bgClass) {
                    if (s.bgClass.includes('indigo')) glowColor = "#4f46e5";
                    else if (s.bgClass.includes('blue')) glowColor = "#2563eb";
                    else if (s.bgClass.includes('emerald')) glowColor = "#059669";
                    else if (s.bgClass.includes('amber')) glowColor = "#d97706";
                    else if (s.bgClass.includes('teal')) glowColor = "#0d9488";
                    else if (s.bgClass.includes('red')) glowColor = "#dc2626";
                }

                return (
                    <div key={idx} className="bg-white rounded-xl sm:rounded-2xl border border-[#E2E8F0] p-3 sm:p-4 flex flex-col gap-2 sm:gap-3 shadow-sm relative overflow-hidden group hover:border-[#A0AEC0] hover:shadow-md transition-all min-w-[140px] shrink-0 sm:shrink snap-start sm:snap-none">
                        <div 
                            className="absolute -right-4 -top-4 w-16 h-16 sm:w-20 sm:h-20 rounded-full opacity-10 blur-2xl transition-all group-hover:opacity-20" 
                            style={{ backgroundColor: glowColor }}
                        ></div>
                        
                        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between relative z-10 gap-2 sm:gap-0">
                            <div className={`w-8 h-8 sm:w-10 sm:h-10 rounded-lg sm:rounded-[0.8rem] ${s.bgClass || "bg-[#E2E8F0]/50"} flex items-center justify-center ring-1 ring-black/5`}>
                                <s.icon className={`w-4 h-4 sm:w-[18px] sm:h-[18px] transition-transform group-hover:scale-110 ${s.iconColorClass || s.colorClass || "text-[#A0AEC0]"}`} />
                            </div>
                            <div className="text-left sm:text-right w-full sm:w-auto">
                                <p className={`text-xl sm:text-2xl font-black tracking-tight ${s.colorClass || "text-[#0A1931]"}`}>{s.value}</p>
                                {s.subValue && <p className="text-[9px] sm:text-[10px] text-[#A0AEC0] font-medium mt-0.5">{s.subValue}</p>}
                            </div>
                        </div>
                        <p className="text-[9px] sm:text-[10px] font-extrabold uppercase tracking-widest text-[#64748B] relative z-10">{s.label}</p>
                    </div>
                );
            })}
        </div>
    );
}
