"use client";

import React, { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { 
    X, Key, Send, CheckCircle2, AlertCircle, Loader2, Eye, EyeOff, 
    Sparkles, RefreshCw, Smartphone, MessageSquare, Check, ShieldCheck,
    CreditCard, Building2, HelpCircle, BellRing, Zap, Play, UserCheck, Video
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { 
    adminIntegrationApi, 
    adminSmsCenterApi,
    type IntegrationItem, 
    type VatanSmsConfig, 
    type SmsAccountInfo,
    type SmsTriggerSettings
} from "@/lib/api";

interface VatanSmsModalProps {
    isOpen: boolean;
    onClose: () => void;
    integration: IntegrationItem | null;
    onSuccess: () => void;
}

export function VatanSmsModal({ isOpen, onClose, integration, onSuccess }: VatanSmsModalProps) {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [mounted, setMounted] = useState(false);
    const [activeTab, setActiveTab] = useState<"config" | "triggers" | "test">("config");

    // Form fields
    const [apiId, setApiId] = useState("");
    const [apiKey, setApiKey] = useState("");
    const [sender, setSender] = useState("");
    const [messageType, setMessageType] = useState<"normal" | "turkce">("normal");
    const [messageContentType, setMessageContentType] = useState<"bilgi" | "ticari">("bilgi");
    const [isEnabled, setIsEnabled] = useState(false);
    const [showApiKey, setShowApiKey] = useState(false);

    // Triggers state
    const [triggers, setTriggers] = useState<SmsTriggerSettings>({
        liveLessonReminderEnabled: false,
        liveLessonReminderTemplate: "Sayın {ad}, {kurs} canlı dersiniz 15 dk sonra başlıyor! Giriş: {giris_linki}",
        liveLessonStartedEnabled: false,
        liveLessonStartedTemplate: "Sayın {ad}, {kurs} canlı dersi başladı! Hemen katılın: {giris_linki}",
        welcomeStudentEnabled: false,
        welcomeStudentTemplate: "Merhaba {ad} {soyad}, {kurum_adi} kaydınız tamamlandı. Kullanıcı Adınız: {kullanici_adi}, Giriş: {giris_linki}",
        recordingReadyEnabled: false,
        recordingReadyTemplate: "Sayın {ad}, {kurs} dersinin video tekrar kaydı izlemeye hazır.",
        newExamEnabled: false,
        newExamTemplate: "Sayın {ad}, yeni bir online deneme sınavı açıldı: {kurs}. Panelinizden katılabilirsiniz."
    });
    const [loadingTriggers, setLoadingTriggers] = useState(false);
    const [savingTriggers, setSavingTriggers] = useState(false);

    // Live account info & senders
    const [accountInfo, setAccountInfo] = useState<SmsAccountInfo | null>(null);
    const [availableSenders, setAvailableSenders] = useState<string[]>([]);
    const [testing, setTesting] = useState(false);
    const [saving, setSaving] = useState(false);

    // Test SMS form
    const [testPhone, setTestPhone] = useState("");
    const [testMessage, setTestMessage] = useState("MURO Vatan SMS entegrasyonu başarıyla test edildi! Dersler ve bildirimler SMS ile iletilebilir.");
    const [sendingTest, setSendingTest] = useState(false);
    const [testResult, setTestResult] = useState<{ success: boolean; message: string; reportId?: string } | null>(null);

    useEffect(() => {
        setMounted(true);
    }, []);

    // Load initial config from integration prop
    useEffect(() => {
        if (integration) {
            setIsEnabled(integration.isEnabled);
            if (integration.configJson) {
                try {
                    const cfg: VatanSmsConfig = JSON.parse(integration.configJson);
                    setApiId(cfg.apiId || "");
                    setApiKey(cfg.apiKey || "");
                    setSender(cfg.sender || "");
                    setMessageType(cfg.messageType || "normal");
                    setMessageContentType(cfg.messageContentType || "bilgi");
                } catch { }
            }
        }
    }, [integration]);

    // Fetch triggers when triggers tab is selected
    useEffect(() => {
        if (activeTab === "triggers" && token && tenantId) {
            setLoadingTriggers(true);
            adminSmsCenterApi.getTriggers(token, tenantId)
                .then(res => {
                    if (res) setTriggers(res);
                })
                .catch(() => {})
                .finally(() => setLoadingTriggers(false));
        }
    }, [activeTab, token, tenantId]);

    // Lock body scroll
    useEffect(() => {
        if (isOpen) {
            document.body.style.overflow = "hidden";
        } else {
            document.body.style.overflow = "unset";
        }
        return () => {
            document.body.style.overflow = "unset";
        };
    }, [isOpen]);

    // ESC to close
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if (e.key === "Escape" && isOpen) {
                onClose();
            }
        };
        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [isOpen, onClose]);

    // Test connection & fetch balance
    const handleTestConnection = async () => {
        if (!token || !tenantId) return;
        if (!apiId.trim() || !apiKey.trim()) {
            toastError("Eksik Bilgi", "Lütfen API ID ve API Key bilgilerini girin.");
            return;
        }

        setTesting(true);
        setTestResult(null);

        const currentConfig = {
            apiId: apiId.trim(),
            apiKey: apiKey.trim(),
            sender: sender.trim(),
            messageType,
            messageContentType
        };

        try {
            const res = await adminIntegrationApi.test(token, tenantId, "vatansms", {
                configJson: JSON.stringify(currentConfig)
            });

            if (res.success) {
                setAccountInfo(res);
                if (res.senders && res.senders.length > 0) {
                    setAvailableSenders(res.senders);
                    if (!sender && res.senders[0]) {
                        setSender(res.senders[0]);
                    }
                }
                success("Bağlantı Başarılı", `Kalan SMS Kredisi: ${res.balance || "0"}`);
            } else {
                toastError("Bağlantı Başarısız", res.message || "Vatan SMS sunucusuyla iletişim kurulamadı.");
            }
        } catch (err: any) {
            toastError("Hata", err.message || "Bağlantı testi sırasında bir hata oluştu.");
        } finally {
            setTesting(false);
        }
    };

    // Save integration
    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!token || !tenantId) return;

        if (isEnabled && (!apiId.trim() || !apiKey.trim())) {
            toastError("Eksik Bilgi", "Entegrasyonu aktif edebilmek için API ID ve API Key zorunludur.");
            return;
        }

        setSaving(true);
        const configToSave: VatanSmsConfig = {
            apiId: apiId.trim(),
            apiKey: apiKey.trim(),
            sender: sender.trim(),
            messageType,
            messageContentType
        };

        try {
            await adminIntegrationApi.update(token, tenantId, "vatansms", {
                isEnabled,
                configJson: JSON.stringify(configToSave)
            });

            success("Kaydedildi", "Vatan SMS entegrasyon ayarları başarıyla güncellendi.");
            onSuccess();
            onClose();
        } catch (err: any) {
            toastError("Hata", err.message || "Ayarlar kaydedilemedi.");
        } finally {
            setSaving(false);
        }
    };

    // Save Triggers
    const handleSaveTriggers = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!token || !tenantId) return;

        setSavingTriggers(true);
        try {
            await adminSmsCenterApi.updateTriggers(token, tenantId, triggers);
            success("Kaydedildi", "Otomatik SMS tetikleyici kuralları güncellendi.");
        } catch (err: any) {
            toastError("Hata", err.message || "Tetikleyiciler kaydedilemedi.");
        } finally {
            setSavingTriggers(false);
        }
    };

    // Send Live Test SMS
    const handleSendTestSms = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!token || !tenantId) return;

        if (!testPhone.trim() || testPhone.replace(/\D/g, "").length < 10) {
            toastError("Geçersiz Numara", "Lütfen 10 haneli geçerli bir telefon numarası girin (5xxxxxxxxx).");
            return;
        }

        if (!testMessage.trim()) {
            toastError("Eksik Mesaj", "Lütfen gönderilecek mesaj metnini yazın.");
            return;
        }

        setSendingTest(true);
        setTestResult(null);

        try {
            const res = await adminIntegrationApi.sendTestSms(token, tenantId, {
                phone: testPhone.trim(),
                message: testMessage.trim(),
                sender: sender.trim() || undefined
            });

            if (res.success) {
                setTestResult({
                    success: true,
                    message: "SMS başarıyla gönderildi ve operatöre iletildi.",
                    reportId: res.reportId
                });
                success("SMS Gönderildi", `${testPhone} numarasına test SMS'i başarıyla ulaştı.`);
            } else {
                setTestResult({
                    success: false,
                    message: res.message || "SMS gönderilemedi."
                });
                toastError("Gönderim Başarısız", res.message || "Vatan SMS operatör hatası.");
            }
        } catch (err: any) {
            setTestResult({
                success: false,
                message: err.message || "SMS gönderimi sırasında bir hata oluştu."
            });
            toastError("Hata", err.message || "SMS servisine ulaşılamadı.");
        } finally {
            setSendingTest(false);
        }
    };

    if (!isOpen || !mounted) return null;

    const charCount = testMessage.length;
    const smsCount = messageType === "turkce"
        ? (charCount <= 155 ? 1 : Math.ceil(charCount / 134))
        : (charCount <= 160 ? 1 : Math.ceil(charCount / 153));

    const modalContent = (
        <div 
            className="fixed inset-0 z-[99999] flex items-center justify-center p-3 sm:p-6 bg-[#0A1931]/65 backdrop-blur-md transition-all animate-in fade-in duration-150"
            onClick={onClose}
        >
            <div 
                className="bg-white rounded-3xl shadow-2xl w-full max-w-2xl max-h-[92vh] flex flex-col overflow-hidden border border-slate-200/90 animate-in zoom-in-95 duration-150"
                onClick={e => e.stopPropagation()}
            >
                {/* ── Header ────────────────────────────────────────────── */}
                <div className="relative overflow-hidden px-6 py-5 border-b border-slate-100 bg-gradient-to-r from-slate-50 via-white to-slate-50 shrink-0">
                    <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-emerald-500 via-teal-500 to-[#0A1931]" />
                    <div className="flex items-center justify-between relative z-10">
                        <div className="flex items-center gap-3.5">
                            <div className="w-11 h-11 rounded-2xl flex items-center justify-center shadow-sm border border-emerald-100 bg-emerald-50 text-emerald-700">
                                <MessageSquare size={22} className="stroke-[2.2]" />
                            </div>
                            <div>
                                <div className="flex items-center gap-2">
                                    <h3 className="text-lg font-black text-[#0A1931] tracking-tight">Vatan SMS Entegrasyonu</h3>
                                    <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200">
                                        REST API v1
                                    </span>
                                </div>
                                <p className="text-xs font-medium text-slate-500 mt-0.5">
                                    Otomatik OTP, canlı ders bildirimleri ve toplu SMS gönderim servisi.
                                </p>
                            </div>
                        </div>
                        <button 
                            onClick={onClose}
                            className="w-8 h-8 flex items-center justify-center rounded-full bg-white border border-slate-200 text-slate-400 hover:text-slate-700 shadow-sm transition-all"
                            title="Kapat (ESC)"
                        >
                            <X size={16} strokeWidth={2.5} />
                        </button>
                    </div>
                </div>

                {/* ── Live Balance / Status Banner ──────────────────────── */}
                {accountInfo && (
                    <div className="px-6 py-3 bg-gradient-to-r from-emerald-50 to-teal-50 border-b border-emerald-100 flex items-center justify-between flex-wrap gap-2 text-xs">
                        <div className="flex items-center gap-2 text-emerald-900 font-bold">
                            <CheckCircle2 size={15} className="text-emerald-600" />
                            <span>Hesap: {accountInfo.customerName || "Vatan SMS Hesabı"}</span>
                        </div>
                        <div className="flex items-center gap-3">
                            <span className="px-2.5 py-1 rounded-lg bg-emerald-600 text-white font-extrabold text-[11px] shadow-sm">
                                {accountInfo.balance || "0"} SMS Kredisi
                            </span>
                            {accountInfo.senders && accountInfo.senders.length > 0 && (
                                <span className="text-[11px] text-emerald-800 font-medium">
                                    {accountInfo.senders.length} Onaylı Başlık
                                </span>
                            )}
                        </div>
                    </div>
                )}

                {/* ── Tabs ──────────────────────────────────────────────── */}
                <div className="flex border-b border-slate-200/80 px-6 bg-slate-50/50 shrink-0 gap-2 overflow-x-auto">
                    <button 
                        onClick={() => setActiveTab("config")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-2 shrink-0 ${
                            activeTab === "config" 
                                ? "border-[#0A1931] text-[#0A1931] bg-white rounded-t-xl" 
                                : "border-transparent text-slate-400 hover:text-slate-700"
                        }`}
                    >
                        <Key size={14} /> API Yapılandırması
                    </button>
                    <button 
                        onClick={() => setActiveTab("triggers")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-2 shrink-0 ${
                            activeTab === "triggers" 
                                ? "border-[#0A1931] text-[#0A1931] bg-white rounded-t-xl" 
                                : "border-transparent text-slate-400 hover:text-slate-700"
                        }`}
                    >
                        <Zap size={14} className="text-amber-500" /> Otomatik Tetikleyiciler (Triggers)
                    </button>
                    <button 
                        onClick={() => setActiveTab("test")}
                        className={`px-4 py-3 text-xs font-bold border-b-2 transition-all flex items-center gap-2 shrink-0 ${
                            activeTab === "test" 
                                ? "border-[#0A1931] text-[#0A1931] bg-white rounded-t-xl" 
                                : "border-transparent text-slate-400 hover:text-slate-700"
                        }`}
                    >
                        <Smartphone size={14} /> Canlı Test SMS Gönder
                    </button>
                </div>

                {/* ── Content ───────────────────────────────────────────── */}
                <div className="flex-1 overflow-y-auto p-5 sm:p-6 bg-slate-50/30">
                    {activeTab === "config" ? (
                        <form onSubmit={handleSave} className="space-y-4">
                            {/* Enable Toggle Switch */}
                            <div className="flex items-center justify-between p-4 bg-white rounded-2xl border border-slate-200/90 shadow-sm">
                                <div>
                                    <p className="text-sm font-bold text-slate-900">Entegrasyon Durumu</p>
                                    <p className="text-xs text-slate-500 mt-0.5">Vatan SMS servisini sistem genelinde aktif veya pasif yapın.</p>
                                </div>
                                <label className="relative inline-flex items-center cursor-pointer">
                                    <input 
                                        type="checkbox" 
                                        checked={isEnabled} 
                                        onChange={e => setIsEnabled(e.target.checked)}
                                        className="sr-only peer"
                                    />
                                    <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-emerald-600"></div>
                                </label>
                            </div>

                            {/* API Credentials */}
                            <div className="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-4">
                                <div className="flex items-center justify-between border-b border-slate-100 pb-2">
                                    <h4 className="text-xs font-extrabold uppercase tracking-wider text-slate-700 flex items-center gap-1.5">
                                        <ShieldCheck size={15} className="text-[#0A1931]" /> Vatan SMS API Kimlik Bilgileri
                                    </h4>
                                    <a 
                                        href="https://vatansms.net" 
                                        target="_blank" 
                                        rel="noopener noreferrer" 
                                        className="text-[11px] text-indigo-600 hover:text-indigo-800 font-semibold flex items-center gap-1"
                                    >
                                        Panele Git & API Al <HelpCircle size={12} />
                                    </a>
                                </div>

                                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                    {/* API ID */}
                                    <div>
                                        <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                            API ID <span className="text-red-500">*</span>
                                        </label>
                                        <input 
                                            type="text"
                                            required={isEnabled}
                                            placeholder="Örn: 9a8b7c6d5e4f..."
                                            value={apiId}
                                            onChange={e => setApiId(e.target.value)}
                                            className="w-full px-3.5 py-2.5 text-xs font-mono font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all"
                                        />
                                    </div>

                                    {/* API Key */}
                                    <div>
                                        <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                            API Key <span className="text-red-500">*</span>
                                        </label>
                                        <div className="relative">
                                            <input 
                                                type={showApiKey ? "text" : "password"}
                                                required={isEnabled}
                                                placeholder="Örn: 1a2b3c4d5e..."
                                                value={apiKey}
                                                onChange={e => setApiKey(e.target.value)}
                                                className="w-full pl-3.5 pr-9 py-2.5 text-xs font-mono font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all"
                                            />
                                            <button 
                                                type="button"
                                                onClick={() => setShowApiKey(!showApiKey)}
                                                className="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                                            >
                                                {showApiKey ? <EyeOff size={15} /> : <Eye size={15} />}
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                {/* Gönderici Başlığı (Sender) */}
                                <div>
                                    <div className="flex items-center justify-between mb-1.5">
                                        <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block">
                                            Gönderici Başlığı (Sender) <span className="text-red-500">*</span>
                                        </label>
                                        {availableSenders.length > 0 && (
                                            <span className="text-[10px] text-emerald-600 font-bold">
                                                ✓ {availableSenders.length} Onaylı Başlık Bulundu
                                            </span>
                                        )}
                                    </div>

                                    {availableSenders.length > 0 ? (
                                        <select 
                                            value={sender}
                                            onChange={e => setSender(e.target.value)}
                                            className="w-full px-3.5 py-2.5 text-xs font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all cursor-pointer"
                                        >
                                            <option value="">— Başlık Seçin —</option>
                                            {availableSenders.map(s => (
                                                <option key={s} value={s}>{s}</option>
                                            ))}
                                        </select>
                                    ) : (
                                        <input 
                                            type="text"
                                            placeholder="Örn: 4T AKADEMI veya VATANSMS"
                                            value={sender}
                                            onChange={e => setSender(e.target.value)}
                                            className="w-full px-3.5 py-2.5 text-xs font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all"
                                        />
                                    )}
                                    <p className="text-[11px] text-slate-400 mt-1">Vatan SMS hesabınızda onaylanmış olan SMS başlığıdır (11 karakter sınırı).</p>
                                </div>

                                {/* Mesaj Türleri */}
                                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
                                    <div>
                                        <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                            Karakter Seti
                                        </label>
                                        <div className="grid grid-cols-2 gap-2">
                                            <button
                                                type="button"
                                                onClick={() => setMessageType("normal")}
                                                className={`px-3 py-2 text-xs font-bold rounded-xl border transition-all ${
                                                    messageType === "normal"
                                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-sm"
                                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                                }`}
                                            >
                                                Normal (160 Karakter)
                                            </button>
                                            <button
                                                type="button"
                                                onClick={() => setMessageType("turkce")}
                                                className={`px-3 py-2 text-xs font-bold rounded-xl border transition-all ${
                                                    messageType === "turkce"
                                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-sm"
                                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                                }`}
                                            >
                                                Türkçe (155 Karakter)
                                            </button>
                                        </div>
                                    </div>

                                    <div>
                                        <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                            İçerik Türü
                                        </label>
                                        <div className="grid grid-cols-2 gap-2">
                                            <button
                                                type="button"
                                                onClick={() => setMessageContentType("bilgi")}
                                                className={`px-3 py-2 text-xs font-bold rounded-xl border transition-all ${
                                                    messageContentType === "bilgi"
                                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-sm"
                                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                                }`}
                                            >
                                                Bilgilendirme / OTP
                                            </button>
                                            <button
                                                type="button"
                                                onClick={() => setMessageContentType("ticari")}
                                                className={`px-3 py-2 text-xs font-bold rounded-xl border transition-all ${
                                                    messageContentType === "ticari"
                                                        ? "bg-[#0A1931] text-white border-[#0A1931] shadow-sm"
                                                        : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                                                }`}
                                            >
                                                Ticari / Tanıtım
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Actions */}
                            <div className="flex items-center justify-between gap-3 pt-2">
                                <button
                                    type="button"
                                    onClick={handleTestConnection}
                                    disabled={testing || !apiId || !apiKey}
                                    className="px-4 py-2.5 bg-emerald-50 hover:bg-emerald-100 text-emerald-800 border border-emerald-200 text-xs font-bold rounded-xl transition-all shadow-sm flex items-center gap-2 disabled:opacity-50"
                                >
                                    {testing ? <Loader2 size={14} className="animate-spin text-emerald-600" /> : <Sparkles size={14} className="text-emerald-600" />}
                                    Bağlantıyı Test Et & Bakiye Sorgula
                                </button>

                                <div className="flex items-center gap-2">
                                    <button
                                        type="button"
                                        onClick={onClose}
                                        className="px-4 py-2.5 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-all"
                                    >
                                        Vazgeç
                                    </button>
                                    <button
                                        type="submit"
                                        disabled={saving}
                                        className="px-5 py-2.5 bg-[#0A1931] hover:bg-[#1B3B6F] text-white text-xs font-bold rounded-xl shadow-md transition-all flex items-center gap-1.5 disabled:opacity-50"
                                    >
                                        {saving ? <Loader2 size={14} className="animate-spin" /> : <Check size={14} strokeWidth={2.5} />}
                                        Ayarları Kaydet
                                    </button>
                                </div>
                            </div>
                        </form>
                    ) : activeTab === "triggers" ? (
                        /* ── Tab 3: Automated Triggers ─────────────────────────── */
                        <form onSubmit={handleSaveTriggers} className="space-y-4">
                            <div className="p-3.5 bg-amber-50/70 border border-amber-200 rounded-2xl text-xs text-amber-900">
                                <p className="font-bold flex items-center gap-1.5">
                                    <Zap size={14} className="text-amber-600" /> Otomatik SMS Tetikleyicileri
                                </p>
                                <p className="text-[11px] text-amber-800 mt-1">
                                    Bu alandaki şablonlarda <code>{`{ad}`}</code>, <code>{`{soyad}`}</code>, <code>{`{kurs}`}</code>, <code>{`{giris_linki}`}</code>, <code>{`{kullanici_adi}`}</code> değişkenlerini kullanabilirsiniz.
                                </p>
                            </div>

                            {/* 1. Canlı Ders Başlama SMS'i */}
                            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-2.5">
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2">
                                        <div className="w-8 h-8 rounded-lg bg-rose-50 border border-rose-100 text-rose-600 flex items-center justify-center">
                                            <Play size={14} />
                                        </div>
                                        <div>
                                            <p className="text-xs font-bold text-slate-900">Canlı Ders Başladı SMS'i</p>
                                            <p className="text-[10px] text-slate-400">Eğitmen canlı yayını başlattığında kayıtlı öğrencilere otomatik SMS gider.</p>
                                        </div>
                                    </div>
                                    <label className="relative inline-flex items-center cursor-pointer">
                                        <input 
                                            type="checkbox" 
                                            checked={triggers.liveLessonStartedEnabled} 
                                            onChange={e => setTriggers({ ...triggers, liveLessonStartedEnabled: e.target.checked })}
                                            className="sr-only peer"
                                        />
                                        <div className="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-emerald-600"></div>
                                    </label>
                                </div>
                                <textarea
                                    rows={2}
                                    value={triggers.liveLessonStartedTemplate}
                                    onChange={e => setTriggers({ ...triggers, liveLessonStartedTemplate: e.target.value })}
                                    className="w-full px-3 py-2 text-xs font-medium border border-slate-200 rounded-xl bg-slate-50 focus:bg-white focus:outline-none focus:ring-1 focus:ring-[#0A1931] resize-none"
                                />
                            </div>

                            {/* 2. Yeni Öğrenci Hoş Geldin SMS'i */}
                            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-2.5">
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2">
                                        <div className="w-8 h-8 rounded-lg bg-indigo-50 border border-indigo-100 text-indigo-600 flex items-center justify-center">
                                            <UserCheck size={14} />
                                        </div>
                                        <div>
                                            <p className="text-xs font-bold text-slate-900">Yeni Öğrenci Hoş Geldin & Giriş Bilgileri</p>
                                            <p className="text-[10px] text-slate-400">Öğrenci kaydı oluşturulduğunda kullanıcı adı ve giriş linki SMS ile iletilir.</p>
                                        </div>
                                    </div>
                                    <label className="relative inline-flex items-center cursor-pointer">
                                        <input 
                                            type="checkbox" 
                                            checked={triggers.welcomeStudentEnabled} 
                                            onChange={e => setTriggers({ ...triggers, welcomeStudentEnabled: e.target.checked })}
                                            className="sr-only peer"
                                        />
                                        <div className="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-emerald-600"></div>
                                    </label>
                                </div>
                                <textarea
                                    rows={2}
                                    value={triggers.welcomeStudentTemplate}
                                    onChange={e => setTriggers({ ...triggers, welcomeStudentTemplate: e.target.value })}
                                    className="w-full px-3 py-2 text-xs font-medium border border-slate-200 rounded-xl bg-slate-50 focus:bg-white focus:outline-none focus:ring-1 focus:ring-[#0A1931] resize-none"
                                />
                            </div>

                            {/* 3. Ders Kaydı Düştü SMS'i */}
                            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-2.5">
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2">
                                        <div className="w-8 h-8 rounded-lg bg-teal-50 border border-teal-100 text-teal-600 flex items-center justify-center">
                                            <Video size={14} />
                                        </div>
                                        <div>
                                            <p className="text-xs font-bold text-slate-900">Ders Tekrar Kaydı Hazır Bildirimi</p>
                                            <p className="text-[10px] text-slate-400">BBB ders kaydı işlenip sisteme düştüğünde öğrencilere otomatik SMS gider.</p>
                                        </div>
                                    </div>
                                    <label className="relative inline-flex items-center cursor-pointer">
                                        <input 
                                            type="checkbox" 
                                            checked={triggers.recordingReadyEnabled} 
                                            onChange={e => setTriggers({ ...triggers, recordingReadyEnabled: e.target.checked })}
                                            className="sr-only peer"
                                        />
                                        <div className="w-9 h-5 bg-slate-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-4 after:w-4 after:transition-all peer-checked:bg-emerald-600"></div>
                                    </label>
                                </div>
                                <textarea
                                    rows={2}
                                    value={triggers.recordingReadyTemplate}
                                    onChange={e => setTriggers({ ...triggers, recordingReadyTemplate: e.target.value })}
                                    className="w-full px-3 py-2 text-xs font-medium border border-slate-200 rounded-xl bg-slate-50 focus:bg-white focus:outline-none focus:ring-1 focus:ring-[#0A1931] resize-none"
                                />
                            </div>

                            <div className="flex justify-end gap-2 pt-2">
                                <button
                                    type="button"
                                    onClick={onClose}
                                    className="px-4 py-2.5 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-all"
                                >
                                    Kapat
                                </button>
                                <button
                                    type="submit"
                                    disabled={savingTriggers}
                                    className="px-5 py-2.5 bg-[#0A1931] hover:bg-[#1B3B6F] text-white text-xs font-bold rounded-xl shadow-md transition-all flex items-center gap-1.5 disabled:opacity-50"
                                >
                                    {savingTriggers ? <Loader2 size={14} className="animate-spin" /> : <Check size={14} strokeWidth={2.5} />}
                                    Tetikleyici Ayarlarını Kaydet
                                </button>
                            </div>
                        </form>
                    ) : (
                        /* ── Tab 2: Test SMS Form ──────────────────────────────── */
                        <form onSubmit={handleSendTestSms} className="space-y-4">
                            <div className="bg-white p-5 rounded-2xl border border-slate-200/90 shadow-sm space-y-4">
                                <div>
                                    <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block mb-1.5">
                                        Alıcı Telefon Numarası <span className="text-red-500">*</span>
                                    </label>
                                    <input 
                                        type="tel"
                                        required
                                        placeholder="05xx xxx xx xx veya 5xxxxxxxxx"
                                        value={testPhone}
                                        onChange={e => setTestPhone(e.target.value)}
                                        className="w-full px-3.5 py-2.5 text-xs font-bold border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all"
                                    />
                                    <p className="text-[11px] text-slate-400 mt-1">Test SMS'inin gideceği cep telefonu numarasını yazın.</p>
                                </div>

                                <div>
                                    <div className="flex items-center justify-between mb-1.5">
                                        <label className="text-[11px] font-extrabold text-slate-600 uppercase tracking-wider block">
                                            Mesaj Metni <span className="text-red-500">*</span>
                                        </label>
                                        <span className="text-[11px] font-bold text-slate-400">
                                            {charCount} Karakter ({smsCount} SMS Boyutu)
                                        </span>
                                    </div>
                                    <textarea 
                                        required
                                        rows={4}
                                        value={testMessage}
                                        onChange={e => setTestMessage(e.target.value)}
                                        className="w-full px-3.5 py-2.5 text-xs font-medium border border-slate-200 rounded-xl text-slate-900 bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#0A1931] focus:bg-white transition-all resize-none"
                                    />
                                </div>

                                {testResult && (
                                    <div className={`p-4 rounded-2xl border text-xs ${
                                        testResult.success 
                                            ? "bg-emerald-50 border-emerald-200 text-emerald-900" 
                                            : "bg-rose-50 border-rose-200 text-rose-900"
                                    }`}>
                                        <div className="flex items-center gap-2 font-bold mb-1">
                                            {testResult.success ? <CheckCircle2 size={16} className="text-emerald-600" /> : <AlertCircle size={16} className="text-rose-600" />}
                                            <span>{testResult.success ? "SMS Başarıyla İletildi" : "Gönderim Hatası"}</span>
                                        </div>
                                        <p className="text-[11px] mt-0.5">{testResult.message}</p>
                                        {testResult.reportId && (
                                            <p className="text-[10px] font-mono text-emerald-700 mt-1">
                                                Rapor ID: {testResult.reportId}
                                            </p>
                                        )}
                                    </div>
                                )}
                            </div>

                            <div className="flex justify-end gap-2 pt-2">
                                <button
                                    type="button"
                                    onClick={onClose}
                                    className="px-4 py-2.5 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-all"
                                >
                                    Kapat
                                </button>
                                <button
                                    type="submit"
                                    disabled={sendingTest || !testPhone || !testMessage}
                                    className="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-md transition-all flex items-center gap-2 disabled:opacity-50 active:scale-95"
                                >
                                    {sendingTest ? <Loader2 size={14} className="animate-spin" /> : <Send size={14} />}
                                    Test SMS Gönder
                                </button>
                            </div>
                        </form>
                    )}
                </div>
            </div>
        </div>
    );

    return createPortal(modalContent, document.body);
}
