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
                    <div key={idx} className="bg-white rounded-2xl sm:rounded-3xl border border-[#E2E8F0] p-4 sm:p-5 flex flex-col gap-3 sm:gap-4 shadow-[0_8px_30px_rgb(0,0,0,0.04)] relative overflow-hidden group hover:border-[#A0AEC0] transition-all min-w-[150px] shrink-0 sm:shrink snap-start sm:snap-none">
                        <div 
                            className="absolute -right-4 -top-4 w-20 h-20 sm:w-24 sm:h-24 rounded-full opacity-10 blur-2xl transition-all group-hover:opacity-20" 
                            style={{ backgroundColor: glowColor }}
                        ></div>
                        
                        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between relative z-10 gap-2 sm:gap-0">
                            <div className={`w-10 h-10 sm:w-12 sm:h-12 rounded-[0.8rem] sm:rounded-[1rem] ${s.bgClass || "bg-[#E2E8F0]/50"} flex items-center justify-center ring-1 ring-black/5`}>
                                <s.icon size={20} className={`transition-transform group-hover:scale-110 ${s.iconColorClass || s.colorClass || "text-[#A0AEC0]"}`} />
                            </div>
                            <div className="text-left sm:text-right w-full sm:w-auto">
                                <p className={`text-2xl sm:text-3xl font-black tracking-tight ${s.colorClass || "text-[#0A1931]"}`}>{s.value}</p>
                                {s.subValue && <p className="text-[10px] sm:text-xs text-[#A0AEC0] font-medium mt-0.5">{s.subValue}</p>}
                            </div>
                        </div>
                        <p className="text-[10px] sm:text-[11px] font-extrabold uppercase tracking-widest text-[#64748B] relative z-10">{s.label}</p>
                    </div>
                );
            })}
        </div>
    );
}
