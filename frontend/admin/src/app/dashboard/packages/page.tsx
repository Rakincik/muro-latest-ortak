"use client";

import { useState, useEffect, useCallback } from "react";
import {
    Package, Plus, Edit3, Trash2, X, Search, Users,
    Copy, Eye, EyeOff, Loader2, RefreshCw, Zap,
    ChevronDown, ChevronUp, Webhook, BookOpen, Play, Video, LayoutGrid,
    CheckCircle,
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import {
    packageApi, groupsApi,
    type PackageDto, type CreatePackageRequest, type WebhookInfo,
    type GroupListDto,
} from "@/lib/api";

// ── Sabitler ──────────────────────────────────────────────────────────────────

const CONTENT_MODES = [
    { value: "Both", label: "Canlı + Video", icon: LayoutGrid, color: "#6366f1" },
    { value: "Online", label: "Sadece Canlı", icon: Play, color: "#10b981" },
    { value: "Offline", label: "Sadece Video", icon: Video, color: "#3b82f6" },
];

// ── Yardımcı Bileşenler ───────────────────────────────────────────────────────

function StatCard({ icon: Icon, label, value, color }: {
    icon: React.ElementType; label: string; value: string | number; color: string;
}) {
    return (
        <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 p-5 flex items-center gap-4 shadow-sm">
            <div className="w-12 h-12 rounded-xl flex items-center justify-center" style={{ background: `${color}18` }}>
                <Icon size={22} style={{ color }} />
            </div>
            <div>
                <p className="text-sm text-[#A9A9A9]">{label}</p>
                <p className="text-2xl font-bold text-[#0A1931]">{value}</p>
            </div>
        </div>
    );
}

function ContentModeChip({ mode }: { mode: string }) {
    const m = CONTENT_MODES.find(x => x.value === mode) ?? CONTENT_MODES[0];
    return (
        <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium"
            style={{ background: `${m.color}18`, color: m.color }}>
            <m.icon size={11} />
            {m.label}
        </span>
    );
}

// ── Paket Kartı ───────────────────────────────────────────────────────────────

function PackageCard({ pkg, onEdit, onDelete }: {
    pkg: PackageDto;
    onEdit: (p: PackageDto) => void;
    onDelete: (p: PackageDto) => void;
}) {
    const [expanded, setExpanded] = useState(false);

    return (
        <div className={`bg-white rounded-2xl border shadow-sm transition-all ${pkg.isActive ? "border-[#E2E8F0]/60" : "border-[#E2E8F0] opacity-60"}`}>
            <div className="p-5">
                <div className="flex items-start justify-between gap-3">
                    <div className="flex items-center gap-3 flex-1 min-w-0">
                        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-[#1B3B6F] to-[#0A1931] flex items-center justify-center flex-shrink-0">
                            <Package size={18} className="text-white" />
                        </div>
                        <div className="min-w-0">
                            <div className="flex items-center gap-2">
                                <h3 className="font-bold text-[#0A1931] truncate">{pkg.name}</h3>
                                {!pkg.isActive && (
                                    <span className="px-2 py-0.5 bg-[#E2E8F0]/40 text-[#A9A9A9] rounded-full text-xs">Pasif</span>
                                )}
                            </div>
                            {pkg.description && (
                                <p className="text-sm text-[#A9A9A9] truncate mt-0.5">{pkg.description}</p>
                            )}
                        </div>
                    </div>
                    <div className="flex items-center gap-2 flex-shrink-0">
                        <button onClick={() => onEdit(pkg)}
                            className="p-2 rounded-xl border border-[#E2E8F0] text-[#A9A9A9] hover:text-[#1B3B6F] hover:border-[#E2E8F0] hover:bg-[#E2E8F0]/30 transition-all">
                            <Edit3 size={15} />
                        </button>
                        <button onClick={() => onDelete(pkg)}
                            className="p-2 rounded-xl border border-[#E2E8F0] text-[#A9A9A9] hover:text-red-600 hover:border-red-200 hover:bg-red-50 transition-all">
                            <Trash2 size={15} />
                        </button>
                    </div>
                </div>

                <div className="mt-4 grid grid-cols-3 gap-3">
                    <div className="bg-[#E2E8F0]/20 rounded-xl p-3">
                        <p className="text-xs text-[#A0AEC0] mb-0.5">Fiyat</p>
                        <p className="font-bold text-[#0A1931]">
                            {pkg.price.toLocaleString("tr-TR", { style: "currency", currency: "TRY" })}
                        </p>
                    </div>
                    <div className="bg-[#E2E8F0]/20 rounded-xl p-3">
                        <p className="text-xs text-[#A0AEC0] mb-0.5">Süre</p>
                        <p className="font-bold text-[#0A1931]">
                            {pkg.durationDays === 0 ? "Sınırsız" : `${pkg.durationDays} gün`}
                        </p>
                    </div>
                    <div className="bg-[#E2E8F0]/20 rounded-xl p-3">
                        <p className="text-xs text-[#A0AEC0] mb-0.5">Aktif Üye</p>
                        <p className="font-bold text-[#1B3B6F]">{pkg.activeUserCount}</p>
                    </div>
                </div>
            </div>

            {pkg.groups.length > 0 && (
                <div className="border-t border-[#E2E8F0]/60 px-5 pb-4 pt-3">
                    <button
                        onClick={() => setExpanded(!expanded)}
                        className="flex items-center justify-between w-full text-sm text-[#A9A9A9] hover:text-[#1B3B6F] transition-colors"
                    >
                        <span className="font-medium">Grup Atamaları ({pkg.groups.length})</span>
                        {expanded ? <ChevronUp size={15} /> : <ChevronDown size={15} />}
                    </button>
                    {expanded && (
                        <div className="mt-3 space-y-2">
                            {pkg.groups.map(g => (
                                <div key={g.id} className="flex items-center justify-between bg-[#E2E8F0]/20 rounded-xl px-3 py-2">
                                    <div className="flex items-center gap-2">
                                        <Users size={13} className="text-[#A0AEC0]" />
                                        <span className="text-sm font-medium text-[#1B3B6F]">{g.groupName}</span>
                                    </div>
                                    <ContentModeChip mode={g.contentMode} />
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}

// ── Paket Modal ───────────────────────────────────────────────────────────────

function PackageModal({
    pkg, groups, token, tenantId, onClose, onSaved,
}: {
    pkg: PackageDto | null;
    groups: GroupListDto[];
    token: string; tenantId: string;
    onClose: () => void;
    onSaved: () => void;
}) {
    const { toast } = useToast();
    const [saving, setSaving] = useState(false);
    const [form, setForm] = useState({
        name: pkg?.name ?? "",
        description: pkg?.description ?? "",
        price: pkg?.price ?? 0,
        durationDays: pkg?.durationDays ?? 30,
        isActive: pkg?.isActive ?? true,
        groups: pkg?.groups.map(g => ({ groupId: g.groupId, contentMode: g.contentMode })) ?? [],
    });

    const toggleGroup = (groupId: string) => {
        setForm(f => {
            const exists = f.groups.find(g => g.groupId === groupId);
            if (exists) return { ...f, groups: f.groups.filter(g => g.groupId !== groupId) };
            return { ...f, groups: [...f.groups, { groupId, contentMode: "Both" }] };
        });
    };

    const setMode = (groupId: string, contentMode: string) => {
        setForm(f => ({
            ...f,
            groups: f.groups.map(g => g.groupId === groupId ? { ...g, contentMode } : g),
        }));
    };

    const handleSave = async () => {
        if (!form.name.trim()) { toast("error", "Paket adı zorunludur."); return; }
        setSaving(true);
        try {
            const data: CreatePackageRequest = {
                name: form.name.trim(),
                description: form.description.trim() || undefined,
                price: Number(form.price),
                durationDays: Number(form.durationDays),
                groups: form.groups,
            };
            if (pkg) {
                await packageApi.update(token, tenantId, pkg.id, { ...data, isActive: form.isActive });
            } else {
                await packageApi.create(token, tenantId, data);
            }
            toast("success", pkg ? "Paket güncellendi." : "Paket oluşturuldu.");
            onSaved();
        } catch {
            toast("error", "İşlem başarısız.");
        } finally {
            setSaving(false);
        }
    };

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
            <div className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col">
                <div className="flex items-center justify-between px-6 py-5 border-b border-[#E2E8F0]/60">
                    <h2 className="text-xl font-bold text-[#0A1931]">
                        {pkg ? "Paketi Düzenle" : "Yeni Paket"}
                    </h2>
                    <button onClick={onClose} className="p-2 rounded-xl hover:bg-[#E2E8F0]/40 transition-colors">
                        <X size={18} className="text-[#A9A9A9]" />
                    </button>
                </div>

                <div className="overflow-y-auto p-6 space-y-5 flex-1">
                    <div className="grid grid-cols-2 gap-4">
                        <div className="col-span-2">
                            <label className="block text-sm font-medium text-[#1B3B6F] mb-1.5">Paket Adı *</label>
                            <input value={form.name} onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
                                className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] focus:outline-none focus:border-[#A0AEC0] focus:ring-2 focus:ring-indigo-100 text-sm"
                                placeholder="ör. A1 İngilizce Canlı Ders Paketi" />
                        </div>
                        <div className="col-span-2">
                            <label className="block text-sm font-medium text-[#1B3B6F] mb-1.5">Açıklama</label>
                            <textarea value={form.description} onChange={e => setForm(f => ({ ...f, description: e.target.value }))}
                                rows={2}
                                className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] focus:outline-none focus:border-[#A0AEC0] focus:ring-2 focus:ring-indigo-100 text-sm resize-none"
                                placeholder="Paket hakkında kısa açıklama..." />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-[#1B3B6F] mb-1.5">Fiyat (₺)</label>
                            <input type="number" value={form.price} onChange={e => setForm(f => ({ ...f, price: +e.target.value }))}
                                className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] focus:outline-none focus:border-[#A0AEC0] focus:ring-2 focus:ring-indigo-100 text-sm"
                                min={0} step={1} />
                        </div>
                        <div>
                            <label className="block text-sm font-medium text-[#1B3B6F] mb-1.5">
                                Erişim Süresi (gün)
                                <span className="ml-1.5 text-[#A0AEC0] font-normal">0 = sınırsız</span>
                            </label>
                            <input type="number" value={form.durationDays} onChange={e => setForm(f => ({ ...f, durationDays: +e.target.value }))}
                                className="w-full px-4 py-3 rounded-xl border border-[#E2E8F0] focus:outline-none focus:border-[#A0AEC0] focus:ring-2 focus:ring-indigo-100 text-sm"
                                min={0} step={1} placeholder="90" />
                        </div>
                    </div>

                    {pkg && (
                        <div className="flex items-center justify-between p-4 rounded-xl bg-[#E2E8F0]/20 border border-[#E2E8F0]">
                            <div>
                                <p className="text-sm font-medium text-[#1B3B6F]">Paket Durumu</p>
                                <p className="text-xs text-[#A0AEC0]">Pasif hâle alınan paket satışa kapanır.</p>
                            </div>
                            <button
                                onClick={() => setForm(f => ({ ...f, isActive: !f.isActive }))}
                                className={`relative w-12 h-6 rounded-full transition-colors ${form.isActive ? "bg-[#1B3B6F]" : "bg-[#A0AEC0]"}`}
                            >
                                <span className={`absolute top-1 w-4 h-4 bg-white rounded-full shadow transition-transform ${form.isActive ? "left-7" : "left-1"}`} />
                            </button>
                        </div>
                    )}

                    {/* Grup Atamaları */}
                    <div>
                        <label className="block text-sm font-medium text-[#1B3B6F] mb-3">
                            Grup Atamaları
                            <span className="ml-2 text-[#A0AEC0] font-normal text-xs">Her grup için içerik tipini belirleyin</span>
                        </label>
                        <div className="space-y-2 max-h-64 overflow-y-auto pr-1">
                            {groups.map(g => {
                                const selected = form.groups.find(fg => fg.groupId === g.id);
                                return (
                                    <div key={g.id}
                                        className={`rounded-xl border transition-all ${selected ? "border-[#E2E8F0] bg-[#E2E8F0]/30" : "border-[#E2E8F0] bg-white"}`}>
                                        <div className="flex items-center justify-between px-4 py-3">
                                            <label className="flex items-center gap-3 cursor-pointer">
                                                <input type="checkbox" checked={!!selected}
                                                    onChange={() => toggleGroup(g.id)}
                                                    className="w-4 h-4 rounded accent-indigo-600" />
                                                <div>
                                                    <span className="text-sm font-medium text-[#1B3B6F]">{g.name}</span>
                                                    {g.description && (
                                                        <p className="text-xs text-[#A0AEC0]">{g.description}</p>
                                                    )}
                                                </div>
                                            </label>
                                            {selected && (
                                                <div className="flex gap-1.5">
                                                    {CONTENT_MODES.map(m => (
                                                        <button key={m.value}
                                                            onClick={() => setMode(g.id, m.value)}
                                                            className={`px-2.5 py-1 rounded-lg text-xs font-medium transition-all border ${selected.contentMode === m.value
                                                                ? "text-white border-transparent"
                                                                : "border-[#E2E8F0] text-[#A9A9A9] hover:border-[#A0AEC0]"}`}
                                                            style={selected.contentMode === m.value
                                                                ? { background: m.color, borderColor: m.color }
                                                                : {}}>
                                                            {m.label}
                                                        </button>
                                                    ))}
                                                </div>
                                            )}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                </div>

                <div className="px-6 py-4 border-t border-[#E2E8F0]/60 flex justify-end gap-3">
                    <button onClick={onClose}
                        className="px-5 py-2.5 rounded-xl border border-[#E2E8F0] text-[#1B3B6F] text-sm font-medium hover:bg-[#E2E8F0]/20 transition-colors">
                        İptal
                    </button>
                    <button onClick={handleSave} disabled={saving}
                        className="px-6 py-2.5 rounded-xl bg-gradient-to-r from-[#1B3B6F] to-[#0A1931] text-white text-sm font-semibold hover:from-indigo-700 hover:to-violet-700 transition-all disabled:opacity-50 flex items-center gap-2">
                        {saving && <Loader2 size={15} className="animate-spin" />}
                        {pkg ? "Güncelle" : "Oluştur"}
                    </button>
                </div>
            </div>
        </div>
    );
}

// ── Webhook Bilgi Paneli ──────────────────────────────────────────────────────

function WebhookPanel({ info }: { info: WebhookInfo }) {
    const [showSecret, setShowSecret] = useState(false);
    const { toast } = useToast();

    const copy = (text: string) => {
        navigator.clipboard.writeText(text);
        toast("success", "Kopyalandı!");
    };

    return (
        <div className="bg-gradient-to-br from-[#1B3B6F] to-[#0A1931] rounded-2xl p-6 text-white">
            <div className="flex items-center gap-3 mb-5">
                <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center">
                    <Webhook size={18} className="text-[#A0AEC0]" />
                </div>
                <div>
                    <h3 className="font-bold">Webhook Entegrasyonu</h3>
                    <p className="text-xs text-[#A0AEC0]">Satış sitenden bu URL&apos;e istek at</p>
                </div>
            </div>

            <div className="space-y-3">
                {[
                    { label: "Satın Alma URL", value: info.purchaseUrl, color: "text-[#A0AEC0]" },
                    { label: "İptal URL", value: info.cancelUrl, color: "text-amber-300" },
                ].map(item => (
                    <div key={item.label} className="bg-white/5 rounded-xl p-4">
                        <p className="text-xs text-[#A0AEC0] mb-1">{item.label}</p>
                        <div className="flex items-center justify-between gap-3">
                            <code className={`text-sm font-mono truncate ${item.color}`}>{item.value}</code>
                            <button onClick={() => copy(item.value)}
                                className="p-1.5 rounded-lg hover:bg-white/10 transition-colors flex-shrink-0">
                                <Copy size={13} className="text-[#A0AEC0]" />
                            </button>
                        </div>
                    </div>
                ))}
                <div className="bg-white/5 rounded-xl p-4">
                    <p className="text-xs text-[#A0AEC0] mb-1">Webhook Secret</p>
                    <div className="flex items-center justify-between gap-3">
                        <code className="text-sm text-emerald-300 font-mono">
                            {showSecret ? info.secretHint : "••••••••"}
                        </code>
                        <button onClick={() => setShowSecret(!showSecret)}
                            className="p-1.5 rounded-lg hover:bg-white/10 transition-colors flex-shrink-0">
                            {showSecret ? <EyeOff size={13} className="text-[#A0AEC0]" /> : <Eye size={13} className="text-[#A0AEC0]" />}
                        </button>
                    </div>
                </div>
                <div className="bg-white/5 rounded-xl p-3 text-xs text-[#A0AEC0]">
                    <span className="text-[#A0AEC0] font-medium">İmzalama:</span> {info.signatureAlgo}<br />
                    <span className="text-[#A0AEC0] font-medium">Header:</span> {info.signatureHeader}
                </div>
            </div>
        </div>
    );
}

// ── Ana Sayfa ─────────────────────────────────────────────────────────────────

export default function PackagesPage() {
    const { token, currentTenantId } = useAuth();
    const { toast } = useToast();
    const tenantId = currentTenantId ?? "";

    const [packages, setPackages] = useState<PackageDto[]>([]);
    const [groups, setGroups] = useState<GroupListDto[]>([]);
    const [webhookInfo, setWebhookInfo] = useState<WebhookInfo | null>(null);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState("");
    const [modalPkg, setModalPkg] = useState<PackageDto | null | "new">(null);
    const [deleteTarget, setDeleteTarget] = useState<PackageDto | null>(null);
    const [deleting, setDeleting] = useState(false);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const [pkgs, grpResult, wh] = await Promise.all([
                packageApi.list(token, tenantId),
                groupsApi.list(token, tenantId),
                packageApi.webhookInfo(token, tenantId),
            ]);
            setPackages(pkgs);
            setGroups(grpResult.items ?? grpResult as unknown as GroupListDto[]);
            setWebhookInfo(wh);
        } catch {
            toast("error", "Veriler yüklenemedi.");
        } finally {
            setLoading(false);
        }
    }, [token, tenantId]);

    useEffect(() => { load(); }, [token, tenantId]); // eslint-disable-line react-hooks/exhaustive-deps

    const filtered = packages.filter(p =>
        p.name.toLowerCase().includes(search.toLowerCase())
    );

    const stats = {
        total: packages.length,
        active: packages.filter(p => p.isActive).length,
        totalUsers: packages.reduce((s, p) => s + p.activeUserCount, 0),
        unlimited: packages.filter(p => p.durationDays === 0).length,
    };

    const handleDelete = async () => {
        if (!deleteTarget) return;
        setDeleting(true);
        try {
            await packageApi.delete(token!, tenantId, deleteTarget.id);
            toast("success", "Paket silindi.");
            setDeleteTarget(null);
            load();
        } catch {
            toast("error", "Silinemedi.");
        } finally {
            setDeleting(false);
        }
    };

    return (
        <div className="min-h-screen bg-[#E2E8F0]/20 p-6">
            <div className="max-w-7xl mx-auto space-y-6">

                {/* Başlık */}
                <div className="flex items-center justify-between">
                    <div>
                        <h1 className="text-3xl font-bold text-[#0A1931]">Paket Yönetimi</h1>
                        <p className="text-[#A9A9A9] mt-1 text-sm">Satış paketleri, erişim süreleri ve webhook entegrasyonu</p>
                    </div>
                    <div className="flex items-center gap-3">
                        <button onClick={load}
                            className="p-2.5 rounded-xl border border-[#E2E8F0] text-[#A9A9A9] hover:bg-white hover:shadow-sm transition-all">
                            <RefreshCw size={16} className={loading ? "animate-spin" : ""} />
                        </button>
                        <button onClick={() => setModalPkg("new")}
                            className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-gradient-to-r from-[#1B3B6F] to-[#0A1931] text-white font-semibold text-sm hover:from-indigo-700 hover:to-violet-700 transition-all shadow-lg shadow-indigo-200">
                            <Plus size={16} />
                            Yeni Paket
                        </button>
                    </div>
                </div>

                {/* İstatistikler */}
                <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
                    <StatCard icon={Package} label="Toplam Paket" value={stats.total} color="#6366f1" />
                    <StatCard icon={CheckCircle} label="Aktif Paketler" value={stats.active} color="#10b981" />
                    <StatCard icon={Users} label="Aktif Üyeler" value={stats.totalUsers} color="#3b82f6" />
                    <StatCard icon={Zap} label="Sınırsız Erişim" value={stats.unlimited} color="#f59e0b" />
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    {/* Sol: Paket Listesi */}
                    <div className="lg:col-span-2 space-y-4">
                        <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 p-4 flex items-center gap-3 shadow-sm">
                            <Search size={16} className="text-[#A0AEC0]" />
                            <input value={search} onChange={e => setSearch(e.target.value)}
                                placeholder="Paket ara..."
                                className="flex-1 text-sm outline-none text-[#1B3B6F] placeholder-[#A9A9A9]" />
                            {search && (
                                <button onClick={() => setSearch("")}>
                                    <X size={15} className="text-[#A0AEC0] hover:text-[#1B3B6F]" />
                                </button>
                            )}
                        </div>

                        {loading ? (
                            <div className="flex items-center justify-center py-20">
                                <Loader2 size={32} className="text-[#1B3B6F] animate-spin" />
                            </div>
                        ) : filtered.length === 0 ? (
                            <div className="text-center py-20 text-[#A0AEC0]">
                                <Package size={48} className="mx-auto mb-3 opacity-30" />
                                <p className="font-medium">Paket bulunamadı</p>
                                <p className="text-sm mt-1">İlk paketini oluştur</p>
                            </div>
                        ) : (
                            <div className="grid gap-4 sm:grid-cols-2">
                                {filtered.map(pkg => (
                                    <PackageCard key={pkg.id} pkg={pkg}
                                        onEdit={p => setModalPkg(p)}
                                        onDelete={p => setDeleteTarget(p)} />
                                ))}
                            </div>
                        )}
                    </div>

                    {/* Sağ: Webhook + İçerik Modu */}
                    <div className="space-y-4">
                        {webhookInfo ? (
                            <WebhookPanel info={webhookInfo} />
                        ) : (
                            <div className="bg-[#1B3B6F] rounded-2xl p-6 text-[#A0AEC0] text-sm text-center">
                                <Loader2 size={24} className="mx-auto mb-2 animate-spin" />
                                Webhook bilgisi yükleniyor...
                            </div>
                        )}

                        <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 p-5 shadow-sm">
                            <h4 className="font-bold text-[#0A1931] mb-4 flex items-center gap-2">
                                <BookOpen size={16} className="text-[#1B3B6F]" />
                                İçerik Modu
                            </h4>
                            <div className="space-y-3">
                                {CONTENT_MODES.map(m => (
                                    <div key={m.value} className="flex items-center gap-3">
                                        <div className="w-8 h-8 rounded-lg flex items-center justify-center flex-shrink-0"
                                            style={{ background: `${m.color}18` }}>
                                            <m.icon size={14} style={{ color: m.color }} />
                                        </div>
                                        <div>
                                            <p className="text-sm font-semibold text-[#1B3B6F]">{m.label}</p>
                                            <p className="text-xs text-[#A0AEC0]">
                                                {m.value === "Both" ? "Hem canlı derslere hem videolara erişebilir" :
                                                    m.value === "Online" ? "Yalnızca BBB canlı derslere katılabilir" :
                                                        "Yalnızca kayıt ve video içerikleri izleyebilir"}
                                            </p>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {/* Modal */}
            {modalPkg !== null && (
                <PackageModal
                    pkg={modalPkg === "new" ? null : modalPkg}
                    groups={groups}
                    token={token!}
                    tenantId={tenantId}
                    onClose={() => setModalPkg(null)}
                    onSaved={() => { setModalPkg(null); load(); }}
                />
            )}

            {/* Silme Onayı */}
            {deleteTarget && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/40 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-2xl p-6 w-full max-w-sm">
                        <div className="w-12 h-12 rounded-xl bg-red-50 flex items-center justify-center mx-auto mb-4">
                            <Trash2 size={20} className="text-red-500" />
                        </div>
                        <h3 className="text-lg font-bold text-[#0A1931] text-center">Paketi Sil</h3>
                        <p className="text-sm text-[#A9A9A9] text-center mt-2">
                            <strong>{deleteTarget.name}</strong> paketi silinecek. Aktif üyelerin erişimleri etkilenebilir.
                        </p>
                        <div className="flex gap-3 mt-6">
                            <button onClick={() => setDeleteTarget(null)}
                                className="flex-1 py-2.5 rounded-xl border border-[#E2E8F0] text-[#1B3B6F] text-sm font-medium hover:bg-[#E2E8F0]/20 transition-colors">
                                İptal
                            </button>
                            <button onClick={handleDelete} disabled={deleting}
                                className="flex-1 py-2.5 rounded-xl bg-red-600 text-white text-sm font-semibold hover:bg-red-700 transition-colors disabled:opacity-50 flex items-center justify-center gap-2">
                                {deleting && <Loader2 size={14} className="animate-spin" />}
                                Sil
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
