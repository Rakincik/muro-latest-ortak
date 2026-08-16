"use client";

import { useEffect, useState, useMemo, useRef } from "react";
import { createPortal } from "react-dom";
import { useAuth } from "@/contexts/AuthContext";
import { studentSupportApi, type StudentTicketDto, type FaqDto, API_BASE } from "@/lib/api";
import {
    Headset, Search, Send, Plus, X, Tag, Clock, HelpCircle,
    MessageSquare, AlertCircle, ChevronDown, Check, RefreshCw, ArrowLeft, BookOpen
} from "lucide-react";

const statusStyles: Record<string, { bg: string; text: string; dot: string; label: string }> = {
    Open: { bg: "bg-amber-50", text: "text-amber-700", dot: "bg-amber-500", label: "Açık" },
    Answered: { bg: "bg-blue-50", text: "text-blue-700", dot: "bg-blue-500", label: "Yanıtlandı" },
    InProgress: { bg: "bg-blue-50", text: "text-blue-700", dot: "bg-blue-500", label: "Yanıtlandı" },
    Closed: { bg: "bg-emerald-50", text: "text-emerald-700", dot: "bg-emerald-500", label: "Çözüldü" },
    Resolved: { bg: "bg-emerald-50", text: "text-emerald-700", dot: "bg-emerald-500", label: "Çözüldü" },
    "Açık": { bg: "bg-amber-50", text: "text-amber-700", dot: "bg-amber-500", label: "Açık" },
    "Yanıtlandı": { bg: "bg-blue-50", text: "text-blue-700", dot: "bg-blue-500", label: "Yanıtlandı" },
    "Çözüldü": { bg: "bg-emerald-50", text: "text-emerald-700", dot: "bg-emerald-500", label: "Çözüldü" },
};

function getStatusStyle(status: string) {
    return statusStyles[status] || { bg: "bg-[#E2E8F0]/40", text: "text-[#A9A9A9]", dot: "bg-[#A0AEC0]", label: status };
}

// ── Custom Category Select ───────────────────────────────────────────────────
function CustomCategorySelect({ 
    options, 
    value, 
    onChange 
}: { 
    options: string[], 
    value: string, 
    onChange: (val: string) => void 
}) {
    const [open, setOpen] = useState(false);
    const ref = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (ref.current && !ref.current.contains(event.target as Node)) {
                setOpen(false);
            }
        };
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    return (
        <div ref={ref} className="relative">
            <button
                type="button"
                onClick={() => setOpen(!open)}
                className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl px-4 py-2.5 text-sm font-medium text-left flex justify-between items-center focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#1B3B6F] focus:bg-white transition-all shadow-sm"
            >
                <span className={`block truncate ${value ? 'text-[#0A1931]' : 'text-[#A9A9A9]'}`}>
                    {value || "Kategori Seçiniz..."}
                </span>
                <ChevronDown size={16} className={`text-[#A0AEC0] transition-transform ${open ? 'rotate-180' : ''}`} />
            </button>
            
            {open && (
                <div className="absolute z-[200] w-full mt-1 bg-white border border-[#E2E8F0] rounded-xl shadow-xl overflow-hidden max-h-60 flex flex-col py-1">
                    {options.map(opt => (
                        <button
                            key={opt}
                            type="button"
                            onClick={() => {
                                onChange(opt);
                                setOpen(false);
                            }}
                            className={`w-full text-left px-4 py-2.5 text-sm transition-colors flex items-center justify-between ${value === opt ? 'bg-[#F0F4FF] text-[#1B3B6F] font-bold' : 'text-[#5A6A7A] hover:bg-[#F8FAFC]'}`}
                        >
                            <span className="truncate pr-2">{opt}</span>
                            {value === opt && <Check size={14} className="text-[#1B3B6F] shrink-0" />}
                        </button>
                    ))}
                </div>
            )}
        </div>
    );
}

const getFileUrl = (path: string | null) => {
    if (!path) return "";
    if (path.startsWith("http") || path.startsWith("blob:") || path.startsWith("data:")) return path;
    const base = API_BASE;
    let cleanPath = path.startsWith("/") ? path : `/${path}`;
    if (cleanPath.startsWith('/uploads')) {
        cleanPath = `/api/v1${cleanPath}`;
    }
    return `${base}${cleanPath}`;
};

const FAQ_CATEGORIES = ["Teknik Sorun", "Ödeme İşlemleri", "Kayıt / Üyelik", "Diğer"];

