"use client";

import { useState, useMemo, useEffect, useCallback } from "react";
import {
    CreditCard, Search, Eye, X, DollarSign,
    TrendingUp, TrendingDown, Clock,
    CheckCircle, AlertCircle, ChevronLeft, ChevronRight,
    Download, RefreshCw, ArrowDownRight
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import {
    accountingApi,
    type TransactionDto,
    type AccountingSummaryDto,
} from "@/lib/api";

const TRY = (n: number) =>
    "₺" + Math.abs(n).toLocaleString("tr-TR", { minimumFractionDigits: 0, maximumFractionDigits: 0 });

const statusStyles: Record<string, { bg: string; text: string; dot: string }> = {
    paid: { bg: "bg-emerald-50", text: "text-emerald-700", dot: "bg-emerald-500" },
    pending: { bg: "bg-amber-50", text: "text-amber-700", dot: "bg-amber-500" },
    failed: { bg: "bg-red-50", text: "text-red-700", dot: "bg-red-500" },
    refunded: { bg: "bg-blue-50", text: "text-blue-700", dot: "bg-blue-500" },
};
const statusLabel: Record<string, string> = { paid: "Ödendi", pending: "Bekliyor", failed: "Başarısız", refunded: "İade" };

const typeStyles: Record<string, { bg: string; text: string }> = {
    sale: { bg: "bg-[#E2E8F0]/30", text: "text-[#0A1931]" },
    refund: { bg: "bg-[#E2E8F0]/40", text: "text-[#1B3B6F]" },
    expense: { bg: "bg-amber-50", text: "text-amber-700" },
};
const typeLabel: Record<string, string> = { sale: "Satış", refund: "İade", expense: "Gider" };

const pmLabel: Record<string, string> = { card: "Kart", bank_transfer: "Havale", cash: "Nakit", other: "Diğer" };

const ITEMS_PER_PAGE = 10;

function exportToCsv(transactions: TransactionDto[]) {
    const header = "ID,Tür,Tutar,Açıklama,Kullanıcı,Plan,Durum,Ödeme Yöntemi,Tarih\n";
    const rows = transactions.map(t =>
        [t.id, typeLabel[t.type] ?? t.type, t.amount, `"${t.description ?? ""}"`,
        `"${t.userName ?? ""}"`, `"${t.planName ?? ""}"`,
        statusLabel[t.status] ?? t.status, pmLabel[t.paymentMethod ?? ""] ?? t.paymentMethod ?? "",
        new Date(t.transactionDate).toLocaleDateString("tr-TR")
        ].join(",")
    ).join("\n");
    const blob = new Blob(["\uFEFF" + header + rows], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a"); a.href = url; a.download = "odemeler.csv"; a.click();
    URL.revokeObjectURL(url);
}

export default function PaymentsPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const { error: toastError } = useToast();

    const [transactions, setTransactions] = useState<TransactionDto[]>([]);
    const [summary, setSummary] = useState<AccountingSummaryDto | null>(null);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState("");
    const [statusFilter, setStatusFilter] = useState("all");
    const [typeFilter, setTypeFilter] = useState("all");
    const [page, setPage] = useState(1);
    const [showDetail, setShowDetail] = useState<TransactionDto | null>(null);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const [txList, sumData] = await Promise.all([
                accountingApi.transactions(token, tenantId),
                accountingApi.summary(token, tenantId),
            ]);
            setTransactions(txList);
            setSummary(sumData);
        } catch {
            toastError("Hata", "Ödeme verileri yüklenemedi.");
        } finally {
            setLoading(false);
        }
    }, [token, tenantId]);

    useEffect(() => { load(); }, [token, tenantId]); // eslint-disable-line react-hooks/exhaustive-deps

    const filtered = useMemo(() => {
        return transactions.filter(t => {
            const matchSearch = search === "" ||
                (t.description?.toLowerCase().includes(search.toLowerCase()) ?? false) ||
                (t.userName?.toLowerCase().includes(search.toLowerCase()) ?? false) ||
                (t.invoiceNo?.toLowerCase().includes(search.toLowerCase()) ?? false);
            const matchStatus = statusFilter === "all" || t.status === statusFilter;
            const matchType = typeFilter === "all" || t.type === typeFilter;
            return matchSearch && matchStatus && matchType;
        });
    }, [transactions, search, statusFilter, typeFilter]);

    const totalPages = Math.ceil(filtered.length / ITEMS_PER_PAGE);
    const paginated = filtered.slice((page - 1) * ITEMS_PER_PAGE, page * ITEMS_PER_PAGE);

    return (
        <div className="space-y-6">
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <CreditCard size={24} className="text-green-500" /> Ödemeler
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-1">Finansal işlemleri takip edin</p>
                </div>
                <div className="flex items-center gap-2">
                    <button onClick={load} className="p-2.5 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9]">
                        <RefreshCw size={15} />
                    </button>
                    <button
                        onClick={() => exportToCsv(filtered)}
                        className="px-4 py-2 text-xs font-medium bg-white text-[#1B3B6F] border border-[#E2E8F0] rounded-lg hover:bg-[#E2E8F0]/20 flex items-center gap-1.5"
                    >
                        <Download size={14} /> CSV İndir ({filtered.length})
                    </button>
                </div>
            </div>

            {/* KPI */}
            <div className="grid grid-cols-4 gap-4">
                {[
                    { label: "Toplam Gelir", value: summary ? TRY(summary.totalRevenue) : "—", icon: TrendingUp, color: "text-emerald-600" },
                    { label: "Bekleyen", value: summary ? `${summary.pendingCount} işlem` : "—", icon: Clock, color: "text-amber-600" },
                    { label: "İadeler", value: summary ? TRY(summary.totalRefunds) : "—", icon: ArrowDownRight, color: "text-red-600" },
                    { label: "Toplam İşlem", value: summary ? String(summary.totalTransactions) : "—", icon: CreditCard, color: "text-blue-600" },
                ].map(s => (
                    <div key={s.label} className="bg-white rounded-xl border border-[#E2E8F0]/60 p-4">
                        <div className="flex items-center justify-between mb-2">
                            <div className="w-10 h-10 rounded-xl bg-[#E2E8F0]/20 flex items-center justify-center">
                                <s.icon size={18} className="text-[#A0AEC0]" />
                            </div>
                        </div>
                        <p className={`text-xl font-bold ${s.color}`}>{s.value}</p>
                        <p className="text-xs text-[#A0AEC0]">{s.label}</p>
                    </div>
                ))}
            </div>

            {/* Filters */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 p-4 flex items-center gap-3 flex-wrap">
                <div className="flex-1 relative min-w-[200px]">
                    <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                    <input type="text" placeholder="Açıklama, kullanıcı veya fatura no..." value={search}
                        onChange={e => { setSearch(e.target.value); setPage(1); }}
                        className="w-full pl-9 pr-4 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500/20" />
                </div>
                <select value={typeFilter} onChange={e => { setTypeFilter(e.target.value); setPage(1); }}
                    className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-lg focus:outline-none">
                    <option value="all">Tüm Türler</option>
                    <option value="sale">Satış</option>
                    <option value="refund">İade</option>
                    <option value="expense">Gider</option>
                </select>
                <select value={statusFilter} onChange={e => { setStatusFilter(e.target.value); setPage(1); }}
                    className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-lg focus:outline-none">
                    <option value="all">Tüm Durumlar</option>
                    <option value="paid">Ödendi</option>
                    <option value="pending">Bekliyor</option>
                    <option value="failed">Başarısız</option>
                    <option value="refunded">İade Edildi</option>
                </select>
                <span className="text-xs text-[#A0AEC0] ml-auto">{filtered.length} işlem</span>
            </div>

            {/* Table */}
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 overflow-hidden">
                {loading ? (
                    <div className="p-4 space-y-2">
                        {[...Array(6)].map((_, i) => <div key={i} className="h-14 bg-[#E2E8F0]/40 rounded-xl animate-pulse" />)}
                    </div>
                ) : (
                    <table className="w-full">
                        <thead>
                            <tr className="border-b border-[#E2E8F0]/60 bg-[#E2E8F0]/20/50">
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Fatura No</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Kullanıcı / Plan</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Tür</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Yöntem</th>
                                <th className="text-right px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Tutar</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Durum</th>
                                <th className="text-left px-5 py-3 text-xs font-semibold text-[#A9A9A9]">Tarih</th>
                                <th className="px-3 py-3"></th>
                            </tr>
                        </thead>
                        <tbody>
                            {paginated.length === 0 ? (
                                <tr><td colSpan={8} className="py-16 text-center">
                                    <CreditCard size={40} className="mx-auto text-[#A9A9A9] mb-3" />
                                    <p className="text-sm text-[#A0AEC0] font-medium">İşlem bulunamadı</p>
                                </td></tr>
                            ) : paginated.map(t => {
                                const ss = statusStyles[t.status] ?? statusStyles.pending;
                                const ts = typeStyles[t.type] ?? typeStyles.sale;
                                return (
                                    <tr key={t.id} className="border-b border-[#E2E8F0]/60/60 hover:bg-[#E2E8F0]/20/50 transition-colors">
                                        <td className="px-5 py-3.5 text-xs font-mono text-[#A0AEC0]">{t.invoiceNo || "—"}</td>
                                        <td className="px-5 py-3.5">
                                            <p className="text-sm font-medium text-[#0A1931] truncate max-w-[160px]">{t.userName || t.description || "—"}</p>
                                            {t.planName && <span className="text-[10px] font-semibold px-1.5 py-0.5 rounded bg-[#E2E8F0]/30 text-[#1B3B6F]">{t.planName}</span>}
                                        </td>
                                        <td className="px-5 py-3.5">
                                            <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-lg ${ts.bg} ${ts.text}`}>
                                                {typeLabel[t.type] ?? t.type}
                                            </span>
                                        </td>
                                        <td className="px-5 py-3.5 text-xs text-[#A9A9A9]">{pmLabel[t.paymentMethod ?? ""] ?? t.paymentMethod ?? "—"}</td>
                                        <td className={`px-5 py-3.5 text-sm font-bold text-right ${t.type === "sale" ? "text-emerald-600" : "text-red-500"}`}>
                                            {t.type === "sale" ? "+" : "−"}{TRY(t.amount)}
                                        </td>
                                        <td className="px-5 py-3.5">
                                            <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-lg flex items-center gap-1 w-fit ${ss.bg} ${ss.text}`}>
                                                <span className={`w-1.5 h-1.5 rounded-full ${ss.dot}`} />
                                                {statusLabel[t.status] ?? t.status}
                                            </span>
                                        </td>
                                        <td className="px-5 py-3.5 text-xs text-[#A0AEC0]">
                                            {new Date(t.transactionDate).toLocaleDateString("tr-TR", { day: "numeric", month: "short", year: "2-digit" })}
                                        </td>
                                        <td className="px-3 py-3.5">
                                            <button onClick={() => setShowDetail(t)} className="p-1.5 rounded-lg hover:bg-blue-50 text-[#A0AEC0] hover:text-blue-600">
                                                <Eye size={14} />
                                            </button>
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody>
                    </table>
                )}
            </div>

            {/* Pagination */}
            {totalPages > 1 && (
                <div className="flex items-center justify-center gap-1">
                    <button onClick={() => setPage(p => Math.max(1, p - 1))} disabled={page === 1} className="p-2 rounded-lg hover:bg-white text-[#A0AEC0] disabled:opacity-30">
                        <ChevronLeft size={16} />
                    </button>
                    {Array.from({ length: Math.min(totalPages, 7) }, (_, i) => {
                        const p = totalPages <= 7 ? i + 1 : page <= 4 ? i + 1 : page >= totalPages - 3 ? totalPages - 6 + i : page - 3 + i;
                        return (
                            <button key={p} onClick={() => setPage(p)}
                                className={`w-8 h-8 rounded-lg text-xs font-medium ${p === page ? "bg-green-600 text-white" : "hover:bg-white text-[#A9A9A9]"}`}>
                                {p}
                            </button>
                        );
                    })}
                    <button onClick={() => setPage(p => Math.min(totalPages, p + 1))} disabled={page === totalPages} className="p-2 rounded-lg hover:bg-white text-[#A0AEC0] disabled:opacity-30">
                        <ChevronRight size={16} />
                    </button>
                </div>
            )}

            {/* Detail Panel */}
            {showDetail && (
                <div className="fixed inset-y-0 right-0 z-[90] w-[420px] bg-white shadow-2xl border-l border-[#E2E8F0] overflow-y-auto">
                    <div className="sticky top-0 bg-white z-10 flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]/60">
                        <h2 className="text-lg font-bold text-[#0A1931]">İşlem Detayı</h2>
                        <button onClick={() => setShowDetail(null)} className="p-1.5 rounded-lg hover:bg-[#E2E8F0]/40 text-[#A0AEC0]"><X size={18} /></button>
                    </div>
                    <div className="px-6 py-6 space-y-4">
                        <div className="text-center py-4">
                            <p className={`text-4xl font-black ${showDetail.type === "sale" ? "text-emerald-600" : "text-red-500"}`}>
                                {showDetail.type === "sale" ? "+" : "−"}{TRY(showDetail.amount)}
                            </p>
                            <p className="text-xs text-[#A0AEC0] mt-1">{showDetail.description || "—"}</p>
                        </div>
                        {[
                            { label: "Fatura No", value: showDetail.invoiceNo || "—" },
                            { label: "Tür", value: typeLabel[showDetail.type] ?? showDetail.type },
                            { label: "Durum", value: statusLabel[showDetail.status] ?? showDetail.status },
                            { label: "Ödeme Yöntemi", value: pmLabel[showDetail.paymentMethod ?? ""] ?? showDetail.paymentMethod ?? "—" },
                            { label: "Kullanıcı", value: showDetail.userName || "—" },
                            { label: "Plan", value: showDetail.planName || "—" },
                            { label: "Tarih", value: new Date(showDetail.transactionDate).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric", hour: "2-digit", minute: "2-digit" }) },
                        ].map(r => (
                            <div key={r.label} className="flex items-center justify-between py-2 border-b border-[#E2E8F0]/60 last:border-0">
                                <span className="text-xs text-[#A0AEC0]">{r.label}</span>
                                <span className="text-sm font-medium text-[#0A1931]">{r.value}</span>
                            </div>
                        ))}
                    </div>
                </div>
            )}
        </div>
    );
}
