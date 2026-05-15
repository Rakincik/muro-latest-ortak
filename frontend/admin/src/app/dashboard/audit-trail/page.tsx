"use client";
import { useState, useEffect, useCallback, useMemo } from "react";
import {
    Shield, Search, Filter, ChevronLeft, ChevronRight,
    User, FileText, Trash2, Edit3, Plus, RefreshCw, Clock, Globe,
    AlertTriangle, Download, X, Activity, Eye, ChevronDown
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { auditApi, type AuditLogDto, type PagedAuditResult } from "@/lib/api";

const DAY_LABELS = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

const actionMeta: Record<string, { label: string; labelTR: string; bg: string; text: string; icon: typeof Plus }> = {
    Create: { label: "Create", labelTR: "Oluşturma", bg: "bg-emerald-50", text: "text-emerald-600", icon: Plus },
    Update: { label: "Update", labelTR: "Güncelleme", bg: "bg-blue-50", text: "text-blue-600", icon: Edit3 },
    Delete: { label: "Delete", labelTR: "Silme", bg: "bg-red-50", text: "text-red-600", icon: Trash2 },
    Login: { label: "Login", labelTR: "Giriş", bg: "bg-violet-50", text: "text-violet-600", icon: User },
    Logout: { label: "Logout", labelTR: "Çıkış", bg: "bg-slate-50", text: "text-slate-500", icon: User },
};
const defaultAction = { label: "?", labelTR: "Diğer", bg: "bg-gray-50", text: "text-gray-600", icon: FileText };

function timeAgo(dateStr: string) {
    const diff = Date.now() - new Date(dateStr).getTime();
    const m = Math.floor(diff / 60000);
    if (m < 1) return "Az önce";
    if (m < 60) return `${m}dk önce`;
    const h = Math.floor(m / 60);
    if (h < 24) return `${h}sa önce`;
    return `${Math.floor(h / 24)}g önce`;
}

// CSV Export
function exportCSV(logs: AuditLogDto[]) {
    const header = "Zaman;Kullanıcı;İşlem;Kayıt Tipi;Kayıt Adı;Detay;IP\n";
    const rows = logs.map(l =>
        `"${new Date(l.createdAt).toLocaleString("tr-TR")}";"${l.userName ?? "Sistem"}";"${l.action}";"${l.entityType}";"${(l.entityName ?? "").replace(/"/g, '""')}";"${(l.details ?? "").replace(/"/g, '""')}";"${l.ipAddress ?? ""}"`
    ).join("\n");
    const blob = new Blob(["\uFEFF" + header + rows], { type: "text/csv;charset=utf-8;" });
    const a = document.createElement("a"); a.href = URL.createObjectURL(blob);
    a.download = `log_kayitlari_${new Date().toISOString().slice(0, 10)}.csv`; a.click();
}

// Suspicious activity detection
interface SuspiciousAlert { type: "night" | "mass_delete" | "multi_ip"; label: string; detail: string; severity: "warning" | "danger"; }

function detectSuspicious(logs: AuditLogDto[]): SuspiciousAlert[] {
    const alerts: SuspiciousAlert[] = [];

    // Night activity (00:00-06:00)
    const nightLogs = logs.filter(l => {
        const h = new Date(l.createdAt).getHours();
        return h >= 0 && h < 6;
    });
    if (nightLogs.length > 0) {
        const uniqueUsers = new Set(nightLogs.map(l => l.userName ?? "Bilinmeyen"));
        alerts.push({
            type: "night", severity: "warning",
            label: `${nightLogs.length} gece aktivitesi`,
            detail: `00:00-06:00 arası: ${Array.from(uniqueUsers).slice(0, 3).join(", ")}`,
        });
    }

    // Mass deletes (3+ deletes by same user within this page)
    const deletesByUser = new Map<string, number>();
    logs.filter(l => l.action === "Delete").forEach(l => {
        const user = l.userName ?? "?";
        deletesByUser.set(user, (deletesByUser.get(user) ?? 0) + 1);
    });
    deletesByUser.forEach((count, user) => {
        if (count >= 3) {
            alerts.push({
                type: "mass_delete", severity: "danger",
                label: `Toplu silme: ${user}`,
                detail: `${count} silme işlemi tespit edildi`,
            });
        }
    });

    // Multiple IPs for same user
    const userIps = new Map<string, Set<string>>();
    logs.forEach(l => {
        if (!l.userName || !l.ipAddress) return;
        if (!userIps.has(l.userName)) userIps.set(l.userName, new Set());
        userIps.get(l.userName)!.add(l.ipAddress);
    });
    userIps.forEach((ips, user) => {
        if (ips.size >= 3) {
            alerts.push({
                type: "multi_ip", severity: "warning",
                label: `Çoklu IP: ${user}`,
                detail: `${ips.size} farklı IP: ${Array.from(ips).slice(0, 3).join(", ")}`,
            });
        }
    });

    return alerts;
}

export default function AuditTrailPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [data, setData] = useState<PagedAuditResult | null>(null);
    const [loading, setLoading] = useState(true);
    const [page, setPage] = useState(1);
    const [actionFilter, setActionFilter] = useState("");
    const [entityFilter, setEntityFilter] = useState("");
    const [search, setSearch] = useState("");
    const [selectedLog, setSelectedLog] = useState<AuditLogDto | null>(null);

    const fetchLogs = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const result = await auditApi.getLogs(token, tenantId, {
                page, pageSize: 30,
                action: actionFilter || undefined,
                entityType: entityFilter || undefined,
                search: search || undefined,
            });
            setData(result);
        } catch { setData(null); }
        finally { setLoading(false); }
    }, [token, tenantId, page, actionFilter, entityFilter, search]);

    useEffect(() => { fetchLogs(); }, [fetchLogs]);

    const logs = data?.items ?? [];
    const suspicious = useMemo(() => detectSuspicious(logs), [logs]);

    // Activity heatmap
    const heatmapData = useMemo(() => {
        const grid: number[][] = Array.from({ length: 7 }, () => Array(24).fill(0));
        logs.forEach(l => {
            const d = new Date(l.createdAt);
            const dayIdx = d.getDay() === 0 ? 6 : d.getDay() - 1;
            grid[dayIdx][d.getHours()] += 1;
        });
        return grid;
    }, [logs]);
    const heatmapMax = Math.max(...heatmapData.flat(), 1);

    // User breakdown
    const userBreakdown = useMemo(() => {
        const map = new Map<string, { name: string; create: number; update: number; delete: number; other: number; total: number }>();
        logs.forEach(l => {
            const key = l.userName ?? "Sistem";
            if (!map.has(key)) map.set(key, { name: key, create: 0, update: 0, delete: 0, other: 0, total: 0 });
            const u = map.get(key)!;
            u.total++;
            if (l.action === "Create") u.create++;
            else if (l.action === "Update") u.update++;
            else if (l.action === "Delete") u.delete++;
            else u.other++;
        });
        return Array.from(map.values()).sort((a, b) => b.total - a.total).slice(0, 8);
    }, [logs]);

    // Timeline groups by hour
    const timelineGroups = useMemo(() => {
        const groups = new Map<string, AuditLogDto[]>();
        logs.forEach(l => {
            const d = new Date(l.createdAt);
            const key = d.toLocaleDateString("tr-TR", { day: "numeric", month: "short" }) + " · " +
                String(d.getHours()).padStart(2, "0") + ":00";
            if (!groups.has(key)) groups.set(key, []);
            groups.get(key)!.push(l);
        });
        return Array.from(groups.entries());
    }, [logs]);

    const maxUserTotal = Math.max(...userBreakdown.map(u => u.total), 1);

    return (
        <div className="space-y-5">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <Shield size={22} className="text-[#1B3B6F]" /> Güvenlik
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-0.5">Sistem aktivite kaydı ve güvenlik izleme</p>
                </div>
                <div className="flex items-center gap-2">
                    <button onClick={() => exportCSV(logs)} className="px-3 py-2 text-xs font-bold bg-white border border-[#E2E8F0] rounded-xl text-[#1B3B6F] hover:bg-[#E2E8F0]/20 flex items-center gap-1.5">
                        <Download size={12} /> CSV
                    </button>
                    <button onClick={fetchLogs} className="p-2 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9]">
                        <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
                    </button>
                </div>
            </div>

            {/* Suspicious Activity Alerts */}
            {suspicious.length > 0 && (
                <div className="space-y-2">
                    {suspicious.map((a, i) => (
                        <div key={i} className={`flex items-center gap-3 p-3 rounded-xl border ${a.severity === "danger" ? "bg-red-50 border-red-200" : "bg-amber-50 border-amber-200"}`}>
                            <AlertTriangle size={16} className={a.severity === "danger" ? "text-red-500" : "text-amber-500"} />
                            <div className="flex-1">
                                <p className={`text-xs font-bold ${a.severity === "danger" ? "text-red-700" : "text-amber-700"}`}>{a.label}</p>
                                <p className="text-[10px] text-[#A0AEC0]">{a.detail}</p>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {/* KPI Cards */}
            <div className="grid grid-cols-5 gap-3">
                {[
                    { label: "Toplam Kayıt", value: data?.totalCount ?? 0, icon: FileText, color: "text-[#0A1931]", bg: "bg-[#1B3B6F]/5" },
                    { label: "Oluşturma", value: logs.filter(l => l.action === "Create").length, icon: Plus, color: "text-emerald-600", bg: "bg-emerald-50" },
                    { label: "Güncelleme", value: logs.filter(l => l.action === "Update").length, icon: Edit3, color: "text-blue-600", bg: "bg-blue-50" },
                    { label: "Silme", value: logs.filter(l => l.action === "Delete").length, icon: Trash2, color: "text-red-600", bg: "bg-red-50" },
                    { label: "Uyarı", value: suspicious.length, icon: AlertTriangle, color: suspicious.length > 0 ? "text-amber-600" : "text-emerald-600", bg: suspicious.length > 0 ? "bg-amber-50" : "bg-emerald-50" },
                ].map(s => (
                    <div key={s.label} className={`${s.bg} rounded-xl border border-[#E2E8F0]/60 p-4 flex items-center gap-3`}>
                        <s.icon size={16} className={s.color} />
                        <div>
                            <p className={`text-xl font-bold ${s.color}`}>{s.value}</p>
                            <p className="text-[10px] text-[#A0AEC0] font-medium">{s.label}</p>
                        </div>
                    </div>
                ))}
            </div>

            {/* Filters */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-3 flex items-center gap-3 flex-wrap">
                <div className="flex-1 relative min-w-[160px]">
                    <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                    <input type="text" placeholder="Kullanıcı, Entity veya IP ara..." value={search}
                        onChange={e => { setSearch(e.target.value); setPage(1); }}
                        className="w-full pl-8 pr-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10" />
                </div>
                <select value={actionFilter} onChange={e => { setActionFilter(e.target.value); setPage(1); }}
                    className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                    <option value="">Tüm İşlemler</option>
                    <option value="Create">Oluşturma</option><option value="Update">Güncelleme</option><option value="Delete">Silme</option>
                </select>
                <select value={entityFilter} onChange={e => { setEntityFilter(e.target.value); setPage(1); }}
                    className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                    <option value="">Tüm Kayıt Tipleri</option>
                    <option value="User">Kullanıcı</option><option value="Course">Ders</option><option value="Session">Oturum</option>
                    <option value="Exam">Sınav</option><option value="Assignment">Ödev</option><option value="Group">Grup</option>
                </select>
            </div>

            {/* Main Content */}
            <div className="w-full space-y-4">
                {loading ? (
                    <div className="space-y-3">{[...Array(6)].map((_, i) => <div key={i} className="h-14 bg-[#E2E8F0]/30 rounded-xl animate-pulse" />)}</div>
                ) : logs.length === 0 ? (
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 py-16 flex flex-col items-center text-[#A0AEC0]">
                        <Shield size={40} className="opacity-20 mb-2" />
                        <p className="text-sm font-bold">Henüz audit kaydı bulunmuyor</p>
                    </div>
                ) : (
                    /* Table View */
                    <div className="bg-white rounded-xl border border-[#E2E8F0]/60 overflow-hidden">
                        <table className="w-full">
                            <thead>
                                <tr className="border-b border-[#E2E8F0] bg-[#E2E8F0]/15">
                                    <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Zaman</th>
                                    <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Kullanıcı</th>
                                    <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">İşlem</th>
                                    <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Kayıt Tipi</th>
                                    <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">Detay</th>
                                    <th className="text-left px-4 py-2.5 text-[10px] font-bold text-[#A9A9A9] uppercase">IP</th>
                                </tr>
                            </thead>
                            <tbody>
                                {logs.map(log => {
                                    const ac = actionMeta[log.action] ?? defaultAction;
                                    const ActionIcon = ac.icon;
                                    return (
                                        <tr key={log.id} onClick={() => setSelectedLog(log)} className="border-b border-[#E2E8F0]/40 hover:bg-[#E2E8F0]/10 cursor-pointer transition-colors">
                                            <td className="px-4 py-2.5 text-[11px] text-[#A0AEC0] whitespace-nowrap">
                                                {new Date(log.createdAt).toLocaleString("tr-TR", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                                            </td>
                                            <td className="px-4 py-2.5 text-xs font-medium text-[#0A1931]">{log.userName ?? "Sistem"}</td>
                                            <td className="px-4 py-2.5">
                                                <span className={`inline-flex items-center gap-1 text-[9px] font-bold px-2 py-0.5 rounded-lg ${ac.bg} ${ac.text}`}>
                                                    <ActionIcon size={9} /> {ac.labelTR}
                                                </span>
                                            </td>
                                            <td className="px-4 py-2.5">
                                                <span className="text-xs font-semibold text-[#1B3B6F]">{log.entityType}</span>
                                                {log.entityName && <p className="text-[10px] text-[#A0AEC0] truncate max-w-[120px]">{log.entityName}</p>}
                                            </td>
                                            <td className="px-4 py-2.5 text-[11px] text-[#A0AEC0] truncate max-w-[250px]">{log.details ?? "—"}</td>
                                            <td className="px-4 py-2.5 text-[11px] text-[#A9A9A9]">{log.ipAddress ?? "—"}</td>
                                        </tr>
                                    );
                                })}
                            </tbody>
                        </table>
                    </div>
                )}

                {/* Pagination */}
                {data && data.totalPages > 1 && (
                    <div className="flex items-center justify-between mt-3 px-2">
                        <p className="text-[10px] font-bold text-[#A0AEC0]">{data.totalCount} Kayıt · Sayfa {data.page}/{data.totalPages}</p>
                        <div className="flex items-center gap-1">
                            <button onClick={() => setPage(p => Math.max(1, p - 1))} disabled={page === 1}
                                className="p-1.5 rounded-lg hover:bg-white text-[#A0AEC0] disabled:opacity-30 border border-[#E2E8F0]">
                                <ChevronLeft size={14} /></button>
                            {Array.from({ length: Math.min(data.totalPages, 5) }, (_, i) => i + 1).map(p => (
                                <button key={p} onClick={() => setPage(p)}
                                    className={`w-8 h-8 rounded-lg text-xs font-bold ${p === page ? "bg-[#0A1931] text-white" : "hover:bg-white text-[#A9A9A9]"}`}>{p}</button>
                            ))}
                            <button onClick={() => setPage(p => Math.min(data.totalPages, p + 1))} disabled={page === data.totalPages}
                                className="p-1.5 rounded-lg hover:bg-white text-[#A0AEC0] disabled:opacity-30 border border-[#E2E8F0]">
                                <ChevronRight size={14} /></button>
                        </div>
                    </div>
                )}
            </div>

            {/* Detail Modal */}
            {selectedLog && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={() => setSelectedLog(null)}>
                    <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
                    <div className="relative w-full max-w-2xl bg-white rounded-2xl shadow-2xl" onClick={e => e.stopPropagation()}>
                        <div className="flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]">
                            <h2 className="text-lg font-bold text-[#0A1931] flex items-center gap-2">
                                <Eye size={18} className="text-[#1B3B6F]" /> Kayıt Detayı
                            </h2>
                            <button onClick={() => setSelectedLog(null)} className="p-2 rounded-xl bg-[#E2E8F0]/20 text-[#A0AEC0] hover:text-[#0A1931] transition-colors"><X size={18} /></button>
                        </div>
                        
                        <div className="p-6">
                            <div className="grid grid-cols-2 gap-6 mb-6">
                                {/* Left Column: Action Details */}
                                <div className="space-y-4">
                                    <h3 className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest border-b border-[#E2E8F0] pb-2">İşlem Bilgileri</h3>
                                    
                                    <div>
                                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Zaman</p>
                                        <p className="text-sm text-[#0A1931] font-bold">
                                            {new Date(selectedLog.createdAt).toLocaleString("tr-TR", { dateStyle: 'medium', timeStyle: 'medium' })}
                                        </p>
                                    </div>
                                    
                                    <div>
                                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">İşlem</p>
                                        <span className={`inline-flex items-center gap-1.5 text-xs font-bold px-2.5 py-1 rounded-lg ${(actionMeta[selectedLog.action] ?? defaultAction).bg} ${(actionMeta[selectedLog.action] ?? defaultAction).text}`}>
                                            {(() => {
                                                const Icon = (actionMeta[selectedLog.action] ?? defaultAction).icon;
                                                return <Icon size={12} />;
                                            })()}
                                            {(actionMeta[selectedLog.action] ?? defaultAction).labelTR}
                                        </span>
                                    </div>
                                </div>

                                {/* Right Column: Target Details */}
                                <div className="space-y-4">
                                    <h3 className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest border-b border-[#E2E8F0] pb-2">Hedef Bilgileri</h3>
                                    
                                    <div>
                                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Kayıt Tipi</p>
                                        <span className="inline-block px-2.5 py-1 rounded-lg bg-[#0A1931]/5 text-[#0A1931] text-xs font-bold border border-[#0A1931]/10">
                                            {selectedLog.entityType}
                                        </span>
                                    </div>

                                    {selectedLog.entityName && (
                                        <div>
                                            <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1">Kayıt Adı</p>
                                            <p className="text-sm text-[#0A1931] font-medium">{selectedLog.entityName}</p>
                                        </div>
                                    )}
                                </div>
                            </div>

                            {/* User & IP Bar */}
                            <div className="flex items-center gap-6 p-4 rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] mb-6">
                                <div className="flex items-center gap-3">
                                    <div className="w-10 h-10 rounded-full bg-[#1B3B6F]/10 flex items-center justify-center text-[#1B3B6F]">
                                        <User size={18} />
                                    </div>
                                    <div>
                                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Kullanıcı</p>
                                        <p className="text-sm font-bold text-[#0A1931]">{selectedLog.userName ?? "Sistem Otomasyonu"}</p>
                                    </div>
                                </div>
                                {selectedLog.ipAddress && (
                                    <>
                                        <div className="w-px h-8 bg-[#E2E8F0]" />
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 rounded-full bg-[#E2E8F0]/50 flex items-center justify-center text-[#A0AEC0]">
                                                <Globe size={18} />
                                            </div>
                                            <div>
                                                <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">IP Adresi</p>
                                                <p className="text-sm font-bold text-[#0A1931] font-mono">{selectedLog.ipAddress}</p>
                                            </div>
                                        </div>
                                    </>
                                )}
                            </div>

                            {/* Details Box */}
                            {selectedLog.details && (
                                <div>
                                    <span className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5 flex items-center gap-1.5">
                                        <FileText size={12} /> İşlem Detayı
                                    </span>
                                    <div className="p-4 bg-[#0A1931] rounded-xl text-[13px] text-[#E2E8F0] font-mono break-all whitespace-pre-wrap max-h-60 overflow-y-auto border border-[#1B3B6F] shadow-inner">
                                        {selectedLog.details.length > 5000 
                                            ? selectedLog.details.substring(0, 5000) + "\n\n... (Veri çok büyük olduğu için kırpıldı)"
                                            : selectedLog.details}
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
