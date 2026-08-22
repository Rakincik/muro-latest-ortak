"use client";

import React, { useState, useEffect, useCallback } from "react";
import { createPortal } from "react-dom";
import { 
    X, Key, Copy, Check, RefreshCw, Terminal, Shield, Play, 
    AlertCircle, CheckCircle2, Loader2, Code2, Globe, Clock, 
    Layers, ExternalLink, Zap, ArrowRight, Smartphone, BookOpen,
    Send, Sparkles, UserMinus, UserPlus, Radio
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/components/toast";
import { 
    adminConnectApi, 
    type TenantApiKeyInfo, 
    type ConnectApiLogItem,
    type ConnectEnrollResult,
    type ConnectPackageDto,
    type ConnectDemoResult,
    type ConnectUnenrollResult
} from "@/lib/api";

interface MuroConnectModalProps {
    isOpen: boolean;
    onClose: () => void;
}

type SimulatorMode = "enroll" | "demo" | "unenroll";

export function MuroConnectModal({ isOpen, onClose }: MuroConnectModalProps) {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success, error: toastError } = useToast();

    const [mounted, setMounted] = useState(false);
    const [activeTab, setActiveTab] = useState<"key" | "test" | "logs" | "code">("key");

    // Key state
    const [keyInfo, setKeyInfo] = useState<TenantApiKeyInfo | null>(null);
    const [loadingKey, setLoadingKey] = useState(false);
    const [regenerating, setRegenerating] = useState(false);
    const [copied, setCopied] = useState(false);

    // Packages state
    const [packages, setPackages] = useState<ConnectPackageDto[]>([]);
    const [loadingPackages, setLoadingPackages] = useState(false);

    // Logs state
    const [logs, setLogs] = useState<ConnectApiLogItem[]>([]);
    const [loadingLogs, setLoadingLogs] = useState(false);

    // Simulator mode
    const [simMode, setSimMode] = useState<SimulatorMode>("enroll");

    // Test form state
    const [testFirstName, setTestFirstName] = useState("Ahmet");
    const [testLastName, setTestLastName] = useState("Yılmaz");
    const [testEmail, setTestEmail] = useState("ahmet.test@ornek.com");
    const [testPhone, setTestPhone] = useState("05551234567");
    const [testPackageCode, setTestPackageCode] = useState("");
    const [testOrderId, setTestOrderId] = useState("TEST-ORDER-" + Math.floor(1000 + Math.random() * 9000));
    const [testSendSms, setTestSendSms] = useState(true);
    const [testDemoDays, setTestDemoDays] = useState(7);
    const [testUnenrollReason, setTestUnenrollReason] = useState("Müşteri İade Talebi");
    
    const [testing, setTesting] = useState(false);
    const [testResult, setTestResult] = useState<any>(null);

    // Selected code tab
    const [codeLanguage, setCodeLanguage] = useState<"js" | "php" | "curl" | "shopier">("js");

    const apiBaseUrl = typeof window !== "undefined" ? window.location.origin : "https://uzem.ataniyorumhocam.com";
    const enrollEndpointUrl = `${apiBaseUrl}/api/v1/connect/enroll`;
    const demoEndpointUrl = `${apiBaseUrl}/api/v1/connect/demo-lead`;
    const unenrollEndpointUrl = `${apiBaseUrl}/api/v1/connect/unenroll`;
    const packagesEndpointUrl = `${apiBaseUrl}/api/v1/connect/packages`;
    const liveStatusEndpointUrl = `${apiBaseUrl}/api/v1/connect/live-status`;

    useEffect(() => {
        setMounted(true);
    }, []);

    const loadKey = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoadingKey(true);
        try {
            const data = await adminConnectApi.getKey(token, tenantId);
            setKeyInfo(data);
        } catch {
            toastError("API anahtarı yüklenemedi.");
        } finally {
            setLoadingKey(false);
        }
    }, [token, tenantId, toastError]);

    const loadPackages = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoadingPackages(true);
        try {
            const data = await adminConnectApi.getPackages(token, tenantId);
            setPackages(data || []);
            if (data && data.length > 0 && !testPackageCode) {
                setTestPackageCode(data[0].code || "");
            }
        } catch {
            // silent fallback
        } finally {
            setLoadingPackages(false);
        }
    }, [token, tenantId, testPackageCode]);

    const loadLogs = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoadingLogs(true);
        try {
            const data = await adminConnectApi.getLogs(token, tenantId, 50);
            setLogs(data || []);
        } catch {
            toastError("İstek logları yüklenemedi.");
        } finally {
            setLoadingLogs(false);
        }
    }, [token, tenantId, toastError]);

    useEffect(() => {
        if (isOpen) {
            loadKey();
            loadPackages();
            if (activeTab === "logs") loadLogs();
        }
    }, [isOpen, activeTab, loadKey, loadPackages, loadLogs]);

    const handleCopyKey = (textToCopy: string) => {
        navigator.clipboard.writeText(textToCopy);
        setCopied(true);
        success("API Anahtarı panoya kopyalandı!");
        setTimeout(() => setCopied(false), 2500);
    };

    const handleRegenerateKey = async () => {
        if (!confirm("DİKKAT: Eski API anahtarınız anında iptal edilecektir. Bağlı olan tüm harici web sitelerinde yeni anahtarı güncellemeniz gerekir. Devam etmek istiyor musunuz?")) {
            return;
        }

        setRegenerating(true);
        try {
            const newKey = await adminConnectApi.regenerateKey(token!, tenantId!);
            setKeyInfo(newKey);
            success("Yeni API anahtarı başarıyla üretildi! Lütfen güvenli bir yere kaydedin.");
        } catch (err: any) {
            toastError(err.message || "Anahtar üretilemedi.");
        } finally {
            setRegenerating(false);
        }
    };

    const handleRunTest = async (e: React.FormEvent) => {
        e.preventDefault();
        setTesting(true);
        setTestResult(null);

        try {
            let res: any;
            if (simMode === "enroll") {
                res = await adminConnectApi.testEnroll(token!, tenantId!, {
                    firstName: testFirstName,
                    lastName: testLastName,
                    email: testEmail,
                    phone: testPhone,
                    packageCode: testPackageCode || undefined,
                    orderId: testOrderId,
                    sendWelcomeSms: testSendSms
                });
            } else if (simMode === "demo") {
                res = await adminConnectApi.testDemo(token!, tenantId!, {
                    firstName: testFirstName,
                    lastName: testLastName,
                    email: testEmail,
                    phone: testPhone,
                    packageCode: testPackageCode || undefined,
                    demoDays: Number(testDemoDays) || 7,
                    sendWelcomeSms: testSendSms
                });
            } else if (simMode === "unenroll") {
                res = await adminConnectApi.testUnenroll(token!, tenantId!, {
                    email: testEmail,
                    phone: testPhone,
                    packageCode: testPackageCode || undefined,
                    reason: testUnenrollReason
                });
            }

            setTestResult(res);
            if (res.success) {
                success(res.message);
                loadLogs();
            } else {
                toastError(res.message);
            }
        } catch (err: any) {
            toastError(err.message || "Test isteği başarısız oldu.");
            setTestResult({
                success: false,
                message: err.message || "İstek hatası."
            });
        } finally {
            setTesting(false);
        }
    };

    if (!isOpen || !mounted) return null;

    const displayKey = keyInfo?.fullKey || keyInfo?.keyPrefix || "muro_live_...";

    return createPortal(
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/85 backdrop-blur-md animate-in fade-in duration-200">
            <div 
                className="bg-[#0b1329] border border-slate-700/80 rounded-2xl w-full max-w-4xl shadow-2xl overflow-hidden flex flex-col max-h-[92vh] text-slate-200"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-900/80">
                    <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-600 via-indigo-600 to-purple-600 flex items-center justify-center text-white shadow-lg shadow-indigo-500/20">
                            <Code2 className="w-5 h-5" />
                        </div>
                        <div>
                            <div className="flex items-center gap-2">
                                <h3 className="text-lg font-bold text-white tracking-wide">MURO Connect Growth Suite</h3>
                                <span className="px-2 py-0.5 text-[11px] font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 rounded-full flex items-center gap-1">
                                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" /> REST API v1
                                </span>
                            </div>
                            <p className="text-xs text-slate-400">Harici web siteleri, Shopier, WordPress ve ödeme geçitleri için tek tıkla entegrasyon</p>
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
                <div className="flex items-center px-6 border-b border-slate-800 bg-slate-950/60 gap-2 overflow-x-auto">
                    <button
                        onClick={() => setActiveTab("key")}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all whitespace-nowrap ${
                            activeTab === "key" 
                                ? "border-blue-500 text-blue-400 bg-blue-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <Key size={15} />
                        API Anahtarı & Endpoint'ler
                    </button>
                    <button
                        onClick={() => setActiveTab("test")}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all whitespace-nowrap ${
                            activeTab === "test" 
                                ? "border-blue-500 text-blue-400 bg-blue-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <Play size={15} />
                        Canlı Test Simülatörü
                    </button>
                    <button
                        onClick={() => { setActiveTab("logs"); loadLogs(); }}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all whitespace-nowrap ${
                            activeTab === "logs" 
                                ? "border-blue-500 text-blue-400 bg-blue-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <Terminal size={15} />
                        İstek Denetçisi (Logs)
                        {logs.length > 0 && (
                            <span className="ml-1 px-1.5 py-0.2 bg-slate-800 text-[10px] rounded-full text-slate-300">
                                {logs.length}
                            </span>
                        )}
                    </button>
                    <button
                        onClick={() => setActiveTab("code")}
                        className={`py-3 px-4 text-xs font-semibold border-b-2 flex items-center gap-2 transition-all whitespace-nowrap ${
                            activeTab === "code" 
                                ? "border-blue-500 text-blue-400 bg-blue-500/5" 
                                : "border-transparent text-slate-400 hover:text-slate-200"
                        }`}
                    >
                        <Code2 size={15} />
                        Kod Kütüphanesi & SDK
                    </button>
                </div>

                {/* Content Body */}
                <div className="flex-1 overflow-y-auto p-6 space-y-6">
                    {/* TAB 1: API KEY & ENDPOINTS */}
                    {activeTab === "key" && (
                        <div className="space-y-6">
                            {/* API Key Box */}
                            <div className="p-5 rounded-2xl bg-gradient-to-br from-slate-900 via-[#0d1730] to-slate-900 border border-slate-700/80 shadow-xl space-y-4">
                                <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2">
                                        <Shield className="w-4 h-4 text-blue-400" />
                                        <span className="text-xs font-bold text-white uppercase tracking-wider">Kurum API Gizli Anahtarı (X-Muro-Key)</span>
                                    </div>
                                    <span className="text-[11px] text-slate-400">Sabit & Süresiz</span>
                                </div>

                                <div className="flex items-center gap-2">
                                    <div className="flex-1 bg-slate-950/90 border border-slate-700 rounded-xl px-4 py-3 font-mono text-sm text-emerald-400 select-all overflow-x-auto">
                                        {loadingKey ? "Yükleniyor..." : displayKey}
                                    </div>
                                    <button
                                        onClick={() => handleCopyKey(keyInfo?.fullKey || keyInfo?.keyPrefix || "")}
                                        disabled={loadingKey}
                                        className="px-4 py-3 bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold rounded-xl transition-all flex items-center gap-2 shadow-lg shadow-blue-600/20 active:scale-95 shrink-0"
                                    >
                                        {copied ? <Check size={16} /> : <Copy size={16} />}
                                        {copied ? "Kopyalandı" : "Kopyala"}
                                    </button>
                                </div>

                                <div className="flex items-center justify-between pt-2 text-xs text-slate-400 border-t border-slate-800/80">
                                    <div>
                                        Harici sitenizden yapacağınız tüm isteklerde <code>X-Muro-Key</code> header'ı olarak bu anahtarı gönderin.
                                    </div>
                                    <button
                                        onClick={handleRegenerateKey}
                                        disabled={regenerating}
                                        className="text-rose-400 hover:text-rose-300 font-semibold text-xs flex items-center gap-1.5 transition-colors"
                                    >
                                        <RefreshCw size={13} className={regenerating ? "animate-spin" : ""} />
                                        Anahtarı Yenile (Revoke)
                                    </button>
                                </div>
                            </div>

                            {/* Endpoints List */}
                            <div className="space-y-3">
                                <div className="text-xs font-bold text-slate-300 uppercase tracking-wider">Kullanılabilir Ana Uç Noktalar (Endpoints)</div>
                                
                                {/* Endpoint 1: Enroll */}
                                <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-2">
                                    <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-2">
                                            <span className="px-2 py-0.5 text-[11px] font-mono font-bold bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 rounded">
                                                POST
                                            </span>
                                            <code className="text-xs text-white font-mono">{enrollEndpointUrl}</code>
                                        </div>
                                        <span className="text-[11px] text-emerald-400 font-medium">✨ Magic Login Destekli</span>
                                    </div>
                                    <p className="text-xs text-slate-400">
                                        Shopier veya web sitenizde ödeme tamamlandığında öğrenci hesabı açar, pakete atar, Magic Login URL üretir ve hoş geldin SMS'i atar.
                                    </p>
                                </div>

                                {/* Endpoint 2: Demo Lead */}
                                <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-2">
                                    <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-2">
                                            <span className="px-2 py-0.5 text-[11px] font-mono font-bold bg-amber-500/10 text-amber-400 border border-amber-500/20 rounded">
                                                POST
                                            </span>
                                            <code className="text-xs text-white font-mono">{demoEndpointUrl}</code>
                                        </div>
                                        <span className="text-[11px] text-amber-400 font-medium">🧲 Ücretsiz Demo Funnel'ı</span>
                                    </div>
                                    <p className="text-xs text-slate-400">
                                        Web sitenizdeki ücretsiz deneme formlarından 7 günlük demo öğrenci hesabı açar ve tek tıkla şifresiz giriş linki döner.
                                    </p>
                                </div>

                                {/* Endpoint 3: Unenroll */}
                                <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-2">
                                    <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-2">
                                            <span className="px-2 py-0.5 text-[11px] font-mono font-bold bg-rose-500/10 text-rose-400 border border-rose-500/20 rounded">
                                                POST
                                            </span>
                                            <code className="text-xs text-white font-mono">{unenrollEndpointUrl}</code>
                                        </div>
                                        <span className="text-[11px] text-rose-400 font-medium">🛑 İade & Paket İptali</span>
                                    </div>
                                    <p className="text-xs text-slate-400">
                                        İade veya iptal durumlarında öğrencinin paket ve canlı ders grup erişimlerini anında otomatik iptal eder.
                                    </p>
                                </div>

                                {/* Endpoint 4: Live Status */}
                                <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-2">
                                    <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-2">
                                            <span className="px-2 py-0.5 text-[11px] font-mono font-bold bg-purple-500/10 text-purple-400 border border-purple-500/20 rounded">
                                                GET
                                            </span>
                                            <code className="text-xs text-white font-mono">{liveStatusEndpointUrl}</code>
                                        </div>
                                        <span className="text-[11px] text-purple-400 font-medium">🔴 Canlı Yayın Durum Bandı</span>
                                    </div>
                                    <p className="text-xs text-slate-400">
                                        Web sitenizin üstünde <i>"Şu An Çağrı Hoca ile Canlı Ders Başladı"</i> şeridi göstermek için anlık canlı yayın durumunu sorgular.
                                    </p>
                                </div>

                                {/* Endpoint 5: Packages Catalog */}
                                <div className="p-4 rounded-xl bg-slate-900/60 border border-slate-800 space-y-2">
                                    <div className="flex items-center justify-between">
                                        <div className="flex items-center gap-2">
                                            <span className="px-2 py-0.5 text-[11px] font-mono font-bold bg-blue-500/10 text-blue-400 border border-blue-500/20 rounded">
                                                GET
                                            </span>
                                            <code className="text-xs text-white font-mono">{packagesEndpointUrl}</code>
                                        </div>
                                        <span className="text-[11px] text-slate-400 font-medium">Aktif Kurs & Paket Kataloğu</span>
                                    </div>
                                    <p className="text-xs text-slate-400">
                                        Web sitenizin ana sayfasında veya kurslar sayfasında dinamik fiyat ve kurs listesi listelemek için canlı JSON çıktısı.
                                    </p>
                                </div>
                            </div>
                        </div>
                    )}

                    {/* TAB 2: LIVE TEST SIMULATOR */}
                    {activeTab === "test" && (
                        <div className="space-y-5">
                            {/* Mode Selector */}
                            <div className="grid grid-cols-3 gap-2 p-1 bg-slate-950 rounded-xl border border-slate-800">
                                <button
                                    type="button"
                                    onClick={() => { setSimMode("enroll"); setTestResult(null); }}
                                    className={`py-2 px-3 text-xs font-bold rounded-lg transition-all flex items-center justify-center gap-1.5 ${
                                        simMode === "enroll" 
                                            ? "bg-blue-600 text-white shadow-md shadow-blue-600/20" 
                                            : "text-slate-400 hover:text-slate-200"
                                    }`}
                                >
                                    <UserPlus size={14} />
                                    1. Satış Kaydı (Enroll)
                                </button>
                                <button
                                    type="button"
                                    onClick={() => { setSimMode("demo"); setTestResult(null); }}
                                    className={`py-2 px-3 text-xs font-bold rounded-lg transition-all flex items-center justify-center gap-1.5 ${
                                        simMode === "demo" 
                                            ? "bg-amber-600 text-white shadow-md shadow-amber-600/20" 
                                            : "text-slate-400 hover:text-slate-200"
                                    }`}
                                >
                                    <Sparkles size={14} />
                                    2. Ücretsiz Demo Lead
                                </button>
                                <button
                                    type="button"
                                    onClick={() => { setSimMode("unenroll"); setTestResult(null); }}
                                    className={`py-2 px-3 text-xs font-bold rounded-lg transition-all flex items-center justify-center gap-1.5 ${
                                        simMode === "unenroll" 
                                            ? "bg-rose-600 text-white shadow-md shadow-rose-600/20" 
                                            : "text-slate-400 hover:text-slate-200"
                                    }`}
                                >
                                    <UserMinus size={14} />
                                    3. İade / İptal (Unenroll)
                                </button>
                            </div>

                            <form onSubmit={handleRunTest} className="p-5 rounded-xl bg-slate-900/70 border border-slate-800 space-y-4">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    {simMode !== "unenroll" && (
                                        <>
                                            <div>
                                                <label className="block text-xs font-semibold text-slate-300 mb-1">Öğrenci Adı *</label>
                                                <input 
                                                    type="text" 
                                                    value={testFirstName}
                                                    onChange={(e) => setTestFirstName(e.target.value)}
                                                    required
                                                    className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-blue-500"
                                                />
                                            </div>
                                            <div>
                                                <label className="block text-xs font-semibold text-slate-300 mb-1">Öğrenci Soyadı *</label>
                                                <input 
                                                    type="text" 
                                                    value={testLastName}
                                                    onChange={(e) => setTestLastName(e.target.value)}
                                                    required
                                                    className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-blue-500"
                                                />
                                            </div>
                                        </>
                                    )}

                                    <div>
                                        <label className="block text-xs font-semibold text-slate-300 mb-1">E-posta Adresi *</label>
                                        <input 
                                            type="email" 
                                            value={testEmail}
                                            onChange={(e) => setTestEmail(e.target.value)}
                                            required
                                            className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-blue-500"
                                        />
                                    </div>
                                    <div>
                                        <label className="block text-xs font-semibold text-slate-300 mb-1">Telefon Numarası *</label>
                                        <input 
                                            type="tel" 
                                            value={testPhone}
                                            onChange={(e) => setTestPhone(e.target.value)}
                                            required
                                            placeholder="555 123 45 67"
                                            className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white font-mono focus:outline-none focus:border-blue-500"
                                        />
                                    </div>

                                    {/* Dynamic Package Dropdown */}
                                    <div>
                                        <label className="block text-xs font-semibold text-slate-300 mb-1">
                                            Tanımlanacak Paket (package_code)
                                        </label>
                                        <select
                                            value={testPackageCode}
                                            onChange={(e) => setTestPackageCode(e.target.value)}
                                            className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-blue-500"
                                        >
                                            <option value="">-- Paket Seçin veya Boş Bırakın --</option>
                                            {packages.map(p => (
                                                <option key={p.id} value={p.code || p.name}>
                                                    {p.name} {p.code ? `(${p.code})` : ''} - {p.price} ₺
                                                </option>
                                            ))}
                                        </select>
                                    </div>

                                    {simMode === "enroll" && (
                                        <div>
                                            <label className="block text-xs font-semibold text-slate-300 mb-1">Sipariş No (order_id)</label>
                                            <input 
                                                type="text" 
                                                value={testOrderId}
                                                onChange={(e) => setTestOrderId(e.target.value)}
                                                className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white font-mono focus:outline-none focus:border-blue-500"
                                            />
                                        </div>
                                    )}

                                    {simMode === "demo" && (
                                        <div>
                                            <label className="block text-xs font-semibold text-slate-300 mb-1">Demo Süresi (Gün)</label>
                                            <input 
                                                type="number" 
                                                value={testDemoDays}
                                                onChange={(e) => setTestDemoDays(Number(e.target.value))}
                                                min={1}
                                                max={30}
                                                className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white font-mono focus:outline-none focus:border-blue-500"
                                            />
                                        </div>
                                    )}

                                    {simMode === "unenroll" && (
                                        <div>
                                            <label className="block text-xs font-semibold text-slate-300 mb-1">İptal / İade Sebebi</label>
                                            <input 
                                                type="text" 
                                                value={testUnenrollReason}
                                                onChange={(e) => setTestUnenrollReason(e.target.value)}
                                                className="w-full bg-slate-950 border border-slate-700 rounded-xl px-3.5 py-2 text-xs text-white focus:outline-none focus:border-blue-500"
                                            />
                                        </div>
                                    )}
                                </div>

                                <div className="flex items-center justify-between pt-2 border-t border-slate-800">
                                    {simMode !== "unenroll" ? (
                                        <label className="flex items-center gap-2 text-xs text-slate-300 cursor-pointer">
                                            <input 
                                                type="checkbox" 
                                                checked={testSendSms}
                                                onChange={(e) => setTestSendSms(e.target.checked)}
                                                className="w-4 h-4 rounded border-slate-700 text-blue-600 focus:ring-blue-500"
                                            />
                                            <span>Öğrenciye Otomatik Bilgilendirme SMS'i Gönder</span>
                                        </label>
                                    ) : <div />}

                                    <button
                                        type="submit"
                                        disabled={testing}
                                        className={`px-5 py-2.5 text-white text-xs font-bold rounded-xl transition-all shadow-lg flex items-center gap-2 disabled:opacity-50 ${
                                            simMode === "enroll" ? "bg-blue-600 hover:bg-blue-500 shadow-blue-600/20" :
                                            simMode === "demo" ? "bg-amber-600 hover:bg-amber-500 shadow-amber-600/20" :
                                            "bg-rose-600 hover:bg-rose-500 shadow-rose-600/20"
                                        }`}
                                    >
                                        {testing ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send size={14} />}
                                        {simMode === "enroll" && "Canlı Satış Simülasyonu Başlat"}
                                        {simMode === "demo" && "Demo Kayıt Simülasyonu Başlat"}
                                        {simMode === "unenroll" && "Paket İptali Simülasyonu Başlat"}
                                    </button>
                                </div>
                            </form>

                            {/* Result Display */}
                            {testResult && (
                                <div className={`p-4 rounded-xl border space-y-3 text-xs ${
                                    testResult.success 
                                        ? "bg-emerald-950/30 border-emerald-500/30 text-emerald-300" 
                                        : "bg-rose-950/30 border-rose-500/30 text-rose-300"
                                }`}>
                                    <div className="flex items-center justify-between font-bold text-sm">
                                        <div className="flex items-center gap-2">
                                            {testResult.success ? <CheckCircle2 size={16} className="text-emerald-400" /> : <AlertCircle size={16} className="text-rose-400" />}
                                            <span>{testResult.message}</span>
                                        </div>

                                        {/* Magic Login Link Button */}
                                        {testResult.magicLoginUrl && (
                                            <a
                                                href={testResult.magicLoginUrl}
                                                target="_blank"
                                                rel="noopener noreferrer"
                                                className="px-3.5 py-1.5 bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white rounded-lg font-bold text-xs flex items-center gap-1.5 shadow-md shadow-purple-600/30 animate-pulse"
                                            >
                                                <Sparkles size={13} />
                                                🪄 Tek Tıkla Derse Başla (Magic Login)
                                                <ExternalLink size={12} />
                                            </a>
                                        )}
                                    </div>

                                    {testResult.success && (
                                        <div className="grid grid-cols-2 md:grid-cols-4 gap-2 pt-2 text-slate-300 border-t border-emerald-500/20 font-mono text-[11px]">
                                            <div>Kullanıcı Adı: <span className="text-white font-bold">{testResult.username || testEmail}</span></div>
                                            <div>Şifre: <span className="text-white font-bold">{testResult.generatedPassword || "******"}</span></div>
                                            <div>İşlem: <span className="text-emerald-400 font-bold">{testResult.action || simMode}</span></div>
                                            <div>Paket: <span className="text-white font-bold">{testResult.packageName || "Aktif"}</span></div>
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    )}

                    {/* TAB 3: REQUEST LOGS */}
                    {activeTab === "logs" && (
                        <div className="space-y-4">
                            <div className="flex items-center justify-between">
                                <div className="text-xs text-slate-400">Dış sitelerden gelen son 50 API isteği listelenmektedir.</div>
                                <button
                                    onClick={loadLogs}
                                    disabled={loadingLogs}
                                    className="px-3 py-1.5 bg-slate-800 hover:bg-slate-700 text-xs font-semibold text-slate-200 rounded-lg flex items-center gap-1.5 transition-colors"
                                >
                                    <RefreshCw size={12} className={loadingLogs ? "animate-spin" : ""} />
                                    Yenile
                                </button>
                            </div>

                            {loadingLogs ? (
                                <div className="py-12 flex flex-col items-center justify-center gap-2 text-slate-400 text-xs">
                                    <Loader2 className="w-6 h-6 animate-spin text-blue-500" />
                                    Loglar yükleniyor...
                                </div>
                            ) : logs.length === 0 ? (
                                <div className="py-12 text-center text-xs text-slate-500 bg-slate-900/40 rounded-xl border border-slate-800">
                                    Henüz harici bir API isteği kaydedilmedi.
                                </div>
                            ) : (
                                <div className="space-y-2.5">
                                    {logs.map(log => (
                                        <div key={log.id} className="p-3.5 rounded-xl bg-slate-900/60 border border-slate-800 space-y-2 text-xs">
                                            <div className="flex items-center justify-between">
                                                <div className="flex items-center gap-2">
                                                    <span className={`px-2 py-0.5 rounded text-[10px] font-bold font-mono ${
                                                        log.statusCode >= 200 && log.statusCode < 300 
                                                            ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/20" 
                                                            : "bg-rose-500/10 text-rose-400 border border-rose-500/20"
                                                    }`}>
                                                        {log.statusCode} {log.httpMethod}
                                                    </span>
                                                    <code className="text-white font-mono text-[11px]">{log.endpoint}</code>
                                                </div>
                                                <div className="flex items-center gap-3 text-slate-400 text-[11px]">
                                                    <span>{log.durationMs} ms</span>
                                                    <span>{new Date(log.createdAt).toLocaleTimeString()}</span>
                                                </div>
                                            </div>

                                            {log.requestBody && (
                                                <div className="bg-slate-950 p-2 rounded-lg font-mono text-[11px] text-slate-300 overflow-x-auto">
                                                    {log.requestBody}
                                                </div>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>
                    )}

                    {/* TAB 4: CODE LIBRARY */}
                    {activeTab === "code" && (
                        <div className="space-y-4">
                            <div className="flex items-center gap-2 border-b border-slate-800 pb-2">
                                {[
                                    { id: "js", label: "Next.js / JavaScript" },
                                    { id: "php", label: "PHP / WordPress" },
                                    { id: "curl", label: "cURL" },
                                    { id: "shopier", label: "Shopier Webhook" }
                                ].map(tab => (
                                    <button
                                        key={tab.id}
                                        onClick={() => setCodeLanguage(tab.id as any)}
                                        className={`px-3 py-1.5 text-xs font-semibold rounded-lg transition-all ${
                                            codeLanguage === tab.id 
                                                ? "bg-blue-600 text-white shadow-sm" 
                                                : "bg-slate-800 text-slate-400 hover:text-white"
                                        }`}
                                    >
                                        {tab.label}
                                    </button>
                                ))}
                            </div>

                            <div className="relative bg-slate-950 p-4 rounded-xl border border-slate-800 font-mono text-xs text-slate-300 overflow-x-auto">
                                {codeLanguage === "js" && (
                                    <pre>{`// 1. Next.js / Node.js ile Öğrenci Kaydı Açma & Magic Login Alma
const res = await fetch("${enrollEndpointUrl}", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "X-Muro-Key": "${keyInfo?.fullKey || keyInfo?.keyPrefix || "muro_live_..."}"
  },
  body: JSON.stringify({
    first_name: "Ahmet",
    last_name: "Yılmaz",
    email: "ahmet@gmail.com",
    phone: "05551234567",
    package_code: "KPSS-2026-FULL",
    order_id: "SHOP-12345",
    send_welcome_sms: true
  })
});

const data = await res.json();
// data.magic_login_url -> Kullanıcıyı şifresiz derse sokan link!
console.log(data);

// 2. Canlı Yayın Durumu Sorgulama (Canlı Yayın Şeridi İçin)
const liveRes = await fetch("${liveStatusEndpointUrl}", {
  headers: { "X-Muro-Key": "${keyInfo?.fullKey || keyInfo?.keyPrefix || "muro_live_..."}" }
});
const liveData = await liveRes.json();
if (liveData.is_live_now) {
  console.log("Şu an canlı ders var:", liveData.session_title);
}`}</pre>
                                )}

                                {codeLanguage === "php" && (
                                    <pre>{`<?php
// PHP / WordPress cURL ile Otomatik Satış Kaydı Açma
$curl = curl_init();

$payload = json_encode([
  "first_name" => "Ahmet",
  "last_name"  => "Yılmaz",
  "email"      => "ahmet@gmail.com",
  "phone"      => "05551234567",
  "package_code" => "KPSS-2026-FULL",
  "order_id"   => "WP-9876",
  "send_welcome_sms" => true
]);

curl_setopt_array($curl, [
  CURLOPT_URL => "${enrollEndpointUrl}",
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_POST => true,
  CURLOPT_POSTFIELDS => $payload,
  CURLOPT_HTTPHEADER => [
    "Content-Type: application/json",
    "X-Muro-Key: ${keyInfo?.fullKey || keyInfo?.keyPrefix || "muro_live_..."}"
  ]
]);

$response = curl_exec($curl);
curl_close($curl);
$data = json_decode($response, true);

// Müşteriye "Hemen Eğitime Git" butonu vermek için:
// $magicUrl = $data['magic_login_url'];
echo $response;
?>`}</pre>
                                )}

                                {codeLanguage === "curl" && (
                                    <pre>{`# 1. Kurs Satışı Kaydı & Magic Login
curl -X POST "${enrollEndpointUrl}" \\
  -H "Content-Type: application/json" \\
  -H "X-Muro-Key: ${keyInfo?.fullKey || keyInfo?.keyPrefix || "muro_live_..."}" \\
  -d '{
    "first_name": "Ahmet",
    "last_name": "Yılmaz",
    "email": "ahmet@gmail.com",
    "phone": "05551234567",
    "package_code": "KPSS-2026-FULL",
    "send_welcome_sms": true
  }'

# 2. Ücretsiz 7 Günlük Demo Lead Kaydı
curl -X POST "${demoEndpointUrl}" \\
  -H "Content-Type: application/json" \\
  -H "X-Muro-Key: ${keyInfo?.fullKey || keyInfo?.keyPrefix || "muro_live_..."}" \\
  -d '{
    "first_name": "Ayşe",
    "last_name": "Demir",
    "phone": "05559876543",
    "demo_days": 7
  }'`}</pre>
                                )}

                                {codeLanguage === "shopier" && (
                                    <pre>{`// Shopier Webhook & Callback Entegrasyonu
// 1. Shopier Panelinde Geri Dönüş (Callback) URL olarak şu adresi tanımlayın:
// URL: https://sizin-web-siteniz.com/api/shopier-callback

// 2. Callback dosyanızda ödeme onaylandığı an MURO'ya POST fırlatın:
if ($status == "success") {
    $muroData = [
        "first_name" => $buyer_name,
        "last_name" => $buyer_surname,
        "email" => $buyer_email,
        "phone" => $buyer_phone,
        "package_code" => $custom_field, // veya ürün kodu
        "order_id" => $order_id,
        "send_welcome_sms" => true
    ];

    // MURO Enroll API'sine POST isteği gönderilir...
    // Öğrenci hesabı açılır, SMS gider, dönen magic_login_url ile teşekkür sayfasına yönlendirilir.
}`}</pre>
                                )}
                            </div>
                        </div>
                    )}
                </div>

                {/* Footer */}
                <div className="flex items-center justify-between px-6 py-4 border-t border-slate-800 bg-slate-900/80">
                    <div className="text-xs text-slate-400 flex items-center gap-1.5">
                        <Globe size={13} className="text-blue-400" />
                        Tüm istekler SSL ve SHA-256 ile korunmaktadır.
                    </div>
                    <button
                        onClick={onClose}
                        className="px-5 py-2 bg-slate-800 hover:bg-slate-700 text-white text-xs font-semibold rounded-xl transition-colors"
                    >
                        Kapat
                    </button>
                </div>
            </div>
        </div>,
        document.body
    );
}
