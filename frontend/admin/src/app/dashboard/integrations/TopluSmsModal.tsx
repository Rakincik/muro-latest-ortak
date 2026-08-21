"use client";

import React, { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { 
    X, Key, Send, CheckCircle2, AlertCircle, Loader2, Eye, EyeOff, 
    Sparkles, RefreshCw, Smartphone, MessageSquare, Check, ShieldCheck,
    CreditCard, Building2, HelpCircle, BellRing, Zap, Play, UserCheck, Video,
    ExternalLink
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { 
    adminIntegrationApi, 
    adminSmsCenterApi,
    type IntegrationItem, 
    type TopluSmsConfig, 
    type SmsAccountInfo,
    type SmsTriggerSettings
} from "@/lib/api";

interface TopluSmsModalProps {
    isOpen: boolean;
    onClose: () => void;
    integration: IntegrationItem | null;
    onSuccess: () => void;
}

export function TopluSmsModal({ isOpen, onClose, integration, onSuccess }: TopluSmsModalProps) {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [mounted, setMounted] = useState(false);
    const [activeTab, setActiveTab] = useState<"config" | "triggers" | "test">("config");

    // Form fields
    const [apiKey, setApiKey] = useState("");
    const [sender, setSender] = useState("");
    const [messageType, setMessageType] = useState<"normal" | "turkce">("normal");
    const [messageContentType, setMessageContentType] = useState<"bilgi" | "ticari">("bilgi");
    const [addCancelLink, setAddCancelLink] = useState(false);
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
    const [testMessage, setTestMessage] = useState("MURO TopluSMS entegrasyonu başarıyla test edildi! Dersler ve bildirimler SMS ile iletilebilir.");
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
                    const cfg: TopluSmsConfig = JSON.parse(integration.configJson);
                    setApiKey(cfg.apiKey || "");
                    setSender(cfg.sender || "");
                    setMessageType(cfg.messageType || "normal");
                    setMessageContentType(cfg.messageContentType || "bilgi");
                    setAddCancelLink(cfg.addCancelLink || false);
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

    if (!isOpen || !mounted) return null;

    const handleTestConnection = async () => {
        if (!apiKey.trim()) {
            toastError("Lütfen API Key alanını doldurunuz.");
            return;
        }

        setTesting(true);
        setAccountInfo(null);

        try {
            const configPayload = JSON.stringify({
                apiKey: apiKey.trim(),
                sender: sender.trim(),
                messageType,
                messageContentType,
                addCancelLink
            });

            const res = await adminIntegrationApi.test(token, tenantId, "toplusms", {
                configJson: configPayload
            });

            setAccountInfo(res);
            if (res.senders && res.senders.length > 0) {
                setAvailableSenders(res.senders);
                if (!sender && res.senders.length > 0) {
                    setSender(res.senders[0]);
                }
            }

            if (res.success) {
                success("TopluSMS bağlantısı başarılı! Hesap bilgileri ve başlıklar güncellendi.");
            } else {
                toastError(res.message || "Bağlantı kurulamadı. API Key bilgilerinizi kontrol ediniz.");
            }
        } catch (err: any) {
            toastError(err.message || "Test sırasında bir hata oluştu.");
            setAccountInfo({
                success: false,
                senders: [],
                message: err.message || "Sunucuya ulaşılamadı."
            });
        } finally {
            setTesting(false);
        }
    };

    const handleSaveConfig = async () => {
        if (isEnabled && !apiKey.trim()) {
            toastError("Entegrasyonu aktif edebilmek için API Key zorunludur.");
            return;
        }

        setSaving(true);
        try {
            const configToSave: TopluSmsConfig = {
                apiKey: apiKey.trim(),
                sender: sender.trim(),
                messageType,
                messageContentType,
                addCancelLink
            };

            await adminIntegrationApi.update(token, tenantId, "toplusms", {
                isEnabled,
                configJson: JSON.stringify(configToSave)
            });

            success("TopluSMS entegrasyon ayarları başarıyla kaydedildi.");
            onSuccess();
            onClose();
        } catch (err: any) {
            toastError(err.message || "Ayarlar kaydedilemedi.");
        } finally {
            setSaving(false);
        }
    };

    const handleSaveTriggers = async () => {
        setSavingTriggers(true);
        try {
            await adminSmsCenterApi.saveTriggers(token, tenantId, triggers);
            success("Otomatik SMS tetikleyici ayarları başarıyla kaydedildi.");
        } catch (err: any) {
            toastError(err.message || "Tetikleyici ayarları kaydedilemedi.");
        } finally {
            setSavingTriggers(false);
        }
    };

    const handleSendTestSms = async () => {
        if (!testPhone.trim() || testPhone.replace(/\D/g, "").length < 10) {
            toastError("Geçerli bir telefon numarası giriniz (Örn: 555 123 45 67).");
            return;
        }

        setSendingTest(true);
        setTestResult(null);

        try {
            const res = await adminSmsCenterApi.sendDirectSms(token, tenantId, {
                phone: testPhone.trim(),
                message: testMessage.trim(),
                sender: sender.trim() || undefined
            });

            setTestResult(res);
            if (res.success) {
                success("Test SMS başarıyla gönderildi!");
            } else {
                toastError(res.message || "SMS gönderilemedi.");
            }
        } catch (err: any) {
            toastError(err.message || "Test SMS gönderilirken hata oluştu.");
            setTestResult({
                success: false,
                message: err.message || "İletişim hatası oluştu."
            });
        } finally {
            setSendingTest(false);
        }
    };

    return createPortal(
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-in fade-in duration-200">
            <div 
                className="bg-[#0f172a] border border-slate-700/80 rounded-2xl w-full max-w-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh] text-slate-200"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-900/60">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center text-white shadow-lg shadow-orange-500/20">
                            <MessageSquare className="w-5 h-5" />
                        </div>
                        <div>
                            <div className="flex items-center gap-2">
                                <h3 className="text-lg font-bold text-white tracking-wide">Toplu SMS Entegrasyonu</h3>
                                <span className="px-2 py-0.5 text-[11px] font-semibold bg-orange-500/10 text-orange-400 border border-orange-500/20 rounded-full">
                                    api.toplusms.app
                                </span>
                            </div>
                            <p className="text-xs text-slate-400">VatanSMS yeni nesil REST API servisi</p>
                        </div>
                    </div>
                    <button 
                        onClick={onClose}
                        className="p-2 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition-colors"
                    >
                        <X size={20} />
                    </button>
                </div>

                {/* Navigation Tabs */}
                <div className="flex items-center px-6 border-b border-slate-800 bg-slate-950/40 gap-2">
                    <button
                        onClick={() => setActiveTab("config")}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all ${
                            activeTab === "config" 
                                ? "border-orange-500 text-orange-400 bg-orange-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <Key size={15} />
                        API Bağlantı Ayarları
                    </button>
                    <button
                        onClick={() => setActiveTab("triggers")}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all ${
                            activeTab === "triggers" 
                                ? "border-orange-500 text-orange-400 bg-orange-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <BellRing size={15} />
                        Otomatik Tetikleyiciler
                    </button>
                    <button
                        onClick={() => setActiveTab("test")}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all ${
                            activeTab === "test" 
                                ? "border-orange-500 text-orange-400 bg-orange-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <Send size={15} />
                        Canlı Test Gönderimi
                    </button>
                </div>

                {/* Body Content */}
                <div className="flex-1 overflow-y-auto p-6 space-y-6">
                    {/* TAB 1: API CONFIG */}
                    {activeTab === "config" && (
                        <div className="space-y-6">
                            {/* Enable Switch Card */}
                            <div className="flex items-center justify-between p-4 rounded-xl bg-slate-900/80 border border-slate-800">
                                <div>
                                    <div className="text-sm font-semibold text-white">TopluSMS Servisini Etkinleştir</div>
                                    <div className="text-xs text-slate-400">Aktif edildiğinde sistem tüm SMS bildirimlerini bu servis üzerinden iletir.</div>
                                </div>
                                <label className="relative inline-flex items-center cursor-pointer">
                                    <input 
                                        type="checkbox" 
                                        checked={isEnabled} 
                                        onChange={(e) => setIsEnabled(e.target.checked)}
                                        className="sr-only peer" 
                                    />
                                    <div className="w-11 h-6 bg-slate-700 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-orange-600"></div>
                                </label>
                            </div>

                            {/* Live Account Status Banner if tested */}
                            {accountInfo && (
                                <div className={`p-4 rounded-xl border flex items-start gap-3 ${
                                    accountInfo.success 
                                        ? "bg-emerald-950/30 border-emerald-500/30 text-emerald-300" 
                                        : "bg-rose-950/30 border-rose-500/30 text-rose-300"
                                }`}>
                                    {accountInfo.success ? (
                                        <CheckCircle2 className="w-5 h-5 text-emerald-400 shrink-0 mt-0.5" />
                                    ) : (
                                        <AlertCircle className="w-5 h-5 text-rose-400 shrink-0 mt-0.5" />
                                    )}
                                    <div className="flex-1 text-xs space-y-1">
                                        <div className="font-semibold text-sm">
                                            {accountInfo.success ? "Bağlantı Doğrulandı" : "Bağlantı Başarısız"}
                                        </div>
                                        <div>{accountInfo.message}</div>
                                        {accountInfo.success && (
                                            <div className="flex flex-wrap items-center gap-4 pt-2 text-slate-300">
                                                {accountInfo.customerName && (
                                                    <span className="flex items-center gap-1 font-medium text-white">
                                                        <Building2 size={13} className="text-emerald-400" />
                                                        {accountInfo.customerName}
                                                    </span>
                                                )}
                                                {accountInfo.balance !== undefined && (
                                                    <span className="flex items-center gap-1 font-bold text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded border border-amber-500/20">
                                                        <CreditCard size={13} />
                                                        Kalan SMS: {accountInfo.balance}
                                                    </span>
                                                )}
                                                {accountInfo.senders && accountInfo.senders.length > 0 && (
                                                    <span className="flex items-center gap-1 text-slate-400">
                                                        <ShieldCheck size={13} className="text-emerald-400" />
                                                        {accountInfo.senders.length} Başlık Tanımlı
                                                    </span>
                                                )}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            )}

                            {/* Credentials Grid */}
                            <div className="grid grid-cols-1 gap-4">
                                <div>
                                    <label className="block text-xs font-semibold text-slate-300 mb-1.5 flex items-center justify-between">
                                        <span>API Key (Gizli Anahtar) *</span>
                                        <a 
                                            href="https://api.toplusms.app" 
                                            target="_blank" 
                                            rel="noreferrer" 
                                            className="text-[11px] text-orange-400 hover:text-orange-300 flex items-center gap-1 transition-colors"
                                        >
                                            Panelden API Key Al <ExternalLink size={11} />
                                        </a>
                                    </label>
                                    <div className="relative">
                                        <input 
                                            type={showApiKey ? "text" : "password"} 
                                            value={apiKey}
                                            onChange={(e) => setApiKey(e.target.value)}
                                            placeholder="Örn: 9a7b5c3d2e1f..." 
                                            className="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-white placeholder:text-slate-600 focus:outline-none focus:border-orange-500 font-mono"
                                        />
                                        <button
                                            type="button"
                                            onClick={() => setShowApiKey(!showApiKey)}
                                            className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300"
                                        >
                                            {showApiKey ? <EyeOff size={16} /> : <Eye size={16} />}
                                        </button>
                                    </div>
                                </div>

                                <div>
                                    <label className="block text-xs font-semibold text-slate-300 mb-1.5">
                                        Gönderici Başlığı (Sender / Originator) *
                                    </label>
                                    {availableSenders.length > 0 ? (
                                        <div className="space-y-1.5">
                                            <select
                                                value={sender}
                                                onChange={(e) => setSender(e.target.value)}
                                                className="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-white focus:outline-none focus:border-orange-500"
                                            >
                                                <option value="">Başlık Seçiniz...</option>
                                                {availableSenders.map(s => (
                                                    <option key={s} value={s}>{s}</option>
                                                ))}
                                            </select>
                                            <div className="text-[11px] text-emerald-400/90 flex items-center gap-1">
                                                <Check size={12} /> Hesabınıza tanımlı onaylı başlıklar otomatik getirildi.
                                            </div>
                                        </div>
                                    ) : (
                                        <input 
                                            type="text" 
                                            value={sender}
                                            onChange={(e) => setSender(e.target.value)}
                                            placeholder="Örn: AKADEMIK veya TOPLUSMS" 
                                            className="w-full bg-slate-900 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-white placeholder:text-slate-600 focus:outline-none focus:border-orange-500 font-mono uppercase"
                                        />
                                    )}
                                </div>
                            </div>

                            {/* Advanced Options */}
                            <div className="p-4 rounded-xl bg-slate-900/40 border border-slate-800 space-y-4">
                                <div className="text-xs font-bold text-slate-300 uppercase tracking-wider">Gelişmiş Gönderim Ayarları</div>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label className="block text-xs font-medium text-slate-400 mb-1">Mesaj Karakter Tipi</label>
                                        <select
                                            value={messageType}
                                            onChange={(e) => setMessageType(e.target.value as any)}
                                            className="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-orange-500"
                                        >
                                            <option value="normal">Normal (Standart GSM - 160 Karakter)</option>
                                            <option value="turkce">Türkçe Karakter Destekli</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label className="block text-xs font-medium text-slate-400 mb-1">İçerik Türü (İYS)</label>
                                        <select
                                            value={messageContentType}
                                            onChange={(e) => setMessageContentType(e.target.value as any)}
                                            className="w-full bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-orange-500"
                                        >
                                            <option value="bilgi">Bilgilendirme (Eğitim/Ders Duyurusu)</option>
                                            <option value="ticari">Ticari / Kampanya</option>
                                        </select>
                                    </div>
                                </div>

                                <div className="flex items-center justify-between pt-2 border-t border-slate-800">
                                    <div>
                                        <div className="text-xs font-semibold text-slate-200">İptal Linki Ekle (add_cancel_link)</div>
                                        <div className="text-[11px] text-slate-400">Ticari mesajlar için SMS sonuna SMS iptal bağlantısı ekler.</div>
                                    </div>
                                    <input 
                                        type="checkbox"
                                        checked={addCancelLink}
                                        onChange={(e) => setAddCancelLink(e.target.checked)}
                                        className="w-4 h-4 rounded border-slate-700 text-orange-600 focus:ring-orange-500"
                                    />
                                </div>
                            </div>
                        </div>
                    )}

                    {/* TAB 2: TRIGGERS */}
                    {activeTab === "triggers" && (
                        <div className="space-y-5">
                            <div className="p-3.5 rounded-xl bg-orange-500/10 border border-orange-500/20 text-orange-300 text-xs flex items-start gap-2.5">
                                <Zap className="w-4 h-4 shrink-0 mt-0.5 text-orange-400" />
                                <div>
                                    Canlı dersler başladığında veya yeni kayıt açıldığında öğrencilere otomatik gidecek SMS şablonlarını buradan yönetebilirsiniz. Şablonlarda <b>&#123;ad&#125;</b>, <b>&#123;kurs&#125;</b>, <b>&#123;giris_linki&#125;</b> gibi değişkenler otomatik doldurulur.
                                </div>
                            </div>

                            {loadingTriggers ? (
                                <div className="py-12 flex flex-col items-center justify-center gap-2 text-slate-400 text-xs">
                                    <Loader2 className="w-6 h-6 animate-spin text-orange-500" />
                                    Tetikleyici ayarları yükleniyor...
                                </div>
                            ) : (
                                <div className="space-y-4">
                                    {/* Trigger 1: Live Lesson Started */}
                                    <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-3">
                                        <div className="flex items-center justify-between">
                                            <div className="flex items-center gap-2">
                                                <Play size={16} className="text-emerald-400" />
                                                <span className="text-xs font-bold text-white">Canlı Ders Başladığında SMS Gönder</span>
                                            </div>
                                            <label className="relative inline-flex items-center cursor-pointer">
                                                <input 
                                                    type="checkbox" 
                                                    checked={triggers.liveLessonStartedEnabled} 
                                                    onChange={(e) => setTriggers({ ...triggers, liveLessonStartedEnabled: e.target.checked })}
                                                    className="sr-only peer" 
                                                />
                                                <div className="w-9 h-5 bg-slate-700 rounded-full peer peer-checked:after:translate-x-full peer-checked:bg-emerald-600 after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all"></div>
                                            </label>
                                        </div>
                                        {triggers.liveLessonStartedEnabled && (
                                            <textarea
                                                value={triggers.liveLessonStartedTemplate}
                                                onChange={(e) => setTriggers({ ...triggers, liveLessonStartedTemplate: e.target.value })}
                                                rows={2}
                                                className="w-full bg-slate-950 border border-slate-800 rounded-lg p-2.5 text-xs text-slate-200 focus:outline-none focus:border-orange-500"
                                            />
                                        )}
                                    </div>

                                    {/* Trigger 2: Welcome Student */}
                                    <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-3">
                                        <div className="flex items-center justify-between">
                                            <div className="flex items-center gap-2">
                                                <UserCheck size={16} className="text-blue-400" />
                                                <span className="text-xs font-bold text-white">Yeni Öğrenci Eklendiğinde Hoş Geldin SMS'i</span>
                                            </div>
                                            <label className="relative inline-flex items-center cursor-pointer">
                                                <input 
                                                    type="checkbox" 
                                                    checked={triggers.welcomeStudentEnabled} 
                                                    onChange={(e) => setTriggers({ ...triggers, welcomeStudentEnabled: e.target.checked })}
                                                    className="sr-only peer" 
                                                />
                                                <div className="w-9 h-5 bg-slate-700 rounded-full peer peer-checked:after:translate-x-full peer-checked:bg-blue-600 after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all"></div>
                                            </label>
                                        </div>
                                        {triggers.welcomeStudentEnabled && (
                                            <textarea
                                                value={triggers.welcomeStudentTemplate}
                                                onChange={(e) => setTriggers({ ...triggers, welcomeStudentTemplate: e.target.value })}
                                                rows={2}
                                                className="w-full bg-slate-950 border border-slate-800 rounded-lg p-2.5 text-xs text-slate-200 focus:outline-none focus:border-orange-500"
                                            />
                                        )}
                                    </div>

                                    {/* Trigger 3: Recording Ready */}
                                    <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-3">
                                        <div className="flex items-center justify-between">
                                            <div className="flex items-center gap-2">
                                                <Video size={16} className="text-purple-400" />
                                                <span className="text-xs font-bold text-white">Ders Tekrar Kaydı Hazır Olduğunda</span>
                                            </div>
                                            <label className="relative inline-flex items-center cursor-pointer">
                                                <input 
                                                    type="checkbox" 
                                                    checked={triggers.recordingReadyEnabled} 
                                                    onChange={(e) => setTriggers({ ...triggers, recordingReadyEnabled: e.target.checked })}
                                                    className="sr-only peer" 
                                                />
                                                <div className="w-9 h-5 bg-slate-700 rounded-full peer peer-checked:after:translate-x-full peer-checked:bg-purple-600 after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-4 after:w-4 after:transition-all"></div>
                                            </label>
                                        </div>
                                        {triggers.recordingReadyEnabled && (
                                            <textarea
                                                value={triggers.recordingReadyTemplate}
                                                onChange={(e) => setTriggers({ ...triggers, recordingReadyTemplate: e.target.value })}
                                                rows={2}
                                                className="w-full bg-slate-950 border border-slate-800 rounded-lg p-2.5 text-xs text-slate-200 focus:outline-none focus:border-orange-500"
                                            />
                                        )}
                                    </div>

                                    <button
                                        onClick={handleSaveTriggers}
                                        disabled={savingTriggers}
                                        className="w-full py-2.5 px-4 bg-slate-800 hover:bg-slate-700 text-white text-xs font-semibold rounded-xl transition-colors flex items-center justify-center gap-2"
                                    >
                                        {savingTriggers ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check size={14} />}
                                        Tetikleyici Şablonlarını Kaydet
                                    </button>
                                </div>
                            )}
                        </div>
                    )}

                    {/* TAB 3: LIVE TEST */}
                    {activeTab === "test" && (
                        <div className="space-y-4">
                            <div className="p-4 rounded-xl bg-slate-900/80 border border-slate-800 space-y-3">
                                <div className="text-xs font-bold text-white flex items-center gap-2">
                                    <Smartphone size={15} className="text-orange-400" />
                                    Canlı Numara ile Test SMS'i Gönder
                                </div>
                                <p className="text-xs text-slate-400">
                                    Girdiğiniz ayarların ve başlığın sorunsuz çalıştığını doğrulamak için kendi telefonunuza anlık test SMS'i atabilirsiniz.
                                </p>

                                <div>
                                    <label className="block text-xs font-medium text-slate-300 mb-1">Telefon Numarası</label>
                                    <input 
                                        type="tel" 
                                        value={testPhone}
                                        onChange={(e) => setTestPhone(e.target.value)}
                                        placeholder="555 123 45 67" 
                                        className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2.5 text-sm text-white placeholder:text-slate-600 focus:outline-none focus:border-orange-500 font-mono"
                                    />
                                </div>

                                <div>
                                    <label className="block text-xs font-medium text-slate-300 mb-1">Mesaj Metni</label>
                                    <textarea 
                                        value={testMessage}
                                        onChange={(e) => setTestMessage(e.target.value)}
                                        rows={2}
                                        className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-orange-500"
                                    />
                                </div>

                                <button
                                    onClick={handleSendTestSms}
                                    disabled={sendingTest}
                                    className="w-full py-2.5 px-4 bg-gradient-to-r from-orange-600 to-amber-600 hover:from-orange-500 hover:to-amber-500 text-white text-xs font-bold rounded-xl transition-all shadow-lg shadow-orange-600/20 flex items-center justify-center gap-2 disabled:opacity-50"
                                >
                                    {sendingTest ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send size={14} />}
                                    Test SMS Gönder
                                </button>

                                {testResult && (
                                    <div className={`p-3 rounded-lg text-xs mt-2 border ${
                                        testResult.success ? "bg-emerald-950/40 border-emerald-500/30 text-emerald-300" : "bg-rose-950/40 border-rose-500/30 text-rose-300"
                                    }`}>
                                        <div className="font-bold">{testResult.success ? "SMS Gönderildi" : "Gönderim Başarısız"}</div>
                                        <div>{testResult.message}</div>
                                        {testResult.reportId && (
                                            <div className="text-[11px] font-mono text-slate-400 mt-1">Rapor ID: {testResult.reportId}</div>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>
                    )}
                </div>

                {/* Footer Buttons */}
                <div className="flex items-center justify-between px-6 py-4 border-t border-slate-800 bg-slate-900/60">
                    <button
                        type="button"
                        onClick={handleTestConnection}
                        disabled={testing || !apiKey.trim()}
                        className="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-semibold rounded-xl transition-colors flex items-center gap-2 disabled:opacity-50"
                    >
                        {testing ? <Loader2 className="w-3.5 h-3.5 animate-spin text-orange-400" /> : <RefreshCw size={13} />}
                        Bağlantıyı Test Et & Başlıkları Çek
                    </button>

                    <div className="flex items-center gap-3">
                        <button
                            type="button"
                            onClick={onClose}
                            className="px-4 py-2 text-xs font-semibold text-slate-400 hover:text-white transition-colors"
                        >
                            İptal
                        </button>
                        <button
                            type="button"
                            onClick={handleSaveConfig}
                            disabled={saving}
                            className="px-5 py-2 bg-gradient-to-r from-orange-600 to-amber-600 hover:from-orange-500 hover:to-amber-500 text-white text-xs font-bold rounded-xl transition-all shadow-lg shadow-orange-600/20 flex items-center gap-2 disabled:opacity-50"
                        >
                            {saving ? <Loader2 className="w-3.5 h-3.5 animate-spin" /> : <Check size={14} />}
                            Ayarları Kaydet
                        </button>
                    </div>
                </div>
            </div>
        </div>,
        document.body
    );
}
