"use client";

import React, { useState, useEffect, useMemo, useCallback } from "react";
import { 
    Blocks, Search, CheckCircle2, XCircle, AlertCircle, 
    Settings2, Sparkles, RefreshCw, Send, ShieldCheck, 
    Layers, ExternalLink, ArrowRight, Check, Key, 
    MessageSquare, CreditCard, Video, Bot, Globe, Smartphone
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { adminIntegrationApi, type IntegrationItem } from "@/lib/api";
import { VatanSmsModal } from "./VatanSmsModal";

export default function IntegrationsPage() {
    const { token, currentTenantId: tenantId, user } = useAuth();
    const { success, error: toastError } = useToast();

    const [integrations, setIntegrations] = useState<IntegrationItem[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedCategory, setSelectedCategory] = useState<string>("all");

    // Modal state
    const [selectedIntegration, setSelectedIntegration] = useState<IntegrationItem | null>(null);
    const [isVatanModalOpen, setIsVatanModalOpen] = useState(false);

    // Load integrations
    const loadIntegrations = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const data = await adminIntegrationApi.list(token, tenantId);
            setIntegrations(data || []);
        } catch (err: any) {
            toastError("Hata", "Entegrasyon listesi yüklenemedi.");
        } finally {
            setLoading(false);
        }
    }, [token, tenantId, toastError]);

    useEffect(() => {
        loadIntegrations();
    }, [loadIntegrations]);

    // Filter categories
    const categories = useMemo(() => {
        const set = new Set<string>();
        integrations.forEach(i => {
            if (i.category) set.add(i.category);
        });
        return ["all", ...Array.from(set)];
    }, [integrations]);

    // Filtered integrations
    const filteredIntegrations = useMemo(() => {
        let list = integrations;

        if (selectedCategory !== "all") {
            list = list.filter(i => i.category === selectedCategory);
        }

        if (searchQuery.trim()) {
            const q = searchQuery.toLowerCase().trim();
            list = list.filter(i => 
                i.title.toLowerCase().includes(q) ||
                (i.description && i.description.toLowerCase().includes(q)) ||
                i.providerKey.toLowerCase().includes(q) ||
                i.category.toLowerCase().includes(q)
            );
        }

        return list;
    }, [integrations, selectedCategory, searchQuery]);

    const handleOpenConfigure = (item: IntegrationItem) => {
        setSelectedIntegration(item);
        if (item.providerKey === "vatansms") {
            setIsVatanModalOpen(true);
        } else {
            toastError("Bilgi", `${item.title} entegrasyonu çok yakında aktif edilecektir.`);
        }
    };

    const getProviderIcon = (providerKey: string, category: string) => {
        if (providerKey === "vatansms" || providerKey === "netgsm") return <MessageSquare size={24} className="stroke-[2.2]" />;
        if (category === "Ödeme") return <CreditCard size={24} className="stroke-[2.2]" />;
        if (category === "CDN & Video") return <Video size={24} className="stroke-[2.2]" />;
        if (category === "Yapay Zeka") return <Bot size={24} className="stroke-[2.2]" />;
        if (providerKey === "whatsapp") return <Smartphone size={24} className="stroke-[2.2]" />;
        return <Blocks size={24} className="stroke-[2.2]" />;
    };

    return (
        <div className="space-y-6 max-w-7xl mx-auto pb-12">
            {/* ── Page Header ────────────────────────────────────────────── */}
            <div className="relative overflow-hidden bg-gradient-to-r from-[#0A1931] via-[#1B3B6F] to-[#0A1931] rounded-3xl p-6 sm:p-8 text-white shadow-xl">
                <div className="absolute right-0 top-0 translate-x-1/4 -translate-y-1/4 w-96 h-96 bg-white/5 rounded-full blur-3xl pointer-events-none" />
                <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div className="space-y-2">
                        <div className="flex items-center gap-2.5">
                            <span className="px-3 py-1 bg-white/10 backdrop-blur-md text-white border border-white/20 rounded-full text-[10px] font-extrabold tracking-widest uppercase flex items-center gap-1.5">
                                <ShieldCheck size={12} className="text-emerald-400" /> SÜPER ADMİN ÖZEL MERKEZİ
                            </span>
                        </div>
                        <h1 className="text-2xl sm:text-3xl font-black tracking-tight">
                            Entegrasyonlar Yönetim Merkezi
                        </h1>
                        <p className="text-sm text-slate-300 max-w-2xl font-normal leading-relaxed">
                            Sisteminizdeki SMS sağlayıcılarını, sanal POS ödeme sistemlerini, video CDN ağlarını ve üçüncü parti servisleri tek bir merkezden yapılandırın.
                        </p>
                    </div>

                    <button
                        onClick={loadIntegrations}
                        disabled={loading}
                        className="px-4 py-2.5 bg-white/10 hover:bg-white/20 text-white border border-white/20 text-xs font-bold rounded-2xl transition-all shadow-sm flex items-center gap-2 self-start md:self-center backdrop-blur-md disabled:opacity-50"
                    >
                        <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
                        <span>Yenile</span>
                    </button>
                </div>
            </div>

            {/* ── Search & Filter Bar ───────────────────────────────────── */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-white p-4 rounded-2xl border border-slate-200/90 shadow-sm">
                <div className="relative flex-1 max-w-md">
                    <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                    <input 
                        type="text" 
                        placeholder="Entegrasyon adı veya servis türü ile ara..."
                        value={searchQuery}
                        onChange={e => setSearchQuery(e.target.value)}
                        className="w-full pl-10 pr-4 py-2 text-xs font-medium border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all"
                    />
                </div>

                <div className="flex items-center gap-1.5 overflow-x-auto pb-1 sm:pb-0">
                    {categories.map(cat => {
                        const label = cat === "all" ? "Tümü" : cat;
                        return (
                            <button
                                key={cat}
                                onClick={() => setSelectedCategory(cat)}
                                className={`px-3 py-1.5 text-xs font-bold rounded-xl transition-all border shrink-0 ${
                                    selectedCategory === cat
                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-sm"
                                        : "bg-white text-slate-600 border-slate-200 hover:bg-slate-50"
                                }`}
                            >
                                {label}
                            </button>
                        );
                    })}
                </div>
            </div>

            {/* ── Integrations Grid ─────────────────────────────────────── */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                {filteredIntegrations.map((item) => {
                    const isVatan = item.providerKey === "vatansms";
                    const isAvailable = isVatan;

                    return (
                        <div 
                            key={item.providerKey}
                            className={`flex flex-col justify-between bg-white rounded-3xl border transition-all duration-200 p-6 shadow-sm relative overflow-hidden group ${
                                item.isEnabled 
                                    ? "border-emerald-200 shadow-emerald-500/5 ring-1 ring-emerald-200" 
                                    : "border-slate-200/90 hover:border-slate-300 hover:shadow-md"
                            }`}
                        >
                            {/* Top row: Icon & Status */}
                            <div>
                                <div className="flex items-start justify-between gap-3 mb-4">
                                    <div className={`w-14 h-14 rounded-2xl flex items-center justify-center border shadow-sm transition-transform group-hover:scale-105 duration-200 ${
                                        item.isEnabled 
                                            ? "bg-emerald-50 border-emerald-200 text-emerald-700" 
                                            : "bg-slate-50 border-slate-200 text-[#0A1931]"
                                    }`}>
                                        {getProviderIcon(item.providerKey, item.category)}
                                    </div>

                                    <div className="flex flex-col items-end gap-1.5">
                                        {item.isEnabled ? (
                                            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-extrabold bg-emerald-100 text-emerald-800 border border-emerald-200 flex items-center gap-1">
                                                <span className="w-1.5 h-1.5 rounded-full bg-emerald-600 animate-pulse" /> AKTİF
                                            </span>
                                        ) : isAvailable ? (
                                            <span className="px-2.5 py-0.5 rounded-full text-[11px] font-extrabold bg-slate-100 text-slate-600 border border-slate-200">
                                                PASİF
                                            </span>
                                        ) : (
                                            <span className="px-2.5 py-0.5 rounded-full text-[10px] font-extrabold bg-amber-50 text-amber-800 border border-amber-200">
                                                YAKINDA
                                            </span>
                                        )}
                                        <span className="text-[10px] font-extrabold uppercase tracking-wider text-slate-400">
                                            {item.category}
                                        </span>
                                    </div>
                                </div>

                                <h3 className="text-base font-black text-[#0A1931] tracking-tight group-hover:text-[#1B3B6F] transition-colors">
                                    {item.title}
                                </h3>
                                <p className="text-xs text-slate-500 font-medium leading-relaxed mt-1 line-clamp-2">
                                    {item.description || "Entegrasyon servisi."}
                                </p>

                                {/* Live Test Status Indicator */}
                                {item.lastTestedAt && (
                                    <div className={`mt-3.5 p-2.5 rounded-xl border text-[11px] font-medium flex items-center gap-2 ${
                                        item.testStatus === "Success" 
                                            ? "bg-emerald-50/60 border-emerald-200 text-emerald-900" 
                                            : "bg-rose-50/60 border-rose-200 text-rose-900"
                                    }`}>
                                        {item.testStatus === "Success" ? (
                                            <CheckCircle2 size={14} className="text-emerald-600 shrink-0" />
                                        ) : (
                                            <XCircle size={14} className="text-rose-600 shrink-0" />
                                        )}
                                        <span className="truncate">{item.testMessage || (item.testStatus === "Success" ? "Bağlantı Başarılı" : "Hata")}</span>
                                    </div>
                                )}
                            </div>

                            {/* Bottom row: Actions */}
                            <div className="pt-5 mt-5 border-t border-slate-100 flex items-center justify-between gap-2">
                                {isAvailable ? (
                                    <>
                                        <button
                                            onClick={() => handleOpenConfigure(item)}
                                            className="w-full px-4 py-2.5 bg-[#0A1931] hover:bg-[#1B3B6F] text-white text-xs font-bold rounded-xl shadow-sm transition-all flex items-center justify-center gap-2 active:scale-95"
                                        >
                                            <Settings2 size={14} />
                                            <span>Yapılandır & Test Et</span>
                                        </button>
                                    </>
                                ) : (
                                    <button
                                        disabled
                                        className="w-full px-4 py-2 bg-slate-100 text-slate-400 text-xs font-bold rounded-xl border border-slate-200 cursor-not-allowed text-center"
                                    >
                                        Geliştirme Aşamasında
                                    </button>
                                )}
                            </div>
                        </div>
                    );
                })}
            </div>

            {/* ── Vatan SMS Modal ───────────────────────────────────────── */}
            <VatanSmsModal 
                isOpen={isVatanModalOpen}
                onClose={() => setIsVatanModalOpen(false)}
                integration={selectedIntegration}
                onSuccess={loadIntegrations}
            />
        </div>
    );
}
