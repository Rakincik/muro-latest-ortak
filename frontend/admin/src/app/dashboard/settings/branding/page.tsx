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
    const [primaryColor, setPrimaryColor] = useState("#1B3B6F");
    const [accentColor, setAccentColor] = useState("#3B82F6");
    const [footerText, setFooterText] = useState("");
    const [logoUrl, setLogoUrl] = useState<string | null>(null);
    const [faviconUrl, setFaviconUrl] = useState<string | null>(null);

    // UX State
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);
    const [uploadingLogo, setUploadingLogo] = useState(false);
    const [uploadingFavicon, setUploadingFavicon] = useState(false);
    
    // Upload refs
    const logoInputRef = useRef<HTMLInputElement>(null);
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
                    setPrimaryColor(res.primaryColor || "#1B3B6F");
                    setAccentColor(res.accentColor || "#3B82F6");
                    setFooterText(res.footerText || "");
                    setLogoUrl(res.logoUrl);
                    setFaviconUrl(res.faviconUrl);
                }
            })
            .catch(() => {
                error("Hata", "Mevcut temalandırma ayarları yüklenemedi.");
            })
            .finally(() => {
                setLoading(false);
            });
    }, [token, currentTenantId]); // eslint-disable-line react-hooks/exhaustive-deps

    // 2. Dosya Yükleme Fonksiyonu
    const handleFileUpload = async (file: File, type: "logo" | "favicon") => {
        if (!token || !currentTenantId) return;

        const isLogo = type === "logo";
        if (isLogo) setUploadingLogo(true);
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
            if (isLogo) {
                setLogoUrl(presigned.publicUrl);
                success("Logo Yüklendi", "Değişikliklerin kaydedilmesi için Kaydet butonuna tıklayınız.");
            } else {
                setFaviconUrl(presigned.publicUrl);
                success("Favicon Yüklendi", "Değişikliklerin kaydedilmesi için Kaydet butonuna tıklayınız.");
            }
        } catch {
            error("Hata", "Dosya yüklenirken bir hata oluştu.");
        } finally {
            if (isLogo) setUploadingLogo(false);
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
                faviconUrl
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
                    <h1 className="text-2xl font-extrabold text-white tracking-wide flex items-center gap-2">
                        <Paintbrush className="text-[#3B82F6]" size={26} />
                        Kurum Ayarları ve Temalandırma
                    </h1>
                    <p className="text-[#A9A9A9] text-xs mt-1">
                        Sisteminizin logosunu, faviconunu, menü arka plan renklerini ve başlığını dinamik olarak özelleştirin.
                    </p>
                </div>
            </div>

            {/* Grid */}
            <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
                
                {/* Sol Taraf: Form */}
                <form onSubmit={handleSave} className="lg:col-span-7 space-y-6">
                    {/* Card */}
                    <div className="bg-[#1B3B6F]/10 backdrop-blur-xl border border-[#1B3B6F]/20 rounded-2xl p-6 shadow-2xl space-y-6">
                        <h2 className="text-md font-semibold text-white flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
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
                                className="w-full px-4 py-3 bg-[#1B3B6F]/10 border border-[#1B3B6F]/30 rounded-xl text-white placeholder-white/30 focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm"
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
                                className="w-full px-4 py-3 bg-[#1B3B6F]/10 border border-[#1B3B6F]/30 rounded-xl text-white placeholder-white/30 focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm"
                                placeholder="Örn: © 2026 Akademik Masa Her Hakkı Saklıdır."
                            />
                        </div>
                    </div>

                    {/* Tema Renkleri */}
                    <div className="bg-[#1B3B6F]/10 backdrop-blur-xl border border-[#1B3B6F]/20 rounded-2xl p-6 shadow-2xl space-y-6">
                        <h2 className="text-md font-semibold text-white flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
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
                                        className={`flex items-center gap-2.5 px-3 py-2.5 rounded-xl border transition-all text-xs font-medium ${primaryColor === color.hex ? 'border-[#3B82F6] bg-[#3B82F6]/10 text-white' : 'border-[#1B3B6F]/20 hover:bg-[#1B3B6F]/15 text-[#A0AEC0]'}`}
                                    >
                                        <span 
                                            className="w-4 h-4 rounded-full border border-white/20 shrink-0" 
                                            style={{ backgroundColor: color.hex }}
                                        />
                                        {color.name}
                                    </button>
                                ))}
                            </div>

                            {/* Custom Color input */}
                            <div className="flex items-center gap-4 mt-4 pt-2">
                                <div className="relative w-12 h-12 rounded-xl overflow-hidden border border-[#1B3B6F]/30 shrink-0">
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
                                        className="w-full px-4 py-2.5 bg-[#1B3B6F]/10 border border-[#1B3B6F]/30 rounded-xl text-white placeholder-white/30 focus:outline-none focus:ring-2 focus:ring-[#3B82F6]/50 focus:border-transparent transition-all text-sm uppercase font-mono"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Logo & Favicon Yükleme */}
                    <div className="bg-[#1B3B6F]/10 backdrop-blur-xl border border-[#1B3B6F]/20 rounded-2xl p-6 shadow-2xl space-y-6">
                        <h2 className="text-md font-semibold text-white flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
                            <Upload size={18} className="text-[#3B82F6]" />
                            Görsel ve Varlık Ayarları
                        </h2>

                        <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            {/* Logo */}
                            <div>
                                <label className="block text-xs font-semibold text-[#A0AEC0] uppercase tracking-wider mb-3">
                                    Kurum Logosu (PNG)
                                </label>
                                <div className="flex flex-col items-center justify-center border-2 border-dashed border-[#1B3B6F]/30 rounded-2xl p-4 bg-[#1B3B6F]/5 relative overflow-hidden group">
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
                                            className="flex flex-col items-center gap-2 text-white/50 group-hover:text-white transition-colors"
                                        >
                                            <Upload size={24} />
                                            <span className="text-xs font-semibold">Dosya Seç</span>
                                        </button>
                                    )}

                                    {uploadingLogo && (
                                        <div className="absolute inset-0 bg-[#060E1A]/80 flex items-center justify-center">
                                            <Loader2 className="animate-spin text-white mb-1" size={20} />
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
                                <div className="flex flex-col items-center justify-center border-2 border-dashed border-[#1B3B6F]/30 rounded-2xl p-4 bg-[#1B3B6F]/5 relative overflow-hidden group">
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
                                            className="flex flex-col items-center gap-2 text-white/50 group-hover:text-white transition-colors"
                                        >
                                            <Upload size={24} />
                                            <span className="text-xs font-semibold">Dosya Seç</span>
                                        </button>
                                    )}

                                    {uploadingFavicon && (
                                        <div className="absolute inset-0 bg-[#060E1A]/80 flex items-center justify-center">
                                            <Loader2 className="animate-spin text-white mb-1" size={20} />
                                        </div>
                                    )}

                                    <input 
                                        type="file" 
                                        ref={faviconInputRef}
                                        accept="image/png"
                                        onChange={(e) => e.target.files?.[0] && handleFileUpload(e.target.files[0], "favicon")}
                                        className="hidden" 
                                    />
                                </div>
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
                    <div className="bg-[#1B3B6F]/10 border border-[#1B3B6F]/20 rounded-2xl p-6 shadow-2xl sticky top-6 space-y-6">
                        <h2 className="text-md font-semibold text-white flex items-center gap-2 border-b border-[#1B3B6F]/20 pb-3">
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
                                                <span className="text-xs font-bold text-white tracking-wider font-mono">{name}</span>
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