export default function SupportPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    
    const [tickets, setTickets] = useState<StudentTicketDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [selectedId, setSelectedId] = useState<string | null>(null);
    const [selected, setSelected] = useState<StudentTicketDto | null>(null);
    const [loadingDetail, setLoadingDetail] = useState(false);
    const [search, setSearch] = useState("");
    const [statusFilter, setStatusFilter] = useState("all");
    
    // SSS (FAQ) State
    const [faqs, setFaqs] = useState<FaqDto[]>([]);
    const [loadingFaqs, setLoadingFaqs] = useState(false);
    const [faqSearch, setFaqSearch] = useState("");
    const [expandedFaqId, setExpandedFaqId] = useState<string | null>(null);
    const [showFaqView, setShowFaqView] = useState(false);

    // Form Modal
    const [showForm, setShowForm] = useState(false);
    const [form, setForm] = useState({ subject: "", category: "Teknik Sorun", message: "" });
    const [sending, setSending] = useState(false);
    const [formError, setFormError] = useState<string | null>(null);
    const [mounted, setMounted] = useState(false);

    useEffect(() => {
        setMounted(true);
    }, []);
    
    // Reply
    const [replyText, setReplyText] = useState("");
    const [replying, setReplying] = useState(false);
    const chatRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (!token || !tenantId) return;
        setLoading(true);
        studentSupportApi.list(token, tenantId)
            .then(data => {
                setTickets(data);
                if (data.length > 0 && !selectedId && !showFaqView) {
                    if (typeof window !== "undefined" && window.innerWidth >= 768) {
                        setSelectedId(data[0].id);
                    }
                }
            })
            .catch(() => setTickets([]))
            .finally(() => setLoading(false));
    }, [token, tenantId, selectedId, showFaqView]);

    useEffect(() => {
        if (!token || !tenantId) return;
        setLoadingFaqs(true);
        studentSupportApi.listFaqs(token, tenantId)
            .then(setFaqs)
            .catch(() => setFaqs([]))
            .finally(() => setLoadingFaqs(false));
    }, [token, tenantId]);

    useEffect(() => {
        if (!token || !tenantId || !selectedId) {
            setSelected(null);
            return;
        }
        setLoadingDetail(true);
        studentSupportApi.get(token, tenantId, selectedId)
            .then(data => {
                setSelected(data);
                setShowFaqView(false);
            })
            .catch(() => setSelected(null))
            .finally(() => setLoadingDetail(false));
    }, [token, tenantId, selectedId]);

    useEffect(() => {
        if (chatRef.current) chatRef.current.scrollTop = chatRef.current.scrollHeight;
    }, [selected?.replies]);

    const filteredTickets = useMemo(() => {
        return tickets.filter(t => {
            const matchSearch = search === "" || t.subject.toLowerCase().includes(search.toLowerCase());
            const matchStatus = statusFilter === "all" || t.status === statusFilter || 
                (statusFilter === "Open" && (t.status === "Açık" || t.status === "Open")) || 
                (statusFilter === "Answered" && (t.status === "Yanıtlandı" || t.status === "Answered" || t.status === "InProgress")) || 
                (statusFilter === "Closed" && (t.status === "Çözüldü" || t.status === "Closed" || t.status === "Resolved"));
            return matchSearch && matchStatus;
        });
    }, [tickets, search, statusFilter]);

    const filteredFaqs = useMemo(() => {
        return faqs.filter(f => 
            faqSearch === "" || 
            f.questionText.toLowerCase().includes(faqSearch.toLowerCase()) || 
            f.answerText.toLowerCase().includes(faqSearch.toLowerCase())
        );
    }, [faqs, faqSearch]);

    const openCount = tickets.filter(t => t.status === "Open" || t.status === "Açık").length;
    const answeredCount = tickets.filter(t => t.status === "Answered" || t.status === "Yanıtlandı" || t.status === "InProgress").length;

    const handleSend = async () => {
        if (!token || !tenantId) return;
        if (!form.subject.trim() || !form.message.trim() || !form.category) {
            setFormError("Konu, Kategori ve Mesaj alanları zorunludur.");
            return;
        }

        setSending(true);
        setFormError(null);
        try {
            const t = await studentSupportApi.create(token, tenantId, {
                subject: form.subject.trim(),
                message: form.message.trim(),
                category: form.category
            });
            setTickets(prev => [t, ...prev]);
            setSelectedId(t.id);
            if (typeof window !== "undefined") {
                window.dispatchEvent(new CustomEvent("toast:show", { detail: { message: "Talep Gönderildi", type: "success" } }));
            }
            
            setForm({ subject: "", category: "Teknik Sorun", message: "" });
            setShowForm(false);
        } catch (e: any) {
            setFormError(e.message || "Talep gönderilemedi.");
        } finally {
            setSending(false);
        }
    };

    const handleReply = async () => {
        if (!token || !tenantId || !selected || !replyText.trim()) return;
        setReplying(true);
        try {
            await studentSupportApi.reply(token, tenantId, selected.id, replyText.trim());
            
            const newReply = {
                id: Math.random().toString(),
                authorName: "Siz",
                message: replyText.trim(),
                isAdmin: false,
                createdAt: new Date().toISOString()
            };
            const updatedTicket = { ...selected, replies: [...(selected.replies || []), newReply], status: "Open" };
            setSelected(updatedTicket);
            setTickets(prev => prev.map(t => t.id === selected.id ? updatedTicket : t));
            setReplyText("");
        } catch (e: any) {
            if (typeof window !== "undefined") {
                window.dispatchEvent(new CustomEvent("toast:show", { detail: { message: "Yanıt gönderilemedi", type: "error" } }));
            }
        } finally {
            setReplying(false);
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <Headset size={24} className="text-[#1B3B6F]" /> Teknik Destek
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-1">
                        Sistemsel ve idari taleplerinizi buradan iletebilirsiniz.
                    </p>
                </div>
                <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
                    <div className="flex items-center gap-2 bg-[#25D366]/10 px-3 py-1.5 rounded-xl border border-[#25D366]/20">
                        <div className="flex flex-col">
                            <span className="text-[10px] font-bold text-[#25D366] uppercase">Acil Durum WhatsApp</span>
                            <div className="flex flex-wrap items-center gap-x-3 gap-y-1 mt-0.5">
                                <a href="https://wa.me/905453724201" target="_blank" rel="noreferrer" className="text-xs font-bold text-[#0A1931] hover:text-[#25D366] transition-colors">
                                    Rüstem (0545 372 4201)
                                </a>
                                <span className="text-[#A0AEC0]/40 hidden xs:inline">|</span>
                                <a href="https://wa.me/905536445851" target="_blank" rel="noreferrer" className="text-xs font-bold text-[#0A1931] hover:text-[#25D366] transition-colors">
                                    Volkan (0553 644 5851)
                                </a>
                            </div>
                        </div>
                    </div>
                    
                    <button
                        onClick={() => { setSelectedId(null); setShowFaqView(true); }}
                        className={`flex items-center justify-center gap-2 px-5 py-2.5 text-sm font-semibold rounded-xl transition-all shadow-md ${showFaqView ? "bg-purple-100 text-purple-700 hover:bg-purple-200 border border-purple-200" : "bg-white border border-[#E2E8F0] hover:bg-gray-50 text-[#1B3B6F]"}`}
                    >
                        <BookOpen size={16} /> SSS / Kılavuzlar
                    </button>

                    <button
                        onClick={() => setShowForm(true)}
                        className="flex items-center justify-center gap-2 px-5 py-2.5 bg-[#1B3B6F] hover:bg-[#0A1931] text-white text-sm font-semibold rounded-xl transition-all shadow-md hover:shadow-lg active:scale-95"
                    >
                        <Plus size={16} /> Yeni Talep
                    </button>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-5 gap-6" style={{ height: 'calc(100vh - 200px)' }}>
                {/* Left Pane: Ticket List */}
                <div className={`md:col-span-2 bg-white rounded-2xl border border-[#E2E8F0]/60 flex flex-col overflow-hidden shadow-sm ${(selectedId || showFaqView) ? "hidden md:flex" : "flex"}`}>
                    <div className="p-4 border-b border-[#E2E8F0]/60 space-y-3">
                        <div className="relative">
                            <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                            <input 
                                type="text" 
                                placeholder="Konu ara..." 
                                value={search} 
                                onChange={e => setSearch(e.target.value)}
                                className="w-full pl-8 pr-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20" 
                            />
                        </div>
                        <div className="flex gap-2">
                            <button onClick={() => { setStatusFilter("all"); setShowFaqView(false); }} className={`flex-1 py-1.5 text-xs rounded-lg transition-colors font-medium ${statusFilter === "all" && !showFaqView ? "bg-[#0A1931] text-white" : "bg-[#E2E8F0]/30 text-[#5A6A7A] hover:bg-[#E2E8F0]/60"}`}>
                                Tümü
                            </button>
                            <button onClick={() => { setStatusFilter("Open"); setShowFaqView(false); }} className={`flex-1 py-1.5 text-xs rounded-lg transition-colors font-medium ${statusFilter === "Open" && !showFaqView ? "bg-amber-100 text-amber-700" : "bg-[#E2E8F0]/30 text-[#5A6A7A] hover:bg-amber-50"}`}>
                                Açık ({openCount})
                            </button>
                            <button onClick={() => { setStatusFilter("Answered"); setShowFaqView(false); }} className={`flex-1 py-1.5 text-xs rounded-lg transition-colors font-medium ${statusFilter === "Answered" && !showFaqView ? "bg-blue-100 text-blue-700" : "bg-[#E2E8F0]/30 text-[#5A6A7A] hover:bg-blue-50"}`}>
                                Yanıtlandı ({answeredCount})
                            </button>
                        </div>
                    </div>
                    
                    <div className="flex-1 overflow-y-auto">
                        {loading ? (
                            <div className="p-4 space-y-3">{[1, 2, 3].map(i => <div key={i} className="h-16 rounded-lg bg-[#E2E8F0]/30 animate-pulse" />)}</div>
                        ) : filteredTickets.length === 0 ? (
                            <div className="flex flex-col items-center justify-center h-full text-[#A0AEC0]">
                                <Headset size={32} className="opacity-20 mb-2" />
                                <p className="text-sm">Talep bulunamadı</p>
                            </div>
                        ) : filteredTickets.map(t => {
                            const ss = getStatusStyle(t.status);
                            return (
                                <button key={t.id} onClick={() => { setSelectedId(t.id); setShowFaqView(false); }}
                                    className={`w-full text-left px-4 py-4 border-b border-[#E2E8F0]/60 hover:bg-[#E2E8F0]/20 transition-colors ${selectedId === t.id && !showFaqView ? "bg-[#F0F4FF] border-l-2 border-l-[#1B3B6F]" : ""}`}>
                                    <div className="flex items-center gap-2 mb-1">
                                        <span className="text-sm font-bold text-[#0A1931] truncate flex-1">{t.subject}</span>
                                        <span className={`w-2 h-2 rounded-full shrink-0 ${ss.dot}`} />
                                    </div>
                                    <div className="flex items-center justify-between mt-2">
                                        <div className="flex items-center gap-1.5 text-[11px] font-medium text-[#A0AEC0]">
                                            <Tag size={12} /> {t.category}
                                        </div>
                                        <p className="text-[10px] text-[#A9A9A9]">{new Date(t.createdAt).toLocaleDateString("tr-TR")}</p>
                                    </div>
                                </button>
                            );
                        })}
                    </div>
                </div>

                {/* Right Pane: Detail & Chat & FAQ */}
                <div className={`md:col-span-3 bg-white rounded-2xl border border-[#E2E8F0]/60 flex flex-col overflow-hidden shadow-sm ${!selectedId && !showFaqView ? "hidden md:flex" : "flex"}`}>
                    {showFaqView ? (
                        /* SSS (FAQ) View */
                        <div className="flex-1 flex flex-col overflow-hidden bg-white">
                            <div className="px-4 py-3 md:px-6 md:py-4 border-b border-[#E2E8F0]/60 bg-[#F8FAFC] flex items-center gap-3">
                                <button 
                                    onClick={() => { setSelectedId(null); setShowFaqView(false); }}
                                    className="md:hidden p-2 rounded-xl border border-[#E2E8F0] bg-white text-[#1B3B6F] hover:bg-gray-50 transition-colors"
                                >
                                    <ArrowLeft size={16} />
                                </button>
                                <div className="flex-1 min-w-0">
                                    <h2 className="text-sm md:text-lg font-bold text-[#0A1931] flex items-center gap-2">
                                        <BookOpen size={18} className="text-[#1B3B6F]" /> Sıkça Sorulan Sorular (SSS)
                                    </h2>
                                    <p className="text-[10px] md:text-xs text-[#A0AEC0]">Sorununuzun çözümü burada olabilir. Lütfen bilet oluşturmadan önce göz atın.</p>
                                </div>
                            </div>

                            <div className="p-4 border-b border-[#E2E8F0]/60">
                                <div className="relative">
                                    <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                                    <input 
                                        type="text" 
                                        placeholder="Sorularda ara..." 
                                        value={faqSearch} 
                                        onChange={e => setFaqSearch(e.target.value)}
                                        className="w-full pl-8 pr-3 py-2 text-sm bg-gray-50 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:bg-white transition-all" 
                                    />
                                </div>
                            </div>

                            <div className="flex-1 overflow-y-auto p-4 md:p-6 space-y-6">
                                {loadingFaqs ? (
                                    <div className="flex flex-col justify-center items-center h-full py-12 gap-2 text-gray-400">
                                        <RefreshCw size={20} className="animate-spin text-[#1B3B6F]" />
                                        <span className="text-sm">SSS yükleniyor...</span>
                                    </div>
                                ) : filteredFaqs.length === 0 ? (
                                    <div className="flex flex-col items-center justify-center h-full text-[#A0AEC0] py-12">
                                        <HelpCircle size={32} className="opacity-20 mb-2" />
                                        <p className="text-sm">Aradığınız soru bulunamadı</p>
                                    </div>
                                ) : (
                                    FAQ_CATEGORIES.map(category => {
                                        const catFaqs = filteredFaqs.filter(f => f.category === category).sort((a, b) => a.sortOrder - b.sortOrder);
                                        if (catFaqs.length === 0) return null;
                                        return (
                                            <div key={category} className="space-y-3">
                                                <h3 className="text-xs font-bold text-[#A0AEC0] uppercase tracking-widest border-b pb-1.5 flex items-center gap-1.5">
                                                    <Tag size={12} /> {category}
                                                </h3>
                                                <div className="space-y-2">
                                                    {catFaqs.map(f => {
                                                        const isExpanded = expandedFaqId === f.id;
                                                        return (
                                                            <div key={f.id} className="border border-[#E2E8F0] rounded-2xl overflow-hidden bg-white hover:border-blue-200 transition-all shadow-sm">
                                                                <button
                                                                    onClick={() => setExpandedFaqId(isExpanded ? null : f.id)}
                                                                    className="w-full text-left px-5 py-4 flex items-center justify-between text-sm font-bold text-[#0A1931] hover:bg-gray-50/50"
                                                                >
                                                                    <span className="pr-4">{f.questionText}</span>
                                                                    <ChevronDown size={16} className={`text-gray-400 shrink-0 transition-transform ${isExpanded ? 'rotate-180' : ''}`} />
                                                                </button>
                                                                {isExpanded && (
                                                                    <div className="px-5 pb-5 pt-1 border-t border-[#E2E8F0] bg-gray-50/30 space-y-4">
                                                                        <p className="text-sm text-gray-600 leading-relaxed whitespace-pre-wrap mt-3">{f.answerText}</p>
                                                                        {f.imageUrl && (
                                                                            <div className="rounded-2xl border border-gray-200 overflow-hidden shadow-sm bg-white max-w-full">
                                                                                <img 
                                                                                    src={getFileUrl(f.imageUrl)} 
                                                                                    alt="Çözüm ekran görüntüsü" 
                                                                                    className="max-h-80 w-auto object-contain mx-auto" 
                                                                                />
                                                                            </div>
                                                                        )}
                                                                    </div>
                                                                )}
                                                            </div>
                                                        );
                                                    })}
                                                </div>
                                            </div>
                                        );
                                    })
                                )}
                            </div>
                        </div>
                    ) : selected ? (
                        <>
                            <div className="px-4 py-3 md:px-6 md:py-4 border-b border-[#E2E8F0]/60 bg-[#F8FAFC] flex items-center gap-3">
                                {/* Mobile Back Button */}
                                <button 
                                    onClick={() => setSelectedId(null)}
                                    className="md:hidden p-2 rounded-xl border border-[#E2E8F0] bg-white text-[#1B3B6F] hover:bg-gray-50 transition-colors"
                                >
                                    <ArrowLeft size={16} />
                                </button>
                                <div className="flex-1 min-w-0">
                                    <div className="flex items-center justify-between mb-1 gap-2">
                                        <h2 className="text-sm md:text-lg font-bold text-[#0A1931] truncate">{selected.subject}</h2>
                                        <span className={`text-[10px] md:text-[11px] font-bold px-2 py-0.5 md:px-2.5 md:py-1 rounded-lg shrink-0 ${getStatusStyle(selected.status).bg} ${getStatusStyle(selected.status).text}`}>
                                            {getStatusStyle(selected.status).label}
                                        </span>
                                    </div>
                                    <div className="flex items-center gap-3 text-[10px] md:text-xs text-[#A0AEC0]">
                                        <span className="flex items-center gap-1"><Tag size={10} /> {selected.category}</span>
                                        <span className="flex items-center gap-1"><Clock size={10} /> {new Date(selected.createdAt).toLocaleString("tr-TR")}</span>
                                    </div>
                                </div>
                            </div>

                            <div ref={chatRef} className="flex-1 overflow-y-auto px-6 py-5 space-y-6">
                                {loadingDetail ? (
                                    <div className="flex flex-col justify-center items-center h-full text-sm text-[#A0AEC0] gap-2">
                                        <RefreshCw size={18} className="animate-spin text-[#1B3B6F]" />
                                        <span>Yükleniyor...</span>
                                    </div>
                                ) : (
                                    <>
                                        {/* Initial Message */}
                                        <div className="flex gap-3">
                                            <div className="w-8 h-8 rounded-full bg-gradient-to-br from-[#1B3B6F] to-blue-800 flex items-center justify-center text-white text-xs font-bold shrink-0">
                                                S
                                            </div>
                                            <div className="flex-1 bg-[#F8FAFC] border border-[#E2E8F0]/60 rounded-xl rounded-tl-none p-4 max-w-[85%]">
                                                <p className="text-sm text-[#0A1931] whitespace-pre-wrap leading-relaxed">{selected.message}</p>
                                            </div>
                                        </div>

                                        {/* Replies */}
                                        {(selected.replies || []).map(r => (
                                            <div key={r.id} className={`flex gap-3 ${r.isAdmin ? "flex-row-reverse" : ""}`}>
                                                <div className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold shrink-0 ${r.isAdmin ? "bg-emerald-500 text-white" : "bg-gradient-to-br from-[#1B3B6F] to-blue-800 text-white"}`}>
                                                    {r.isAdmin ? "D" : "S"}
                                                </div>
                                                <div className={`flex-1 flex flex-col ${r.isAdmin ? "items-end" : "items-start"}`}>
                                                    <div className={`rounded-xl p-4 max-w-[85%] ${r.isAdmin ? "bg-emerald-50 border border-emerald-100 rounded-tr-none text-emerald-900" : "bg-[#F8FAFC] border border-[#E2E8F0]/60 rounded-tl-none text-[#0A1931]"}`}>
                                                        <p className="text-sm whitespace-pre-wrap leading-relaxed">{r.message}</p>
                                                    </div>
                                                    <p className="text-[10px] text-[#A0AEC0] mt-1.5 mx-1">{new Date(r.createdAt).toLocaleString("tr-TR")}</p>
                                                </div>
                                            </div>
                                        ))}
                                    </>
                                )}
                            </div>

                            {/* Reply Box */}
                            {selected.status !== "Closed" && selected.status !== "Çözüldü" && (
                                <div className="px-5 pb-5 pt-3 border-t border-[#E2E8F0]/60 bg-white">
                                    <div className="flex items-end gap-3">
                                        <textarea
                                            value={replyText}
                                            onChange={e => setReplyText(e.target.value)}
                                            placeholder="Yanıtınızı yazın..."
                                            className="flex-1 px-4 py-3 text-sm bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:bg-white resize-none max-h-32 transition-all"
                                            rows={2}
                                            onKeyDown={e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); handleReply(); } }}
                                        />
                                        <button
                                            onClick={handleReply}
                                            disabled={replying || !replyText.trim()}
                                            className="p-3.5 bg-[#1B3B6F] hover:bg-[#0A1931] disabled:opacity-50 text-white rounded-xl transition-colors shrink-0 shadow-md"
                                        >
                                            <Send size={18} />
                                        </button>
                                    </div>
                                </div>
                            )}
                        </>
                    ) : (
                        <div className="flex flex-col items-center justify-center h-full text-[#A0AEC0]">
                            <MessageSquare size={40} className="opacity-20 mb-3" />
                            <p className="text-sm">Detayları görmek için listeden bir talep seçin</p>
                        </div>
                    )}
                </div>
            </div>

            {/* Create Modal */}
            {showForm && mounted && createPortal(
                <div className="fixed inset-0 z-[150] flex items-center justify-center p-4 bg-[#0A1931]/60 backdrop-blur-sm transition-all" onClick={() => setShowForm(false)}>
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden flex flex-col animate-in fade-in zoom-in-95 duration-200" onClick={e => e.stopPropagation()}>
                        <div className="px-6 py-5 bg-gradient-to-br from-[#1B3B6F] to-[#0A1931] flex items-center justify-between relative overflow-hidden">
                            <div className="absolute -right-8 -top-8 w-32 h-32 rounded-full bg-white/10 blur-2xl" />
                            <div className="flex items-center gap-3 relative z-10">
                                <div className="w-10 h-10 rounded-xl bg-white/10 border border-white/20 flex items-center justify-center shadow-sm backdrop-blur-md">
                                    <Headset size={20} className="text-white" />
                                </div>
                                <div>
                                    <h3 className="text-lg font-bold text-white">Yeni Destek Talebi</h3>
                                    <p className="text-[10px] font-medium text-blue-200 uppercase tracking-widest mt-0.5">Müşteri Hizmetleri</p>
                                </div>
                            </div>
                            <button onClick={() => setShowForm(false)} className="p-2 rounded-xl bg-white/10 text-white/70 hover:bg-white/20 hover:text-white transition-colors relative z-10">
                                <X size={16} />
                            </button>
                        </div>

                        <div className="p-6 space-y-5 bg-[#F8FAFC]">
                            <div className="bg-white p-5 rounded-xl border border-[#E2E8F0] shadow-sm space-y-5">
                                <div>
                                    <label className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1.5 block">Kategori <span className="text-red-500">*</span></label>
                                    <CustomCategorySelect 
                                        options={["Teknik Sorun", "Ödeme İşlemleri", "Kayıt / Üyelik", "Diğer"]}
                                        value={form.category}
                                        onChange={val => setForm(f => ({ ...f, category: val }))}
                                    />
                                </div>

                                <div>
                                    <label className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1.5 block">Konu Özeti <span className="text-red-500">*</span></label>
                                    <input
                                        type="text"
                                        value={form.subject}
                                        onChange={e => setForm(f => ({ ...f, subject: e.target.value }))}
                                        placeholder="Örn: Videolar açılmıyor"
                                        className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl px-4 py-2.5 text-[#0A1931] text-sm font-medium placeholder-[#A9A9A9] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#1B3B6F] focus:bg-white transition-all shadow-sm"
                                    />
                                </div>

                                <div>
                                    <label className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-widest mb-1.5 block">Mesajınız <span className="text-red-500">*</span></label>
                                    <textarea
                                        value={form.message}
                                        onChange={e => setForm(f => ({ ...f, message: e.target.value }))}
                                        placeholder="Yaşadığınız sorunu detaylıca anlatabilirsiniz..."
                                        rows={4}
                                        className="w-full bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl px-4 py-3 text-[#0A1931] text-sm font-medium placeholder-[#A9A9A9] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#1B3B6F] focus:bg-white resize-none transition-all shadow-sm"
                                    />
                                </div>
                            </div>
                        </div>

                        {formError && (
                            <div className="px-6 py-3 bg-red-50 border-t border-red-100 flex items-center gap-2">
                                <AlertCircle size={14} className="text-red-500 shrink-0" />
                                <p className="text-red-600 text-xs font-bold">{formError}</p>
                            </div>
                        )}

                        <div className="flex items-center justify-end gap-2 px-6 py-4 border-t border-[#E2E8F0] bg-white">
                            <button
                                onClick={() => setShowForm(false)}
                                className="px-5 py-2.5 text-[#A0AEC0] hover:text-[#0A1931] hover:bg-[#E2E8F0]/50 rounded-xl text-sm font-bold transition-all"
                            >
                                İptal
                            </button>
                            <button
                                onClick={handleSend}
                                disabled={sending || !form.subject.trim() || !form.message.trim()}
                                className="px-6 py-2.5 bg-[#1B3B6F] hover:bg-[#0A1931] disabled:opacity-50 text-white rounded-xl text-sm font-bold transition-all shadow-lg flex items-center justify-center gap-2"
                            >
                                {sending ? "Gönderiliyor..." : <><Send size={16} /> Gönder</>}
                            </button>
                        </div>
                    </div>
                </div>,
                document.body
            )}
        </div>
    );
}
