"use client";

import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter } from "next/navigation";
import {
    MessageSquare, Search, CheckCircle, Clock, X,
    Send, RefreshCw, Tag, AlertCircle, Trash2, Edit, Plus, Zap, Image as ImageIcon, ChevronDown, BookOpen
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { ConfirmDialog } from "@/components/confirm-dialog";
import { supportApi, type TicketDto, type TicketReplyDto, type FaqDto } from "@/lib/api";
import { CustomSelect } from "@/components/ui/CustomSelect";
import { API_BASE } from "@/lib/api/core";

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

const compressImageBase64 = (base64Str: string): Promise<string> => {
    return new Promise((resolve) => {
        const img = new window.Image();
        img.src = base64Str;
        img.onload = () => {
            const canvas = document.createElement("canvas");
            const MAX_WIDTH = 800;
            const MAX_HEIGHT = 600;
            let width = img.width;
            let height = img.height;

            if (width > height) {
                if (width > MAX_WIDTH) {
                    height *= MAX_WIDTH / width;
                    width = MAX_WIDTH;
                }
            } else {
                if (height > MAX_HEIGHT) {
                    width *= MAX_HEIGHT / height;
                    height = MAX_HEIGHT;
                }
            }
            canvas.width = width;
            canvas.height = height;
            const ctx = canvas.getContext("2d");
            ctx?.drawImage(img, 0, 0, width, height);
            resolve(canvas.toDataURL("image/jpeg", 0.7)); // Compress to 70% quality JPEG
        };
    });
};

const STATUS_MAP: Record<string, { label: string; bg: string; text: string; icon: React.ElementType }> = {
    "Açık": { label: "Açık", bg: "bg-amber-50", text: "text-amber-700", icon: Clock },
    "Yanıtlandı": { label: "Yanıtlandı", bg: "bg-blue-50", text: "text-blue-700", icon: MessageSquare },
    "Çözüldü": { label: "Çözüldü", bg: "bg-emerald-50", text: "text-emerald-700", icon: CheckCircle },
    "Open": { label: "Açık", bg: "bg-amber-50", text: "text-amber-700", icon: Clock },
    "Answered": { label: "Yanıtlandı", bg: "bg-blue-50", text: "text-blue-700", icon: MessageSquare },
    "Closed": { label: "Çözüldü", bg: "bg-emerald-50", text: "text-emerald-700", icon: CheckCircle },
    "InProgress": { label: "Yanıtlandı", bg: "bg-blue-50", text: "text-blue-700", icon: MessageSquare },
    "Resolved": { label: "Çözüldü", bg: "bg-emerald-50", text: "text-emerald-700", icon: CheckCircle },
};
function getStatus(s: string) { return STATUS_MAP[s] ?? { label: s, bg: "bg-[#E2E8F0]/20", text: "text-[#A9A9A9]", icon: AlertCircle }; }

const PRIORITY_MAP: Record<string, { label: string; dot: string }> = {
    high: { label: "Yüksek", dot: "bg-red-500" },
    normal: { label: "Normal", dot: "bg-amber-500" },
    low: { label: "Düşük", dot: "bg-[#A0AEC0]" },
    urgent: { label: "Acil", dot: "bg-red-700" },
};

const STATUS_OPTIONS = [
    { label: "Açık", value: "Open", icon: Clock },
    { label: "Yanıtlandı", value: "InProgress", icon: MessageSquare },
    { label: "Çözüldü", value: "Closed", icon: CheckCircle }
];

const normalizeStatus = (status: string) => {
    if (status === "Açık" || status === "Open") return "Open";
    if (status === "Yanıtlandı" || status === "Answered" || status === "InProgress") return "InProgress";
    if (status === "Çözüldü" || status === "Closed" || status === "Resolved") return "Closed";
    return "Open";
};

const FAQ_CATEGORIES = ["Teknik Sorun", "Ödeme İşlemleri", "Kayıt / Üyelik", "Diğer"];

export default function SupportPage() {
    const router = useRouter();
    const { token, currentTenantId: tenantId, user } = useAuth();
    const { success, error: toastError } = useToast();

    const isSuperAdmin = user?.role === "SuperAdmin";
    const currentTenant = user?.tenants?.find(t => t.tenantId === tenantId);
    const brandName = currentTenant?.tenantName || "MURO";
    const waMessage = encodeURIComponent(`Merhaba size ${brandName} kurumundan ulaşıyorum.`);

    const [activeTab, setActiveTab] = useState<"tickets" | "faq">("tickets");
    const [tickets, setTickets] = useState<TicketDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [selected, setSelected] = useState<TicketDto | null>(null);
    const [loadingDetail, setLoadingDetail] = useState(false);
    const [replyText, setReplyText] = useState("");
    const [replying, setReplying] = useState(false);
    const [search, setSearch] = useState("");
    const [statusFilter, setStatusFilter] = useState("all");
    const [deleteTarget, setDeleteTarget] = useState<string | null>(null);
    const chatRef = useRef<HTMLDivElement>(null);

    const [faqs, setFaqs] = useState<FaqDto[]>([]);
    const [loadingFaqs, setLoadingFaqs] = useState(false);
    const [faqModalOpen, setFaqModalOpen] = useState(false);
    const [editingFaq, setEditingFaq] = useState<FaqDto | null>(null);
    const [faqForm, setFaqForm] = useState({
        questionText: "",
        answerText: "",
        category: "Teknik Sorun",
        sortOrder: 0,
        imageUrl: null as string | null
    });
    const [deleteFaqTarget, setDeleteFaqTarget] = useState<string | null>(null);

    const [quickReplies, setQuickReplies] = useState<{ id: string; title: string; text: string }[]>([]);
    const [quickReplyModalOpen, setQuickReplyModalOpen] = useState(false);
    const [quickReplyForm, setQuickReplyForm] = useState({ title: "", text: "" });

    const [drawerOpen, setDrawerOpen] = useState(false);
    const [drawerTab, setDrawerTab] = useState<"quick" | "faq">("quick");
    const [drawerSearch, setDrawerSearch] = useState("");
    const [expandedFaqId, setExpandedFaqId] = useState<string | null>(null);

    const load = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        try {
            const data = await supportApi.list(token, tenantId, { pageSize: 100 });
            setTickets(data.items ?? []);
        } catch {
            toastError("Hata", "Destek talepleri yüklenemedi.");
        } finally {
            setLoading(false);
        }
    }, [token, tenantId, toastError]);

    const loadFaqs = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoadingFaqs(true);
        try {
            const data = await supportApi.listFaqs(token, tenantId);
            setFaqs(data ?? []);
        } catch {
            toastError("Hata", "Sıkça sorulan sorular yüklenemedi.");
        } finally {
            setLoadingFaqs(false);
        }
    }, [token, tenantId, toastError]);

    useEffect(() => {
        load();
        loadFaqs();

        if (typeof window !== "undefined") {
            const saved = localStorage.getItem("muro_quick_replies");
            if (saved) {
                try { setQuickReplies(JSON.parse(saved)); } catch {}
            } else {
                const defaults = [
                    { id: "1", title: "Selamlama", text: "Merhaba, yaşadığınız sorun için üzgünüz. Konuyu inceleyip en kısa sürede size bilgi vereceğiz." },
                    { id: "2", title: "Çözüldü Bilgisi", text: "Sorun giderilmiştir. Kontrol edip onaylayabilir misiniz?" },
                    { id: "3", title: "Ekran Görüntüsü İsteme", text: "Konuyu daha detaylı inceleyebilmemiz için karşılaştığınız hatanın ekran görüntüsünü iletebilir misiniz?" }
                ];
                setQuickReplies(defaults);
                localStorage.setItem("muro_quick_replies", JSON.stringify(defaults));
            }
        }
    }, [token, tenantId, load, loadFaqs]);

    useEffect(() => {
        if (chatRef.current) chatRef.current.scrollTop = chatRef.current.scrollHeight;
    }, [selected?.messages]);

    const handleSelectTicket = async (ticket: TicketDto) => {
        if (!token || !tenantId) return;
        setSelected(ticket);
        setLoadingDetail(true);
        try {
            const detail = await supportApi.get(token, tenantId, ticket.id);
            setSelected(detail);
        } catch {
            toastError("Hata", "Talep detayları yüklenemedi.");
        } finally {
            setLoadingDetail(false);
        }
    };

    const handleReply = async () => {
        if (!token || !tenantId || !selected || !replyText.trim()) return;
        setReplying(true);
        try {
            const reply = await supportApi.reply(token, tenantId, selected.id, replyText.trim());
            const updatedTicket: TicketDto = {
                ...selected,
                messages: [...(selected.messages ?? []), reply],
                status: "Yanıtlandı",
                createdAt: reply.createdAt,
            };
            setSelected(updatedTicket);
            setTickets(prev => prev.map(t => t.id === updatedTicket.id ? updatedTicket : t));
            setReplyText("");
            success("Yanıt gönderildi");
        } catch { toastError("Hata", "Yanıt gönderilemedi."); }
        finally { setReplying(false); }
    };

    const handleStatusChange = async (ticketId: string, newStatus: string) => {
        if (!token || !tenantId) return;
        try {
            await supportApi.updateStatus(token, tenantId, ticketId, newStatus);
            setTickets(prev => prev.map(t => t.id === ticketId ? { ...t, status: newStatus } : t));
            if (selected?.id === ticketId) {
                setSelected(prev => prev ? { ...prev, status: newStatus } : null);
            }
            success("Durum güncellendi");
        } catch { toastError("Hata", "Durum güncellenemedi."); }
    };

    const handleDelete = async () => {
        if (!token || !tenantId || !deleteTarget) return;
        try {
            await supportApi.delete(token, tenantId, deleteTarget);
            setTickets(prev => prev.filter(t => t.id !== deleteTarget));
            if (selected?.id === deleteTarget) setSelected(null);
            setDeleteTarget(null);
            success("Talep silindi");
        } catch { toastError("Hata", "Silinemedi."); }
    };

    const handleOpenFaqModal = (faq: FaqDto | null = null) => {
        if (faq) {
            setEditingFaq(faq);
            setFaqForm({
                questionText: faq.questionText,
                answerText: faq.answerText,
                category: faq.category || "Teknik Sorun",
                sortOrder: faq.sortOrder,
                imageUrl: faq.imageUrl ?? null
            });
        } else {
            setEditingFaq(null);
            setFaqForm({
                questionText: "",
                answerText: "",
                category: "Teknik Sorun",
                sortOrder: faqs.length + 1,
                imageUrl: null
            });
        }
        setFaqModalOpen(true);
    };

    const handleFaqImageChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onloadend = async () => {
            const compressed = await compressImageBase64(reader.result as string);
            setFaqForm(prev => ({ ...prev, imageUrl: compressed }));
        };
        reader.readAsDataURL(file);
    };

    const handleSaveFaq = async () => {
        if (!token || !tenantId) return;
        if (!faqForm.questionText.trim() || !faqForm.answerText.trim()) {
            toastError("Hata", "Soru ve Cevap alanları doldurulmalıdır.");
            return;
        }
        try {
            if (editingFaq) {
                const updated = await supportApi.updateFaq(token, tenantId, editingFaq.id, faqForm);
                setFaqs(prev => prev.map(f => f.id === updated.id ? updated : f));
                success("SSS güncellendi");
            } else {
                const created = await supportApi.createFaq(token, tenantId, faqForm);
                setFaqs(prev => [...prev, created]);
                success("Yeni SSS eklendi");
            }
            setFaqModalOpen(false);
            setEditingFaq(null);
        } catch {
            toastError("Hata", "Soru kaydedilirken hata oluştu.");
        }
    };

    const handleDeleteFaq = async () => {
        if (!token || !tenantId || !deleteFaqTarget) return;
        try {
            await supportApi.deleteFaq(token, tenantId, deleteFaqTarget);
            setFaqs(prev => prev.filter(f => f.id !== deleteFaqTarget));
            setDeleteFaqTarget(null);
            success("SSS silindi");
        } catch {
            toastError("Hata", "Soru silinirken hata oluştu.");
        }
    };

    const handleOpenQuickReplyModal = () => {
        setQuickReplyModalOpen(true);
    };

    const handleSaveQuickReply = () => {
        if (!quickReplyForm.title.trim() || !quickReplyForm.text.trim()) return;
        const newItem = {
            id: Math.random().toString(),
            title: quickReplyForm.title.trim(),
            text: quickReplyForm.text.trim()
        };
        const updated = [...quickReplies, newItem];
        setQuickReplies(updated);
        localStorage.setItem("muro_quick_replies", JSON.stringify(updated));
        setQuickReplyForm({ title: "", text: "" });
        setQuickReplyModalOpen(false);
        success("Hızlı yanıt şablonu eklendi");
    };

    const handleDeleteQuickReply = (id: string, e: React.MouseEvent) => {
        e.stopPropagation();
        const updated = quickReplies.filter(q => q.id !== id);
        setQuickReplies(updated);
        localStorage.setItem("muro_quick_replies", JSON.stringify(updated));
        success("Şablon silindi");
    };

    const filteredTickets = tickets.filter(t => {
        const matchSearch = !search || t.subject.toLowerCase().includes(search.toLowerCase()) || (t.userFullName && t.userFullName.toLowerCase().includes(search.toLowerCase()));
        const matchStatus = statusFilter === "all" || 
            (statusFilter === "Open" && (t.status === "Open" || t.status === "Açık")) ||
            (statusFilter === "InProgress" && (t.status === "Answered" || t.status === "Yanıtlandı" || t.status === "InProgress")) ||
            (statusFilter === "Closed" && (t.status === "Closed" || t.status === "Çözüldü" || t.status === "Resolved"));
        return matchSearch && matchStatus;
    }).sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());

    const filteredDrawerFaqs = faqs.filter(f => 
        !drawerSearch || 
        f.questionText.toLowerCase().includes(drawerSearch.toLowerCase()) || 
        f.answerText.toLowerCase().includes(drawerSearch.toLowerCase())
    );

    const filteredDrawerQuickReplies = quickReplies.filter(q => 
        !drawerSearch || 
        q.title.toLowerCase().includes(drawerSearch.toLowerCase()) || 
        q.text.toLowerCase().includes(drawerSearch.toLowerCase())
    );

    const openTickets = tickets.filter(t => t.status === "Açık" || t.status === "Open").length;
    const answeredTickets = tickets.filter(t => t.status === "Yanıtlandı" || t.status === "Answered" || t.status === "InProgress").length;
    const closedTickets = tickets.filter(t => t.status === "Çözüldü" || t.status === "Closed" || t.status === "Resolved").length;

    return (
        <div className="space-y-4">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <MessageSquare size={24} className="text-[#A0AEC0]" /> Teknik Destek Talepleri
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-1">Öğrenci sorularını yönetin</p>
                </div>
                <div className="flex flex-wrap items-center gap-3">
                    <div className="flex items-center gap-2 bg-[#25D366]/10 px-3 py-1.5 rounded-xl border border-[#25D366]/20">
                        <div className="flex flex-col">
                            <span className="text-[10px] font-bold text-[#25D366] uppercase">Acil Durum WhatsApp</span>
                            <div className="flex items-center gap-3 mt-0.5">
                                <a href={`https://wa.me/905453724201?text=${waMessage}`} target="_blank" rel="noreferrer" className="text-xs font-bold text-[#0A1931] hover:text-[#25D366] transition-colors">
                                    Rüstem (0545 372 4201)
                                </a>
                                <span className="text-[#A0AEC0]/40">|</span>
                                <a href={`https://wa.me/905536445851?text=${waMessage}`} target="_blank" rel="noreferrer" className="text-xs font-bold text-[#0A1931] hover:text-[#25D366] transition-colors">
                                    Volkan (0553 644 5851)
                                </a>
                            </div>
                        </div>
                    </div>
                    <button onClick={load} className="self-start sm:self-auto p-2.5 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9]" title="Yenile">
                        <RefreshCw size={15} />
                    </button>
                </div>
            </div>

            <div className="flex lg:grid lg:grid-cols-3 gap-3 overflow-x-auto hide-scrollbar pb-2 snap-x">
                {[
                    { label: "Açık", value: openTickets, color: "text-amber-600", bg: "bg-amber-50" },
                    { label: "Yanıtlandı", value: answeredTickets, color: "text-blue-600", bg: "bg-blue-50" },
                    { label: "Çözüldü", value: closedTickets, color: "text-emerald-600", bg: "bg-emerald-50" },
                ].map(s => (
                    <div key={s.label} className={`min-w-[120px] lg:min-w-0 shrink-0 snap-start ${s.bg} rounded-xl p-2.5 flex items-center justify-center gap-2 border border-white/50 shadow-sm`}>
                        <p className={`text-xl font-black ${s.color}`}>{s.value}</p>
                        <p className="text-[11px] font-bold text-[#64748B] uppercase tracking-wider">{s.label}</p>
                    </div>
                ))}
            </div>

            <div className="flex gap-2 border-b border-[#E2E8F0]">
                <button
                    onClick={() => setActiveTab("tickets")}
                    className={`px-4 py-2.5 text-xs font-bold uppercase tracking-wider border-b-2 transition-all ${activeTab === "tickets" ? "border-purple-600 text-purple-600" : "border-transparent text-[#A9A9A9] hover:text-[#0A1931]"}`}
                >
                    Destek Talepleri
                </button>
                {isSuperAdmin && (
                    <button
                        onClick={() => setActiveTab("faq")}
                        className={`px-4 py-2.5 text-xs font-bold uppercase tracking-wider border-b-2 transition-all ${activeTab === "faq" ? "border-purple-600 text-purple-600" : "border-transparent text-[#A9A9A9] hover:text-[#0A1931]"}`}
                    >
                        SSS Yönetimi
                    </button>
                )}
            </div>

            {activeTab === "tickets" ? (
                <div className="grid grid-cols-1 md:grid-cols-5 gap-4" style={{ height: "calc(100vh - 330px)", minHeight: "500px" }}>
                    <div className={`md:col-span-2 bg-white rounded-2xl border border-[#E2E8F0]/60 flex-col overflow-hidden ${selected ? 'hidden md:flex' : 'flex'}`}>
                        <div className="p-3 border-b border-[#E2E8F0]/60 space-y-2">
                            <div className="relative">
                                <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                                <input type="text" placeholder="Konu veya öğrenci ara..." value={search}
                                    onChange={e => setSearch(e.target.value)}
                                    className="w-full pl-8 pr-3 py-2 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500/20" />
                            </div>
                            <div className="flex gap-1">
                                {["all", "Open", "InProgress", "Closed"].map(s => (
                                    <button key={s}
                                        onClick={() => setStatusFilter(s)}
                                        className={`flex-1 text-[10px] font-semibold py-1 rounded-lg transition-all ${statusFilter === s ? "bg-purple-600 text-white" : "bg-[#E2E8F0]/40 text-[#A9A9A9] hover:bg-[#E2E8F0]"}`}>
                                        {s === "all" ? "Tümü" : s === "Open" ? "Açık" : s === "InProgress" ? "Yanıtlandı" : "Çözüldü"}
                                    </button>
                                ))}
                            </div>
                        </div>
                        <div className="flex-1 overflow-y-auto divide-y divide-[#E2E8F0]">
                            {loading ? (
                                [...Array(5)].map((_, i) => <div key={i} className="m-3 h-16 bg-[#E2E8F0]/40 rounded-xl animate-pulse" />)
                            ) : filteredTickets.length === 0 ? (
                                <div className="flex flex-col items-center justify-center h-full py-12 text-[#A0AEC0]">
                                    <MessageSquare size={32} className="opacity-25 mb-2" />
                                    <p className="text-sm">Talep bulunamadı</p>
                                </div>
                            ) : filteredTickets.map(t => {
                                const st = getStatus(t.status);
                                const prio = PRIORITY_MAP[t.priority] ?? PRIORITY_MAP.normal;
                                return (
                                    <button key={t.id} onClick={() => handleSelectTicket(t)}
                                        className={`w-full text-left p-3 hover:bg-[#E2E8F0]/20 transition-colors ${selected?.id === t.id ? "bg-purple-50 border-l-2 border-purple-500" : ""}`}>
                                        <div className="flex items-start justify-between gap-2 mb-1">
                                            <p className="text-sm font-semibold text-[#0A1931] truncate">{t.subject}</p>
                                            <span className={`text-[10px] font-semibold px-1.5 py-0.5 rounded shrink-0 ${st.bg} ${st.text}`}>{st.label}</span>
                                        </div>
                                        <p className="text-xs text-[#A9A9A9] truncate">{t.userFullName}</p>
                                        <div className="flex items-center gap-2 mt-1">
                                            <span className={`w-1.5 h-1.5 rounded-full ${prio.dot}`} />
                                            <span className="text-[10px] text-[#A0AEC0]">{prio.label}</span>
                                            <span className="text-[10px] text-[#A0AEC0] ml-auto">{new Date(t.createdAt).toLocaleDateString("tr-TR")}</span>
                                        </div>
                                    </button>
                                );
                            })}
                        </div>
                    </div>

                    <div className={`md:col-span-3 bg-white rounded-2xl border border-[#E2E8F0]/60 flex-col overflow-hidden relative ${!selected ? 'hidden md:flex' : 'flex'}`}>
                        {!selected ? (
                            <div className="flex-1 flex flex-col items-center justify-center text-[#A0AEC0]">
                                <MessageSquare size={48} className="opacity-20 mb-3" />
                                <p className="text-sm">Bir destek talebi seçin</p>
                            </div>
                        ) : (
                            <>
                                <div className="px-4 md:px-5 py-4 border-b border-[#E2E8F0]/60 flex items-start justify-between gap-2 z-10 bg-white">
                                    <div className="flex items-start gap-2 min-w-0">
                                        <button onClick={() => setSelected(null)} className="md:hidden p-1.5 -ml-1 mt-0.5 rounded-lg bg-[#E2E8F0]/40 text-[#1B3B6F] hover:bg-[#E2E8F0] shrink-0">
                                            <X size={16} />
                                        </button>
                                        <div className="min-w-0">
                                            <h2 className="text-base font-bold text-[#0A1931] truncate">{selected.subject}</h2>
                                            <div className="flex items-center gap-2 mt-1 flex-wrap">
                                                <span 
                                                    onClick={() => router.push(`/dashboard/users?userId=${selected.userId}`)}
                                                    className="text-xs font-semibold text-purple-600 hover:text-purple-800 hover:underline cursor-pointer transition-colors"
                                                    title="Öğrencinin Profiline Git"
                                                >
                                                    {selected.userFullName}
                                                </span>
                                                <span className="text-[#A0AEC0]">·</span>
                                                <span className="text-[11px] text-[#A0AEC0] flex items-center gap-1"><Tag size={10} />{selected.category}</span>
                                                <span className="text-[#A0AEC0]">·</span>
                                                <span className="text-[11px] text-[#A0AEC0]">{new Date(selected.createdAt).toLocaleDateString("tr-TR")}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="flex items-center gap-1.5 ml-auto shrink-0">
                                        <button
                                            onClick={() => setDrawerOpen(!drawerOpen)}
                                            className={`p-1.5 rounded-lg border transition-all flex items-center gap-1 text-xs font-bold ${drawerOpen ? "bg-purple-50 border-purple-200 text-purple-600" : "bg-white border-[#E2E8F0] text-[#5A6A7A] hover:bg-[#E2E8F0]/20"}`}
                                            title="Yardımcı Araçlar Panelini Aç/Kapat"
                                        >
                                            <Zap size={14} className={drawerOpen ? "animate-pulse text-purple-600" : ""} /> {drawerOpen ? "Yardımcıyı Kapat" : "Yardımcı"}
                                        </button>
                                        
                                        <CustomSelect
                                            value={normalizeStatus(selected.status)}
                                            onChange={val => handleStatusChange(selected.id, String(val))}
                                            options={STATUS_OPTIONS}
                                            className="w-[125px]"
                                        />
                                        <button onClick={() => setDeleteTarget(selected.id)}
                                            className="p-1.5 rounded-lg hover:bg-red-50 text-[#A0AEC0] hover:text-red-500">
                                            <Trash2 size={14} />
                                        </button>
                                        <button onClick={() => setSelected(null)} className="hidden md:block p-1.5 rounded-lg hover:bg-[#E2E8F0]/40 text-[#A0AEC0]">
                                            <X size={14} />
                                        </button>
                                    </div>
                                </div>

                                <div className="flex-1 flex overflow-hidden relative">
                                    <div ref={chatRef} className={`flex-1 overflow-y-auto p-4 space-y-3 transition-all duration-300 ${drawerOpen ? "mr-80" : ""}`}>
                                        {loadingDetail ? (
                                            <div className="flex flex-col justify-center items-center h-full text-sm text-[#A0AEC0] gap-2">
                                                <RefreshCw size={18} className="animate-spin text-purple-600" />
                                                <span>Yükleniyor...</span>
                                            </div>
                                        ) : (
                                            <>
                                                <div className="flex gap-3">
                                                    <div 
                                                        onClick={() => router.push(`/dashboard/users?userId=${selected.userId}`)}
                                                        className="w-8 h-8 rounded-full bg-gradient-to-br from-[#1B3B6F] to-blue-800 flex items-center justify-center shrink-0 text-xs font-bold text-white hover:opacity-90 cursor-pointer transition-all active:scale-95"
                                                        title="Profilini Gör"
                                                    >
                                                        {selected.userFullName?.[0] ?? "?"}
                                                    </div>
                                                    <div className="flex-1">
                                                        <p 
                                                            onClick={() => router.push(`/dashboard/users?userId=${selected.userId}`)}
                                                            className="text-[11px] font-semibold text-[#5A6A7A] hover:text-[#1B3B6F] cursor-pointer transition-colors mb-1 inline-block"
                                                            title="Profilini Gör"
                                                        >
                                                            {selected.userFullName}
                                                        </p>
                                                        <div className="bg-[#F8FAFC] border border-[#E2E8F0]/60 rounded-xl rounded-tl-none p-3 max-w-[85%]">
                                                            <p className="text-sm text-[#0A1931]">{selected.body}</p>
                                                        </div>
                                                        <p className="text-[10px] text-[#A0AEC0] mt-1 ml-1">{new Date(selected.createdAt).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}</p>
                                                    </div>
                                                </div>
                                                
                                                {(selected.messages ?? []).map((r: TicketReplyDto) => {
                                                    const isAdminReply = !!r.isAdmin;
                                                    return (
                                                        <div key={r.id} className={`flex gap-3 ${isAdminReply ? "flex-row-reverse" : ""}`}>
                                                            <div 
                                                                onClick={() => !isAdminReply && router.push(`/dashboard/users?userId=${selected.userId}`)}
                                                                className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 text-xs font-bold ${
                                                                    isAdminReply 
                                                                        ? "bg-emerald-500 text-white" 
                                                                        : "bg-gradient-to-br from-[#1B3B6F] to-blue-800 text-white hover:opacity-90 cursor-pointer transition-all active:scale-95"
                                                                }`}
                                                                title={isAdminReply ? undefined : "Profilini Gör"}
                                                            >
                                                                {r.senderName?.[0] ?? "?"}
                                                            </div>
                                                            <div className={`flex-1 ${isAdminReply ? "flex flex-col items-end" : ""}`}>
                                                                <p 
                                                                    onClick={() => !isAdminReply && router.push(`/dashboard/users?userId=${selected.userId}`)}
                                                                    className={`text-[11px] font-semibold text-[#5A6A7A] mb-1 mx-1 ${
                                                                        isAdminReply 
                                                                            ? "" 
                                                                            : "hover:text-[#1B3B6F] cursor-pointer transition-colors"
                                                                    }`}
                                                                    title={isAdminReply ? undefined : "Profilini Gör"}
                                                                >
                                                                    {isAdminReply ? "Destek Ekibi" : r.senderName}
                                                                </p>
                                                                <div className={`rounded-xl p-3 max-w-[85%] ${isAdminReply ? "bg-emerald-50 border border-emerald-100 rounded-tr-none text-emerald-900" : "bg-[#F8FAFC] border border-[#E2E8F0]/60 rounded-tl-none text-[#0A1931]"}`}>
                                                                    <p className="text-sm">{r.body}</p>
                                                                </div>
                                                                <p className="text-[10px] text-[#A0AEC0] mt-1 mx-1">{new Date(r.createdAt).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}</p>
                                                            </div>
                                                        </div>
                                                    );
                                                })}
                                            </>
                                        )}
                                    </div>

                                    <div className={`absolute top-0 right-0 h-full w-80 bg-white border-l border-[#E2E8F0]/60 shadow-xl z-20 transition-transform duration-300 flex flex-col ${drawerOpen ? "translate-x-0" : "translate-x-full"}`}>
                                        <div className="p-3 border-b border-[#E2E8F0]/60 flex items-center justify-between">
                                            <div className="flex gap-1.5">
                                                <button
                                                    onClick={() => setDrawerTab("quick")}
                                                    className={`px-3 py-1 text-xs font-bold rounded-lg transition-colors ${drawerTab === "quick" ? "bg-purple-600 text-white" : "text-[#A9A9A9] hover:bg-gray-100"}`}
                                                >
                                                    Hızlı Yanıt
                                                </button>
                                                <button
                                                    onClick={() => setDrawerTab("faq")}
                                                    className={`px-3 py-1 text-xs font-bold rounded-lg transition-colors ${drawerTab === "faq" ? "bg-purple-600 text-white" : "text-[#A9A9A9] hover:bg-gray-100"}`}
                                                >
                                                    SSS Şablon
                                                </button>
                                            </div>
                                            <button onClick={() => setDrawerOpen(false)} className="p-1 rounded hover:bg-gray-100 text-gray-400">
                                                <X size={16} />
                                            </button>
                                        </div>

                                        <div className="p-2 border-b border-[#E2E8F0]/60">
                                            <div className="relative">
                                                <Search size={12} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                                                <input
                                                    type="text"
                                                    placeholder="Şablonlarda ara..."
                                                    value={drawerSearch}
                                                    onChange={e => setDrawerSearch(e.target.value)}
                                                    className="w-full pl-7 pr-3 py-1.5 text-xs bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-1 focus:ring-purple-500"
                                                />
                                            </div>
                                        </div>

                                        <div className="flex-1 overflow-y-auto p-2.5 space-y-2">
                                            {drawerTab === "quick" ? (
                                                <>
                                                    <button
                                                        onClick={handleOpenQuickReplyModal}
                                                        className="w-full py-2 border border-dashed border-purple-300 text-purple-600 hover:bg-purple-50 text-xs font-bold rounded-lg flex items-center justify-center gap-1 transition-colors"
                                                    >
                                                        <Plus size={14} /> Yeni Şablon Ekle
                                                    </button>

                                                    {filteredDrawerQuickReplies.length === 0 ? (
                                                        <p className="text-center text-xs text-gray-400 py-4">Şablon bulunamadı</p>
                                                    ) : (
                                                        filteredDrawerQuickReplies.map(q => (
                                                            <div
                                                                key={q.id}
                                                                onClick={() => setReplyText(prev => prev ? `${prev}\n${q.text}` : q.text)}
                                                                className="p-2 border border-[#E2E8F0] rounded-xl hover:border-purple-300 hover:bg-purple-50/20 cursor-pointer group transition-all"
                                                            >
                                                                <div className="flex items-center justify-between">
                                                                    <h4 className="text-xs font-bold text-[#0A1931]">{q.title}</h4>
                                                                    <button
                                                                        onClick={(e) => handleDeleteQuickReply(q.id, e)}
                                                                        className="p-0.5 rounded text-gray-300 hover:text-red-500 hover:bg-red-50 opacity-0 group-hover:opacity-100 transition-all"
                                                                    >
                                                                        <Trash2 size={12} />
                                                                    </button>
                                                                </div>
                                                                <p className="text-[11px] text-gray-500 mt-1 line-clamp-2">{q.text}</p>
                                                            </div>
                                                        ))
                                                    )}
                                                </>
                                            ) : (
                                                <>
                                                    {filteredDrawerFaqs.length === 0 ? (
                                                        <p className="text-center text-xs text-gray-400 py-4">Soru bulunamadı</p>
                                                    ) : (
                                                        filteredDrawerFaqs.map(f => {
                                                            const isExpanded = expandedFaqId === f.id;
                                                            return (
                                                                <div key={f.id} className="border border-[#E2E8F0] rounded-xl overflow-hidden bg-white">
                                                                    <button
                                                                        onClick={() => setExpandedFaqId(isExpanded ? null : f.id)}
                                                                        className="w-full text-left p-2.5 flex items-center justify-between text-xs font-bold text-[#0A1931] hover:bg-gray-50"
                                                                    >
                                                                        <span className="truncate pr-2">{f.questionText}</span>
                                                                        <ChevronDown size={14} className={`text-gray-400 shrink-0 transition-transform ${isExpanded ? 'rotate-180' : ''}`} />
                                                                    </button>
                                                                    {isExpanded && (
                                                                        <div className="p-2.5 border-t border-[#E2E8F0] bg-gray-50/50 space-y-2">
                                                                            <p className="text-[11px] text-gray-600 whitespace-pre-wrap">{f.answerText}</p>
                                                                            {f.imageUrl && (
                                                                                <img src={getFileUrl(f.imageUrl)} alt="SSS Görseli" className="max-w-full rounded border border-[#E2E8F0] max-h-32 object-contain" />
                                                                            )}
                                                                            <button
                                                                                onClick={() => setReplyText(prev => prev ? `${prev}\n${f.answerText}` : f.answerText)}
                                                                                className="w-full py-1 bg-purple-50 hover:bg-purple-100 text-purple-600 text-[10px] font-bold rounded transition-colors"
                                                                            >
                                                                                Yanıt Olarak Kullan
                                                                            </button>
                                                                        </div>
                                                                    )}
                                                                </div>
                                                            );
                                                        })
                                                    )}
                                                </>
                                            )}
                                        </div>
                                    </div>
                                </div>

                                {selected.status !== "Kapandı" && selected.status !== "Closed" && (
                                    <div className={`px-4 pb-4 pt-2 border-t border-[#E2E8F0]/60 bg-[#E2E8F0]/15 z-10 transition-all ${drawerOpen ? "mr-80" : ""}`}>
                                        <div className="flex items-end gap-2">
                                            <div className="flex-1 flex flex-col gap-1.5">
                                                <textarea
                                                    value={replyText}
                                                    onChange={e => setReplyText(e.target.value)}
                                                    onKeyDown={e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); handleReply(); } }}
                                                    placeholder="Yanıtınızı yazın... (Enter göndermek için)"
                                                    className="w-full px-3 py-2 text-sm bg-white border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-purple-500/20 resize-none max-h-32"
                                                    rows={2}
                                                />
                                                <div className="flex justify-between items-center px-1">
                                                    <span className="text-[10px] text-gray-400">Şablonları kullanmak için sağ üstteki <b>Yardımcı</b> butonuna bas.</span>
                                                    <button
                                                        type="button"
                                                        onClick={() => {
                                                            if (!replyText.trim()) return;
                                                            setQuickReplyForm({ title: "", text: replyText.trim() });
                                                            setQuickReplyModalOpen(true);
                                                        }}
                                                        disabled={!replyText.trim()}
                                                        className="text-[10px] font-bold text-purple-600 hover:text-purple-800 disabled:opacity-40 hover:underline transition-all"
                                                        title="Yazılan yanıtı şablon olarak kaydet"
                                                    >
                                                        + Bu Yanıtı Şablon Yap
                                                    </button>
                                                </div>
                                            </div>
                                            <button
                                                onClick={handleReply}
                                                disabled={replying || !replyText.trim()}
                                                className="p-3 bg-purple-600 hover:bg-purple-700 disabled:opacity-40 text-white rounded-xl transition-colors shrink-0 mb-5"
                                            >
                                                <Send size={16} />
                                            </button>
                                        </div>
                                    </div>
                                )}
                            </>
                        )}
                    </div>
                </div>
            ) : (
                <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 p-4 md:p-6 flex flex-col overflow-y-auto" style={{ height: "calc(100vh - 330px)", minHeight: "500px" }}>
                    <div className="flex justify-between items-center mb-6">
                        <div>
                            <h2 className="text-lg font-bold text-[#0A1931]">Sıkça Sorulan Sorular (SSS) Yönetimi</h2>
                            <p className="text-xs text-gray-400">Öğrencilerin bilet açmadan önce görebileceği yardım kütüphanesini düzenleyin.</p>
                        </div>
                        <button
                            onClick={() => handleOpenFaqModal(null)}
                            className="flex items-center gap-1.5 px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white text-xs font-bold rounded-xl transition-all shadow-md active:scale-95"
                        >
                            <Plus size={14} /> Yeni SSS Ekle
                        </button>
                    </div>

                    {loadingFaqs ? (
                        <div className="flex flex-col items-center justify-center py-12 gap-2 text-gray-400">
                            <RefreshCw size={24} className="animate-spin text-purple-600" />
                            <span className="text-sm">SSS yükleniyor...</span>
                        </div>
                    ) : faqs.length === 0 ? (
                        <div className="flex flex-col items-center justify-center py-16 text-gray-400 border border-dashed border-gray-200 rounded-2xl">
                            <BookOpen size={40} className="opacity-20 mb-3" />
                            <p className="text-sm font-semibold">Henüz SSS eklenmemiş</p>
                            <p className="text-xs text-gray-400 mt-1">Öğrencilerinizin işini kolaylaştırmak için ilk soruyu ekleyin.</p>
                        </div>
                    ) : (
                        <div className="space-y-6">
                            {FAQ_CATEGORIES.map(category => {
                                const catFaqs = faqs.filter(f => f.category === category).sort((a, b) => a.sortOrder - b.sortOrder);
                                if (catFaqs.length === 0) return null;
                                return (
                                    <div key={category} className="space-y-3">
                                        <h3 className="text-xs font-bold text-gray-400 uppercase tracking-widest border-b pb-1.5 flex items-center gap-1.5">
                                            <Tag size={12} /> {category}
                                        </h3>
                                        <div className="grid grid-cols-1 gap-3">
                                            {catFaqs.map(f => (
                                                <div key={f.id} className="p-4 border border-[#E2E8F0] rounded-2xl bg-white hover:border-purple-200 hover:shadow-sm transition-all flex flex-col md:flex-row justify-between gap-4">
                                                    <div className="flex-1 space-y-2">
                                                        <div className="flex items-center gap-2">
                                                            <span className="text-[10px] bg-purple-50 text-purple-600 font-bold px-2 py-0.5 rounded-lg border border-purple-100">Sıra: {f.sortOrder}</span>
                                                            <h4 className="text-sm font-bold text-[#0A1931]">{f.questionText}</h4>
                                                        </div>
                                                        <p className="text-xs text-gray-600 leading-relaxed whitespace-pre-wrap">{f.answerText}</p>
                                                        {f.imageUrl && (
                                                            <div className="mt-3">
                                                                <img src={getFileUrl(f.imageUrl)} alt="FAQ screenshot" className="max-h-48 rounded-xl border border-gray-200 object-contain shadow-sm bg-gray-50" />
                                                            </div>
                                                        )}
                                                    </div>
                                                    <div className="flex md:flex-col justify-end items-end gap-2 shrink-0">
                                                        <button
                                                            onClick={() => handleOpenFaqModal(f)}
                                                            className="p-2 border border-gray-200 hover:border-purple-300 hover:bg-purple-50 text-gray-500 hover:text-purple-600 rounded-xl transition-all flex items-center justify-center gap-1 text-xs font-bold"
                                                            title="Düzenle"
                                                        >
                                                            <Edit size={14} /> Düzenle
                                                        </button>
                                                        <button
                                                            onClick={() => setDeleteFaqTarget(f.id)}
                                                            className="p-2 border border-gray-200 hover:border-red-300 hover:bg-red-50 text-gray-500 hover:text-red-500 rounded-xl transition-all flex items-center justify-center gap-1 text-xs font-bold"
                                                            title="Sil"
                                                        >
                                                            <Trash2 size={14} /> Sil
                                                        </button>
                                                    </div>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>
            )}

            <ConfirmDialog
                open={deleteTarget !== null}
                onClose={() => setDeleteTarget(null)}
                onConfirm={handleDelete}
                title="Talebi Sil"
                message="Bu destek talebi kalıcı olarak silinecek."
            />

            <ConfirmDialog
                open={deleteFaqTarget !== null}
                onClose={() => setDeleteFaqTarget(null)}
                onConfirm={handleDeleteFaq}
                title="Sıkça Sorulan Soruyu Sil"
                message="Bu yardım sorusu kalıcı olarak silinecek."
            />

            {faqModalOpen && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#0A1931]/60 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-xl overflow-hidden flex flex-col animate-in fade-in zoom-in-95 duration-200">
                        <div className="px-6 py-4 bg-gradient-to-br from-purple-600 to-indigo-700 flex items-center justify-between text-white">
                            <div>
                                <h3 className="text-lg font-bold">{editingFaq ? "SSS Düzenle" : "Yeni SSS Ekle"}</h3>
                                <p className="text-[10px] text-purple-100 uppercase tracking-widest mt-0.5">Yardım Kütüphanesi</p>
                            </div>
                            <button onClick={() => setFaqModalOpen(false)} className="p-1.5 rounded-lg bg-white/10 hover:bg-white/20 text-white transition-colors">
                                <X size={16} />
                            </button>
                        </div>
                        <div className="p-6 space-y-4 max-h-[70vh] overflow-y-auto bg-gray-50">
                            <div className="bg-white p-4 rounded-xl border border-gray-200/80 shadow-sm space-y-4">
                                <div>
                                    <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1.5 block">Kategori</label>
                                    <select
                                        value={faqForm.category}
                                        onChange={e => setFaqForm(prev => ({ ...prev, category: e.target.value }))}
                                        className="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2 text-sm text-[#0A1931] focus:outline-none focus:ring-2 focus:ring-purple-500/20"
                                    >
                                        {FAQ_CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
                                    </select>
                                </div>

                                <div className="grid grid-cols-3 gap-3">
                                    <div className="col-span-2">
                                        <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1.5 block">Sıralama Değeri (Sort Order)</label>
                                        <input
                                            type="number"
                                            value={faqForm.sortOrder}
                                            onChange={e => setFaqForm(prev => ({ ...prev, sortOrder: parseInt(e.target.value) || 0 }))}
                                            className="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500/20"
                                        />
                                    </div>
                                </div>

                                <div>
                                    <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1.5 block">Soru Metni</label>
                                    <input
                                        type="text"
                                        value={faqForm.questionText}
                                        onChange={e => setFaqForm(prev => ({ ...prev, questionText: e.target.value }))}
                                        placeholder="Örn: Şifremi nasıl yenileyebilirim?"
                                        className="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-purple-500/20"
                                    />
                                </div>

                                <div>
                                    <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1.5 block">Cevap Metni</label>
                                    <textarea
                                        value={faqForm.answerText}
                                        onChange={e => setFaqForm(prev => ({ ...prev, answerText: e.target.value }))}
                                        placeholder="Öğrencinin yapması gereken adımları açıklayın..."
                                        rows={4}
                                        className="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-purple-500/20"
                                    />
                                </div>

                                <div>
                                    <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1.5 block">Ekran Görüntüsü / Görsel</label>
                                    <div className="flex items-center gap-3">
                                        <label className="flex items-center gap-1.5 px-3 py-2 border border-gray-200 hover:border-purple-300 hover:bg-purple-50 rounded-xl text-xs font-bold text-gray-600 hover:text-purple-600 transition-all cursor-pointer">
                                            <ImageIcon size={14} /> Resim Seç
                                            <input type="file" accept="image/*" className="hidden" onChange={handleFaqImageChange} />
                                        </label>
                                        {faqForm.imageUrl && (
                                            <button
                                                type="button"
                                                onClick={() => setFaqForm(prev => ({ ...prev, imageUrl: null }))}
                                                className="text-xs text-red-500 hover:underline font-bold"
                                            >
                                                Görseli Kaldır
                                            </button>
                                        )}
                                    </div>
                                    {faqForm.imageUrl && (
                                        <div className="mt-3 border border-gray-200 rounded-xl overflow-hidden max-h-40 flex items-center justify-center bg-gray-100">
                                            <img src={getFileUrl(faqForm.imageUrl)} alt="FAQ Preview" className="max-h-40 object-contain" />
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                        <div className="flex justify-end gap-2 px-6 py-4 border-t border-gray-200 bg-white">
                            <button
                                onClick={() => setFaqModalOpen(false)}
                                className="px-4 py-2 text-gray-400 hover:text-gray-600 text-xs font-bold transition-all"
                            >
                                İptal
                            </button>
                            <button
                                onClick={handleSaveFaq}
                                className="px-5 py-2 bg-purple-600 hover:bg-purple-700 text-white text-xs font-bold rounded-xl transition-all shadow-md"
                            >
                                Kaydet
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {quickReplyModalOpen && (
                <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-[#0A1931]/60 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden flex flex-col animate-in fade-in zoom-in-95 duration-200">
                        <div className="px-6 py-4 bg-purple-600 text-white flex justify-between items-center">
                            <h3 className="text-sm font-bold uppercase tracking-wider">Hızlı Yanıt Şablonu Ekle</h3>
                            <button onClick={() => setQuickReplyModalOpen(false)} className="p-1 rounded hover:bg-purple-700 text-white">
                                <X size={16} />
                            </button>
                        </div>
                        <div className="p-5 space-y-4 bg-gray-50">
                            <div className="bg-white p-4 rounded-xl border border-gray-200 space-y-4 shadow-sm">
                                <div>
                                    <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1 block">Şablon Başlığı</label>
                                    <input
                                        type="text"
                                        value={quickReplyForm.title}
                                        onChange={e => setQuickReplyForm(prev => ({ ...prev, title: e.target.value }))}
                                        placeholder="Örn: Zoom Bağlantı Yardımı"
                                        className="w-full bg-gray-50 border border-gray-200 rounded-lg px-3 py-1.5 text-xs focus:outline-none focus:ring-1 focus:ring-purple-500"
                                    />
                                </div>
                                <div>
                                    <label className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-1 block">Hazır Mesaj Metni</label>
                                    <textarea
                                        value={quickReplyForm.text}
                                        onChange={e => setQuickReplyForm(prev => ({ ...prev, text: e.target.value }))}
                                        placeholder="Bu şablon seçildiğinde otomatik eklenecek metin..."
                                        rows={4}
                                        className="w-full bg-gray-50 border border-gray-200 rounded-lg px-3 py-1.5 text-xs resize-none focus:outline-none focus:ring-1 focus:ring-purple-500"
                                    />
                                </div>
                            </div>
                        </div>
                        <div className="flex justify-end gap-2 px-5 py-3 border-t border-gray-200 bg-white">
                            <button onClick={() => setQuickReplyModalOpen(false)} className="px-3 py-1.5 text-xs text-gray-400 hover:text-gray-600 font-bold transition-all">İptal</button>
                            <button onClick={handleSaveQuickReply} className="px-4 py-1.5 bg-purple-600 hover:bg-purple-700 text-white text-xs font-bold rounded-lg transition-all shadow-md">Şablonu Ekle</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
