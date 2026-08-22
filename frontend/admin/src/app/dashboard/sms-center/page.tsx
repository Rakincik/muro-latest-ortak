"use client";

import React, { useState, useEffect, useMemo, useCallback } from "react";
import { useSearchParams } from "next/navigation";
import { 
    MessageSquare, Send, Users, BookOpen, Layers, Package, 
    Sparkles, CheckCircle2, AlertCircle, Clock, Calendar, 
    RefreshCw, ShieldCheck, ChevronRight, Search, Check, 
    Smartphone, FileText, ArrowRight, Loader2, AlertTriangle,
    UserCheck, Plus, X, PhoneCall, Key, BookmarkCheck
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { 
    adminSmsCenterApi, 
    adminIntegrationApi,
    type SmsTargetsResponse, 
    type BulkSmsPreviewResult,
    type BulkSmsExecutionResult,
    type SmsAccountInfo,
    type SmsStudentSearchResult
} from "@/lib/api";

const TEMPLATE_PRESETS = [
    {
        title: "🎓 Canlı Ders Başlıyor",
        badge: "Canlı Yayın",
        color: "bg-amber-50 text-amber-700 border-amber-200 hover:bg-amber-100",
        text: "Sayın {ad}, {kurs} canlı dersiniz 15 dakika sonra başlıyor! Canlı yayına katılmak için: {giris_linki}"
    },
    {
        title: "🔑 Şifre & Giriş Bilgileri",
        badge: "Hesap",
        color: "bg-sky-50 text-sky-700 border-sky-200 hover:bg-sky-100",
        text: "Sayın {ad} {soyad}, {kurum_adi} öğrenci paneli giriş bilgileriniz: Kullanıcı Adınız: {kullanici_adi}, Giriş Linki: {giris_linki}"
    },
    {
        title: "📝 Yeni Deneme / Sınav",
        badge: "Sınav",
        color: "bg-purple-50 text-purple-700 border-purple-200 hover:bg-purple-100",
        text: "Sayın {ad}, {kurs} için 1. Genel Deneme Sınavı panelinize yüklendi! Başarılar dileriz."
    },
    {
        title: "🎬 Ders Kaydı Yüklendi",
        badge: "Video",
        color: "bg-emerald-50 text-emerald-700 border-emerald-200 hover:bg-emerald-100",
        text: "Sayın {ad}, {kurs} dersinin tekrar video kaydı sisteme yüklendi. Panelinizden izleyebilirsiniz: {giris_linki}"
    },
    {
        title: "💳 Paket Tanımlandı",
        badge: "Satış",
        color: "bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-100",
        text: "Merhaba {ad}, {kurs} eğitim paketiniz hesabınıza başarıyla tanımlandı. Hemen derslerinize başlamak için: {giris_linki}"
    },
    {
        title: "📢 Genel Duyuru",
        badge: "Duyuru",
        color: "bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100",
        text: "Sayın {ad} {soyad}, {kurum_adi} hakkında önemli bilgilendirme: {giris_linki}"
    }
];

export default function SmsCenterPage() {
    const searchParams = useSearchParams();
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    // Targets & Account data
    const [targets, setTargets] = useState<SmsTargetsResponse>({ courses: [], groups: [], packages: [] });
    const [accountInfo, setAccountInfo] = useState<SmsAccountInfo | null>(null);
    const [senders, setSenders] = useState<string[]>([]);
    const [loadingInit, setLoadingInit] = useState(true);

    // Form state
    const [targetType, setTargetType] = useState<"all" | "course" | "group" | "package" | "individual">("all");
    const [selectedTargetIds, setSelectedTargetIds] = useState<string[]>([]);
    
    // Individual student search & custom phones
    const [studentSearchQuery, setStudentSearchQuery] = useState("");
    const [searchingStudents, setSearchingStudents] = useState(false);
    const [studentSearchResults, setStudentSearchResults] = useState<SmsStudentSearchResult[]>([]);
    const [selectedStudents, setSelectedStudents] = useState<SmsStudentSearchResult[]>([]);
    const [customPhoneInput, setCustomPhoneInput] = useState("");
    const [customPhones, setCustomPhones] = useState<string[]>([]);

    const [messageTemplate, setMessageTemplate] = useState<string>("Sayın {ad} {soyad}, {kurs} hakkında önemli bilgilendirme: Giriş linki: {giris_linki}");
    const [selectedSender, setSelectedSender] = useState<string>("");
    const [isScheduled, setIsScheduled] = useState(false);
    const [scheduledDateTime, setScheduledDateTime] = useState("");

    // Preview & Sending state
    const [preview, setPreview] = useState<BulkSmsPreviewResult | null>(null);
    const [loadingPreview, setLoadingPreview] = useState(false);
    const [sending, setSending] = useState(false);
    const [executionResult, setExecutionResult] = useState<BulkSmsExecutionResult | null>(null);

    // Load initial target lists & Vatan SMS balance
    const loadInitialData = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoadingInit(true);
        try {
            const [targetsRes, accountRes, sendersRes] = await Promise.allSettled([
                adminSmsCenterApi.getTargets(token, tenantId),
                adminIntegrationApi.getAccountInfo(token, tenantId),
                adminIntegrationApi.getSenders(token, tenantId)
            ]);

            if (targetsRes.status === "fulfilled") setTargets(targetsRes.value);
            if (accountRes.status === "fulfilled" && accountRes.value.success) {
                setAccountInfo(accountRes.value);
                if (accountRes.value.senders?.length > 0 && !selectedSender) {
                    setSelectedSender(accountRes.value.senders[0]);
                }
            }
            if (sendersRes.status === "fulfilled" && Array.isArray(sendersRes.value)) {
                setSenders(sendersRes.value);
            }
        } catch {
        } finally {
            setLoadingInit(false);
        }
    }, [token, tenantId, selectedSender]);

    useEffect(() => {
        loadInitialData();
    }, [loadInitialData]);

    // Handle deep link query params (e.g. from users list page)
    useEffect(() => {
        const studentIdParam = searchParams.get("studentId");
        const phoneParam = searchParams.get("phone");
        const nameParam = searchParams.get("name");

        if (studentIdParam || phoneParam) {
            setTargetType("individual");
            if (studentIdParam) {
                const prefilled: SmsStudentSearchResult = {
                    id: studentIdParam,
                    fullName: nameParam ? decodeURIComponent(nameParam) : "Öğrenci",
                    phone: phoneParam || undefined
                };
                setSelectedStudents([prefilled]);
                setSelectedTargetIds([studentIdParam]);
            } else if (phoneParam) {
                setCustomPhones([phoneParam]);
            }
        }
    }, [searchParams]);

    // Search students when query changes
    useEffect(() => {
        if (targetType !== "individual" || !token || !tenantId) return;
        if (!studentSearchQuery.trim()) {
            setStudentSearchResults([]);
            return;
        }

        const timer = setTimeout(async () => {
            setSearchingStudents(true);
            try {
                const results = await adminSmsCenterApi.searchStudents(token, tenantId, studentSearchQuery.trim());
                setStudentSearchResults(results);
            } catch {
                setStudentSearchResults([]);
            } finally {
                setSearchingStudents(false);
            }
        }, 300);

        return () => clearTimeout(timer);
    }, [studentSearchQuery, targetType, token, tenantId]);

    const addStudent = (st: SmsStudentSearchResult) => {
        if (!selectedStudents.some(s => s.id === st.id)) {
            const updated = [...selectedStudents, st];
            setSelectedStudents(updated);
            setSelectedTargetIds(updated.map(s => s.id));
        }
        setStudentSearchQuery("");
        setStudentSearchResults([]);
    };

    const removeStudent = (id: string) => {
        const updated = selectedStudents.filter(s => s.id !== id);
        setSelectedStudents(updated);
        setSelectedTargetIds(updated.map(s => s.id));
    };

    const addCustomPhone = () => {
        const clean = customPhoneInput.trim().replace(/\s/g, "");
        if (!clean) return;
        if (!customPhones.includes(clean)) {
            setCustomPhones(prev => [...prev, clean]);
        }
        setCustomPhoneInput("");
    };

    const removeCustomPhone = (phone: string) => {
        setCustomPhones(prev => prev.filter(p => p !== phone));
    };

    // Insert variable tag into template
    const insertTag = (tag: string) => {
        setMessageTemplate(prev => prev + tag);
    };

    // Apply template preset
    const applyPreset = (presetText: string) => {
        setMessageTemplate(presetText);
    };

    // Toggle target checkbox
    const toggleTargetId = (id: string) => {
        setSelectedTargetIds(prev => 
            prev.includes(id) ? prev.filter(x => x !== id) : [...prev, id]
        );
    };

    // Calculate characters & SMS count
    const charCount = messageTemplate.length;
    const isTurkish = /[ğüşıöçĞÜŞİÖÇ]/.test(messageTemplate);
    const maxCharsPerSms = isTurkish ? 155 : 160;
    const smsUnitsPerPerson = charCount <= maxCharsPerSms ? 1 : Math.ceil(charCount / (maxCharsPerSms - 7));

    // Handle preview
    const handleGeneratePreview = async () => {
        if (!token || !tenantId) return;
        if (!messageTemplate.trim()) {
            toastError("Eksik Mesaj", "Lütfen mesaj metnini yazın.");
            return;
        }

        if (targetType === "individual" && selectedStudents.length === 0 && customPhones.length === 0) {
            toastError("Alıcı Seçilmedi", "Lütfen en az bir öğrenci seçin veya telefon numarası ekleyin.");
            return;
        }

        if (targetType !== "all" && targetType !== "individual" && selectedTargetIds.length === 0) {
            toastError("Hedef Kitle Seçilmedi", "Lütfen en az bir kurs, grup veya paket seçin.");
            return;
        }

        setLoadingPreview(true);
        setExecutionResult(null);

        try {
            const res = await adminSmsCenterApi.preview(token, tenantId, {
                targetType,
                targetIds: targetType === "individual" ? selectedStudents.map(s => s.id) : selectedTargetIds,
                customPhones: targetType === "individual" ? customPhones : undefined,
                messageTemplate: messageTemplate.trim(),
                sender: selectedSender || undefined
            });

            setPreview(res);
            if (res.validPhonesCount === 0) {
                toastError("Uyarı", "Seçilen hedef kitlede geçerli cep telefonu numarası bulunamadı.");
            } else {
                success("Önizleme Hazır", `${res.validPhonesCount} geçerli alıcı tespit edildi.`);
            }
        } catch (err: any) {
            toastError("Hata", err.message || "Önizleme oluşturulamadı.");
        } finally {
            setLoadingPreview(false);
        }
    };

    // Send Bulk / Individual SMS Campaign
    const handleSendCampaign = async () => {
        if (!token || !tenantId) return;
        if (!messageTemplate.trim()) {
            toastError("Eksik Mesaj", "Lütfen mesaj metnini yazın.");
            return;
        }

        if (!preview || preview.validPhonesCount === 0) {
            toastError("Önizleme Gerekli", "Lütfen önce 'Alıcıları Önizle' butonuna basarak kitleyi kontrol edin.");
            return;
        }

        const confirmMsg = targetType === "individual"
            ? `Seçtiğiniz ${preview.validPhonesCount} kişiye bireysel SMS gönderilecek. Onaylıyor musunuz?`
            : `Toplam ${preview.validPhonesCount} geçerli öğrenciye yaklaşık ${preview.estimatedSmsUnits} SMS kredisi kullanılarak kampanya başlatılacaktır. Onaylıyor musunuz?`;

        if (!confirm(confirmMsg)) {
            return;
        }

        setSending(true);
        setExecutionResult(null);

        try {
            const res = await adminSmsCenterApi.sendBulk(token, tenantId, {
                targetType,
                targetIds: targetType === "individual" ? selectedStudents.map(s => s.id) : selectedTargetIds,
                customPhones: targetType === "individual" ? customPhones : undefined,
                messageTemplate: messageTemplate.trim(),
                sender: selectedSender || undefined,
                sendTime: isScheduled && scheduledDateTime.trim() ? scheduledDateTime.trim() : undefined
            });

            setExecutionResult(res);
            if (res.success) {
                success("SMS Başarıyla Gönderildi", `${res.sentCount} kişiye SMS gönderildi.`);
                loadInitialData(); // Reload balance
            } else {
                toastError("Gönderim Uyarısı", res.message || "Gönderim tamamlanamadı.");
            }
        } catch (err: any) {
            toastError("Kritik Hata", err.message || "SMS servisi yanıt vermedi.");
        } finally {
            setSending(false);
        }
    };

    return (
        <div className="space-y-6 animate-in fade-in duration-300 pb-16 max-w-7xl mx-auto">
            {/* Header */}
            <div className="bg-gradient-to-r from-[#0A1931] via-[#15284A] to-[#1E3E62] p-6 sm:p-8 rounded-3xl text-white shadow-xl relative overflow-hidden">
                <div className="absolute right-0 top-0 w-96 h-96 bg-white/5 rounded-full blur-3xl -mr-20 -mt-20 pointer-events-none" />
                
                <div className="relative z-10 flex flex-col md:flex-row md:items-center justify-between gap-6">
                    <div className="space-y-2">
                        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/10 backdrop-blur-md border border-white/10 text-xs font-bold tracking-wide text-sky-200">
                            <Smartphone size={14} className="text-sky-300" />
                            <span>MURO SMS Kampanya & İletişim Merkezi</span>
                        </div>
                        <h1 className="text-2xl sm:text-3xl font-black tracking-tight">Toplu & Bireysel SMS Merkezi</h1>
                        <p className="text-sm text-slate-300 max-w-2xl font-medium">
                            Kursa, gruba, pakete kayıtlı veya tekil öğrencilerinize kişiselleştirilmiş canlı ders, sınav ve şifre bilgilendirme SMS'leri gönderin.
                        </p>
                    </div>

                    {/* Account Balance Widget */}
                    <div className="bg-white/10 backdrop-blur-md border border-white/15 p-4 rounded-2xl flex items-center gap-4 shrink-0 shadow-inner">
                        <div className="w-12 h-12 rounded-xl bg-amber-400/20 border border-amber-400/30 flex items-center justify-center text-amber-300">
                            <Sparkles size={24} />
                        </div>
                        <div>
                            <div className="text-[11px] font-extrabold uppercase tracking-wider text-slate-300">SMS Kredisi / Bakiye</div>
                            <div className="text-xl font-black text-white">
                                {loadingInit ? (
                                    <span className="text-sm text-slate-300 font-bold">Yükleniyor...</span>
                                ) : accountInfo?.balance ? (
                                    <span>{accountInfo.balance} <span className="text-xs font-bold text-amber-300">Kredi</span></span>
                                ) : (
                                    <span className="text-xs font-bold text-slate-300">Aktif Başlık Bağlı</span>
                                )}
                            </div>
                            {accountInfo?.customerName && (
                                <div className="text-[10px] text-slate-300 truncate max-w-[180px]">{accountInfo.customerName}</div>
                            )}
                        </div>
                    </div>
                </div>
            </div>

            {/* Main Content Grid (12 Cols) */}
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
                
                {/* ── Left Column: Composer Form (7 cols) ───── */}
                <div className="lg:col-span-7 space-y-5">
                    
                    {/* Step 1: Target Audience Selection */}
                    <div className="bg-white p-5 sm:p-6 rounded-3xl border border-slate-200/90 shadow-sm space-y-4">
                        <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                            <h3 className="text-sm font-extrabold text-[#0A1931] flex items-center gap-2">
                                <span className="w-6 h-6 rounded-full bg-[#0A1931] text-white text-xs flex items-center justify-center font-black">1</span>
                                Hedef Kitle Seçimi
                            </h3>
                            {targetType === "individual" ? (
                                <span className="text-[11px] font-bold text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-full border border-indigo-200">
                                    {selectedStudents.length + customPhones.length} Bireysel Alıcı
                                </span>
                            ) : targetType !== "all" && (
                                <span className="text-[11px] font-bold text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-full border border-indigo-200">
                                    {selectedTargetIds.length} Seçili
                                </span>
                            )}
                        </div>

                        {/* Target Type Selector (5 Tabs) */}
                        <div className="grid grid-cols-2 sm:grid-cols-5 gap-2">
                            <button
                                type="button"
                                onClick={() => { setTargetType("all"); setSelectedTargetIds([]); }}
                                className={`p-3 rounded-2xl border text-xs font-bold transition-all flex flex-col items-center gap-1.5 ${
                                    targetType === "all"
                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-md"
                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                }`}
                            >
                                <Users size={16} />
                                <span>Tüm Öğrenciler</span>
                            </button>

                            <button
                                type="button"
                                onClick={() => { setTargetType("course"); setSelectedTargetIds([]); }}
                                className={`p-3 rounded-2xl border text-xs font-bold transition-all flex flex-col items-center gap-1.5 ${
                                    targetType === "course"
                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-md"
                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                }`}
                            >
                                <BookOpen size={16} />
                                <span>Kursa Göre</span>
                            </button>

                            <button
                                type="button"
                                onClick={() => { setTargetType("group"); setSelectedTargetIds([]); }}
                                className={`p-3 rounded-2xl border text-xs font-bold transition-all flex flex-col items-center gap-1.5 ${
                                    targetType === "group"
                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-md"
                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                }`}
                            >
                                <Layers size={16} />
                                <span>Gruba Göre</span>
                            </button>

                            <button
                                type="button"
                                onClick={() => { setTargetType("package"); setSelectedTargetIds([]); }}
                                className={`p-3 rounded-2xl border text-xs font-bold transition-all flex flex-col items-center gap-1.5 ${
                                    targetType === "package"
                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-md"
                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                }`}
                            >
                                <Package size={16} />
                                <span>Pakete Göre</span>
                            </button>

                            <button
                                type="button"
                                onClick={() => { setTargetType("individual"); setSelectedTargetIds([]); }}
                                className={`p-3 rounded-2xl border text-xs font-bold transition-all flex flex-col items-center gap-1.5 col-span-2 sm:col-span-1 relative overflow-hidden ${
                                    targetType === "individual"
                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-md ring-2 ring-indigo-400/40"
                                        : "bg-indigo-50/50 text-indigo-900 border-indigo-200 hover:bg-indigo-100"
                                }`}
                            >
                                <UserCheck size={16} className={targetType === "individual" ? "text-indigo-300" : "text-indigo-600"} />
                                <span>Bireysel SMS</span>
                            </button>
                        </div>

                        {/* Individual Student / Custom Phone Selector */}
                        {targetType === "individual" && (
                            <div className="space-y-4 pt-2 border-t border-slate-100 animate-in fade-in">
                                {/* Student Search Box */}
                                <div className="space-y-2">
                                    <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block">
                                        Öğrenci Ara & Ekle (İsim, Telefon veya E-posta)
                                    </label>
                                    <div className="relative">
                                        <Search size={15} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                                        <input
                                            type="text"
                                            value={studentSearchQuery}
                                            onChange={e => setStudentSearchQuery(e.target.value)}
                                            placeholder="Örn: Mustafa Çakmak veya 0555..."
                                            className="w-full pl-10 pr-10 py-2.5 text-xs font-bold border border-slate-200 rounded-xl bg-slate-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931]"
                                        />
                                        {searchingStudents && (
                                            <Loader2 size={15} className="absolute right-3.5 top-1/2 -translate-y-1/2 animate-spin text-slate-400" />
                                        )}
                                    </div>

                                    {/* Search Dropdown Results */}
                                    {studentSearchResults.length > 0 && (
                                        <div className="border border-slate-200 rounded-2xl p-1 bg-white shadow-lg max-h-48 overflow-y-auto space-y-0.5 animate-in slide-in-from-top-2">
                                            {studentSearchResults.map(st => (
                                                <div
                                                    key={st.id}
                                                    onClick={() => addStudent(st)}
                                                    className="flex items-center justify-between p-2 rounded-xl hover:bg-indigo-50/80 cursor-pointer transition-all text-xs"
                                                >
                                                    <div>
                                                        <span className="font-extrabold text-slate-900">{st.fullName}</span>
                                                        <span className="text-[11px] text-slate-500 font-medium ml-2">{st.phone || st.email || st.username}</span>
                                                    </div>
                                                    <span className="text-[10px] font-bold text-indigo-600 bg-indigo-100 px-2 py-0.5 rounded-md flex items-center gap-1">
                                                        <Plus size={12} /> Ekle
                                                    </span>
                                                </div>
                                            ))}
                                        </div>
                                    )}
                                </div>

                                {/* Custom Phone Number Input */}
                                <div className="space-y-1.5">
                                    <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block">
                                        veya Doğrudan Telefon Numarası Yaz
                                    </label>
                                    <div className="flex gap-2">
                                        <div className="relative flex-1">
                                            <PhoneCall size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400" />
                                            <input
                                                type="text"
                                                value={customPhoneInput}
                                                onChange={e => setCustomPhoneInput(e.target.value)}
                                                onKeyDown={e => { if (e.key === "Enter") { e.preventDefault(); addCustomPhone(); } }}
                                                placeholder="05xx xxx xx xx"
                                                className="w-full pl-10 pr-3.5 py-2 text-xs font-mono font-bold border border-slate-200 rounded-xl bg-slate-50 focus:bg-white focus:outline-none focus:border-[#0A1931]"
                                            />
                                        </div>
                                        <button
                                            type="button"
                                            onClick={addCustomPhone}
                                            className="px-4 py-2 bg-slate-800 hover:bg-slate-900 text-white text-xs font-bold rounded-xl shadow-xs transition-all flex items-center gap-1 active:scale-95"
                                        >
                                            <Plus size={14} /> Ekle
                                        </button>
                                    </div>
                                </div>

                                {/* Selected Students & Phones Badges */}
                                {(selectedStudents.length > 0 || customPhones.length > 0) && (
                                    <div className="p-3 bg-slate-50 rounded-2xl border border-slate-200 space-y-2">
                                        <span className="text-[10px] font-extrabold uppercase tracking-wider text-slate-500 block">
                                            Seçilen Bireysel Alıcılar ({selectedStudents.length + customPhones.length}):
                                        </span>
                                        <div className="flex flex-wrap gap-1.5 max-h-36 overflow-y-auto pr-1">
                                            {selectedStudents.map(st => (
                                                <span key={st.id} className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-white border border-indigo-200 text-indigo-900 text-xs font-bold shadow-2xs">
                                                    <span>{st.fullName} {st.phone && `(${st.phone})`}</span>
                                                    <button type="button" onClick={() => removeStudent(st.id)} className="text-slate-400 hover:text-rose-600 transition-colors">
                                                        <X size={13} />
                                                    </button>
                                                </span>
                                            ))}
                                            {customPhones.map(phone => (
                                                <span key={phone} className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-900 text-xs font-mono font-bold shadow-2xs">
                                                    <span>{phone}</span>
                                                    <button type="button" onClick={() => removeCustomPhone(phone)} className="text-emerald-500 hover:text-rose-600 transition-colors">
                                                        <X size={13} />
                                                    </button>
                                                </span>
                                            ))}
                                        </div>
                                    </div>
                                )}
                            </div>
                        )}

                        {/* List Selector when course/group/package selected */}
                        {targetType === "course" && (
                            <div className="max-h-48 overflow-y-auto border border-slate-200 rounded-2xl p-2 space-y-1 bg-slate-50/50">
                                {targets.courses.length === 0 ? (
                                    <p className="text-xs text-slate-400 p-2 text-center">Kurs bulunamadı.</p>
                                ) : (
                                    targets.courses.map(c => (
                                        <label key={c.id} className="flex items-center gap-2.5 p-2 rounded-xl hover:bg-white cursor-pointer transition-all text-xs font-bold text-slate-800">
                                            <input 
                                                type="checkbox" 
                                                checked={selectedTargetIds.includes(c.id)}
                                                onChange={() => toggleTargetId(c.id)}
                                                className="w-4 h-4 rounded text-[#0A1931] focus:ring-[#0A1931]"
                                            />
                                            <span>{c.title}</span>
                                        </label>
                                    ))
                                )}
                            </div>
                        )}

                        {targetType === "group" && (
                            <div className="max-h-48 overflow-y-auto border border-slate-200 rounded-2xl p-2 space-y-1 bg-slate-50/50">
                                {targets.groups.length === 0 ? (
                                    <p className="text-xs text-slate-400 p-2 text-center">Grup bulunamadı.</p>
                                ) : (
                                    targets.groups.map(g => (
                                        <label key={g.id} className="flex items-center gap-2.5 p-2 rounded-xl hover:bg-white cursor-pointer transition-all text-xs font-bold text-slate-800">
                                            <input 
                                                type="checkbox" 
                                                checked={selectedTargetIds.includes(g.id)}
                                                onChange={() => toggleTargetId(g.id)}
                                                className="w-4 h-4 rounded text-[#0A1931] focus:ring-[#0A1931]"
                                            />
                                            <span>{g.title}</span>
                                        </label>
                                    ))
                                )}
                            </div>
                        )}

                        {targetType === "package" && (
                            <div className="max-h-48 overflow-y-auto border border-slate-200 rounded-2xl p-2 space-y-1 bg-slate-50/50">
                                {targets.packages.length === 0 ? (
                                    <p className="text-xs text-slate-400 p-2 text-center">Paket bulunamadı.</p>
                                ) : (
                                    targets.packages.map(p => (
                                        <label key={p.id} className="flex items-center gap-2.5 p-2 rounded-xl hover:bg-white cursor-pointer transition-all text-xs font-bold text-slate-800">
                                            <input 
                                                type="checkbox" 
                                                checked={selectedTargetIds.includes(p.id)}
                                                onChange={() => toggleTargetId(p.id)}
                                                className="w-4 h-4 rounded text-[#0A1931] focus:ring-[#0A1931]"
                                            />
                                            <span>{p.title}</span>
                                        </label>
                                    ))
                                )}
                            </div>
                        )}
                    </div>

                    {/* Step 2: Message Template & Quick Presets */}
                    <div className="bg-white p-5 sm:p-6 rounded-3xl border border-slate-200/90 shadow-sm space-y-4">
                        <div className="flex items-center justify-between border-b border-slate-100 pb-3">
                            <h3 className="text-sm font-extrabold text-[#0A1931] flex items-center gap-2">
                                <span className="w-6 h-6 rounded-full bg-[#0A1931] text-white text-xs flex items-center justify-center font-black">2</span>
                                Mesaj Metni & Hazır Şablonlar
                            </h3>
                            <span className="text-[11px] font-bold text-slate-400">
                                {charCount} Karakter ({smsUnitsPerPerson} SMS Boyutu)
                            </span>
                        </div>

                        {/* Quick Presets Library */}
                        <div className="space-y-1.5">
                            <p className="text-[11px] font-extrabold text-slate-500 uppercase tracking-wider flex items-center gap-1.5">
                                <BookmarkCheck size={13} className="text-amber-500" />
                                Hazır Şablonlar (Tek Tıkla Doldur):
                            </p>
                            <div className="flex flex-wrap gap-1.5">
                                {TEMPLATE_PRESETS.map((preset, idx) => (
                                    <button
                                        key={idx}
                                        type="button"
                                        onClick={() => applyPreset(preset.text)}
                                        className={`px-3 py-1.5 border text-[11px] font-bold rounded-xl transition-all shadow-2xs active:scale-95 flex items-center gap-1.5 ${preset.color}`}
                                    >
                                        <span>{preset.title}</span>
                                    </button>
                                ))}
                            </div>
                        </div>

                        {/* Tag Insert Buttons */}
                        <div className="pt-1">
                            <p className="text-[11px] font-extrabold text-slate-500 uppercase tracking-wider mb-2">Tıkla & Değişken Ekle:</p>
                            <div className="flex flex-wrap gap-1.5">
                                {[
                                    { label: "Öğrenci Adı", tag: " {ad} " },
                                    { label: "Soyadı", tag: " {soyad} " },
                                    { label: "Ad Soyad", tag: " {ad_soyad} " },
                                    { label: "Kurs / Paket", tag: " {kurs} " },
                                    { label: "Giriş Linki", tag: " {giris_linki} " },
                                    { label: "Kullanıcı Adı", tag: " {kullanici_adi} " },
                                    { label: "Tarih", tag: " {tarih} " },
                                    { label: "Kurum Adı", tag: " {kurum_adi} " }
                                ].map(item => (
                                    <button
                                        key={item.tag}
                                        type="button"
                                        onClick={() => insertTag(item.tag)}
                                        className="px-2.5 py-1 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 border border-indigo-200 text-[11px] font-bold rounded-lg transition-all active:scale-95 shadow-2xs"
                                    >
                                        + {item.label}
                                    </button>
                                ))}
                            </div>
                        </div>

                        {/* Textarea */}
                        <textarea 
                            rows={4}
                            value={messageTemplate}
                            onChange={e => setMessageTemplate(e.target.value)}
                            placeholder="Mesajınızı buraya yazın..."
                            className="w-full px-4 py-3 text-xs font-medium border border-slate-200 rounded-2xl bg-slate-50 text-slate-900 focus:bg-white focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] transition-all resize-none leading-relaxed"
                        />

                        {/* Sender & Schedule options */}
                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                            <div>
                                <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                    Gönderici Başlığı (Sender)
                                </label>
                                {senders.length > 0 ? (
                                    <select
                                        value={selectedSender}
                                        onChange={e => setSelectedSender(e.target.value)}
                                        className="w-full px-3.5 py-2.5 text-xs font-bold border border-slate-200 rounded-xl bg-slate-50 text-slate-900 focus:bg-white focus:outline-none focus:border-[#0A1931]"
                                    >
                                        {senders.map(s => (
                                            <option key={s} value={s}>{s}</option>
                                        ))}
                                    </select>
                                ) : (
                                    <input 
                                        type="text"
                                        placeholder="Örn: 4T AKADEMI"
                                        value={selectedSender}
                                        onChange={e => setSelectedSender(e.target.value)}
                                        className="w-full px-3.5 py-2.5 text-xs font-bold border border-slate-200 rounded-xl bg-slate-50 text-slate-900 focus:bg-white focus:outline-none focus:border-[#0A1931]"
                                    />
                                )}
                            </div>

                            <div>
                                <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                    Gönderim Zamanı
                                </label>
                                <div className="flex items-center gap-2">
                                    <button
                                        type="button"
                                        onClick={() => setIsScheduled(false)}
                                        className={`flex-1 py-2 text-xs font-bold rounded-xl border transition-all ${
                                            !isScheduled
                                                ? "bg-[#0A1931] text-white border-[#0A1931]"
                                                : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                        }`}
                                    >
                                        Hemen
                                    </button>
                                    <button
                                        type="button"
                                        onClick={() => setIsScheduled(true)}
                                        className={`flex-1 py-2 text-xs font-bold rounded-xl border transition-all ${
                                            isScheduled
                                                ? "bg-[#0A1931] text-white border-[#0A1931]"
                                                : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                        }`}
                                    >
                                        Zamanla
                                    </button>
                                </div>
                            </div>
                        </div>

                        {isScheduled && (
                            <div className="pt-2 animate-in fade-in">
                                <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                    Tarih ve Saat (YYYY-AA-GG SS:dd:ss)
                                </label>
                                <input 
                                    type="text"
                                    placeholder="2026-08-25 19:30:00"
                                    value={scheduledDateTime}
                                    onChange={e => setScheduledDateTime(e.target.value)}
                                    className="w-full px-3.5 py-2 text-xs font-mono font-bold border border-slate-200 rounded-xl bg-slate-50 focus:bg-white focus:outline-none focus:border-[#0A1931]"
                                />
                            </div>
                        )}

                        {/* Action buttons */}
                        <div className="flex items-center justify-between pt-4 border-t border-slate-100">
                            <button
                                type="button"
                                onClick={handleGeneratePreview}
                                disabled={loadingPreview}
                                className="px-4 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-800 text-xs font-bold rounded-xl transition-all shadow-2xs flex items-center gap-2 active:scale-95 disabled:opacity-50"
                            >
                                {loadingPreview ? <Loader2 size={14} className="animate-spin" /> : <Search size={14} />}
                                Alıcıları Önizle & Hesapla
                            </button>

                            <button
                                type="button"
                                onClick={handleSendCampaign}
                                disabled={sending || !preview || preview.validPhonesCount === 0}
                                className="px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-md transition-all flex items-center gap-2 active:scale-95 disabled:opacity-50"
                            >
                                {sending ? <Loader2 size={14} className="animate-spin" /> : <Send size={14} />}
                                {targetType === "individual" ? "Bireysel SMS Gönder" : "Kampanyayı Başlat"} ({preview ? preview.validPhonesCount : 0} Kişi)
                            </button>
                        </div>
                    </div>
                </div>

                {/* ── Right Column: Preview & Estimation (5 cols) ───── */}
                <div className="lg:col-span-5 space-y-5">
                    
                    {/* Summary Stats Card */}
                    <div className="bg-white p-5 sm:p-6 rounded-3xl border border-slate-200/90 shadow-sm space-y-4">
                        <h3 className="text-sm font-extrabold text-[#0A1931] flex items-center gap-2 border-b border-slate-100 pb-3">
                            <Sparkles size={16} className="text-amber-500" />
                            Kampanya Maliyet & Kitle Özeti
                        </h3>

                        <div className="grid grid-cols-2 gap-3">
                            <div className="p-3.5 rounded-2xl bg-slate-50 border border-slate-100">
                                <span className="text-[10px] font-extrabold text-slate-400 uppercase tracking-wider block">Toplam Alıcı</span>
                                <span className="text-xl font-black text-slate-900 mt-1 block">
                                    {preview ? preview.totalRecipients : "—"}
                                </span>
                            </div>

                            <div className="p-3.5 rounded-2xl bg-emerald-50 border border-emerald-100">
                                <span className="text-[10px] font-extrabold text-emerald-600 uppercase tracking-wider block">Geçerli Telefon</span>
                                <span className="text-xl font-black text-emerald-900 mt-1 block">
                                    {preview ? preview.validPhonesCount : "—"}
                                </span>
                            </div>

                            <div className="p-3.5 rounded-2xl bg-rose-50 border border-rose-100">
                                <span className="text-[10px] font-extrabold text-rose-600 uppercase tracking-wider block">Hatalı / Eksik</span>
                                <span className="text-xl font-black text-rose-900 mt-1 block">
                                    {preview ? preview.invalidPhonesCount : "—"}
                                </span>
                            </div>

                            <div className="p-3.5 rounded-2xl bg-indigo-50 border border-indigo-100">
                                <span className="text-[10px] font-extrabold text-indigo-600 uppercase tracking-wider block">Harcanacak SMS</span>
                                <span className="text-xl font-black text-indigo-900 mt-1 block">
                                    {preview ? preview.estimatedSmsUnits : "—"}
                                </span>
                            </div>
                        </div>

                        {/* Execution Result Banner */}
                        {executionResult && (
                            <div className={`p-4 rounded-2xl border text-xs animate-in zoom-in-95 ${
                                executionResult.success
                                    ? "bg-emerald-50 border-emerald-200 text-emerald-900"
                                    : "bg-rose-50 border-rose-200 text-rose-900"
                            }`}>
                                <div className="flex items-center gap-2 font-bold mb-1">
                                    {executionResult.success ? <CheckCircle2 size={16} className="text-emerald-600" /> : <AlertTriangle size={16} className="text-rose-600" />}
                                    <span>{executionResult.success ? "SMS Kampanyası Tamamlandı" : "Gönderim Hatası"}</span>
                                </div>
                                <p className="text-[11px] mt-0.5">{executionResult.message}</p>
                                {executionResult.reportId && (
                                    <p className="text-[10px] font-mono text-emerald-700 mt-1">Rapor ID: {executionResult.reportId}</p>
                                )}
                            </div>
                        )}
                    </div>

                    {/* Live Sample Messages Preview */}
                    <div className="bg-white p-5 sm:p-6 rounded-3xl border border-slate-200/90 shadow-sm space-y-3">
                        <h3 className="text-sm font-extrabold text-[#0A1931] flex items-center justify-between border-b border-slate-100 pb-3">
                            <span className="flex items-center gap-2">
                                <Smartphone size={16} className="text-indigo-600" /> Canlı Mesaj Önizlemeleri
                            </span>
                            {preview && (
                                <span className="text-[11px] font-medium text-slate-400">
                                    İlk {preview.recipients.length} kişi
                                </span>
                            )}
                        </h3>

                        {!preview ? (
                            <div className="p-8 text-center text-slate-400 space-y-2">
                                <FileText size={32} className="mx-auto text-slate-300 stroke-[1.5]" />
                                <p className="text-xs font-medium">Hedef kitle ve şablon seçip <strong>"Alıcıları Önizle"</strong> butonuna tıklayın.</p>
                            </div>
                        ) : preview.recipients.length === 0 ? (
                            <p className="text-xs text-slate-400 text-center py-6">Kriterlere uyan öğrenci bulunamadı.</p>
                        ) : (
                            <div className="space-y-3 max-h-[380px] overflow-y-auto pr-1">
                                {preview.recipients.map((r, idx) => (
                                    <div key={idx} className="p-3.5 rounded-2xl bg-slate-50 border border-slate-200/80 space-y-1.5">
                                        <div className="flex items-center justify-between text-xs">
                                            <span className="font-extrabold text-slate-900">{r.fullName}</span>
                                            <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                                                r.isValidPhone 
                                                    ? "bg-emerald-100 text-emerald-800" 
                                                    : "bg-rose-100 text-rose-800"
                                            }`}>
                                                {r.phone}
                                            </span>
                                        </div>
                                        <p className="text-xs text-slate-600 font-normal leading-relaxed bg-white p-2.5 rounded-xl border border-slate-100">
                                            {r.renderedMessage}
                                        </p>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}
