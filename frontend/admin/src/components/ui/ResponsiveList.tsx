"use client";

import React from "react";

interface ResponsiveListProps<T> {
    data: T[];
    keyExtractor: (item: T) => string;
    // Desktop props
    desktopColumns: React.ReactNode[];
    renderDesktopRow: (item: T) => React.ReactNode;
    // Mobile props
    renderMobileCard: (item: T) => React.ReactNode;
    // Optional props
    emptyMessage?: string;
    emptyIcon?: React.ReactNode;
    loading?: boolean;
    loadingComponent?: React.ReactNode;
}

export function ResponsiveList<T>({
    data,
    keyExtractor,
    desktopColumns,
    renderDesktopRow,
    renderMobileCard,
    emptyMessage = "Kayıt bulunamadı.",
    emptyIcon,
    loading = false,
    loadingComponent
}: ResponsiveListProps<T>) {
    
    if (loading) {
        return loadingComponent ? <>{loadingComponent}</> : (
            <div className="flex justify-center p-8 text-[#A0AEC0]">Yükleniyor...</div>
        );
    }

    if (data.length === 0) {
        return (
            <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 flex flex-col items-center justify-center py-16 text-[#A0AEC0]">
                {emptyIcon && <div className="opacity-30 mb-3">{emptyIcon}</div>}
                <p className="text-sm font-medium">{emptyMessage}</p>
            </div>
        );
    }

    return (
        <div className="w-full">
            {/* Desktop View */}
            <div className="hidden lg:block bg-white rounded-2xl border border-[#E2E8F0]/60 overflow-hidden shadow-sm">
                <table className="w-full text-left">
                    <thead className="bg-[#E2E8F0]/20 border-b border-[#E2E8F0]">
                        <tr>
                            {desktopColumns.map((col, idx) => (
                                <th key={idx} className="px-5 py-4 text-[11px] font-bold uppercase tracking-widest text-[#A0AEC0]">
                                    {col}
                                </th>
                            ))}
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-[#E2E8F0]/60">
                        {data.map((item) => (
                            <React.Fragment key={keyExtractor(item)}>
                                {renderDesktopRow(item)}
                            </React.Fragment>
                        ))}
                    </tbody>
                </table>
            </div>

            {/* Mobile View */}
            <div className="lg:hidden flex flex-col gap-4">
                {data.map((item) => (
                    <div key={keyExtractor(item)} className="w-full">
                        {renderMobileCard(item)}
                    </div>
                ))}
            </div>
        </div>
    );
}
