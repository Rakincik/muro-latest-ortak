"use client";

import { useState, useEffect, useCallback, useMemo } from "react";
import {
    Wallet, TrendingUp, TrendingDown, DollarSign, Receipt,
    Plus, Search, Trash2, X, Filter, RefreshCw, Download,
    ArrowUpRight, ArrowDownRight, Minus, CreditCard,
    Building2, Banknote, CheckCircle2, Clock, AlertTriangle, XCircle,
    Tag, ChevronDown, Edit3, Users, PieChart, CalendarDays
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { ConfirmDialog } from "@/components/confirm-dialog";
import {
    accountingApi,
    type AccountingSummaryDto, type TransactionDto,
    type PlanDto, type CreateTransactionRequest,
} from "@/lib/api";

// ─── Helpers ─────────────────────────────────────────────────────────────────
const TRY = (n: number) => "₺" + n.toLocaleString("tr-TR", { minimumFractionDigits: 0, maximumFractionDigits: 0 });

const TYPE_META: Record<string, { label: string; icon: typeof ArrowUpRight; color: string; sign: string }> = {
    sale: { label: "Satış", icon: ArrowUpRight, color: "emerald", sign: "+" },
    refund: { label: "İade", icon: ArrowDownRight, color: "red", sign: "-" },
    expense: { label: "Gider", icon: Minus, color: "amber", sign: "-" },
};
const STATUS_META: Record<string, { label: string; icon: typeof CheckCircle2; cls: string }> = {
    paid: { label: "Ödendi", icon: CheckCircle2, cls: "bg-emerald-50 text-emerald-700" },
    pending: { label: "Bekliyor", icon: Clock, cls: "bg-amber-50 text-amber-700" },
    failed: { label: "Başarısız", icon: XCircle, cls: "bg-red-50 text-red-600" },
    refunded: { label: "İade", icon: ArrowDownRight, cls: "bg-[#E2E8F0]/40 text-[#1B3B6F]" },
};
const PM_LABEL: Record<string, string> = { card: "Kredi Kartı", bank_transfer: "Havale/EFT", cash: "Nakit", other: "Diğer" };
const CYCLE_LABEL: Record<string, string> = { monthly: "Aylık", quarterly: "3 Aylık", yearly: "Yıllık", onetime: "Tek Seferlik" };
const PLAN_COLORS = ["#6366f1", "#8b5cf6", "#ec4899", "#10b981", "#f59e0b", "#3b82f6", "#ef4444", "#06b6d4"];
const DATE_RANGES: Record<string, { label: string; days: number }> = {
    all: { label: "Tüm Zamanlar", days: 0 },
    "30": { label: "Son 30 Gün", days: 30 },
    "90": { label: "Son 3 Ay", days: 90 },
    "180": { label: "Son 6 Ay", days: 180 },
    "365": { label: "Son 1 Yıl", days: 365 },
};

// ─── Mini Bar Chart ───────────────────────────────────────────────────────────
function BarChart({ data }: { data: AccountingSummaryDto["monthlyRevenue"] }) {
    const maxVal = Math.max(...data.map(d => d.revenue), 1);
    return (
        <div className="flex items-end gap-3 h-40">
            {data.map((d, i) => (
                <div key={d.month} className="flex-1 flex flex-col items-center gap-1.5 group">
                    <div className="w-full flex items-end gap-0.5 h-32 relative">
                        <div className="flex-1 rounded-t-lg transition-all duration-700 relative overflow-hidden"
                            style={{ height: `${(d.revenue / maxVal) * 100}%`, background: "linear-gradient(180deg,#10b981,#059669)" }}>
                            <div className="absolute -top-10 left-1/2 -translate-x-1/2 bg-[#0A1931] text-white text-[9px] font-bold px-2 py-1 rounded-lg whitespace-nowrap opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-10">
                                {TRY(d.revenue)}
                            </div>
                        </div>
                        {d.refunds > 0 && (
                            <div className="w-3 rounded-t-lg transition-all"
                                style={{ height: `${(d.refunds / maxVal) * 100}%`, background: "#fca5a5" }} />
                        )}
                    </div>
                    <span className="text-[10px] font-bold text-[#A0AEC0]">{d.monthLabel}</span>
                </div>
            ))}
        </div>
    );
}

// ─── Payment Method Donut ────────────────────────────────────────────────────
function PaymentMethodChart({ breakdown }: { breakdown: AccountingSummaryDto["paymentMethodBreakdown"] }) {
    const icons: Record<string, typeof CreditCard> = { card: CreditCard, bank_transfer: Building2, cash: Banknote, other: Wallet };
    const colors: Record<string, string> = { card: "#6366f1", bank_transfer: "#10b981", cash: "#f59e0b", other: "#A0AEC0" };

    if (!breakdown || breakdown.length === 0) return <div className="h-32 flex items-center justify-center text-[#A0AEC0] text-sm font-bold">Veri yok</div>;

    return (
        <div className="space-y-3">
            {breakdown.map((pm) => {
                const Icon = icons[pm.method] || Wallet;
                return (
                    <div key={pm.method}>
                        <div className="flex justify-between items-center mb-1">
                            <div className="flex items-center gap-2">
                                <Icon size={14} style={{ color: colors[pm.method] || "#A0AEC0" }} />
                                <span className="text-xs font-bold text-[#1B3B6F]">{pm.label}</span>
                            </div>
                            <div className="flex items-center gap-3">
                                <span className="text-[10px] text-[#A0AEC0]">{pm.count} işlem</span>
                                <span className="text-xs font-black text-[#0A1931]">{TRY(pm.amount)}</span>
                            </div>
                        </div>
                        <div className="h-2 bg-[#E2E8F0]/40 rounded-full overflow-hidden">
                            <div className="h-full rounded-full transition-all duration-700"
                                style={{ width: `${pm.percentage}%`, background: colors[pm.method] || "#A0AEC0" }} />
                        </div>
                    </div>
                );
            })}
        </div>
    );
}

// ─── Plan Revenue Breakdown ──────────────────────────────────────────────────
interface PlanRevenueSlice { planName: string; revenue: number; saleCount: number; color: string; }
function PlanDonut({ data, total }: { data: PlanRevenueSlice[]; total: number }) {
    return (
        <div className="space-y-3">
            {data.map((p, i) => {
                const pct = total > 0 ? (p.revenue / total) * 100 : 0;
                return (
                    <div key={p.planName}>
                        <div className="flex justify-between items-center mb-1">
                            <div className="flex items-center gap-2">
                                <div className="w-2.5 h-2.5 rounded-full" style={{ background: p.color }} />
                                <span className="text-xs font-bold text-[#1B3B6F]">{p.planName}</span>
                            </div>
                            <div className="flex items-center gap-3">
                                <span className="text-[10px] text-[#A0AEC0]">{p.saleCount} satış</span>
                                <span className="text-xs font-black text-[#0A1931]">{TRY(p.revenue)}</span>
                            </div>
                        </div>
                        <div className="h-2 bg-[#E2E8F0]/40 rounded-full overflow-hidden">
                            <div className="h-full rounded-full transition-all duration-700"
                                style={{ width: `${pct}%`, background: p.color }} />
                        </div>
                    </div>
                );
            })}
        </div>
    );
}

// ─── KPI Tile ─────────────────────────────────────────────────────────────────
function KpiTile({ label, value, sub, icon: Icon, color }: {
    label: string; value: string; sub?: string; icon: typeof Wallet; color: string;
}) {
    return (
        <div className="relative overflow-hidden rounded-2xl p-5 bg-white border border-[#E2E8F0] shadow-sm hover:shadow-lg transition-all group">
            <div className="absolute -right-4 -top-4 w-24 h-24 rounded-full opacity-[0.07] group-hover:opacity-[0.12] transition-all"
                style={{ background: color }} />
            <div className="flex items-start justify-between">
                <div>
                    <p className="text-[10px] font-black uppercase tracking-widest text-[#A0AEC0]">{label}</p>
                    <p className="text-2xl font-black text-[#0A1931] mt-2 leading-none">{value}</p>
                    {sub && <p className="text-[10px] font-bold text-[#A0AEC0] mt-1">{sub}</p>}
                </div>
                <div className="w-11 h-11 rounded-xl flex items-center justify-center shadow-md group-hover:scale-110 transition-transform"
                    style={{ background: `${color}18` }}>
                    <Icon size={20} style={{ color }} />
                </div>
            </div>
        </div>
    );
}

// ─── Transaction Form Modal (Create + Edit) ─────────────────────────────────
function TxFormModal({ tx, plans, onClose, onSave }: {
    tx: TransactionDto | null; plans: PlanDto[]; onClose: () => void;
    onSave: (r: CreateTransactionRequest, id?: string) => void;
}) {
    const isEdit = !!tx;
    const [form, setForm] = useState<CreateTransactionRequest>({
        type: tx?.type ?? "sale", amount: tx?.amount ?? 0,
        status: tx?.status ?? "paid", paymentMethod: tx?.paymentMethod ?? "card",
        planId: tx?.planId ?? undefined, description: tx?.description ?? undefined,
        invoiceNo: tx?.invoiceNo ?? undefined, userName: tx?.userName ?? undefined,
    });
    const set = (k: keyof CreateTransactionRequest, v: string | number | undefined) => setForm(p => ({ ...p, [k]: v }));

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={onClose}>
            <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
            <div className="relative w-full max-w-lg bg-white rounded-2xl shadow-2xl" onClick={e => e.stopPropagation()}>
                <div className="flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]">
                    <div>
                        <h2 className="text-lg font-bold text-[#0A1931]">{isEdit ? "İşlemi Düzenle" : "Yeni İşlem"}</h2>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Gelir / İade / Gider</p>
                    </div>
                    <button onClick={onClose} className="p-2 rounded-xl bg-[#E2E8F0]/20 text-[#A0AEC0] hover:text-[#0A1931]"><X size={18} /></button>
                </div>
                <div className="p-6 space-y-4">
                    {/* Type */}
                    <div>
                        <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-2">İşlem Türü</label>
                        <div className="flex gap-2">
                            {(["sale", "refund", "expense"] as const).map(t => (
                                <button key={t} onClick={() => set("type", t)}
                                    className={`flex-1 py-2.5 rounded-xl text-xs font-bold transition-all border ${form.type === t ? "bg-[#0A1931] text-white border-[#0A1931]" : "bg-white text-[#A9A9A9] border-[#E2E8F0] hover:border-[#A0AEC0]"}`}>
                                    {TYPE_META[t].label}
                                </button>
                            ))}
                        </div>
                    </div>
                    {/* Amount + Status */}
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Tutar (₺)</label>
                            <input type="number" value={form.amount || ""} onChange={e => set("amount", parseFloat(e.target.value) || 0)}
                                className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" placeholder="0" />
                        </div>
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Durum</label>
                            <select value={form.status} onChange={e => set("status", e.target.value)}
                                className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none">
                                <option value="paid">Ödendi</option><option value="pending">Bekliyor</option>
                                <option value="failed">Başarısız</option><option value="refunded">İade Edildi</option>
                            </select>
                        </div>
                    </div>
                    {/* Plan + Payment */}
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Plan</label>
                            <select value={form.planId || ""} onChange={e => set("planId", e.target.value || undefined)}
                                className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none">
                                <option value="">— Plan Seçin —</option>
                                {plans.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                            </select>
                        </div>
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Ödeme Yöntemi</label>
                            <select value={form.paymentMethod || ""} onChange={e => set("paymentMethod", e.target.value)}
                                className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none">
                                <option value="card">Kredi Kartı</option><option value="bank_transfer">Havale / EFT</option>
                                <option value="cash">Nakit</option><option value="other">Diğer</option>
                            </select>
                        </div>
                    </div>
                    {/* Invoice + User */}
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Fatura No</label>
                            <input value={form.invoiceNo || ""} onChange={e => set("invoiceNo", e.target.value || undefined)}
                                placeholder="INV-2026-001" className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                        </div>
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Kullanıcı Adı</label>
                            <input value={form.userName || ""} onChange={e => set("userName", e.target.value || undefined)}
                                placeholder="Ahmet Yılmaz" className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                        </div>
                    </div>
                    {/* Description */}
                    <div>
                        <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Açıklama</label>
                        <input value={form.description || ""} onChange={e => set("description", e.target.value || undefined)}
                            placeholder="Örn: Yıllık Paket — Ahmet Yılmaz"
                            className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                    </div>
                </div>
                <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-[#E2E8F0] bg-[#E2E8F0]/10 rounded-b-2xl">
                    <button onClick={onClose} className="px-5 py-2.5 text-xs font-bold text-[#A9A9A9] hover:text-[#0A1931]">İptal</button>
                    <button onClick={() => onSave(form, tx?.id)} disabled={form.amount <= 0}
                        className="px-6 py-2.5 text-sm font-bold text-white bg-[#0A1931] rounded-xl hover:bg-[#1B3B6F] shadow-lg disabled:opacity-40">
                        {isEdit ? "Güncelle" : "Kaydet"}
                    </button>
                </div>
            </div>
        </div>
    );
}

// ─── Plan Form Modal (Create + Edit) ─────────────────────────────────────────
function PlanFormModal({ plan, onClose, onSave }: {
    plan: PlanDto | null; onClose: () => void;
    onSave: (body: any, id?: string) => void;
}) {
    const isEdit = !!plan;
    const [form, setForm] = useState({
        name: plan?.name ?? "", description: plan?.description ?? "",
        price: plan?.price ?? 0, currency: plan?.currency ?? "TRY",
        billingCycle: plan?.billingCycle ?? "monthly", maxStudents: plan?.maxStudents?.toString() ?? "",
        isActive: plan?.isActive ?? true,
    });
    const set = (k: string, v: string | number | boolean) => setForm(p => ({ ...p, [k]: v }));

    return (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={onClose}>
            <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
            <div className="relative w-full max-w-md bg-white rounded-2xl shadow-2xl" onClick={e => e.stopPropagation()}>
                <div className="flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]">
                    <h2 className="text-lg font-bold text-[#0A1931] flex items-center gap-2"><Tag size={16} className="text-[#1B3B6F]" /> {isEdit ? "Planı Düzenle" : "Yeni Plan"}</h2>
                    <button onClick={onClose} className="p-2 rounded-xl bg-[#E2E8F0]/20 text-[#A0AEC0] hover:text-[#0A1931]"><X size={17} /></button>
                </div>
                <div className="p-6 space-y-4">
                    <div>
                        <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Plan Adı</label>
                        <input value={form.name} onChange={e => set("name", e.target.value)} placeholder="Yıllık Paket"
                            className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Fiyat (₺)</label>
                            <input type="number" value={form.price || ""} onChange={e => set("price", parseFloat(e.target.value) || 0)}
                                className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                        </div>
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Dönem</label>
                            <select value={form.billingCycle} onChange={e => set("billingCycle", e.target.value)}
                                className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none">
                                <option value="monthly">Aylık</option><option value="quarterly">3 Aylık</option>
                                <option value="yearly">Yıllık</option><option value="onetime">Tek Seferlik</option>
                            </select>
                        </div>
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                        <div>
                            <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Maks. Öğrenci</label>
                            <input type="number" value={form.maxStudents} onChange={e => set("maxStudents", e.target.value)}
                                placeholder="Sınırsız" className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                        </div>
                        {isEdit && (
                            <div className="flex items-end pb-1">
                                <label className="flex items-center gap-2 cursor-pointer">
                                    <input type="checkbox" checked={form.isActive as boolean} onChange={e => set("isActive", e.target.checked)}
                                        className="w-4 h-4 rounded border-[#E2E8F0] text-[#1B3B6F] focus:ring-[#1B3B6F]/20" />
                                    <span className="text-xs font-bold text-[#1B3B6F]">Aktif Plan</span>
                                </label>
                            </div>
                        )}
                    </div>
                    <div>
                        <label className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest block mb-1.5">Açıklama</label>
                        <input value={form.description} onChange={e => set("description", e.target.value)} placeholder="Plan detayı..."
                            className="w-full px-4 py-2.5 text-sm font-bold bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" />
                    </div>
                </div>
                <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-[#E2E8F0] bg-[#E2E8F0]/10 rounded-b-2xl">
                    <button onClick={onClose} className="px-5 py-2.5 text-xs font-bold text-[#A9A9A9]">İptal</button>
                    <button onClick={() => onSave({ name: form.name, description: form.description || null, price: form.price, currency: form.currency, billingCycle: form.billingCycle, maxStudents: form.maxStudents ? parseInt(form.maxStudents) : null, isActive: form.isActive }, plan?.id)}
                        disabled={!form.name || form.price <= 0}
                        className="px-6 py-2.5 text-sm font-bold text-white bg-[#0A1931] rounded-xl hover:bg-[#1B3B6F] shadow-lg disabled:opacity-40">
                        {isEdit ? "Güncelle" : "Oluştur"}
                    </button>
                </div>
            </div>
        </div>
    );
}

// ─── CSV Export ───────────────────────────────────────────────────────────────
function exportCSV(txs: TransactionDto[]) {
    const header = "Tarih,Tür,Açıklama,Kullanıcı,Plan,Tutar,Durum,Ödeme Yöntemi,Fatura No\n";
    const rows = txs.map(t =>
        `"${new Date(t.transactionDate).toLocaleDateString("tr-TR")}","${TYPE_META[t.type]?.label ?? t.type}","${t.description ?? ""}","${t.userName ?? ""}","${t.planName ?? ""}","${t.amount}","${STATUS_META[t.status]?.label ?? t.status}","${PM_LABEL[t.paymentMethod ?? ""] ?? t.paymentMethod ?? ""}","${t.invoiceNo ?? ""}"`
    ).join("\n");
    const blob = new Blob(["\uFEFF" + header + rows], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a"); a.href = url; a.download = `muhasebe_${new Date().toISOString().slice(0, 10)}.csv`; a.click();
    URL.revokeObjectURL(url);
}

// ─── MAIN PAGE ────────────────────────────────────────────────────────────────
export default function AccountingPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [summary, setSummary] = useState<AccountingSummaryDto | null>(null);
    const [transactions, setTxs] = useState<TransactionDto[]>([]);
    const [plans, setPlans] = useState<PlanDto[]>([]);
    const [loading, setLoading] = useState(true);

    // Filters
    const [search, setSearch] = useState("");
    const [typeFilter, setTypeFilter] = useState("all");
    const [statusFilter, setStatusFilter] = useState("all");
    const [planFilter, setPlanFilter] = useState("all");
    const [dateRange, setDateRange] = useState("all");

    // UI
    const [activeTab, setActiveTab] = useState<"transactions" | "plans">("transactions");
    const [showTxForm, setShowTxForm] = useState(false);
    const [editTx, setEditTx] = useState<TransactionDto | null>(null);
    const [showPlanForm, setShowPlanForm] = useState(false);
    const [editPlan, setEditPlan] = useState<PlanDto | null>(null);
    const [deleteTxId, setDeleteTxId] = useState<string | null>(null);
    const [deletePlanId, setDeletePlanId] = useState<string | null>(null);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const [sum, txList, planList] = await Promise.all([
                accountingApi.summary(token, tenantId),
                accountingApi.transactions(token, tenantId),
                accountingApi.plans(token, tenantId),
            ]);
            setSummary(sum); setTxs(txList); setPlans(planList);
        } catch { toastError("Hata", "Muhasebe verileri yüklenemedi."); }
        finally { setLoading(false); }
    }, [token, tenantId]);

    useEffect(() => { load(); }, [token, tenantId]); // eslint-disable-line react-hooks/exhaustive-deps

    // Filtering with date range
    const filteredTxs = useMemo(() => {
        const now = Date.now();
        return transactions.filter(t => {
            const ms = !search || (t.description?.toLowerCase().includes(search.toLowerCase()) ?? false) || (t.userName?.toLowerCase().includes(search.toLowerCase()) ?? false) || (t.invoiceNo?.toLowerCase().includes(search.toLowerCase()) ?? false);
            const mt = typeFilter === "all" || t.type === typeFilter;
            const mst = statusFilter === "all" || t.status === statusFilter;
            const mp = planFilter === "all" || t.planId === planFilter;
            const dr = DATE_RANGES[dateRange];
            const md = !dr || dr.days === 0 || (now - new Date(t.transactionDate).getTime()) <= dr.days * 86400000;
            return ms && mt && mst && mp && md;
        });
    }, [transactions, search, typeFilter, statusFilter, planFilter, dateRange]);

    // Pending payments alert — use backend values
    const pendingTotal = summary?.pendingTotal ?? 0;
    const pendingTxs = transactions.filter(t => t.status === "pending");
    const handleSaveTx = async (req: CreateTransactionRequest, id?: string) => {
        if (!token || !tenantId) return;
        try {
            if (id) {
                const updated = await accountingApi.updateTransaction(token, tenantId, id, req);
                setTxs(prev => prev.map(t => t.id === id ? updated : t));
                success("İşlem güncellendi");
            } else {
                const created = await accountingApi.createTransaction(token, tenantId, req);
                setTxs(prev => [created, ...prev]);
                success("İşlem eklendi");
            }
            setShowTxForm(false); setEditTx(null); load();
        } catch { toastError("Hata", "İşlem kaydedilemedi."); }
    };

    const handleDeleteTx = async () => {
        if (!token || !tenantId || !deleteTxId) return;
        try {
            await accountingApi.deleteTransaction(token, tenantId, deleteTxId);
            setTxs(prev => prev.filter(t => t.id !== deleteTxId));
            setDeleteTxId(null); success("İşlem silindi"); load();
        } catch { toastError("Hata", "Silinemedi."); }
    };

    const handleSavePlan = async (body: any, id?: string) => {
        if (!token || !tenantId) return;
        try {
            if (id) {
                const updated = await accountingApi.updatePlan(token, tenantId, id, body);
                setPlans(prev => prev.map(p => p.id === id ? updated : p));
                success("Plan güncellendi");
            } else {
                const created = await accountingApi.createPlan(token, tenantId, body);
                setPlans(prev => [...prev, created]);
                success("Plan oluşturuldu");
            }
            setShowPlanForm(false); setEditPlan(null);
        } catch { toastError("Hata", "Plan kaydedilemedi."); }
    };

    const handleDeletePlan = async () => {
        if (!token || !tenantId || !deletePlanId) return;
        try {
            await accountingApi.deletePlan(token, tenantId, deletePlanId);
            setPlans(prev => prev.filter(p => p.id !== deletePlanId));
            setDeletePlanId(null); success("Plan silindi");
        } catch { toastError("Hata", "Silinemedi."); }
    };

    const totalRevenue = summary?.totalRevenue ?? 0;
    const totalRefunds = summary?.totalRefunds ?? 0;
    const totalExpenses = summary?.totalExpenses ?? 0;
    const netRevenue = summary?.netRevenue ?? 0;

    // MRR: from backend
    const mrr = summary?.last3MonthAvgRevenue ?? 0;

    // Revenue growth: compare last 2 months
    const revenueGrowth = useMemo(() => {
        const monthlyRev = summary?.monthlyRevenue ?? [];
        if (monthlyRev.length < 2) return null;
        const curr = monthlyRev[monthlyRev.length - 1].revenue;
        const prev = monthlyRev[monthlyRev.length - 2].revenue;
        if (prev === 0) return null;
        return Math.round(((curr - prev) / prev) * 100);
    }, [summary]);

    // Filtered stats
    const filteredSaleTotal = filteredTxs.filter(t => t.type === "sale").reduce((s, t) => s + t.amount, 0);
    const filteredRefundTotal = filteredTxs.filter(t => t.type === "refund" || t.type === "expense").reduce((s, t) => s + t.amount, 0);

    return (
        <div className="flex flex-col gap-6 pb-10">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] tracking-tight flex items-center gap-2">
                        Muhasebe <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-500 to-teal-500">Merkez</span>
                    </h1>
                    <p className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-widest mt-0.5">Gelir · İade · Gider · Plan Yönetimi</p>
                </div>
                <div className="flex items-center gap-2">
                    <button onClick={() => exportCSV(filteredTxs)} className="p-2.5 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9]" title="CSV İndir">
                        <Download size={15} />
                    </button>
                    <button onClick={load} className="p-2.5 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9]"><RefreshCw size={15} /></button>
                    <button onClick={() => { setEditPlan(null); setShowPlanForm(true); }} className="px-4 py-2.5 text-xs font-bold text-[#1B3B6F] bg-white border border-[#E2E8F0] rounded-xl hover:bg-[#E2E8F0]/20 flex items-center gap-2">
                        <Tag size={14} /> Plan Ekle
                    </button>
                    <button onClick={() => { setEditTx(null); setShowTxForm(true); }} className="px-4 py-2.5 text-xs font-bold bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 flex items-center gap-2 shadow-lg shadow-emerald-500/20">
                        <Plus size={14} /> İşlem Ekle
                    </button>
                </div>
            </div>

            {/* Pending Payment Alert */}
            {pendingTxs.length > 0 && (
                <div className="bg-amber-50 border border-amber-200 rounded-xl overflow-hidden">
                    <div className="flex items-center gap-3 p-4">
                        <AlertTriangle size={18} className="text-amber-500 flex-shrink-0" />
                        <div className="flex-1">
                            <p className="text-sm text-amber-700 font-bold">
                                {pendingTxs.length} bekleyen ödeme — toplam {TRY(pendingTotal)}
                            </p>
                            <div className="flex flex-wrap gap-2 mt-1.5">
                                {pendingTxs.slice(0, 5).map(t => (
                                    <span key={t.id} className="text-[10px] font-bold px-2 py-0.5 bg-amber-100 text-amber-700 rounded-lg">
                                        {t.userName || t.description || 'İsimsiz'} — {TRY(t.amount)}
                                    </span>
                                ))}
                                {pendingTxs.length > 5 && <span className="text-[10px] text-amber-600">+{pendingTxs.length - 5} daha</span>}
                            </div>
                        </div>
                        <button onClick={() => { setStatusFilter("pending"); setActiveTab("transactions"); }}
                            className="px-3 py-1.5 text-xs font-bold text-amber-700 bg-amber-100 rounded-lg hover:bg-amber-200 flex-shrink-0">
                            Görüntüle →
                        </button>
                    </div>
                </div>
            )}

            {/* KPI Tiles */}
            <div className="grid grid-cols-2 xl:grid-cols-5 gap-4">
                <KpiTile label="Toplam Gelir" value={TRY(totalRevenue)} sub={`${summary?.paidCount ?? 0} ödenen işlem`} icon={TrendingUp} color="#10b981" />
                <KpiTile label="Net Gelir" value={TRY(netRevenue)} sub="Gelir − İade − Gider" icon={DollarSign} color="#6366f1" />
                <KpiTile label="Aylık Ort. (MRR)" value={TRY(mrr)} sub={revenueGrowth !== null ? `${revenueGrowth > 0 ? '↑' : '↓'} ${Math.abs(revenueGrowth)}% geçen aya göre` : 'Son 3 ay ortalaması'} icon={CalendarDays} color="#06b6d4" />
                <KpiTile label="İade / Gider" value={TRY(totalRefunds + totalExpenses)} sub={`${TRY(totalRefunds)} iade, ${TRY(totalExpenses)} gider`} icon={TrendingDown} color="#ef4444" />
                <KpiTile label="Toplam İşlem" value={String(summary?.totalTransactions ?? 0)} sub={`${summary?.pendingCount ?? 0} bekliyor, ${summary?.failedCount ?? 0} başarısız`} icon={Receipt} color="#f59e0b" />
            </div>

            {/* Charts Row */}
            <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
                {/* Monthly Revenue */}
                <div className="xl:col-span-1 bg-white rounded-2xl border border-[#E2E8F0] p-6">
                    <div className="flex items-center justify-between mb-5">
                        <div>
                            <h3 className="text-sm font-bold text-[#0A1931]">Aylık Gelir</h3>
                            <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mt-0.5">Son 12 Ay</p>
                        </div>
                        <div className="flex items-center gap-3 text-[10px] text-[#A0AEC0] font-bold">
                            <span className="flex items-center gap-1"><span className="w-3 h-3 rounded" style={{ background: "#10b981" }} /> Gelir</span>
                            <span className="flex items-center gap-1"><span className="w-3 h-3 rounded bg-red-200" /> İade</span>
                        </div>
                    </div>
                    {loading ? <div className="h-40 bg-[#E2E8F0]/20 rounded-xl animate-pulse" /> :
                        summary?.monthlyRevenue?.length ? <BarChart data={summary.monthlyRevenue} /> :
                            <div className="h-40 flex items-center justify-center text-[#A0AEC0] text-sm">Veri yok</div>}
                </div>

                {/* Plan Breakdown */}
                <div className="bg-white rounded-2xl border border-[#E2E8F0] p-6">
                    <div className="mb-5">
                        <h3 className="text-sm font-bold text-[#0A1931]">Plan Kırılımı</h3>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mt-0.5">Pakete Göre Gelir</p>
                    </div>
                    {loading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-8 bg-[#E2E8F0]/20 rounded-xl animate-pulse" />)}</div> :
                        summary?.planBreakdown?.length ? <PlanDonut data={summary.planBreakdown} total={totalRevenue} /> :
                            <div className="h-32 flex items-center justify-center text-[#A0AEC0] text-sm">Veri yok</div>}
                </div>

                {/* Payment Method Distribution */}
                <div className="bg-white rounded-2xl border border-[#E2E8F0] p-6">
                    <div className="mb-5">
                        <h3 className="text-sm font-bold text-[#0A1931]">Ödeme Yöntemi</h3>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mt-0.5">Dağılım</p>
                    </div>
                    {loading ? <div className="space-y-3">{[...Array(3)].map((_, i) => <div key={i} className="h-8 bg-[#E2E8F0]/20 rounded-xl animate-pulse" />)}</div> :
                        <PaymentMethodChart breakdown={summary?.paymentMethodBreakdown ?? []} />}
                </div>
            </div>

            {/* Status Row */}
            {summary && (
                <div className="grid grid-cols-4 gap-3">
                    {[
                        { label: "Ödendi", val: summary.paidCount, cls: "border-emerald-200 bg-emerald-50 text-emerald-700", icon: CheckCircle2 },
                        { label: "Bekliyor", val: summary.pendingCount, cls: "border-amber-200 bg-amber-50 text-amber-700", icon: Clock },
                        { label: "Başarısız", val: summary.failedCount, cls: "border-red-200 bg-red-50 text-red-600", icon: AlertTriangle },
                        { label: "Toplam", val: summary.totalTransactions, cls: "border-[#E2E8F0] bg-white text-[#1B3B6F]", icon: Receipt },
                    ].map(s => (
                        <div key={s.label} className={`flex items-center gap-3 px-4 py-3 rounded-xl border ${s.cls}`}>
                            <s.icon size={16} />
                            <div>
                                <p className="text-lg font-bold leading-none">{s.val}</p>
                                <p className="text-[9px] font-bold uppercase tracking-widest">{s.label}</p>
                            </div>
                        </div>
                    ))}
                </div>
            )}

            {/* Tabs */}
            <div className="flex items-center gap-1 bg-[#E2E8F0]/40 p-1 rounded-xl w-fit">
                {(["transactions", "plans"] as const).map(t => (
                    <button key={t} onClick={() => setActiveTab(t)}
                        className={`px-5 py-2 rounded-lg text-xs font-bold transition-all ${activeTab === t ? "bg-white text-[#0A1931] shadow-sm" : "text-[#A0AEC0] hover:text-[#1B3B6F]"}`}>
                        {t === "transactions" ? "İşlemler" : "Planlar"}
                    </button>
                ))}
            </div>

            {/* Transactions Tab */}
            {activeTab === "transactions" && (
                <div className="bg-white rounded-2xl border border-[#E2E8F0] overflow-hidden">
                    {/* Filter Bar */}
                    <div className="flex items-center gap-3 px-6 py-4 border-b border-[#E2E8F0] flex-wrap">
                        <div className="relative flex-1 min-w-[160px]">
                            <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                            <input value={search} onChange={e => setSearch(e.target.value)} placeholder="Ara..."
                                className="w-full pl-9 pr-4 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/10" />
                        </div>
                        <select value={typeFilter} onChange={e => setTypeFilter(e.target.value)}
                            className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                            <option value="all">Tüm Türler</option>
                            <option value="sale">Satış</option><option value="refund">İade</option><option value="expense">Gider</option>
                        </select>
                        <select value={statusFilter} onChange={e => setStatusFilter(e.target.value)}
                            className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                            <option value="all">Tüm Durumlar</option>
                            <option value="paid">Ödendi</option><option value="pending">Bekliyor</option>
                            <option value="failed">Başarısız</option><option value="refunded">İade</option>
                        </select>
                        <select value={planFilter} onChange={e => setPlanFilter(e.target.value)}
                            className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                            <option value="all">Tüm Planlar</option>
                            {plans.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                        </select>
                        <select value={dateRange} onChange={e => setDateRange(e.target.value)}
                            className="px-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none text-[#1B3B6F]">
                            {Object.entries(DATE_RANGES).map(([k, v]) => <option key={k} value={k}>{v.label}</option>)}
                        </select>
                        <span className="text-xs font-bold text-[#A0AEC0] ml-auto">{filteredTxs.length} işlem</span>
                    </div>

                    {/* Filtered Summary Bar */}
                    {(search || typeFilter !== "all" || statusFilter !== "all" || planFilter !== "all" || dateRange !== "all") && filteredTxs.length > 0 && (
                        <div className="flex items-center gap-4 px-6 py-2.5 bg-[#E2E8F0]/10 border-b border-[#E2E8F0]">
                            <span className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Filtreli Özet:</span>
                            {filteredSaleTotal > 0 && <span className="text-xs font-bold text-emerald-600">+{TRY(filteredSaleTotal)} gelir</span>}
                            {filteredRefundTotal > 0 && <span className="text-xs font-bold text-red-500">−{TRY(filteredRefundTotal)} gider/iade</span>}
                            <span className={`text-xs font-bold ${filteredSaleTotal - filteredRefundTotal >= 0 ? "text-[#1B3B6F]" : "text-red-600"}`}>
                                Net: {TRY(filteredSaleTotal - filteredRefundTotal)}
                            </span>
                        </div>
                    )}

                    {/* List */}
                    <div className="divide-y divide-[#E2E8F0]">
                        {loading ? [...Array(5)].map((_, i) => <div key={i} className="h-14 mx-6 my-2 bg-[#E2E8F0]/20 rounded-xl animate-pulse" />) :
                            filteredTxs.length === 0 ? (
                                <div className="py-16 flex flex-col items-center gap-3 text-[#A0AEC0]">
                                    <Receipt size={40} strokeWidth={1} /><p className="text-sm font-bold">İşlem bulunamadı</p>
                                </div>
                            ) : filteredTxs.map(t => {
                                const tm = TYPE_META[t.type] ?? { label: t.type, color: "gray", sign: "", icon: Receipt };
                                const sm = STATUS_META[t.status] ?? { label: t.status, cls: "bg-[#E2E8F0]/40 text-[#1B3B6F]", icon: Clock };
                                return (
                                    <div key={t.id} className="flex items-center gap-4 px-6 py-3.5 hover:bg-[#E2E8F0]/10 transition-colors group">
                                        <div className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 ${t.type === "sale" ? "bg-emerald-50 text-emerald-600" : t.type === "refund" ? "bg-red-50 text-red-500" : "bg-amber-50 text-amber-600"}`}>
                                            <tm.icon size={16} />
                                        </div>
                                        <div className="flex-1 min-w-0">
                                            <p className="text-sm font-bold text-[#0A1931] truncate">{t.description || "—"}</p>
                                            <div className="flex items-center gap-2 mt-0.5 flex-wrap">
                                                {t.invoiceNo && <span className="text-[9px] font-mono text-[#A0AEC0]">{t.invoiceNo}</span>}
                                                {t.userName && <span className="text-[10px] font-bold text-[#A0AEC0]">{t.userName}</span>}
                                                {t.planName && <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-[#E2E8F0]/30 text-[#1B3B6F]">{t.planName}</span>}
                                            </div>
                                        </div>
                                        {t.paymentMethod && (
                                            <div className="hidden sm:flex items-center gap-1 text-[10px] font-bold text-[#A0AEC0]">
                                                {t.paymentMethod === "card" ? <CreditCard size={12} /> : t.paymentMethod === "bank_transfer" ? <Building2 size={12} /> : <Banknote size={12} />}
                                                {PM_LABEL[t.paymentMethod] ?? t.paymentMethod}
                                            </div>
                                        )}
                                        <span className={`text-[10px] font-bold px-2.5 py-1 rounded-lg ${sm.cls}`}>{sm.label}</span>
                                        <span className="text-xs text-[#A0AEC0] hidden md:block">
                                            {new Date(t.transactionDate).toLocaleDateString("tr-TR", { day: "numeric", month: "short" })}
                                        </span>
                                        <span className={`text-base font-bold ${t.type === "sale" ? "text-emerald-600" : "text-red-500"}`}>
                                            {t.type === "sale" ? "+" : "−"}{TRY(t.amount)}
                                        </span>
                                        <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                            <button onClick={() => { setEditTx(t); setShowTxForm(true); }}
                                                className="p-1.5 rounded-lg text-[#A0AEC0] hover:text-[#1B3B6F] hover:bg-[#E2E8F0]/20"><Edit3 size={13} /></button>
                                            <button onClick={() => setDeleteTxId(t.id)}
                                                className="p-1.5 rounded-lg text-[#A0AEC0] hover:text-red-500 hover:bg-red-50"><Trash2 size={13} /></button>
                                        </div>
                                    </div>
                                );
                            })}
                    </div>
                </div>
            )}

            {/* Plans Tab */}
            {activeTab === "plans" && (
                <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
                    {loading ? [...Array(3)].map((_, i) => <div key={i} className="h-40 rounded-2xl bg-[#E2E8F0]/40 animate-pulse" />) :
                        plans.length === 0 ? (
                            <div className="col-span-3 py-20 flex flex-col items-center gap-3 text-[#A0AEC0]">
                                <Tag size={40} strokeWidth={1} /><p className="text-sm font-bold">Henüz plan yok</p>
                            </div>
                        ) : plans.map((p, i) => (
                            <div key={p.id} className={`relative bg-white rounded-2xl border p-6 hover:shadow-lg transition-all group overflow-hidden ${p.isActive ? "border-[#E2E8F0]" : "border-red-200 opacity-60"}`}>
                                <div className="absolute top-0 right-0 w-32 h-32 rounded-full opacity-[0.06] -mr-10 -mt-10"
                                    style={{ background: PLAN_COLORS[i % PLAN_COLORS.length] }} />
                                <div className="flex items-start justify-between mb-4">
                                    <div className="w-10 h-10 rounded-xl flex items-center justify-center"
                                        style={{ background: `${PLAN_COLORS[i % PLAN_COLORS.length]}18` }}>
                                        <Tag size={18} style={{ color: PLAN_COLORS[i % PLAN_COLORS.length] }} />
                                    </div>
                                    <div className="flex items-center gap-1">
                                        {!p.isActive && <span className="text-[9px] font-bold px-2 py-0.5 rounded-full bg-red-50 text-red-500 border border-red-200">Pasif</span>}
                                        <button onClick={() => { setEditPlan(p); setShowPlanForm(true); }}
                                            className="opacity-0 group-hover:opacity-100 p-1.5 rounded-lg text-[#A0AEC0] hover:text-[#1B3B6F] hover:bg-[#E2E8F0]/20"><Edit3 size={14} /></button>
                                        <button onClick={() => setDeletePlanId(p.id)}
                                            className="opacity-0 group-hover:opacity-100 p-1.5 rounded-lg text-[#A0AEC0] hover:text-red-500 hover:bg-red-50"><Trash2 size={14} /></button>
                                    </div>
                                </div>
                                <h3 className="text-base font-bold text-[#0A1931]">{p.name}</h3>
                                {p.description && <p className="text-xs text-[#A0AEC0] mt-0.5">{p.description}</p>}
                                <div className="mt-4 pt-4 border-t border-[#E2E8F0] flex items-end justify-between">
                                    <div>
                                        <p className="text-2xl font-bold text-[#0A1931]">{TRY(p.price)}</p>
                                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest mt-0.5">
                                            {CYCLE_LABEL[p.billingCycle] ?? p.billingCycle} · {p.currency}
                                        </p>
                                    </div>
                                    <div className="text-right">
                                        <p className="text-lg font-bold" style={{ color: PLAN_COLORS[i % PLAN_COLORS.length] }}>{p.transactionCount}</p>
                                        <p className="text-[9px] font-bold text-[#A0AEC0] uppercase tracking-widest">Satış</p>
                                    </div>
                                </div>
                                {p.maxStudents && <div className="mt-3 text-[10px] font-bold text-[#A0AEC0]">Maks. {p.maxStudents} öğrenci</div>}
                            </div>
                        ))}
                </div>
            )}

            {/* Modals */}
            {showTxForm && <TxFormModal tx={editTx} plans={plans} onClose={() => { setShowTxForm(false); setEditTx(null); }} onSave={handleSaveTx} />}
            {showPlanForm && <PlanFormModal plan={editPlan} onClose={() => { setShowPlanForm(false); setEditPlan(null); }} onSave={handleSavePlan} />}
            <ConfirmDialog open={deleteTxId !== null} onClose={() => setDeleteTxId(null)} onConfirm={handleDeleteTx} title="İşlemi Sil" message="Bu işlem kalıcı olarak silinecek." />
            <ConfirmDialog open={deletePlanId !== null} onClose={() => setDeletePlanId(null)} onConfirm={handleDeletePlan} title="Planı Sil" message="Bu plan kalıcı olarak silinecek." />
        </div>
    );
}
