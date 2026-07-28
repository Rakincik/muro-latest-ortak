"use client";

import { useState, useEffect, useRef } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { tenantApi } from "@/lib/api/tenant";
import { uploadApi } from "@/lib/api/upload";
import { useToast } from "@/components/toast";
import { 
    Paintbrush, 
    Upload, 
    Check, 
    Loader2, 
    Building2, 
    Sparkles, 
    HelpCircle,
    Eye,
    ChevronRight,
    Lock
} from "lucide-react";

// Presets kanka, kullanıcı kolay seçsin diye
const PRESET_COLORS = [
    { name: "Monopol Lacivert", hex: "#1B3B6F" },
    { name: "Kraliyet Mavi", hex: "#1D4ED8" },
    { name: "Zümrüt Yeşil", hex: "#059669" },
    { name: "Yakut Kırmızı", hex: "#DC2626" },
    { name: "Gökçe Mor", hex: "#7C3AED" },
    { name: "Turuncu Işık", hex: "#D97706" }
];

export default function BrandingSettingsPage() {
    const { token, currentTenantId, user } = useAuth();
    const { success, error } = useToast();

    // Form state
    const [name, setName] = useState("Monopoluzem");
    const [primaryColor, setPrimaryColor] = useState("#0A1931");
    const [accentColor, setAccentColor] = useState("#3B82F6");
    const [footerText, setFooterText] = useState("");
    const [logoUrl, setLogoUrl] = useState<string | null>(null);
    const [sidebarLogoUrl, setSidebarLogoUrl] = useState<string | null>(null);
    const [useWhiteLogoBackground, setUseWhiteLogoBackground] = useState(false);
    const [faviconUrl, setFaviconUrl] = useState<string | null>(null);
    const [usernameRule, setUsernameRule] = useState("default");
    const [passwordRule, setPasswordRule] = useState("{first_name}.{phone_last2}.{last_name_first_char}");
    const [applyToStudents, setApplyToStudents] = useState(false);
    const [applyToAllUsers, setApplyToAllUsers] = useState(false);

    // UX State
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [uploadingLogo, setUploadingLogo] = useState(false);
    const [uploadingSidebarLogo, setUploadingSidebarLogo] = useState(false);
    const [uploadingFavicon, setUploadingFavicon] = useState(false);
    
    // Upload refs
    const logoInputRef = useRef<HTMLInputElement>(null);
    const sidebarLogoInputRef = useRef<HTMLInputElement>(null);
    const faviconInputRef = useRef<HTMLInputElement>(null);

    // Role check guard
    const isSuperAdmin = user?.role === "SuperAdmin";

    // 1. Verileri Yükle
    useEffect(() => {
        if (!token || !currentTenantId) return;

        setLoading(true);
        tenantApi.getAdminBranding(token, currentTenantId)
            .then(res => {
                if (res) {
                    setName(res.tenantName || "Monopoluzem");
                    setPrimaryColor(res.primaryColor || "#0A1931");
                    setAccentColor(res.accentColor || "#3B82F6");
                    setFooterText(res.footerText || "");
                    setLogoUrl(res.logoUrl);
                    setSidebarLogoUrl(res.sidebarLogoUrl || null);
                    setUseWhiteLogoBackground(res.useWhiteLogoBackground || false);
                    setFaviconUrl(res.faviconUrl);
                    // Cast res as any to support dynamic rule properties
                    const data = res as any;
                    if (data.usernameRule) setUsernameRule(data.usernameRule);
                    if (data.passwordRule) setPasswordRule(data.passwordRule);
                }
            })
            .catch(() => {
                error("Hata", "Mevcut temalandırma ayarları yüklenemedi.");
            })
            .finally(() => {
                setLoading(false);
            });
    }, [token, currentTenantId]); // eslint-disable-line react-hooks/exhaustive-deps

    // 2. Dosya Yukleme Fonksiyonu
    const handleFileUpload = async (file: File, type: "logo" | "sidebarLogo" | "favicon") => {
        if (!token || !currentTenantId) return;

        if (type === "logo") setUploadingLogo(true);
        else if (type === "sidebarLogo") setUploadingSidebarLogo(true);
        else setUploadingFavicon(true);

        try {
            // A. Presigned URL al kanka
            const presigned = await uploadApi.getPresignedUrl(token, currentTenantId, file.name, file.type);
            
            // B. Dosyayı doğrudan sunucuya PUT et
            await uploadApi.uploadMediaWithProgress(
                presigned.uploadUrl, 
                file, 
                () => {} // progress tracker
            );

            // C. Public URL'i kaydet
            if (type === "logo") setLogoUrl(presigned.publicUrl.split("?")[0]);
            else if (type === "sidebarLogo") setSidebarLogoUrl(presigned.publicUrl.split("?")[0]);
            else setFaviconUrl(presigned.publicUrl.split("?")[0]);
            
            success("Basarili", "Gorsel yuklendi, kaydedin.");
        } catch {
            error("Hata", "Gorsel yuklenemedi.");
        } finally {
            if (type === "logo") setUploadingLogo(false);
            else if (type === "sidebarLogo") setUploadingSidebarLogo(false);
            else setUploadingFavicon(false);
        }
    };

    // 3. Form Kaydet
    const handleSave = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!token || !currentTenantId) return;

        setSaving(true);
        try {
            await tenantApi.updateAdminBranding(token, currentTenantId, {
                name,
                primaryColor,
                accentColor,
                footerText,
                logoUrl,
                sidebarLogoUrl,
                useWhiteLogoBackground,
                faviconUrl,
                usernameRule,
                passwordRule,
                applyToStudents,
                applyToAllUsers
            });
            success("Kaydedildi", "Kurum temalandırma ayarları başarıyla kaydedildi!");
            
            // Logoyu ve başlığı anında yansıtması için ufak bir beklemeden sonra yeniliyoruz kanka
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        } catch {
            error("Hata", "Ayarlar kaydedilirken hata oluştu.");
        } finally {
            setSaving(false);
        }
    };

    // Yetki Kontrolü
    if (!isSuperAdmin) {
        return (
            <div className="min-h-[80vh] flex flex-col items-center justify-center p-6 bg-[#060E1A]/10 rounded-2xl border border-red-500/20">
                <div className="w-16 h-16 bg-red-500/10 border border-red-500/30 rounded-2xl flex items-center justify-center mb-4 text-red-500 shadow-xl shadow-red-500/5">
                    <Lock size={28} />
                </div>
                <h1 className="text-xl font-bold text-white mb-2">Erişim Engellendi</h1>
                <p className="text-[#A9A9A9] text-center max-w-sm text-sm">
                    Bu ayarlar sayfasına erişim yalnızca **Süper Admin** rolüne sahip yetkililerle sınırlandırılmıştır.
                </p>
            </div>
        );
    }

    if (loading) {
        return (
            <div className="min-h-[60vh] flex flex-col items-center justify-center">
                <Loader2 className="animate-spin text-white mb-3" size={32} />
                <p className="text-white/60 text-sm font-medium">Tema Ayarları Yükleniyor...</p>
            </div>
        );
    }

    return (
        <div className="max-w-6xl mx-auto p-4 sm:p-6 lg:p-8">
            {/* Header */}
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
                <div>
                    <h1 className="text-2xl font-extrabold text-[#1B3B6F] tracking-wide flex items-center gap-2">
                        <Paintbrush className="text-[#3B82F6]" size={26} />
                        Kurum Ayarları ve Temalandırma
                    </h1>
                    <p className="text-[#64748B] text-xs mt-1">
                        Sisteminizin logosunu, faviconunu, menü arka plan renklerini ve başlığını dinamik olarak özelleştirin.
                    </p>
                </div>
            </div>

            {/* Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
                
                {/* Sol Taraf: Form */}
                <form onSubmit={handleSave} className="lg:col-span-7 space-y-6">
                    {/* Card */}
                    <div className="bg-white border border-[#E2E8F0] rounded-2xl p-6 shadow-sm space-y-6">
                        <h2 className="text-md font-semibold text-[#1B3B6F] flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
                            <Building2 size={18} className="text-[#3B82F6]" />
                            Kurum Genel Bilgileri
                        </h2>

                        {/* Kurum Adı */}
                        <div>
                            <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-2">
                                Kurum Adı (Site Başlığı)
                            </label>
                            <input 
                                type="text"
                                value={name}
                                onChange={(e) => setName(e.target.value)}
                                required
                                className="w-full px-4 py-3 bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl text-[#0F172A] placeholder-[#94A3B8] focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm"
                                placeholder="Örn: Akademik Masa"
                            />
                        </div>

                        {/* Footer Alt Yazı */}
                        <div>
                            <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-2">
                                Sayfa Alt Metni (Footer)
                            </label>
                            <input 
                                type="text"
                                value={footerText}
                                onChange={(e) => setFooterText(e.target.value)}
                                className="w-full px-4 py-3 bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl text-[#0F172A] placeholder-[#94A3B8] focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm"
                                placeholder="Örn: © 2026 Akademik Masa Her Hakkı Saklıdır."
                            />
                        </div>
                    </div>

                    {/* Tema Renkleri */}
                    <div className="bg-white border border-[#E2E8F0] rounded-2xl p-6 shadow-sm space-y-6">
                        <h2 className="text-md font-semibold text-[#1B3B6F] flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
                            <Sparkles size={18} className="text-[#3B82F6]" />
                            Sidebar & Tema Renkleri
                        </h2>

                        {/* Renk Seçimi */}
                        <div className="space-y-4">
                            <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-2">
                                Sol Menü (Sidebar) Arka Plan Rengi
                            </label>
                            
                            {/* Preset List */}
                            <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                                {PRESET_COLORS.map((color) => (
                                    <button
                                        key={color.hex}
                                        type="button"
                                        onClick={() => setPrimaryColor(color.hex)}
                                        className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border transition-all text-xs font-medium ${primaryColor === color.hex ? 'border-[#3B82F6] bg-[#3B82F6] text-white shadow-md shadow-blue-500/20' : 'border-[#E2E8F0] hover:bg-[#F1F5F9] text-[#64748B]'}`}
                                    >
                                        <span 
                                            className="w-4 h-4 rounded-full border border-white/20 shrink-0" 
                                            style={{ backgroundColor: color.hex }}
                                        />
                                        {color.name}
                                    </button>
                                ))}
                            </div>

                            {/* Primary Color input */}
                            <div className="flex flex-col gap-1 mt-4 pt-2">
                                <label className="text-xs font-semibold text-[#64748B] uppercase">Ana Renk (Primary)</label>
                                <div className="flex items-center gap-4">
                                    <div className="relative w-12 h-12 rounded-xl overflow-hidden border border-[#E2E8F0] shrink-0">
                                        <input 
                                            type="color"
                                            value={primaryColor}
                                            onChange={(e) => setPrimaryColor(e.target.value)}
                                            className="absolute inset-0 w-full h-full p-0 border-0 cursor-pointer scale-150"
                                        />
                                    </div>
                                    <div className="flex-1">
                                        <input 
                                            type="text"
                                            value={primaryColor}
                                            onChange={(e) => setPrimaryColor(e.target.value)}
                                            placeholder="#0A1931"
                                            className="w-full px-4 py-2.5 bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl text-[#0F172A] placeholder-[#94A3B8] focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm uppercase font-mono"
                                        />
                                    </div>
                                </div>
                            </div>
                            
                            {/* Accent Color input */}
                            <div className="flex flex-col gap-1 mt-4">
                                <label className="text-xs font-semibold text-[#64748B] uppercase">Vurgu Rengi (Aktif Menü vb.)</label>
                                <div className="flex items-center gap-4">
                                    <div className="relative w-12 h-12 rounded-xl overflow-hidden border border-[#E2E8F0] shrink-0">
                                        <input 
                                            type="color"
                                            value={accentColor}
                                            onChange={(e) => setAccentColor(e.target.value)}
                                            className="absolute inset-0 w-full h-full p-0 border-0 cursor-pointer scale-150"
                                        />
                                    </div>
                                    <div className="flex-1">
                                        <input 
                                            type="text"
                                            value={accentColor}
                                            onChange={(e) => setAccentColor(e.target.value)}
                                            placeholder="#3B82F6"
                                            className="w-full px-4 py-2.5 bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl text-[#0F172A] placeholder-[#94A3B8] focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm uppercase font-mono"
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Logo & Favicon Yükleme */}
                    <div className="bg-white border border-[#E2E8F0] rounded-2xl p-6 shadow-sm space-y-6">
                        <h2 className="text-md font-semibold text-[#1B3B6F] flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
                            <Upload size={18} className="text-[#3B82F6]" />
                            Görsel ve Varlık Ayarları
                        </h2>

                        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
                            {/* Logo */}
                            <div>
                                <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-3">
                                    Kurum Logosu (PNG)
                                </label>
                                <div className="flex flex-col items-center justify-center border-2 border-dashed border-[#E2E8F0] rounded-2xl p-4 bg-[#F8FAFC] relative overflow-hidden group">
                                    {logoUrl ? (
                                        <div className="flex flex-col items-center gap-3">
                                            <img src={logoUrl} alt="Logo Preview" className="max-h-16 max-w-full object-contain mb-2 drop-shadow-md" />
                                            <button 
                                                type="button"
                                                onClick={() => logoInputRef.current?.click()}
                                                className="px-3 py-1.5 bg-[#3B82F6]/10 hover:bg-[#3B82F6]/20 border border-[#3B82F6]/30 text-[#3B82F6] rounded-lg text-xs font-semibold transition-all"
                                            >
                                                Logoyu Değiştir
                                            </button>
                                        </div>
                                    ) : (
                                        <button 
                                            type="button" 
                                            onClick={() => logoInputRef.current?.click()}
                                            className="flex flex-col items-center gap-2 text-[#94A3B8] group-hover:text-[#3B82F6] transition-colors"
                                        >
                                            <Upload size={24} />
                                            <span className="text-xs font-semibold">Dosya Seç</span>
                                        </button>
                                    )}

                                    {uploadingLogo && (
                                        <div className="absolute inset-0 bg-white/80 flex items-center justify-center">
                                            <Loader2 className="animate-spin text-[#3B82F6] mb-1" size={20} />
                                        </div>
                                    )}

                                    <input 
                                        type="file" 
                                        ref={logoInputRef}
                                        accept="image/png"
                                        onChange={(e) => e.target.files?.[0] && handleFileUpload(e.target.files[0], "logo")}
                                        className="hidden" 
                                    />
                                </div>
                            </div>

                            {/* Favicon */}
                            <div>
                                <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-3">
                                    Sekme İkonu (Favicon - PNG)
                                </label>
                                <div className="flex flex-col items-center justify-center border-2 border-dashed border-[#E2E8F0] rounded-2xl p-4 bg-[#F8FAFC] relative overflow-hidden group">
                                    {faviconUrl ? (
                                        <div className="flex flex-col items-center gap-3">
                                            <img src={faviconUrl} alt="Favicon Preview" className="w-8 h-8 object-contain mb-2 drop-shadow-md" />
                                            <button 
                                                type="button"
                                                onClick={() => faviconInputRef.current?.click()}
                                                className="px-3 py-1.5 bg-[#3B82F6]/10 hover:bg-[#3B82F6]/20 border border-[#3B82F6]/30 text-[#3B82F6] rounded-lg text-xs font-semibold transition-all"
                                            >
                                                Favicon Değiştir
                                            </button>
                                        </div>
                                    ) : (
                                        <button 
                                            type="button" 
                                            onClick={() => faviconInputRef.current?.click()}
                                            className="flex flex-col items-center gap-2 text-[#94A3B8] group-hover:text-[#3B82F6] transition-colors"
                                        >
                                            <Upload size={24} />
                                            <span className="text-xs font-semibold">Dosya Seç</span>
                                        </button>
                                    )}

                                    {uploadingFavicon && (
                                        <div className="absolute inset-0 bg-white/80 flex items-center justify-center">
                                            <Loader2 className="animate-spin text-[#3B82F6] mb-1" size={20} />
                                        </div>
                                    )}

                                    <input 
                                        type="file" 
                                        ref={faviconInputRef}
                                        accept="image/png,image/jpeg,image/webp,image/svg+xml"
                                        onChange={(e) => e.target.files?.[0] && handleFileUpload(e.target.files[0], "favicon")}
                                        className="hidden" 
                                    />
                                </div>
                            </div>

                            {/* Sidebar Logo */}
                            <div>
                                <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-3">
                                    Panel Logosu (Sidebar)
                                </label>
                                <div className="relative group">
                                    <div className="absolute -inset-0.5 bg-gradient-to-r from-[#1B3B6F] to-[#0A1931] rounded-2xl blur opacity-0 group-hover:opacity-20 transition duration-500"></div>
                                    <div 
                                        onClick={() => sidebarLogoInputRef.current?.click()}
                                        className="relative flex flex-col items-center justify-center p-6 bg-[#F8FAFC] border-2 border-dashed border-[#CBD5E1] rounded-xl cursor-pointer hover:border-[#1B3B6F]/50 transition-all group-hover:bg-white h-40"
                                    >
                                        {uploadingSidebarLogo ? (
                                            <div className="flex flex-col items-center justify-center">
                                                <Loader2 className="animate-spin text-[#3B82F6] mb-1" size={20} />
                                            </div>
                                        ) : sidebarLogoUrl ? (
                                            <img src={sidebarLogoUrl} alt="Sidebar Logo" className="max-h-24 max-w-[80%] object-contain" />
                                        ) : (
                                            <div className="flex flex-col items-center text-center">
                                                <div className="w-10 h-10 rounded-full bg-white shadow-sm flex items-center justify-center mb-3">
                                                    <Upload size={18} className="text-[#64748B]" />
                                                </div>
                                                <p className="text-sm font-medium text-[#0F172A]">Sidebar Logosu Sec</p>
                                                <p className="text-xs text-[#94A3B8] mt-1">PNG, SVG</p>
                                            </div>
                                        )}
                                    </div>
                                    <input 
                                        type="file" 
                                        ref={sidebarLogoInputRef}
                                        accept="image/png,image/jpeg,image/webp,image/svg+xml"
                                        onChange={(e) => e.target.files?.[0] && handleFileUpload(e.target.files[0], "sidebarLogo")}
                                        className="hidden" 
                                    />
                                </div>
                            </div>
                        </div>
                        
                        {/* Toggle Logo Background */}
                        <div className="mt-6 pt-6 border-t border-[#E2E8F0] flex items-center justify-between">
                            <div>
                                <h3 className="text-sm font-semibold text-[#0F172A]">Panel Logosunu Beyaz Kapsule Al</h3>
                                <p className="text-xs text-[#64748B] mt-1">
                                    Koyu renkli logolarin, karanlik sol menude okunakli olmasi icin beyaz bir arkaplan ekler.
                                </p>
                            </div>
                            <label className="relative inline-flex items-center cursor-pointer">
                                <input 
                                    type="checkbox" 
                                    className="sr-only peer" 
                                    checked={useWhiteLogoBackground}
                                    onChange={(e) => setUseWhiteLogoBackground(e.target.checked)}
                                />
                                <div className="w-11 h-6 bg-[#CBD5E1] peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-['] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#3B82F6]"></div>
                            </label>
                        </div>
                    </div>

                    {/* Kullanıcı Oluşturma ve Şifre Güvenlik Kuralları */}
                    <div className="bg-white border border-[#E2E8F0] rounded-2xl p-6 shadow-sm space-y-6">
                        <h2 className="text-md font-semibold text-[#1B3B6F] flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
                            <Lock size={18} className="text-[#3B82F6]" />
                            Kullanıcı Oluşturma & Şifre Kuralları
                        </h2>

                        {/* Kullanıcı Adı Kuralı */}
                        <div>
                            <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-2">
                                Otomatik Kullanıcı Adı Formatı
                            </label>
                            <select
                                value={usernameRule}
                                onChange={(e) => setUsernameRule(e.target.value)}
                                className="w-full px-4 py-3 bg-[#1B3B6F]/10 border border-[#1B3B6F]/30 rounded-xl text-white focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm appearance-none cursor-pointer"
                            >
                                <option value="default" className="bg-white text-[#0F172A]">İsim Soyisim İngilizce Karakter (Varsayılan - örn: ahmetyilmaz)</option>
                                <option value="email" className="bg-white text-[#0F172A]">E-posta Adresi (örn: ahmet@gmail.com)</option>
                                <option value="phone" className="bg-white text-[#0F172A]">Telefon Numarası (örn: 5551234567)</option>
                            </select>
                        </div>

                        {/* Şifre Kuralı */}
                        <div className="space-y-3">
                            <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider">
                                Otomatik Üretilen Şifre Formülü
                            </label>

                            {/* Preset Buttons */}
                            <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                <button
                                    type="button"
                                    onClick={() => setPasswordRule("{first_name}.{phone_last2}.{last_name_first_char}")}
                                    className={`px-3 py-2.5 rounded-xl border transition-all text-left text-xs ${passwordRule === "{first_name}.{phone_last2}.{last_name_first_char}" ? 'border-[#3B82F6] bg-[#3B82F6] text-white shadow-md shadow-blue-500/20' : 'border-[#E2E8F0] hover:bg-[#F1F5F9] text-[#64748B]'}`}
                                >
                                    <span className="font-bold block mb-0.5">Varsayılan Formül</span>
                                    <span className="opacity-70 text-[10px]">isim.telefonSon2.soyisimİlkHarf</span>
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setPasswordRule("{email}")}
                                    className={`px-3 py-2.5 rounded-xl border transition-all text-left text-xs ${passwordRule === "{email}" ? 'border-[#3B82F6] bg-[#3B82F6] text-white shadow-md shadow-blue-500/20' : 'border-[#E2E8F0] hover:bg-[#F1F5F9] text-[#64748B]'}`}
                                >
                                    <span className="font-bold block mb-0.5">Doğrudan E-posta</span>
                                    <span className="opacity-70 text-[10px]">{`{email}`}</span>
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setPasswordRule("{phone}")}
                                    className={`px-3 py-2.5 rounded-xl border transition-all text-left text-xs ${passwordRule === "{phone}" ? 'border-[#3B82F6] bg-[#3B82F6] text-white shadow-md shadow-blue-500/20' : 'border-[#E2E8F0] hover:bg-[#F1F5F9] text-[#64748B]'}`}
                                >
                                    <span className="font-bold block mb-0.5">Doğrudan Telefon</span>
                                    <span className="opacity-70 text-[10px]">{`{phone}`}</span>
                                </button>
                                <button
                                    type="button"
                                    onClick={() => setPasswordRule("{email}.{phone_last2}")}
                                    className={`px-3 py-2.5 rounded-xl border transition-all text-left text-xs ${passwordRule === "{email}.{phone_last2}" ? 'border-[#3B82F6] bg-[#3B82F6] text-white shadow-md shadow-blue-500/20' : 'border-[#E2E8F0] hover:bg-[#F1F5F9] text-[#64748B]'}`}
                                >
                                    <span className="font-bold block mb-0.5">E-posta + Telefon Son 2</span>
                                    <span className="opacity-70 text-[10px]">{`{email}.{phone_last2}`}</span>
                                </button>
                            </div>

                            {/* Custom Formula input */}
                            <div className="pt-2">
                                <label className="block text-[11px] font-bold text-[#A0AEC0] mb-1.5">Kendi Özel Formülünü Yaz</label>
                                <input
                                    type="text"
                                    value={passwordRule}
                                    onChange={(e) => setPasswordRule(e.target.value)}
                                    className="w-full px-4 py-2.5 bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl text-[#0F172A] placeholder-[#94A3B8] focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm font-mono"
                                    placeholder="Örn: {email}.{phone_last2}"
                                />
                            </div>

                            {/* Değişken Kılavuzu */}
                            <div className="bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl p-4 text-[11px] text-[#64748B] space-y-2.5">
                                <span className="font-bold text-[#1B3B6F] block">Formülde Kullanabileceğin Değişkenler:</span>
                                <div className="grid grid-cols-2 gap-2 font-mono">
                                    <div><span className="text-[#3B82F6]">{`{first_name}`}</span>: Küçük harf isim</div>
                                    <div><span className="text-[#3B82F6]">{`{last_name}`}</span>: Küçük harf soyisim</div>
                                    <div><span className="text-[#3B82F6]">{`{last_name_first_char}`}</span>: Soyisim ilk harf</div>
                                    <div><span className="text-[#3B82F6]">{`{phone}`}</span>: Telefon numarası</div>
                                    <div><span className="text-[#3B82F6]">{`{phone_last2}`}</span>: Telefon son 2 hanesi</div>
                                    <div><span className="text-[#3B82F6]">{`{email}`}</span>: E-posta adresi</div>
                                    <div><span className="text-[#3B82F6]">{`{tcno}`}</span>: TC Kimlik numarası</div>
                                    <div><span className="text-[#3B82F6]">{`{tcno_last4}`}</span>: TC son 4 hanesi</div>
                                </div>
                            </div>
                        </div>

                        {/* Geriye Dönük Uygulama Seçenekleri */}
                        <div className="pt-4 border-t border-[#1B3B6F]/20 space-y-3">
                            <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider">
                                Kuralları Geriye Dönük Uygula
                            </label>

                            <div className="space-y-2">
                                <label className="flex items-start gap-3 cursor-pointer group">
                                    <input
                                        type="checkbox"
                                        checked={applyToStudents}
                                        onChange={(e) => {
                                            setApplyToStudents(e.target.checked);
                                            if (e.target.checked) setApplyToAllUsers(false);
                                        }}
                                        className="mt-1 rounded border-[#1B3B6F]/30 bg-[#1B3B6F]/10 text-[#3B82F6] focus:ring-offset-0 focus:ring-[#3B82F6]/50"
                                    />
                                    <div className="text-xs text-[#64748B] group-hover:text-[#0F172A] transition-colors">
                                        <span className="font-semibold text-[#1B3B6F] block">Mevcut Öğrencilere Uygula</span>
                                        Kaydederken tüm aktif öğrencilerin kullanıcı adı ve şifrelerini bu yeni kurallara göre güncelle.
                                    </div>
                                </label>

                                <label className="flex items-start gap-3 cursor-pointer group">
                                    <input
                                        type="checkbox"
                                        checked={applyToAllUsers}
                                        onChange={(e) => {
                                            setApplyToAllUsers(e.target.checked);
                                            if (e.target.checked) setApplyToStudents(false);
                                        }}
                                        className="mt-1 rounded border-[#1B3B6F]/30 bg-[#1B3B6F]/10 text-[#3B82F6] focus:ring-offset-0 focus:ring-[#3B82F6]/50"
                                    />
                                    <div className="text-xs text-[#64748B] group-hover:text-[#0F172A] transition-colors">
                                        <span className="font-semibold text-[#1B3B6F] block">Tüm Mevcut Kullanıcılara Uygula</span>
                                        Mevcut tüm kullanıcıların (Öğretmen, Eğitmen, Admin) bilgilerini güncelle (SuperAdmin hariç).
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>

                    {/* Kaydet Button */}
                    <div className="flex justify-end gap-3 pt-2">
                        <button
                            type="submit"
                            disabled={saving}
                            className="px-6 py-3 bg-[#3B82F6] hover:bg-[#2563EB] disabled:bg-[#3B82F6]/50 text-white rounded-xl font-bold transition-all shadow-xl shadow-blue-500/20 text-sm flex items-center gap-2"
                        >
                            {saving ? (
                                <>
                                    <Loader2 className="animate-spin" size={16} />
                                    Kaydediliyor...
                                </>
                            ) : (
                                <>
                                    <Check size={16} />
                                    Değişiklikleri Kaydet
                                </>
                            )}
                        </button>
                    </div>
                </form>

                {/* Sağ Taraf: Canlı Önizleme */}
                <div className="lg:col-span-5 space-y-6">
                    <div className="bg-white border border-[#E2E8F0] rounded-2xl p-6 shadow-sm sticky top-6 space-y-6">
                        <h2 className="text-md font-semibold text-[#1B3B6F] flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
                            <Eye size={18} className="text-[#3B82F6]" />
                            Canlı Önizleme Panel (Canlı)
                        </h2>

                        {/* Önizleme 1: Sidebar Önizlemesi */}
                        <div className="space-y-2">
                            <span className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-wider">Sol Menü Önizlemesi</span>
                            <div className="rounded-xl border border-white/10 overflow-hidden shadow-lg flex bg-[#060E1A]">
                                {/* Önizleme Sidebar */}
                                <div 
                                    className="w-40 p-4 transition-all duration-300 flex flex-col justify-between min-h-[160px]"
                                    style={{ backgroundColor: primaryColor }}
                                >
                                    <div>
                                        {/* Logo */}
                                        <div className="mb-4">
                                            {logoUrl ? (
                                                <img src={logoUrl} alt="Logo" className="max-h-7 max-w-full object-contain" />
                                            ) : (
                                                <span className="text-xs font-bold text-[#1B3B6F] tracking-wider font-mono">{name}</span>
                                            )}
                                        </div>
                                        {/* Menü Öğeleri */}
                                        <div className="space-y-1">
                                            <div className="flex items-center gap-1.5 px-2 py-1 bg-white/10 text-white rounded text-[10px] font-semibold">
                                                <div className="w-1.5 h-1.5 rounded-full bg-blue-400" />
                                                Ana Sayfa
                                            </div>
                                            <div className="flex items-center gap-1.5 px-2 py-1 text-white/50 text-[10px]">
                                                <div className="w-1.5 h-1.5 rounded-full bg-white/20" />
                                                Öğrenciler
                                            </div>
                                        </div>
                                    </div>
                                    <div className="text-[8px] text-white/40 truncate mt-6">
                                        {footerText || "MURO LMS © 2026"}
                                    </div>
                                </div>
                                
                                {/* Önizleme İçerik */}
                                <div className="flex-1 p-4 bg-[#0A1931]/10 flex flex-col justify-between">
                                    <div className="flex items-center justify-between border-b border-white/5 pb-2 mb-2">
                                        <span className="text-[10px] font-bold text-white">Gösterge Paneli</span>
                                        <div className="w-5 h-5 rounded-full bg-white/10" />
                                    </div>
                                    <div className="space-y-1.5">
                                        <div className="h-6 rounded bg-[#1B3B6F]/25 flex items-center justify-between px-2 text-[8px] text-white/60">
                                            <span>Aktif Öğrenci Sayısı</span>
                                            <span className="font-bold text-white">412</span>
                                        </div>
                                        <div className="h-6 rounded bg-[#1B3B6F]/25 flex items-center justify-between px-2 text-[8px] text-white/60">
                                            <span>Toplam Ders Saati</span>
                                            <span className="font-bold text-white">1,240 s</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Önizleme 2: Tarayıcı Sekme Önizlemesi */}
                        <div className="space-y-2">
                            <span className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-wider">Tarayıcı Sekmesi Önizlemesi</span>
                            <div className="rounded-xl border border-white/10 bg-[#1e1e1e] p-3 shadow-lg flex items-center gap-3">
                                {/* Sekme */}
                                <div className="bg-[#2d2d2d] px-3 py-1.5 rounded-t-lg border-b-2 border-blue-500 flex items-center gap-2 max-w-[160px] shadow-sm">
                                    {faviconUrl ? (
                                        <img src={faviconUrl} alt="Favicon" className="w-3.5 h-3.5 object-contain" />
                                    ) : (
                                        <div className="w-3.5 h-3.5 rounded bg-blue-500 flex items-center justify-center text-[8px] text-white font-bold font-mono">M</div>
                                    )}
                                    <span className="text-[10px] font-semibold text-white/90 truncate">{name}</span>
                                </div>
                                <div className="text-white/20 text-xs font-semibold">+</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
