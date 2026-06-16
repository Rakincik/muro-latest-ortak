"use client";

import React, { useRef, useEffect, useState } from "react";

export interface PremiumTabItem {
    id: string;
    label: string;
    icon?: React.ReactNode;
}

interface PremiumTabsProps {
    tabs: PremiumTabItem[];
    activeTab: string;
    onChange: (id: string) => void;
    className?: string;
}

export function PremiumTabs({ tabs, activeTab, onChange, className = "" }: PremiumTabsProps) {
    const containerRef = useRef<HTMLDivElement>(null);
    const [pillStyle, setPillStyle] = useState({ left: 0, width: 0, opacity: 0 });

    useEffect(() => {
        const activeIndex = tabs.findIndex(t => t.id === activeTab);
        if (activeIndex === -1 || !containerRef.current) return;

        const activeEl = containerRef.current.children[activeIndex + 1] as HTMLElement; // +1 because of pill element
        if (activeEl) {
            setPillStyle({
                left: activeEl.offsetLeft,
                width: activeEl.offsetWidth,
                opacity: 1
            });
            // Center active tab in view if scrollable
            const container = containerRef.current;
            const scrollLeft = activeEl.offsetLeft - (container.offsetWidth / 2) + (activeEl.offsetWidth / 2);
            container.scrollTo({ left: scrollLeft, behavior: 'smooth' });
        }
    }, [activeTab, tabs]);

    return (
        <div className={`w-full min-w-0 overflow-hidden ${className}`}>
            <div 
                ref={containerRef}
                className="relative flex w-fit max-w-full items-center p-1.5 bg-[#F0F4F8] rounded-xl overflow-x-auto hide-scrollbar whitespace-nowrap border border-[#E2E8F0]/60 after:content-[''] after:min-w-[6px] after:h-full"
                style={{ scrollbarWidth: 'none', msOverflowStyle: 'none' }}
            >
                {/* Active Pill Background */}
                <div 
                    className="absolute top-1.5 bottom-1.5 bg-white rounded-lg shadow-sm ring-1 ring-black/5 transition-all duration-300 ease-[cubic-bezier(0.23,1,0.32,1)]"
                    style={pillStyle}
                />
                
                {tabs.map((tab) => {
                    const isActive = activeTab === tab.id;
                    return (
                        <button
                            key={tab.id}
                            onClick={() => onChange(tab.id)}
                            className={`relative z-10 flex items-center gap-1.5 sm:gap-2 px-3 sm:px-5 py-1.5 sm:py-2 text-[11px] sm:text-sm font-bold rounded-lg transition-colors justify-center shrink-0 ${
                                isActive ? "text-[#0A1931]" : "text-[#64748B] hover:text-[#0A1931]"
                            }`}
                        >
                            {tab.icon && (
                                <span className={isActive ? "text-[#1B3B6F]" : "text-[#A0AEC0]"}>
                                    {tab.icon}
                                </span>
                            )}
                            {tab.label}
                        </button>
                    );
                })}
            </div>
            {/* Custom CSS to hide webkit scrollbar */}
            <style dangerouslySetInnerHTML={{__html: `
                .hide-scrollbar::-webkit-scrollbar {
                    display: none;
                }
            `}} />
        </div>
    );
}
