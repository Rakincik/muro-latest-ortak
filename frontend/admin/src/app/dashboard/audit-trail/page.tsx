"use client";
import { useState, useEffect, useCallback, useMemo } from "react";
import {
    Shield, Search, ChevronLeft, ChevronRight,
    User, FileText, Trash2, Edit3, Plus, RefreshCw, Clock, Globe,
    AlertTriangle, X, Activity, Eye, Lock, Smartphone, Monitor
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { auditApi, securityApi } from "@/lib/api/audits";
import { type AuditLogDto, type UserAuditSummaryDto, type SuspiciousUserDto } from "@/lib/api/types";
import { UAParser } from "ua-parser-js";

// Action Colors
const actionMeta: Record<string, { labelTR: string; bg: string; text: string; icon: typeof Plus }> = {
    Create: { labelTR: "Oluşturma", bg: "bg-emerald-50", text: "text-emerald-600", icon: Plus },
    Update: { labelTR: "Güncelleme", bg: "bg-blue-50", text: "text-blue-600", icon: Edit3 },
    Delete: { labelTR: "Silme", bg: "bg-red-50", text: "text-red-600", icon: Trash2 },
};
const defaultAction = { labelTR: "Diğer", bg: "bg-gray-50", text: "text-gray-600", icon: FileText };

// Parse User Agent
const parseUserAgent = (ua?: string) => {
    if (!ua) return { os: "Bilinmiyor", browser: "Bilinmiyor", device: "Desktop" };
    const parser = new UAParser(ua);
    const res = parser.getResult();
    return {
        os: res.os.name ? `${res.os.name} ${res.os.version || ""}` : "Bilinmiyor",
        browser: res.browser.name ? `${res.browser.name} ${res.browser.version || ""}` : "Bilinmiyor",
        device: res.device.type === "mobile" || res.device.type === "tablet" ? "Mobile" : "Desktop"
    };
};

export default function AuditTrailPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    
    // Master View States
    const [users, setUsers] = useState<UserAuditSummaryDto[]>([]);
    const [suspicious, setSuspicious] = useState<SuspiciousUserDto[]>([]);
    const [totalUsers, setTotalUsers] = useState(0);
    const [totalPages, setTotalPages] = useState(1);
    
    const [page, setPage] = useState(1);
    const [search, setSearch] = useState("");
    const [loading, setLoading] = useState(true);

    // Detail Modal States
    const [selectedUser, setSelectedUser] = useState<{ id: string | null; name: string | null } | null>(null);
    const [userLogs, setUserLogs] = useState<any[]>([]); // Merged Audit + Security
    const [loadingLogs, setLoadingLogs] = useState(false);

    const fetchMasterData = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const [usersRes, suspRes] = await Promise.all([
                auditApi.getUserAudits(token, tenantId, { page, pageSize: 10, search }),
                auditApi.getSuspiciousUsers(token, tenantId)
            ]);
            setUsers(usersRes.items);
            setTotalUsers(usersRes.totalCount);
            setTotalPages(usersRes.totalPages);
            setSuspicious(suspRes);
        } catch (e) {
            console.error("Failed to load audit data", e);
        } finally {
            setLoading(false);
        }
    }, [token, tenantId, page, search]);

    useEffect(() => { fetchMasterData(); }, [fetchMasterData]);

    // Load detailed logs for selected user
    useEffect(() => {
        if (!selectedUser || !token || !tenantId) return;
        
        let isMounted = true;
        const loadLogs = async () => {
            setLoadingLogs(true);
            try {
                // Fetch both system audits and security events for the user
                const [sysLogs, secLogs] = await Promise.all([
                    auditApi.getLogs(token, tenantId, { search: selectedUser.id || undefined, pageSize: 50 }),
                    securityApi.getEvents(token, tenantId, { userId: selectedUser.id || undefined, pageSize: 50 })
                ]);
                
                if (!isMounted) return;

                // Merge and sort chronologically (newest first)
                const merged = [
                    ...sysLogs.items.map(l => ({ ...l, _type: 'system' })),
                    ...secLogs.items.map(l => ({ ...l, _type: 'security' }))
                ];
                merged.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
                
                setUserLogs(merged);
            } catch (e) {
                console.error("Failed to load user logs", e);
            } finally {
                if (isMounted) setLoadingLogs(false);
            }
        };
        
        loadLogs();
        return () => { isMounted = false; };
    }, [selectedUser, token, tenantId]);

    // Separate Suspicious Users
    const multipleLoginUsers = suspicious.filter(s => s.alertType === "SESSION_KICKED");
    const otherSuspiciousUsers = suspicious.filter(s => s.alertType !== "SESSION_KICKED");

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <Shield size={22} className="text-[#1B3B6F]" /> Kullanıcı Kayıtları
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-0.5">Sistemdeki tüm eylemler ve şüpheli tespitleri</p>
                </div>
                <button onClick={fetchMasterData} className="p-2 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9] transition-all shadow-sm">
                    <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
                </button>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
                
                {/* ── LEFT COLUMN: USER LIST ── */}
                <div className="lg:col-span-8 bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm overflow-hidden flex flex-col min-h-[600px]">
                    <div className="p-4 border-b border-[#E2E8F0] flex items-center justify-between bg-slate-50/50">
                        <h2 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                            <Activity size={16} className="text-[#1B3B6F]" /> Kullanıcı Hareketleri
                        </h2>
                        <div className="relative w-64">
                            <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                            <input 
                                type="text" placeholder="İsimle ara..." 
                                value={search} onChange={e => { setSearch(e.target.value); setPage(1); }}
                                className="w-full pl-8 pr-3 py-2 text-xs bg-white border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10" 
                            />
                        </div>
                    </div>
                    
                    <div className="flex-1 overflow-auto">
                        <table className="w-full">
                            <thead>
                                <tr className="bg-slate-50 border-b border-[#E2E8F0]">
                                    <th className="text-left px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase">Hareket</th>
                                    <th className="text-left px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase">Kullanıcı</th>
                                    <th className="text-left px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase">Son İşlem Tarihi</th>
                                    <th className="text-right px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase">İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading && users.length === 0 ? (
                                    [...Array(10)].map((_, i) => (
                                        <tr key={i} className="border-b border-[#E2E8F0]/40"><td colSpan={4} className="p-4"><div className="h-6 bg-slate-100 rounded-lg animate-pulse" /></td></tr>
                                    ))
                                ) : users.length === 0 ? (
                                    <tr>
                                        <td colSpan={4} className="py-20 text-center text-[#A0AEC0]">
                                            <Search size={32} className="mx-auto mb-3 opacity-20" />
                                            <p className="text-sm font-medium">Kayıt bulunamadı</p>
                                        </td>
                                    </tr>
                                ) : (
                                    users.map((u, i) => (
                                        <tr key={u.userId || i} className="border-b border-[#E2E8F0]/40 hover:bg-slate-50 transition-colors">
                                            <td className="px-5 py-3">
                                                <span className="inline-flex items-center justify-center min-w-[32px] h-6 px-2 bg-emerald-50 text-emerald-600 text-xs font-bold rounded-lg border border-emerald-100">
                                                    {u.actionCount}
                                                </span>
                                            </td>
                                            <td className="px-5 py-3 text-sm font-bold text-[#0A1931]">
                                                {u.userName || "Sistem / Anonim"}
                                            </td>
                                            <td className="px-5 py-3 text-xs text-[#A9A9A9]">
                                                {new Date(u.lastActionAt).toLocaleString("tr-TR", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                                            </td>
                                            <td className="px-5 py-3 text-right">
                                                <button 
                                                    onClick={() => setSelectedUser({ id: u.userId, name: u.userName })}
                                                    className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-[#0A1931] text-white text-xs font-bold rounded-lg hover:bg-[#1B3B6F] transition-colors"
                                                >
                                                    <Eye size={12} /> İncele
                                                </button>
                                            </td>
                                        </tr>
                                    ))
                                )}
                            </tbody>
                        </table>
                    </div>

                    {/* Pagination */}
                    {totalPages > 1 && (
                        <div className="p-3 border-t border-[#E2E8F0] bg-slate-50 flex items-center justify-between">
                            <p className="text-xs font-bold text-[#A0AEC0]">{totalUsers} Kayıt</p>
                            <div className="flex items-center gap-1">
                                <button onClick={() => setPage(p => Math.max(1, p - 1))} disabled={page === 1} className="p-1.5 rounded-lg hover:bg-white text-[#A0AEC0] border border-[#E2E8F0]"><ChevronLeft size={14} /></button>
                                {Array.from({ length: Math.min(totalPages, 5) }, (_, i) => {
                                    let p = i + 1;
                                    if (totalPages > 5 && page > 3) p = page - 3 + i;
                                    if (p > totalPages) return null;
                                    return (
                                        <button key={p} onClick={() => setPage(p)} className={`w-8 h-8 rounded-lg text-xs font-bold ${p === page ? "bg-[#0A1931] text-white" : "hover:bg-white text-[#A9A9A9]"}`}>{p}</button>
                                    );
                                })}
                                <button onClick={() => setPage(p => Math.min(totalPages, p + 1))} disabled={page === totalPages} className="p-1.5 rounded-lg hover:bg-white text-[#A0AEC0] border border-[#E2E8F0]"><ChevronRight size={14} /></button>
                            </div>
                        </div>
                    )}
                </div>

                {/* ── RIGHT COLUMN: ALERTS ── */}
                <div className="lg:col-span-4 space-y-6">
                    <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm overflow-hidden">
                        <div className="p-4 bg-slate-50/50 border-b border-[#E2E8F0] flex items-center justify-between">
                            <h2 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                                <AlertTriangle size={16} className="text-amber-500" /> Usulsüz İşlemler
                            </h2>
                        </div>
                        
                        <div className="p-5 space-y-5">
                            
                            {/* Çoklu Giriş Paneli */}
                            <div>
                                <div className="flex items-center gap-2 mb-3">
                                    <span className="flex items-center justify-center w-6 h-6 rounded bg-[#1B3B6F] text-white">
                                        <Lock size={12} />
                                    </span>
                                    <h3 className="text-xs font-bold text-[#0A1931] uppercase tracking-wider">Çoklu Giriş Tespiti</h3>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    {multipleLoginUsers.length === 0 ? (
                                        <p className="text-xs text-[#A9A9A9] italic">Son 7 günde tespit bulunamadı.</p>
                                    ) : (
                                        multipleLoginUsers.map((su, i) => (
                                            <button 
                                                key={i} 
                                                onClick={() => setSelectedUser({ id: su.userId, name: su.userName })}
                                                className="px-2.5 py-1.5 bg-[#1B3B6F]/5 border border-[#1B3B6F]/20 text-[#1B3B6F] hover:bg-[#1B3B6F] hover:text-white text-[11px] font-bold rounded-lg transition-colors"
                                            >
                                                {su.userName || "Bilinmeyen"}
                                            </button>
                                        ))
                                    )}
                                </div>
                            </div>

                            <hr className="border-[#E2E8F0]" />

                            {/* Şüpheli Paneli */}
                            <div>
                                <div className="flex items-center gap-2 mb-3">
                                    <span className="flex items-center justify-center w-6 h-6 rounded bg-amber-500 text-white">
                                        <AlertTriangle size={12} />
                                    </span>
                                    <h3 className="text-xs font-bold text-[#0A1931] uppercase tracking-wider">Şüpheli İşlemler</h3>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    {otherSuspiciousUsers.length === 0 ? (
                                        <p className="text-xs text-[#A9A9A9] italic">Son 7 günde tespit bulunamadı.</p>
                                    ) : (
                                        otherSuspiciousUsers.map((su, i) => (
                                            <button 
                                                key={i} 
                                                onClick={() => setSelectedUser({ id: su.userId, name: su.userName })}
                                                className="px-2.5 py-1.5 bg-amber-50 border border-amber-200 text-amber-700 hover:bg-amber-500 hover:text-white hover:border-amber-500 text-[11px] font-bold rounded-lg transition-colors flex items-center gap-1"
                                                title={`${su.eventCount} adet ${su.alertType} şüphesi`}
                                            >
                                                {su.userName || "Bilinmeyen"} <span className="opacity-50">({su.eventCount})</span>
                                            </button>
                                        ))
                                    )}
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            {/* ── DETAIL MODAL (TIMELINE) ── */}
            {selectedUser && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={() => setSelectedUser(null)}>
                    <div className="absolute inset-0 bg-[#0A1931]/40 backdrop-blur-sm" />
                    <div className="relative w-full max-w-3xl max-h-[90vh] bg-white rounded-2xl shadow-2xl flex flex-col animate-in zoom-in-95 duration-200" onClick={e => e.stopPropagation()}>
                        
                        <div className="px-6 py-4 border-b border-[#E2E8F0] flex items-center justify-between shrink-0">
                            <div className="flex items-center gap-3">
                                <div className="w-10 h-10 rounded-full bg-[#1B3B6F]/10 flex items-center justify-center text-[#1B3B6F]">
                                    <User size={18} />
                                </div>
                                <div>
                                    <h2 className="text-lg font-bold text-[#0A1931]">{selectedUser.name || "Bilinmeyen Kullanıcı"}</h2>
                                    <p className="text-xs font-bold text-[#A0AEC0] uppercase tracking-widest">Sicil & Aksiyon Geçmişi</p>
                                </div>
                            </div>
                            <button onClick={() => setSelectedUser(null)} className="p-2 rounded-xl bg-[#E2E8F0]/30 hover:bg-[#E2E8F0] text-[#A0AEC0] hover:text-[#0A1931] transition-colors"><X size={18} /></button>
                        </div>
                        
                        <div className="flex-1 overflow-y-auto p-6 bg-slate-50/50">
                            {loadingLogs ? (
                                <div className="space-y-4">
                                    {[...Array(4)].map((_, i) => (
                                        <div key={i} className="flex gap-4 opacity-50 animate-pulse">
                                            <div className="w-12 text-right"><div className="h-4 bg-slate-200 rounded" /></div>
                                            <div className="w-px bg-slate-200" />
                                            <div className="flex-1 h-16 bg-slate-200 rounded-xl" />
                                        </div>
                                    ))}
                                </div>
                            ) : userLogs.length === 0 ? (
                                <div className="text-center py-20 text-[#A0AEC0]">
                                    <Search size={40} className="mx-auto mb-3 opacity-20" />
                                    <p className="text-sm font-medium">Bu kullanıcıya ait son 50 işlemde kayıt bulunamadı.</p>
                                </div>
                            ) : (
                                <div className="space-y-0 relative before:absolute before:inset-0 before:ml-[60px] before:-translate-x-px md:before:ml-[88px] before:h-full before:w-0.5 before:bg-gradient-to-b before:from-[#E2E8F0] before:via-[#E2E8F0] before:to-transparent">
                                    {userLogs.map((log, i) => {
                                        const isSystem = log._type === 'system';
                                        
                                        // Format Date & Time
                                        const dateObj = new Date(log.createdAt);
                                        const dateStr = dateObj.toLocaleDateString("tr-TR", { day: 'numeric', month: 'short' });
                                        const timeStr = dateObj.toLocaleTimeString("tr-TR", { hour: '2-digit', minute: '2-digit' });
                                        
                                        // Show date header only if it's the first item or day changed
                                        const prevDateObj = i > 0 ? new Date(userLogs[i-1].createdAt) : null;
                                        const prevDateStr = prevDateObj ? prevDateObj.toLocaleDateString("tr-TR", { day: 'numeric', month: 'short' }) : null;
                                        const showDate = dateStr !== prevDateStr;

                                        return (
                                            <div key={log.id} className="relative mb-6">
                                                {showDate && (
                                                    <div className="flex items-center mb-4">
                                                        <div className="w-[60px] md:w-[88px]" />
                                                        <span className="px-3 py-1 bg-white border border-[#E2E8F0] text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest rounded-full shadow-sm relative z-10 -ml-3">
                                                            {dateStr}
                                                        </span>
                                                    </div>
                                                )}
                                                
                                                <div className="flex items-start gap-4 md:gap-6 group">
                                                    {/* Time */}
                                                    <div className="w-[44px] md:w-[64px] shrink-0 text-right pt-1">
                                                        <span className="text-[11px] font-bold text-[#A0AEC0] font-mono">{timeStr}</span>
                                                    </div>
                                                    
                                                    {/* Node/Dot */}
                                                    <div className="relative shrink-0 flex items-center justify-center w-6 h-6 rounded-full bg-white border-2 border-[#E2E8F0] group-hover:border-[#0A1931] transition-colors z-10 mt-0.5">
                                                        {isSystem ? <Activity size={10} className="text-[#A0AEC0]" /> : <Lock size={10} className="text-[#A0AEC0]" />}
                                                    </div>

                                                    {/* Content Card */}
                                                    <div className="flex-1 bg-white border border-[#E2E8F0] rounded-xl p-4 shadow-sm group-hover:shadow-md transition-shadow">
                                                        {isSystem ? (
                                                            // SYSTEM AUDIT LOG UI
                                                            <div>
                                                                <div className="flex items-center gap-2 mb-2">
                                                                    <span className={`inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-lg ${(actionMeta[log.action] || defaultAction).bg} ${(actionMeta[log.action] || defaultAction).text}`}>
                                                                        {(() => { const Icon = (actionMeta[log.action] || defaultAction).icon; return <Icon size={10} />; })()}
                                                                        {(actionMeta[log.action] || defaultAction).labelTR}
                                                                    </span>
                                                                    <span className="text-xs font-bold text-[#0A1931]">{log.entityType}</span>
                                                                </div>
                                                                {log.entityName && <p className="text-sm font-medium text-[#1B3B6F] mb-1">{log.entityName}</p>}
                                                                {log.details && <p className="text-xs text-[#A9A9A9] truncate max-w-lg">{log.details}</p>}
                                                                <p className="text-[10px] text-[#A0AEC0] mt-2 font-mono flex items-center gap-1"><Globe size={10}/> IP: {log.ipAddress || "Bilinmiyor"}</p>
                                                            </div>
                                                        ) : (
                                                            // SECURITY EVENT LOG UI
                                                            <div>
                                                                <div className="flex items-center gap-2 mb-2">
                                                                    {log.eventType === "LOGIN_SUCCESS" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-lg border border-emerald-100"><Shield size={10} /> Başarılı Giriş</span>}
                                                                    {log.eventType === "SESSION_KICKED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-red-50 text-red-600 text-[10px] font-bold rounded-lg border border-red-100"><AlertTriangle size={10} /> Çoklu Giriş Engellendi</span>}
                                                                    {log.eventType === "LOGIN_FAILED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-orange-50 text-orange-600 text-[10px] font-bold rounded-lg border border-orange-100"><X size={10} /> Hatalı Şifre Denemesi</span>}
                                                                    {log.eventType === "BRUTE_FORCE_DETECTED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-red-100 text-red-700 text-[10px] font-bold rounded-lg border border-red-200"><Shield size={10} /> Şüpheli (Brute Force)</span>}
                                                                </div>
                                                                {log.userAgent && (
                                                                    <div className="flex items-center gap-3 text-xs text-[#1B3B6F] font-medium bg-[#F8FAFC] p-2 rounded-lg border border-[#E2E8F0]">
                                                                        {parseUserAgent(log.userAgent).device === "Mobile" ? <Smartphone size={14} /> : <Monitor size={14} />}
                                                                        <span>{parseUserAgent(log.userAgent).os}</span>
                                                                        <span className="w-1 h-1 rounded-full bg-[#E2E8F0]" />
                                                                        <span className="text-[#A0AEC0]">{parseUserAgent(log.userAgent).browser}</span>
                                                                    </div>
                                                                )}
                                                                <p className="text-[10px] text-[#A0AEC0] mt-2 font-mono flex items-center gap-1"><Globe size={10}/> IP: {log.ipAddress || "Bilinmiyor"}</p>
                                                            </div>
                                                        )}
                                                    </div>
                                                </div>
                                            </div>
                                        );
                                    })}
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
