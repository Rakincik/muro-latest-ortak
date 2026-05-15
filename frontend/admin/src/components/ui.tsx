"use client";

import { Search, Plus, LucideIcon } from "lucide-react";
import { ReactNode, useState } from "react";

/* ─── PageShell: consistent page layout ─── */
interface PageShellProps {
    title: string;
    subtitle?: string;
    icon?: LucideIcon;
    actions?: ReactNode;
    children: ReactNode;
}

export function PageShell({ title, subtitle, icon: Icon, actions, children }: PageShellProps) {
    return (
        <div className="animate-fade-in">
            <div className="page-header">
                <div className="flex items-center gap-4">
                    {Icon && (
                        <div className="w-11 h-11 rounded-xl flex items-center justify-center"
                            style={{ background: 'var(--accent-soft)', color: 'var(--accent)' }}>
                            <Icon size={22} />
                        </div>
                    )}
                    <div>
                        <h1>{title}</h1>
                        {subtitle && <p>{subtitle}</p>}
                    </div>
                </div>
                {actions && <div className="flex items-center gap-3">{actions}</div>}
            </div>
            {children}
        </div>
    );
}

/* ─── SearchInput ─── */
interface SearchInputProps {
    value: string;
    onChange: (v: string) => void;
    placeholder?: string;
}

export function SearchInput({ value, onChange, placeholder = "Ara..." }: SearchInputProps) {
    return (
        <div className="search-bar">
            <Search />
            <input
                className="input"
                value={value}
                onChange={(e) => onChange(e.target.value)}
                placeholder={placeholder}
            />
        </div>
    );
}

/* ─── StatCard ─── */
interface StatCardProps {
    label: string;
    value: string | number;
    icon: LucideIcon;
    color: string;
    trend?: string;
}

export function StatCard({ label, value, icon: Icon, color, trend }: StatCardProps) {
    return (
        <div className="card stat-card group">
            <div className="flex items-start justify-between">
                <div>
                    <p className="stat-label">{label}</p>
                    <p className="stat-value mt-2">{value}</p>
                    {trend && (
                        <p className="text-xs font-medium mt-2" style={{ color }}>
                            {trend}
                        </p>
                    )}
                </div>
                <div className="w-12 h-12 rounded-2xl flex items-center justify-center transition-all duration-300 group-hover:scale-105 bg-[#E2E8F0]/20 border border-[#E2E8F0]/60 text-[#A0AEC0] group-hover:text-[#0A1931] group-hover:border-[#A0AEC0] shadow-sm"
                    style={{ color: 'var(--text-secondary)' }}>
                    <Icon size={24} />
                </div>
            </div>
        </div>
    );
}

/* ─── DataTable ─── */
interface Column<T> {
    key: string;
    label: string;
    render?: (item: T) => ReactNode;
    className?: string;
}

interface DataTableProps<T> {
    columns: Column<T>[];
    data: T[];
    loading?: boolean;
    emptyIcon?: LucideIcon;
    emptyTitle?: string;
    emptyDesc?: string;
}

export function DataTable<T extends Record<string, unknown>>({
    columns, data, loading, emptyIcon: EmptyIcon, emptyTitle, emptyDesc
}: DataTableProps<T>) {
    if (loading) {
        return (
            <div className="card overflow-hidden">
                <div className="p-4 space-y-3">
                    {[...Array(5)].map((_, i) => (
                        <div key={i} className="flex gap-4 items-center">
                            <div className="skeleton h-4 flex-1" />
                            <div className="skeleton h-4 w-24" />
                            <div className="skeleton h-4 w-20" />
                        </div>
                    ))}
                </div>
            </div>
        );
    }

    if (data.length === 0) {
        return (
            <div className="card">
                <div className="empty-state">
                    {EmptyIcon && (
                        <div className="empty-state-icon"><EmptyIcon size={24} /></div>
                    )}
                    <h3>{emptyTitle || "Veri bulunamadı"}</h3>
                    <p>{emptyDesc || "Henüz kayıt eklenmemiş"}</p>
                </div>
            </div>
        );
    }

    return (
        <div className="card overflow-hidden">
            <table className="data-table">
                <thead>
                    <tr>
                        {columns.map((col) => (
                            <th key={col.key} className={col.className}>{col.label}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {data.map((item, idx) => (
                        <tr key={(item.id as string) ?? idx}>
                            {columns.map((col) => (
                                <td key={col.key} className={col.className}>
                                    {col.render
                                        ? col.render(item)
                                        : String(item[col.key] ?? "—")}
                                </td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

/* ─── TabBar ─── */
interface Tab {
    key: string;
    label: string;
    count?: number;
}

interface TabBarProps {
    tabs: Tab[];
    active: string;
    onChange: (key: string) => void;
}

export function TabBar({ tabs, active, onChange }: TabBarProps) {
    return (
        <div className="flex items-center gap-1.5 p-1.5 rounded-2xl mb-8 bg-[#E2E8F0]/40/50 border border-[#E2E8F0]/40 shadow-inner">
            {tabs.map((tab) => (
                <button
                    key={tab.key}
                    onClick={() => onChange(tab.key)}
                    className={`flex items-center gap-2 px-6 py-2.5 rounded-xl text-xs font-bold uppercase tracking-wider transition-all ${active === tab.key
                        ? "bg-[#0A1931] text-white shadow-xl shadow-[#0A1931]900/20"
                        : "text-[#A0AEC0] hover:text-[#1B3B6F] hover:bg-white"
                        }`}
                >
                    {tab.label}
                    {tab.count !== undefined && (
                        <span className={`text-[10px] px-2 py-0.5 rounded-full font-bold ${active === tab.key
                            ? "bg-white/20 text-white"
                            : "bg-[#E2E8F0] text-[#A9A9A9]"
                            }`}>
                            {tab.count}
                        </span>
                    )}
                </button>
            ))}
        </div>
    );
}

/* ─── Modal ─── */
interface ModalProps {
    open: boolean;
    onClose: () => void;
    title: string;
    children: ReactNode;
    footer?: ReactNode;
    size?: "sm" | "md" | "lg";
}

export function Modal({ open, onClose, title, children, footer, size = "md" }: ModalProps) {
    if (!open) return null;
    const widths = { sm: "max-w-md", md: "max-w-lg", lg: "max-w-2xl" };
    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4"
            onClick={onClose}>
            <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
            <div className={`relative w-full ${widths[size]} bg-white rounded-2xl shadow-xl animate-fade-in`}
                onClick={(e) => e.stopPropagation()}>
                <div className="flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]/60">
                    <h2 className="text-[16px] font-semibold text-[#0A1931]">{title}</h2>
                    <button onClick={onClose}
                        className="w-8 h-8 rounded-lg flex items-center justify-center text-[#A0AEC0] hover:bg-[#E2E8F0]/40 hover:text-[#1B3B6F] transition-all">
                        ✕
                    </button>
                </div>
                <div className="px-6 py-5">{children}</div>
                {footer && (
                    <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-[#E2E8F0]/60 bg-[#E2E8F0]/20/50 rounded-b-2xl">
                        {footer}
                    </div>
                )}
            </div>
        </div>
    );
}
