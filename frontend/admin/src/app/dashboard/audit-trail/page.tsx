"use client";
import { useState, useEffect, useCallback, useMemo } from "react";
import {
    Shield, Search, ChevronLeft, ChevronRight,
    User, FileText, Trash2, Edit3, Plus, RefreshCw, Clock, Globe,
    AlertTriangle, X, Activity, Eye, Lock, Smartphone, Monitor,
    ArrowRight, Check, Unlock
} from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { auditApi, securityApi } from "@/lib/api/audits";
import { type AuditLogDto, type UserAuditSummaryDto, type SuspiciousUserDto } from "@/lib/api/types";
import { UAParser } from "ua-parser-js";
import { useToast } from "@/components/toast";

const actionMeta: Record<string, { labelTR: string; bg: string; text: string; icon: any }> = {
    Create: { labelTR: "Oluşturuldu", bg: "bg-emerald-50 border border-emerald-100", text: "text-emerald-700", icon: Plus },
    Update: { labelTR: "Güncellendi", bg: "bg-blue-50 border border-blue-100", text: "text-blue-700", icon: Edit3 },
    Delete: { labelTR: "Silindi", bg: "bg-red-50 border border-red-100", text: "text-red-700", icon: Trash2 },
    BulkCreate: { labelTR: "Toplu Eklendi", bg: "bg-emerald-50 border border-emerald-100", text: "text-emerald-700", icon: Plus },
    BulkDelete: { labelTR: "Toplu Silindi", bg: "bg-red-50 border border-red-100", text: "text-red-700", icon: Trash2 },
};
const defaultAction = { labelTR: "İşlem Yaptı", bg: "bg-slate-100 border border-slate-200", text: "text-slate-700", icon: Activity };

const entityMeta: Record<string, { labelTR: string; icon: any }> = {
    User: { labelTR: "Kullanıcı", icon: User },
    Course: { labelTR: "Ders", icon: FileText },
    Lesson: { labelTR: "İçerik/Video", icon: Monitor },
    Group: { labelTR: "Grup", icon: User },
    Settings: { labelTR: "Sistem Ayarları", icon: Activity },
};

// Parse User Agent
const parseUserAgent = (ua?: string) => {
    if (!ua) return { os: "Bilinmiyor", browser: "Bilinmiyor", device: "Desktop" };
    const parser = new UAParser(ua);
    const res = parser.getResult();
    return {
        os: res.os.name ? `${res.os.name} ${res.os.version || ""}` : "Bilinmiyor",
        browser: res.browser.name ? `${res.browser.name} ${res.browser.version || ""}` : "Bilinmiyor",
        device: res.device.type === "mobile" || res.device.type === "tablet" ? "Mobile" : "Desktop"
    };
};

// Global in-memory cache and pending lookup promises to prevent race conditions and duplicate API requests
const ipLocMemoryCache = new Map<string, string>();
const ipLocPendingLookups = new Map<string, Promise<string>>();

function IpLocation({ ip }: { ip?: string }) {
    const [loc, setLoc] = useState<string>("");
    
    useEffect(() => {
        if (!ip || ip === "Bilinmiyor" || ip.startsWith("127.") || ip.startsWith("192.168") || ip === "::1" || ip === "localhost") return;
        
        // 1. Check in-memory cache
        if (ipLocMemoryCache.has(ip)) {
            setLoc(ipLocMemoryCache.get(ip)!);
            return;
        }

        // 2. Check localStorage
        const cached = localStorage.getItem(`iploc_${ip}`);
        if (cached) {
            ipLocMemoryCache.set(ip, cached);
            setLoc(cached);
            return;
        }

        // 3. Check if there's already a pending lookup for this IP
        if (ipLocPendingLookups.has(ip)) {
            ipLocPendingLookups.get(ip)!.then(finalVal => {
                if (finalVal) setLoc(finalVal);
            });
            return;
        }

        const formatLocation = (city: string, region: string, isp: string) => {
            const ilce = city || "";
            const il = region || "";
            
            let locationString = "";
            if (ilce && il) {
                locationString = `${ilce}, ${il}`;
            } else {
                locationString = il || ilce || "";
            }
            
            let ispFriendly = isp || "";
            if (ispFriendly.toLowerCase().includes("superonline")) ispFriendly = "Superonline";
            else if (ispFriendly.toLowerCase().includes("ttnet") || ispFriendly.toLowerCase().includes("telekom")) ispFriendly = "Türk Telekom";
            else if (ispFriendly.toLowerCase().includes("turkcell")) ispFriendly = "Turkcell Mobil";
            else if (ispFriendly.toLowerCase().includes("vodafone")) ispFriendly = "Vodafone";
            else if (ispFriendly.toLowerCase().includes("turknet")) ispFriendly = "TurkNet";
            
            return locationString && ispFriendly 
                ? `${locationString} | ${ispFriendly}`
                : (locationString || ispFriendly || "");
        };

        // Create the promise for fetching
        const lookupPromise = (async () => {
            try {
                // Provider 1 (ipwho.is)
                const res = await fetch(`https://ipwho.is/${ip}`);
                const data = await res.json();
                if (data && data.success) {
                    const val = formatLocation(data.city, data.region, data.connection?.isp);
                    if (val) return val;
                }
                throw new Error("Failed validation");
            } catch {
                try {
                    // Provider 2 (ipwhois.app)
                    const res = await fetch(`https://ipwhois.app/json/${ip}`);
                    const data = await res.json();
                    if (data && data.success) {
                        const val = formatLocation(data.city, data.region, data.isp);
                        if (val) return val;
                    }
                    throw new Error("Failed validation");
                } catch {
                    try {
                        // Provider 3 (freeipapi.com)
                        const res = await fetch(`https://freeipapi.com/api/json/${ip}`);
                        const data = await res.json();
                        if (data && data.cityName) {
                            const val = formatLocation(data.cityName, data.regionName, "");
                            if (val) return val;
                        }
                    } catch {
                        // Ignore
                    }
                }
            }
            return "";
        })();

        // Register the promise
        ipLocPendingLookups.set(ip, lookupPromise);

        lookupPromise.then(finalVal => {
            ipLocPendingLookups.delete(ip);
            if (finalVal) {
                ipLocMemoryCache.set(ip, finalVal);
                localStorage.setItem(`iploc_${ip}`, finalVal);
                setLoc(finalVal);
            }
        });

    }, [ip]);

    if (!loc) return null;
    return <span className="text-[#1B3B6F] font-semibold text-[10px] ml-1.5 bg-[#1B3B6F]/5 px-1.5 py-0.5 rounded border border-[#1B3B6F]/10 font-sans shadow-sm">( {loc} )</span>;
}

const formatActionLabel = (action: string): string => {
    if (!action) return "İşlem Yaptı";

    let act = action;
    let entity = "";

    if (action.includes(":")) {
        const parts = action.split(":");
        act = parts[0];
        entity = parts[1];
    }

    if (act === "WatchSession" || entity === "VideoProgress") {
        return "Video İzleme Aktivitesi";
    }

    const translations: Record<string, string> = {
        Create: "Oluşturdu",
        Update: "Güncelledi",
        Delete: "Sildi",
        BulkCreate: "Toplu Ekleme Yaptı",
        BulkDelete: "Toplu Silme Yaptı",
        Submit: "Teslim Etti",
        Grade: "Notlandırdı",
        StatusChange: "Durumunu Değiştirdi",
        Clone: "Klonladı",
        AddMember: "Üye Eklemesi Yaptı",
        RemoveMember: "Üye Çıkarması Yaptı",
        BulkSend: "Toplu Gönderim Yaptı",
        Generate: "AI ile Üretti",
        Ask: "Soru Sordu",
        Answer: "Cevapladı",
        DeleteAnswer: "Cevap Sildi",
        UpdateStatus: "Statü Güncelledi",
        AddNote: "Not Eklemesi Yaptı",
        DeleteNote: "Not Sildi",
        StartLive: "Canlı Ders Başlattı",
        ForceDelete: "Kalıcı Olarak Sildi",
        AssignRole: "Rol Atandı",
        RemoveRole: "Rol Kaldırdı",
        Login: "Giriş Yaptı",
        Logout: "Çıkış Yaptı",
    };

    const actionText = translations[act] || act;
    if (entity) {
        const entityText = formatEntityLabel(entity);
        return `${entityText} ${actionText.toLowerCase()}`;
    }
    return actionText;
};

const formatEntityLabel = (entityType: string): string => {
    const translations: Record<string, string> = {
        User: "Kullanıcı",
        Course: "Ders",
        Lesson: "İçerik/Video",
        Group: "Grup",
        Settings: "Sistem Ayarları",
        Transaction: "Ödeme/İşlem",
        Plan: "Abonelik Planı",
        Assignment: "Ödev",
        Exam: "Sınav/Quiz",
        Notification: "Bildirim",
        Podcast: "Podcast",
        Question: "Soru",
        Ticket: "Destek Talebi",
        FAQ: "Sıkça Sorulan Soru",
        VideoNote: "Video Notu",
        VideoProgress: "Video İzleme İlerlemesi",
        Package: "Paket",
        Session: "Canlı Ders Oturumu",
        DeviceSession: "Cihaz Oturumu"
    };
    return translations[entityType] || entityType;
};

// Çeviri ve Formatlama Yardımcıları
const keyTranslations: Record<string, string> = {
    LastPosition: "İzleme Noktası (Video)",
    WatchedSeconds: "Toplam İzlenen Süre",
    UpdatedAt: "İlerleme Zamanı",
    CompletionPercentage: "Tamamlanma Oranı",
    CompletedAt: "Tamamlanma Tarihi",
    FirstName: "Ad",
    LastName: "Soyad",
    Email: "E-Posta",
    Role: "Kullanıcı Rolü",
    IsActive: "Aktiflik Durumu",
    PhoneNumber: "Telefon Numarası",
    Title: "Başlık",
    Description: "Açıklama",
    Price: "Fiyat",
    IsPublished: "Yayın Durumu",
    Name: "Adı / Başlığı",
    Status: "Durum",
    Subject: "Konu",
    ExamType: "Sınav Tipi",
    StartDate: "Başlangıç Tarihi",
    Duration: "Süre",
    MaxScore: "Maksimum Puan",
    DeviceInfo: "Cihaz Bilgisi",
    IpAddress: "IP Adresi",
    LoginAt: "Giriş Zamanı",
    UserAgent: "Tarayıcı Detayı",
    UserId: "Kullanıcı ID",
    CreatedAt: "Kayıt Tarihi",
    FilePath: "Dosya Yolu",
    HlsPath: "HLS Yayın Yolu",
    ThumbnailPath: "Önizleme Resmi",
    VttPath: "Video Alt Yazı Dosyası",
    VideoUrl: "Video Bağlantısı",
    PlaybackUrl: "Oynatma Bağlantısı",
    FileUrl: "Dosya Adresi",
    Password: "Şifre",
    PasswordHash: "Şifre Özeti (Hash)",
    PasswordSalt: "Şifre Tuzu (Salt)"
};

const formatAuditValue = (key: string, value: any): string => {
    if (value === null || value === undefined || value === "") return "Boş";
    
    const strVal = String(value).trim();
    const keyLower = key.toLowerCase();

    // Güvenlik: Şifre ve sistem dosya yollarını UI üzerinde asla gösterme
    const sensitiveKeys = [
        "filepath", "hlspath", "thumbnailpath", "vttpath", "videourl", "playbackurl", "fileurl", "url", "path",
        "file_path", "hls_path", "thumbnail_path", "vtt_path", "video_url", "playback_url", "file_url",
        "password", "passwordhash", "passwordsalt", "securitystamp", "concurrencystamp"
    ];
    if (sensitiveKeys.includes(keyLower)) {
        return "[Dosya / Güvenlik Yolu Gizlendi]";
    }

    if (["LastPosition", "WatchedSeconds", "Duration"].includes(key)) {
        const totalSeconds = parseInt(strVal, 10);
        if (!isNaN(totalSeconds)) {
            const hrs = Math.floor(totalSeconds / 3600);
            const mins = Math.floor((totalSeconds % 3600) / 60);
            const secs = totalSeconds % 60;
            return `${hrs > 0 ? `${hrs}sa ` : ""}${mins > 0 ? `${mins}dk ` : ""}${secs}sn`;
        }
    }

    if (key === "UserAgent") {
        const parsedUA = parseUserAgent(strVal);
        return `${parsedUA.os} - ${parsedUA.browser} (${parsedUA.device})`;
    }

    // Tarih formatlama
    if (Date.parse(strVal) && (strVal.includes("-") || strVal.includes("/")) && strVal.length > 10) {
        try {
            return new Date(strVal).toLocaleString("tr-TR");
        } catch (e) {
            return strVal;
        }
    }

    if (strVal.toLowerCase() === "true") return "Aktif / Evet";
    if (strVal.toLowerCase() === "false") return "Pasif / Hayır";

    return strVal;
};

const renderChangesGrid = (changes: Array<{ label: string; oldVal: string; newVal: string }>) => {
    return (
        <div className="mt-3 space-y-2">
            {changes.map((change, idx) => {
                const isCreate = change.oldVal === "-" || change.oldVal === "Boş" || change.oldVal === "";
                const isDelete = change.newVal === "Boş" || change.newVal === "" || change.newVal === null;
                
                let indicatorColor = "bg-blue-500";
                let newValueStyle = "bg-blue-50/50 text-blue-700 border-blue-100/50 font-bold";
                
                if (isCreate) {
                    indicatorColor = "bg-emerald-500 animate-pulse";
                    newValueStyle = "bg-emerald-50 text-emerald-700 border-emerald-100/50 font-bold";
                } else if (isDelete) {
                    indicatorColor = "bg-rose-500";
                    newValueStyle = "bg-rose-50 text-rose-700 border-rose-100/50 line-through";
                }

                return (
                    <div 
                        key={idx} 
                        className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 p-3.5 bg-slate-50/40 hover:bg-slate-50 border border-slate-100/70 rounded-xl transition-all duration-200 shadow-sm"
                    >
                        {/* Sol Taraf: Alan Etiketi */}
                        <div className="flex items-center gap-2.5">
                            <span className={`w-1.5 h-5 rounded-full ${indicatorColor} shrink-0`} />
                            <span className="text-xs font-bold text-slate-800 tracking-tight">{change.label}</span>
                        </div>

                        {/* Sağ Taraf: Karşılaştırmalı Değerler */}
                        <div className="flex items-center gap-2 text-[11px] font-mono shrink-0">
                            {!isCreate && (
                                <>
                                    <span className="px-2.5 py-1 bg-slate-100 text-slate-500 rounded-lg border border-slate-200/40 max-w-[160px] truncate shadow-sm">
                                        {change.oldVal}
                                    </span>
                                    <ArrowRight size={12} className="text-slate-400 shrink-0" />
                                </>
                            )}
                            <span className={`px-2.5 py-1 rounded-lg border max-w-[160px] truncate shadow-sm ${newValueStyle}`}>
                                {change.newVal}
                            </span>
                        </div>
                    </div>
                );
            })}
        </div>
    );
};

const RenderLogDetails = ({ details }: { details: string }) => {
    if (!details) return null;

    let parsed: any = null;
    try {
        if (details.trim().startsWith("{") || details.trim().startsWith("[")) {
            parsed = JSON.parse(details);
        }
    } catch (e) {
        // silent fail
    }

    const ignoredKeys = [
        "MediaAssetId", "ReplayCount", "SkipCount", "TotalSeconds", 
        "UserId", "UpdatedAt", "CompletedAt", "Id", "AuditDisplayName",
        "GroupId", "TenantId", "IsDeleted", "FailedLoginCount", 
        "AccessFailedCount", "ConcurrencyStamp", "SecurityStamp", 
        "PasswordHash", "PasswordSalt", "NormalizedEmail", 
        "NormalizedUserName", "EmailConfirmed", "PhoneNumberConfirmed",
        "LockoutEnd", "LockoutEnabled", "TwoFactorEnabled"
    ];

    // JSON formatındaki yeni kayıtlar
    if (parsed && parsed.changes) {
        const changesObj = parsed.changes;
        const keys = Object.keys(changesObj);

        if (keys.length === 0) {
            return (
                <div className="mt-2 text-xs text-slate-500 italic">
                    (Detaylı alan değişikliği tespit edilmedi)
                </div>
            );
        }

        const changes = keys
            .filter(key => !ignoredKeys.includes(key))
            .map((key) => {
                const change = changesObj[key];
                return {
                    label: keyTranslations[key] || key,
                    oldVal: formatAuditValue(key, change.old),
                    newVal: formatAuditValue(key, change.new),
                };
            });

        if (changes.length === 0) {
            return (
                <div className="mt-2 text-xs text-slate-500 italic">
                    (Detaylı alan değişikliği tespit edilmedi veya gizlendi)
                </div>
            );
        }

        return renderChangesGrid(changes);
    }

    // Eski düz metin logları (Geriye dönük uyumluluk için regex ile ayrıştırma)
    const lines = details.split("\n").map(line => line.trim());
    const parsedChanges: Array<{ label: string; oldVal: string; newVal: string }> = [];

    lines.forEach(line => {
        const matchUpdate = line.match(/^-\s+([^:]+):\s+'(.*)'\s+➔\s+'(.*)'$/) || line.match(/^-\s+([^:]+):\s+(.+)\s+➔\s+(.+)$/);
        const matchCreate = line.match(/^-\s+([^:]+):\s+'(.*)'$/) || line.match(/^-\s+([^:]+):\s+(.+)$/);

        if (matchUpdate) {
            const [, key, oldVal, newVal] = matchUpdate;
            if (!ignoredKeys.includes(key.trim())) {
                parsedChanges.push({
                    label: keyTranslations[key.trim()] || key.trim(),
                    oldVal: formatAuditValue(key.trim(), oldVal),
                    newVal: formatAuditValue(key.trim(), newVal),
                });
            }
        } else if (matchCreate) {
            const [, key, val] = matchCreate;
            if (!ignoredKeys.includes(key.trim())) {
                parsedChanges.push({
                    label: keyTranslations[key.trim()] || key.trim(),
                    oldVal: "-",
                    newVal: formatAuditValue(key.trim(), val),
                });
            }
        }
    });

    if (parsedChanges.length > 0) {
        return renderChangesGrid(parsedChanges);
    }

    // Basit düz metinler (Örn: "Tutar: 100 TL")
    return (
        <div className="mt-2 p-3 bg-slate-50 border border-slate-100 rounded-xl text-xs text-slate-600 whitespace-pre-wrap leading-relaxed">
            {details}
        </div>
    );
};

export default function AuditTrailPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const { success: toastSuccess, error: toastError } = useToast();
    
    // Master View States
    const [users, setUsers] = useState<UserAuditSummaryDto[]>([]);
    const [suspicious, setSuspicious] = useState<SuspiciousUserDto[]>([]);
    const [blockedIps, setBlockedIps] = useState<Array<{ ipAddress: string; blockedUntil: string }>>([]);
    const [lockedAccounts, setLockedAccounts] = useState<Array<{ id: string; firstName: string; lastName: string; email: string; failedLoginCount: number; lockoutUntil: string }>>([]);
    const [securitySummary, setSecuritySummary] = useState<any>(null);
    const [totalUsers, setTotalUsers] = useState(0);
    const [totalPages, setTotalPages] = useState(1);
    
    const [page, setPage] = useState(1);
    const [search, setSearch] = useState("");
    const [sortBy, setSortBy] = useState<"date" | "count">("date");
    const [loading, setLoading] = useState(true);
    const [loadingBlockedIps, setLoadingBlockedIps] = useState(false);
    const [loadingLockedAccounts, setLoadingLockedAccounts] = useState(false);

    // Detail Modal States
    const [selectedUser, setSelectedUser] = useState<{ id: string | null; name: string | null; avatarUrl?: string | null; email?: string | null } | null>(null);
    const [logFilter, setLogFilter] = useState<"all" | "education" | "security" | "system">("all");
    const [userLogs, setUserLogs] = useState<any[]>([]); // Merged Audit + Security
    const [loadingLogs, setLoadingLogs] = useState(false);

    const fetchMasterData = useCallback(async () => {
        if (!token || !tenantId) return;
        setLoading(true);
        setLoadingBlockedIps(true);
        setLoadingLockedAccounts(true);
        try {
            const [usersRes, suspRes, blockedRes, lockedRes, summaryRes] = await Promise.all([
                auditApi.getUserAudits(token, tenantId, { page, pageSize: 10, search, sortBy }),
                auditApi.getSuspiciousUsers(token, tenantId),
                securityApi.getBlockedIps(token, tenantId),
                securityApi.getLockedAccounts(token, tenantId).catch(() => ({ items: [] })),
                securityApi.getSecuritySummary(token, tenantId).catch(() => null)
            ]);
            setUsers(usersRes.items);
            setTotalUsers(usersRes.totalCount);
            setTotalPages(usersRes.totalPages);
            setSuspicious(suspRes);
            setBlockedIps(blockedRes.items || []);
            setLockedAccounts(lockedRes.items || lockedRes || []);
            setSecuritySummary(summaryRes);
        } catch (e) {
            console.error("Failed to load audit data", e);
        } finally {
            setLoading(false);
            setLoadingBlockedIps(false);
            setLoadingLockedAccounts(false);
        }
    }, [token, tenantId, page, search, sortBy]);

    const handleUnblockIp = async (ip: string) => {
        if (!token || !tenantId) return;
        try {
            const res = await securityApi.unblockIp(token, tenantId, ip);
            if (res.success) {
                toastSuccess("IP Engeli Kaldırıldı", res.message || `${ip} engeli başarıyla kaldırıldı.`);
                const blockedRes = await securityApi.getBlockedIps(token, tenantId);
                setBlockedIps(blockedRes.items || []);
                // İstatistikleri de yenileyelim kanka
                const summaryRes = await securityApi.getSecuritySummary(token, tenantId).catch(() => null);
                setSecuritySummary(summaryRes);
            } else {
                toastError("Hata", "IP engeli kaldırılamadı.");
            }
        } catch (e: any) {
            console.error("Failed to unblock IP", e);
            toastError("Hata", e.message || "IP engeli kaldırılırken bir hata oluştu.");
        }
    };

    const handleUnlockAccount = async (userId: string, userName: string) => {
        if (!token || !tenantId) return;
        try {
            const res = await securityApi.unlockAccount(token, tenantId, userId);
            if (res.success) {
                toastSuccess("Hesap Kilidi Kaldırıldı", `${userName} kullanıcısının hesap kilidi başarıyla kaldırıldı.`);
                const lockedRes = await securityApi.getLockedAccounts(token, tenantId).catch(() => ({ items: [] }));
                setLockedAccounts(lockedRes.items || lockedRes || []);
                // İstatistikleri yenileyelim kanka
                const summaryRes = await securityApi.getSecuritySummary(token, tenantId).catch(() => null);
                setSecuritySummary(summaryRes);
            } else {
                toastError("Hata", "Hesap kilidi kaldırılamadı.");
            }
        } catch (e: any) {
            console.error("Failed to unlock account", e);
            toastError("Hata", e.message || "Hesap kilidi kaldırılırken bir hata oluştu.");
        }
    };

    useEffect(() => { fetchMasterData(); }, [fetchMasterData]);

    // Load detailed logs for selected user
    useEffect(() => {
        if (!selectedUser || !token || !tenantId) return;
        
        let isMounted = true;
        const loadLogs = async () => {
            setLoadingLogs(true);
            try {
                // Fetch both system audits and security events for the user
                const [sysLogs, secLogs] = await Promise.all([
                    auditApi.getLogs(token, tenantId, { search: selectedUser.id || undefined, pageSize: 50 }),
                    securityApi.getEvents(token, tenantId, { userId: selectedUser.id || undefined, pageSize: 50 })
                ]);
                
                if (!isMounted) return;

                // Merge and sort chronologically (newest first)
                const merged = [
                    ...sysLogs.items.map((l: any) => ({ ...l, _type: 'system' })),
                    ...secLogs.items.map((l: any) => ({ ...l, _type: 'security' }))
                ];
                merged.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
                
                // Group consecutive video progress logs
                const grouped = [];
                for (let i = 0; i < merged.length; i++) {
                    const current = merged[i];
                    if (current._type === 'system' && current.action === "Update" && current.entityType === "VideoProgress") {
                        let sessionEndTime = new Date(current.createdAt).getTime();
                        let j = i;
                        while (
                            j + 1 < merged.length && 
                            merged[j+1]._type === 'system' &&
                            merged[j+1].action === "Update" && 
                            merged[j+1].entityType === "VideoProgress" &&
                            merged[j+1].entityId === current.entityId &&
                            (new Date(merged[j].createdAt).getTime() - new Date(merged[j+1].createdAt).getTime() < 30 * 60 * 1000)
                        ) {
                            j++;
                        }
                        if (j > i) {
                            const oldest = merged[j];
                            grouped.push({
                                ...current,
                                isGrouped: true,
                                groupedCount: j - i + 1,
                                sessionStartTime: oldest.createdAt,
                                sessionEndTime: current.createdAt,
                                action: "WatchSession" // Custom action
                            });
                            i = j;
                        } else {
                            grouped.push(current);
                        }
                    } else {
                        grouped.push(current);
                    }
                }

                setUserLogs(grouped);
            } catch (e) {
                console.error("Failed to load user logs", e);
            } finally {
                if (isMounted) setLoadingLogs(false);
            }
        };
        
        loadLogs();
        return () => { isMounted = false; };
    }, [selectedUser, token, tenantId]);

    // Separate Suspicious Users
    const multipleLoginUsers = suspicious.filter(s => s.alertType === "SESSION_KICKED");
    const otherSuspiciousUsers = suspicious.filter(s => s.alertType !== "SESSION_KICKED");

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931] flex items-center gap-2">
                        <Shield size={22} className="text-[#1B3B6F]" /> Kullanıcı Kayıtları
                    </h1>
                    <p className="text-sm text-[#A9A9A9] mt-0.5">Sistemdeki tüm eylemler ve şüpheli tespitleri</p>
                </div>
                <button onClick={fetchMasterData} className="p-2 rounded-xl bg-white border border-[#E2E8F0] hover:bg-[#E2E8F0]/20 text-[#A9A9A9] transition-all shadow-sm">
                    <RefreshCw size={14} className={loading ? "animate-spin" : ""} />
                </button>
            </div>

            {/* ── SECURITY KPI DASHBOARD ── */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-4 animate-in fade-in duration-300">
                {/* Brute Force Card */}
                <div className="bg-white border border-[#E2E8F0] p-4 rounded-2xl shadow-sm flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-red-50 border border-red-100 flex items-center justify-center text-red-500 shrink-0">
                        <AlertTriangle size={20} />
                    </div>
                    <div>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider">Şüpheli Denemeler (24s)</p>
                        <h3 className="text-lg font-black text-slate-800 font-mono mt-0.5">
                            {securitySummary?.events24h?.bruteForce ?? 0}
                        </h3>
                    </div>
                </div>

                {/* Failed Logins Card */}
                <div className="bg-white border border-[#E2E8F0] p-4 rounded-2xl shadow-sm flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-amber-50 border border-amber-100 flex items-center justify-center text-amber-500 shrink-0">
                        <Lock size={18} />
                    </div>
                    <div>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider">Hatalı Girişler (24s)</p>
                        <h3 className="text-lg font-black text-slate-800 font-mono mt-0.5">
                            {securitySummary?.events24h?.failedLogins ?? 0}
                        </h3>
                    </div>
                </div>

                {/* Giriş Sorunu Yaşayanlar Card */}
                <div className="bg-white border border-[#E2E8F0] p-4 rounded-2xl shadow-sm flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center text-blue-500 shrink-0">
                        <AlertTriangle size={18} />
                    </div>
                    <div>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider">Giriş Sorunu Yaşayanlar</p>
                        <h3 className="text-lg font-black text-slate-800 font-mono mt-0.5">
                            {lockedAccounts.length}
                        </h3>
                    </div>
                </div>

                {/* Sessions Kicked Card */}
                <div className="bg-white border border-[#E2E8F0] p-4 rounded-2xl shadow-sm flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-purple-50 border border-purple-100 flex items-center justify-center text-purple-500 shrink-0">
                        <Activity size={18} />
                    </div>
                    <div>
                        <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider">Oturum Engelleme (24s)</p>
                        <h3 className="text-lg font-black text-slate-800 font-mono mt-0.5">
                            {securitySummary?.events24h?.sessionsKicked ?? 0}
                        </h3>
                    </div>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
                
                {/* ── LEFT COLUMN: USER LIST ── */}
                <div className="lg:col-span-8 bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm overflow-hidden flex flex-col min-h-[600px]">
                    <div className="p-4 border-b border-[#E2E8F0] flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-slate-50/50">
                        <h2 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                            <Activity size={16} className="text-[#1B3B6F]" /> Kullanıcı Hareketleri
                        </h2>
                        <div className="relative w-full sm:w-64">
                            <Search size={13} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                            <input 
                                type="text" placeholder="İsimle ara..." 
                                value={search} onChange={e => { setSearch(e.target.value); setPage(1); }}
                                className="w-full pl-8 pr-3 py-2 text-xs bg-white border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10" 
                            />
                        </div>
                    </div>
                    
                    <div className="flex-1 overflow-x-auto hide-scrollbar">
                        <table className="w-full min-w-[550px]">
                            <thead>
                                <tr className="bg-slate-50 border-b border-[#E2E8F0]">
                                    <th 
                                        className={`text-left px-5 py-3 text-[10px] font-bold uppercase whitespace-nowrap cursor-pointer select-none transition-colors hover:text-[#0A1931] ${sortBy === "count" ? "text-[#0A1931] font-extrabold" : "text-[#A9A9A9]"}`}
                                        onClick={() => { setSortBy("count"); setPage(1); }}
                                    >
                                        <div className="flex items-center gap-1">
                                            Toplam İşlem
                                            {sortBy === "count" && <span className="text-[#0A1931] text-[8px]">▼</span>}
                                        </div>
                                    </th>
                                    <th className="text-left px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase whitespace-nowrap select-none">Kullanıcı</th>
                                    <th 
                                        className={`text-left px-5 py-3 text-[10px] font-bold uppercase whitespace-nowrap cursor-pointer select-none transition-colors hover:text-[#0A1931] ${sortBy === "date" ? "text-[#0A1931] font-extrabold" : "text-[#A9A9A9]"}`}
                                        onClick={() => { setSortBy("date"); setPage(1); }}
                                    >
                                        <div className="flex items-center gap-1">
                                            Son İşlem
                                            {sortBy === "date" && <span className="text-[#0A1931] text-[8px]">▼</span>}
                                        </div>
                                    </th>
                                    <th className="text-left px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase whitespace-nowrap select-none">Durum</th>
                                    <th className="text-right px-5 py-3 text-[10px] font-bold text-[#A9A9A9] uppercase whitespace-nowrap select-none">İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                {loading && users.length === 0 ? (
                                    [...Array(10)].map((_, i) => (
                                        <tr key={i} className="border-b border-[#E2E8F0]/40"><td colSpan={4} className="p-4"><div className="h-6 bg-slate-100 rounded-lg animate-pulse" /></td></tr>
                                    ))
                                ) : users.length === 0 ? (
                                    <tr>
                                        <td colSpan={4} className="py-20 text-center text-[#A0AEC0]">
                                            <Search size={32} className="mx-auto mb-3 opacity-20" />
                                            <p className="text-sm font-medium">Kayıt bulunamadı</p>
                                        </td>
                                    </tr>
                                ) : (
                                    users.map((u, i) => {
                                        const isSuspicious = suspicious.some(s => s.userId === u.userId);
                                        return (
                                        <tr key={u.userId || i} className="border-b border-[#E2E8F0]/40 hover:bg-slate-50 transition-colors">
                                            <td className="px-5 py-3">
                                                <span className="inline-flex items-center justify-center min-w-[32px] h-6 px-2 bg-emerald-50 text-emerald-600 text-xs font-bold rounded-lg border border-emerald-100 shadow-sm">
                                                    {u.actionCount}
                                                </span>
                                            </td>
                                            <td className="px-5 py-3">
                                                <div className="flex items-center gap-3">
                                                    {u.userId ? (
                                                        <div className="w-8 h-8 rounded-full bg-gradient-to-br from-[#1B3B6F] to-[#0A1931] flex items-center justify-center text-white text-[10px] font-bold flex-shrink-0">
                                                            {u.avatarUrl ? <img src={u.avatarUrl} alt="Avatar" className="w-full h-full rounded-full object-cover" /> : u.userName?.[0]?.toUpperCase() || "U"}
                                                        </div>
                                                    ) : (
                                                        <div className="w-8 h-8 rounded-full bg-slate-200 flex items-center justify-center text-slate-500 text-[10px] font-bold flex-shrink-0">
                                                            <Globe size={14} />
                                                        </div>
                                                    )}
                                                    <div>
                                                        <p className="text-sm font-bold text-[#0A1931]">{u.userName || "Sistem / Anonim"}</p>
                                                        {u.email && <p className="text-[10px] text-[#A0AEC0]">{u.email}</p>}
                                                    </div>
                                                </div>
                                            </td>
                                            <td className="px-5 py-3 whitespace-nowrap">
                                                {u.lastAction && <p className="text-xs font-bold text-slate-700">{formatActionLabel(u.lastAction)}</p>}
                                                <p className="text-[10px] text-[#A9A9A9]">
                                                    {new Date(u.lastActionAt).toLocaleString("tr-TR", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                                                </p>
                                            </td>
                                            <td className="px-5 py-3">
                                                {isSuspicious ? (
                                                    <span className="inline-flex items-center gap-1 px-2 py-1 bg-red-50 text-red-600 text-[10px] font-bold rounded-lg border border-red-100">
                                                        <AlertTriangle size={10} /> Riskli
                                                    </span>
                                                ) : (
                                                    <span className="inline-flex items-center gap-1 px-2 py-1 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-lg border border-emerald-100">
                                                        <Check size={10} /> Güvenli
                                                    </span>
                                                )}
                                            </td>
                                            <td className="px-5 py-3 text-right">
                                                <button 
                                                    onClick={() => setSelectedUser({ id: u.userId || null, name: u.userName || null, avatarUrl: u.avatarUrl, email: u.email })}
                                                    className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-[#0A1931] text-white text-xs font-bold rounded-lg hover:bg-[#1B3B6F] transition-colors"
                                                >
                                                    <Eye size={12} /> İncele
                                                </button>
                                            </td>
                                        </tr>
                                    )})
                                )}
                            </tbody>
                        </table>
                    </div>

                    {/* Pagination */}
                    {totalPages > 1 && (
                        <div className="p-3 border-t border-[#E2E8F0] bg-slate-50 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                            <p className="text-xs font-bold text-[#A0AEC0] text-center sm:text-left">{totalUsers} Kayıt</p>
                            <div className="flex items-center justify-center gap-1">
                                <button onClick={() => setPage(p => Math.max(1, p - 1))} disabled={page === 1} className="p-1.5 rounded-lg hover:bg-white text-[#A0AEC0] border border-[#E2E8F0]"><ChevronLeft size={14} /></button>
                                {Array.from({ length: Math.min(totalPages, 5) }, (_, i) => {
                                    let p = i + 1;
                                    if (totalPages > 5 && page > 3) p = page - 3 + i;
                                    if (p > totalPages) return null;
                                    return (
                                        <button key={p} onClick={() => setPage(p)} className={`w-8 h-8 rounded-lg text-xs font-bold ${p === page ? "bg-[#0A1931] text-white" : "hover:bg-white text-[#A9A9A9]"}`}>{p}</button>
                                    );
                                })}
                                <button onClick={() => setPage(p => Math.min(totalPages, p + 1))} disabled={page === totalPages} className="p-1.5 rounded-lg hover:bg-white text-[#A0AEC0] border border-[#E2E8F0]"><ChevronRight size={14} /></button>
                            </div>
                        </div>
                    )}
                </div>

                {/* ── RIGHT COLUMN: ALERTS ── */}
                <div className="lg:col-span-4 space-y-6">
                    <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm overflow-hidden">
                        <div className="p-4 bg-slate-50/50 border-b border-[#E2E8F0] flex items-center justify-between">
                            <h2 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                                <AlertTriangle size={16} className="text-amber-500" /> Usulsüz İşlemler
                            </h2>
                        </div>
                        
                        <div className="p-5 space-y-5">
                            
                            {/* Çoklu Giriş Paneli */}
                            <div>
                                <div className="flex items-center gap-2 mb-3">
                                    <span className="flex items-center justify-center w-6 h-6 rounded bg-[#1B3B6F] text-white">
                                        <Lock size={12} />
                                    </span>
                                    <h3 className="text-xs font-bold text-[#0A1931] uppercase tracking-wider">Çoklu Giriş Tespiti</h3>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    {multipleLoginUsers.length === 0 ? (
                                        <p className="text-xs text-[#A9A9A9] italic">Son 7 günde tespit bulunamadı.</p>
                                    ) : (
                                        multipleLoginUsers.map((su, i) => (
                                            <button 
                                                key={i} 
                                                onClick={() => setSelectedUser({ id: su.userId, name: su.userName })}
                                                className="px-2.5 py-1.5 bg-[#1B3B6F]/5 border border-[#1B3B6F]/20 text-[#1B3B6F] hover:bg-[#1B3B6F] hover:text-white text-[11px] font-bold rounded-lg transition-colors"
                                            >
                                                {su.userName || "Bilinmeyen"}
                                            </button>
                                        ))
                                    )}
                                </div>
                            </div>

                            <hr className="border-[#E2E8F0]" />

                            {/* Şüpheli Paneli */}
                            <div>
                                <div className="flex items-center gap-2 mb-3">
                                    <span className="flex items-center justify-center w-6 h-6 rounded bg-amber-500 text-white">
                                        <AlertTriangle size={12} />
                                    </span>
                                    <h3 className="text-xs font-bold text-[#0A1931] uppercase tracking-wider">Şüpheli İşlemler</h3>
                                </div>
                                <div className="flex flex-wrap gap-2">
                                    {otherSuspiciousUsers.length === 0 ? (
                                        <p className="text-xs text-[#A9A9A9] italic">Son 7 günde tespit bulunamadı.</p>
                                    ) : (
                                        otherSuspiciousUsers.map((su, i) => (
                                            <button 
                                                key={i} 
                                                onClick={() => setSelectedUser({ id: su.userId, name: su.userName })}
                                                className="px-2.5 py-1.5 bg-amber-50 border border-amber-200 text-amber-700 hover:bg-amber-500 hover:text-white hover:border-amber-500 text-[11px] font-bold rounded-lg transition-colors flex items-center gap-1"
                                                title={`${su.eventCount} adet ${su.alertType} şüphesi`}
                                            >
                                                {su.userName || "Bilinmeyen"} <span className="opacity-50">({su.eventCount})</span>
                                            </button>
                                        ))
                                    )}
                                </div>
                            </div>

                        </div>
                    </div>

                    {/* Engellenen IP Adresleri Paneli */}
                    <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm overflow-hidden animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <div className="p-4 bg-slate-50/50 border-b border-[#E2E8F0] flex items-center justify-between">
                            <h2 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                                <Lock size={16} className="text-red-500" /> Engellenen IP Adresleri
                            </h2>
                            <span className="px-2 py-0.5 bg-red-50 text-red-600 text-[10px] font-bold rounded-lg border border-red-100 shadow-sm font-sans">
                                {blockedIps.length} Aktif
                            </span>
                        </div>

                        <div className="p-5">
                            {loadingBlockedIps || loading ? (
                                <div className="space-y-3">
                                    {[...Array(2)].map((_, i) => (
                                        <div key={i} className="h-10 bg-slate-100 rounded-xl animate-pulse" />
                                    ))}
                                </div>
                            ) : blockedIps.length === 0 ? (
                                <p className="text-xs text-[#A9A9A9] italic text-center py-4 font-sans">Şu an engellenmiş bir IP adresi bulunmuyor.</p>
                            ) : (
                                <div className="space-y-3">
                                    {blockedIps.map((b, i) => (
                                        <div key={i} className="flex items-center justify-between p-3 bg-red-50/30 hover:bg-red-50/50 border border-red-100 rounded-xl transition-all duration-200 shadow-sm">
                                            <div className="min-w-0 flex-1">
                                                <div className="flex items-center gap-1.5 flex-wrap">
                                                    <span className="text-xs font-mono font-bold text-[#0A1931] truncate">{b.ipAddress}</span>
                                                    <IpLocation ip={b.ipAddress} />
                                                </div>
                                                <p className="text-[10px] text-[#A9A9A9] mt-0.5 font-sans">
                                                    Engel Bitiş: {new Date(b.blockedUntil).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" })}
                                                </p>
                                            </div>
                                            <button
                                                onClick={() => handleUnblockIp(b.ipAddress)}
                                                className="p-1.5 bg-white hover:bg-emerald-50 text-slate-400 hover:text-emerald-600 rounded-lg border border-slate-200 hover:border-emerald-200 transition-all shadow-sm shrink-0 ml-2"
                                                title="Engeli Kaldır"
                                            >
                                                <Unlock size={14} />
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Giriş Sorunu Yaşayanlar Paneli */}
                    <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm overflow-hidden animate-in fade-in slide-in-from-bottom-2 duration-300">
                        <div className="p-4 bg-slate-50/50 border-b border-[#E2E8F0] flex items-center justify-between">
                            <h2 className="text-sm font-bold text-[#0A1931] flex items-center gap-2">
                                <AlertTriangle size={16} className="text-amber-500" /> Giriş Sorunu Yaşayanlar
                            </h2>
                            <span className="px-2 py-0.5 bg-amber-50 text-amber-600 text-[10px] font-bold rounded-lg border border-amber-100 shadow-sm font-sans">
                                {lockedAccounts.length} Aktif
                            </span>
                        </div>

                        <div className="p-5">
                            {loadingLockedAccounts || loading ? (
                                <div className="space-y-3">
                                    {[...Array(2)].map((_, i) => (
                                        <div key={i} className="h-10 bg-slate-100 rounded-xl animate-pulse" />
                                    ))}
                                </div>
                            ) : lockedAccounts.length === 0 ? (
                                <p className="text-xs text-[#A9A9A9] italic text-center py-4 font-sans">Şu an giriş sorunu (5+ hatalı deneme) yaşayan kullanıcı bulunmuyor.</p>
                            ) : (
                                <div className="space-y-3">
                                    {lockedAccounts.map((u, i) => (
                                        <div key={u.id || i} className="flex items-center justify-between p-3 bg-amber-50/10 hover:bg-amber-50/20 border border-amber-100 rounded-xl transition-all duration-200 shadow-sm">
                                            <div className="min-w-0 flex-1">
                                                <div className="flex items-center gap-1.5 flex-wrap">
                                                    <span className="text-xs font-bold text-[#0A1931] truncate">{u.firstName} {u.lastName}</span>
                                                    <span className="text-[9px] bg-red-50 text-red-600 border border-red-100 px-1 py-0.2 rounded font-sans font-bold">
                                                        {u.failedLoginCount} Hatalı Giriş
                                                    </span>
                                                </div>
                                                <p className="text-[10px] text-[#A9A9A9] truncate font-sans">{u.email}</p>
                                            </div>
                                            <button
                                                onClick={() => handleUnlockAccount(u.id, `${u.firstName} ${u.lastName}`)}
                                                className="p-1.5 bg-white hover:bg-emerald-50 text-slate-400 hover:text-emerald-600 rounded-lg border border-slate-200 hover:border-emerald-200 transition-all shadow-sm shrink-0 ml-2"
                                                title="Hatalı Giriş Sayacını Sıfırla"
                                            >
                                                <RefreshCw size={14} />
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>
                    </div>

                </div>
            </div>

            {/* ── DETAIL MODAL (TIMELINE) ── */}
            {selectedUser && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={() => setSelectedUser(null)}>
                    <div className="absolute inset-0 bg-[#0A1931]/40 backdrop-blur-sm" />
                    <div className="relative w-full max-w-3xl max-h-[90vh] bg-white rounded-2xl shadow-2xl flex flex-col animate-in zoom-in-95 duration-200" onClick={e => e.stopPropagation()}>
                        
                        <div className="px-6 py-4 border-b border-[#E2E8F0] flex flex-col sm:flex-row sm:items-center justify-between shrink-0 gap-4">
                            <div className="flex items-center gap-3">
                                {selectedUser.avatarUrl ? (
                                    <div className="w-10 h-10 rounded-full shrink-0">
                                        <img src={selectedUser.avatarUrl} alt="Avatar" className="w-full h-full rounded-full object-cover shadow-sm border border-[#E2E8F0]" />
                                    </div>
                                ) : (
                                    <div className="w-10 h-10 rounded-full bg-[#1B3B6F]/10 flex items-center justify-center text-[#1B3B6F] shrink-0 border border-[#1B3B6F]/20">
                                        <User size={18} />
                                    </div>
                                )}
                                <div>
                                    <h2 className="text-lg font-bold text-[#0A1931]">{selectedUser.name || "Bilinmeyen Kullanıcı"}</h2>
                                    {selectedUser.email ? <p className="text-xs text-[#A0AEC0]">{selectedUser.email}</p> : <p className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest">Aksiyon Geçmişi</p>}
                                </div>
                            </div>
                            
                            <div className="flex items-center gap-1.5 bg-slate-100/80 p-1 rounded-xl">
                                {[
                                    { id: "all", label: "Tümü" },
                                    { id: "education", label: "Eğitim" },
                                    { id: "security", label: "Güvenlik" },
                                    { id: "system", label: "Sistem" }
                                ].map(f => (
                                    <button 
                                        key={f.id}
                                        onClick={() => setLogFilter(f.id as any)}
                                        className={`px-3 py-1.5 text-[11px] font-bold rounded-lg transition-all ${logFilter === f.id ? "bg-white text-[#0A1931] shadow-sm" : "text-[#A0AEC0] hover:text-[#7A8A9A]"}`}
                                    >
                                        {f.label}
                                    </button>
                                ))}
                                <button onClick={() => setSelectedUser(null)} className="ml-2 p-1.5 rounded-lg text-[#A0AEC0] hover:text-[#0A1931] transition-colors"><X size={16} /></button>
                            </div>
                        </div>
                        
                        <div className="flex-1 overflow-y-auto p-6 bg-slate-50/50">
                            {loadingLogs ? (
                                <div className="space-y-4">
                                    {[...Array(4)].map((_, i) => (
                                        <div key={i} className="flex gap-4 opacity-50 animate-pulse">
                                            <div className="w-12 text-right"><div className="h-4 bg-slate-200 rounded" /></div>
                                            <div className="w-px bg-slate-200" />
                                            <div className="flex-1 h-16 bg-slate-200 rounded-xl" />
                                        </div>
                                    ))}
                                </div>
                            ) : userLogs.length === 0 ? (
                                <div className="text-center py-20 text-[#A0AEC0]">
                                    <Search size={40} className="mx-auto mb-3 opacity-20" />
                                    <p className="text-sm font-medium">Bu kullanıcıya ait son 50 işlemde kayıt bulunamadı.</p>
                                </div>
                            ) : (
                                <div className="space-y-0 relative before:absolute before:inset-0 before:ml-[60px] before:-translate-x-px md:before:ml-[88px] before:h-full before:w-0.5 before:bg-gradient-to-b before:from-[#E2E8F0] before:via-[#E2E8F0] before:to-transparent">
                                    {(() => {
                                        const educationActions = ["Submit", "Ask", "StartLive", "WatchSession"];
                                        const educationEntities = ["Course", "Lesson", "Assignment", "Exam", "VideoProgress"];
                                        const filteredLogs = userLogs.filter(log => {
                                            if (logFilter === "all") return true;
                                            if (logFilter === "security") return log._type === "security" || ["Login", "Logout"].includes(log.action);
                                            if (logFilter === "education") return educationActions.includes(log.action) || educationEntities.includes(log.entityType);
                                            if (logFilter === "system") return !educationActions.includes(log.action) && !educationEntities.includes(log.entityType) && log._type !== "security";
                                            return true;
                                        });

                                        if (filteredLogs.length === 0) {
                                            return <div className="text-center py-10 text-[#A0AEC0] text-sm">Bu filtreye uygun kayıt bulunamadı.</div>;
                                        }

                                        return filteredLogs.map((log, i) => {
                                        const isSystem = log._type === 'system';
                                        
                                        // Format Date & Time
                                        const dateObj = new Date(log.createdAt);
                                        const dateStr = dateObj.toLocaleDateString("tr-TR", { day: 'numeric', month: 'short' });
                                        const timeStr = dateObj.toLocaleTimeString("tr-TR", { hour: '2-digit', minute: '2-digit' });
                                        
                                        // Show date header only if it's the first item or day changed
                                        const prevDateObj = i > 0 ? new Date(userLogs[i-1].createdAt) : null;
                                        const prevDateStr = prevDateObj ? prevDateObj.toLocaleDateString("tr-TR", { day: 'numeric', month: 'short' }) : null;
                                        const showDate = dateStr !== prevDateStr;

                                        return (
                                            <div key={log.id} className="relative mb-6">
                                                {showDate && (
                                                    <div className="flex items-center mb-4">
                                                        <div className="w-[60px] md:w-[88px]" />
                                                        <span className="px-3 py-1 bg-white border border-[#E2E8F0] text-[10px] font-bold text-[#A0AEC0] uppercase tracking-widest rounded-full shadow-sm relative z-10 -ml-3">
                                                            {dateStr}
                                                        </span>
                                                    </div>
                                                )}
                                                
                                                <div className="flex items-start gap-4 md:gap-6 group">
                                                    {/* Time */}
                                                    <div className="w-[44px] md:w-[64px] shrink-0 text-right pt-1">
                                                        <span className="text-[11px] font-bold text-[#A0AEC0] font-mono">{timeStr}</span>
                                                    </div>
                                                    
                                                    {/* Node/Dot */}
                                                    <div className="relative shrink-0 flex items-center justify-center w-6 h-6 rounded-full bg-white border-2 border-[#E2E8F0] group-hover:border-[#0A1931] transition-colors z-10 mt-0.5">
                                                        {isSystem ? <Activity size={10} className="text-[#A0AEC0]" /> : <Lock size={10} className="text-[#A0AEC0]" />}
                                                    </div>

                                                    {/* Content Card */}
                                                    <div className="flex-1 bg-white border border-[#E2E8F0] rounded-xl p-4 shadow-sm group-hover:shadow-md transition-shadow">
                                                        {isSystem ? (
                                                            // SYSTEM AUDIT LOG UI
                                                            <div>
                                                                {(() => {
                                                                    if (log.action === "WatchSession") {
                                                                        return (
                                                                            <>
                                                                                <div className="flex items-center gap-2 mb-2.5">
                                                                                    <span className={`inline-flex items-center gap-1.5 text-[11px] font-bold px-2.5 py-1 rounded-lg bg-indigo-50 border border-indigo-100 text-indigo-700 shadow-sm`}>
                                                                                        <Monitor size={12} />
                                                                                        Video İzleme Oturumu
                                                                                    </span>
                                                                                </div>
                                                                                <p className="text-sm font-bold text-[#0A1931] mb-1.5">🎬 {log.entityName === "VideoProgress" ? "Eğitim Videosu" : (log.entityName || "Video")} izlendi</p>
                                                                                <p className="text-xs text-[#A0AEC0] mt-1.5">
                                                                                    Yaklaşık {Math.round((new Date(log.sessionEndTime).getTime() - new Date(log.sessionStartTime).getTime()) / 60000)} dk kesintisiz izleme ({log.groupedCount} hareket)
                                                                                </p>
                                                                                <div className="mt-3">
                                                                                    {(() => {
                                                                                        let totalWatchedStr = "-";
                                                                                        try {
                                                                                            const parsed = JSON.parse(log.details);
                                                                                            const watchedSecVal = parsed?.changes?.WatchedSeconds?.new;
                                                                                            if (watchedSecVal !== undefined) totalWatchedStr = formatAuditValue("WatchedSeconds", watchedSecVal);
                                                                                        } catch(e) {}
                                                                                        
                                                                                        return (
                                                                                            <div className="bg-slate-50 px-4 py-2.5 rounded-xl border border-slate-100/50 flex items-center justify-between">
                                                                                                <span className="text-[10px] font-bold text-slate-400 uppercase tracking-tight">Kümülatif İzleme Süresi</span>
                                                                                                <span className="text-xs font-bold text-slate-700 font-mono">{totalWatchedStr}</span>
                                                                                            </div>
                                                                                        );
                                                                                    })()}
                                                                                </div>
                                                                            </>
                                                                        );
                                                                    }
                                                                    const aMeta = actionMeta[log.action] || defaultAction;
                                                                    const eMeta = entityMeta[log.entityType] || { labelTR: log.entityType, icon: FileText };
                                                                    const AIcon = aMeta.icon;
                                                                    return (
                                                                        <>
                                                                            <div className="flex items-center gap-2 mb-2.5">
                                                                                <span className={`inline-flex items-center gap-1.5 text-[11px] font-bold px-2.5 py-1 rounded-lg ${aMeta.bg} ${aMeta.text} shadow-sm`}>
                                                                                    <AIcon size={12} />
                                                                                    {formatEntityLabel(log.entityType)} {formatActionLabel(log.action)}
                                                                                </span>
                                                                            </div>
                                                                            {log.entityName && <p className="text-sm font-bold text-[#0A1931] mb-1.5">{log.entityName}</p>}
                                                                            {log.details && (
                                                                                <RenderLogDetails details={log.details} />
                                                                            )}
                                                                            <div className="mt-3 pt-3 border-t border-slate-100 flex items-center justify-between">
                                                                                <p className="text-[10px] text-[#A0AEC0] font-mono flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded-md">
                                                                                    <Globe size={10}/> IP: {log.ipAddress || "Bilinmiyor"}
                                                                                </p>
                                                                            </div>
                                                                        </>
                                                                    );
                                                                })()}
                                                            </div>
                                                        ) : (
                                                            // SECURITY EVENT LOG UI
                                                            <div>
                                                                <div className="flex items-center gap-2 mb-2">
                                                                    {log.eventType === "LOGIN_SUCCESS" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-emerald-50 text-emerald-600 text-[10px] font-bold rounded-lg border border-emerald-100"><Shield size={10} /> Başarılı Giriş</span>}
                                                                    {log.eventType === "SESSION_KICKED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-red-50 text-red-600 text-[10px] font-bold rounded-lg border border-red-100"><AlertTriangle size={10} /> Çoklu Giriş Engellendi</span>}
                                                                    {log.eventType === "LOGIN_FAILED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-orange-50 text-orange-600 text-[10px] font-bold rounded-lg border border-orange-100"><X size={10} /> Hatalı Şifre Denemesi</span>}
                                                                    {log.eventType === "BRUTE_FORCE_DETECTED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-red-100 text-red-700 text-[10px] font-bold rounded-lg border border-red-200"><Shield size={10} /> Şüpheli (Brute Force)</span>}
                                                                    {log.eventType === "DEVTOOLS_DETECTED" && <span className="inline-flex items-center gap-1 px-2 py-0.5 bg-rose-50 text-rose-600 text-[10px] font-bold rounded-lg border border-rose-100"><Shield size={10} /> DevTools (F12) Açma Girişimi</span>}
                                                                </div>
                                                                {(() => {
                                                                    if (!log.details) return null;
                                                                    
                                                                    try {
                                                                        const parsed = JSON.parse(log.details);
                                                                        
                                                                        if (log.eventType === "SESSION_KICKED" && parsed.kickedIp) {
                                                                            return (
                                                                                <div className="flex flex-col gap-2 mb-3 mt-1">
                                                                                    <div className="flex items-center gap-2 p-2 bg-red-50 border border-red-100 rounded-lg">
                                                                                        <div className="w-6 h-6 rounded-md bg-red-100 flex items-center justify-center shrink-0">
                                                                                            <span className="text-[10px]">❌</span>
                                                                                        </div>
                                                                                        <div className="flex-1 min-w-0">
                                                                                            <p className="text-[10px] font-bold text-red-800">ATILAN ESKİ CİHAZ</p>
                                                                                            <p className="text-xs text-red-600 truncate">{parsed.kickedDeviceInfo?.split('|')[0] || "Bilinmeyen Cihaz"} <span className="font-mono text-[10px] opacity-70">({parsed.kickedIp})</span></p>
                                                                                        </div>
                                                                                    </div>
                                                                                    
                                                                                    <div className="flex items-center gap-2 p-2 bg-amber-50 border border-amber-100 rounded-lg">
                                                                                        <div className="w-6 h-6 rounded-md bg-amber-100 flex items-center justify-center shrink-0">
                                                                                            <span className="text-[10px]">⚠️</span>
                                                                                        </div>
                                                                                        <div className="flex-1 min-w-0">
                                                                                            <p className="text-[10px] font-bold text-amber-800">YENİ GİREN CİHAZ (Şu Anki)</p>
                                                                                            <p className="text-xs text-amber-600 truncate">{log.userAgent ? parseUserAgent(log.userAgent).os : "Bilinmiyor"} <span className="font-mono text-[10px] opacity-70">({parsed.newIp || log.ipAddress})</span></p>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            );
                                                                        }
                                                                        
                                                                        // Eğer JSON ama başka bir event ise, sadece formatlı göster
                                                                        return (
                                                                            <pre className="text-[10px] text-[#0A1931] font-mono mb-3 bg-slate-50 p-2.5 rounded-xl border border-slate-100 overflow-x-auto">
                                                                                {JSON.stringify(parsed, null, 2)}
                                                                            </pre>
                                                                        );
                                                                    } catch (e) {
                                                                        // Normal metin
                                                                        return <p className="text-xs text-[#0A1931] font-medium mb-3 bg-slate-50 p-2.5 rounded-xl border border-slate-100">{log.details}</p>;
                                                                    }
                                                                })()}
                                                                {log.userAgent && (
                                                                    <div className="flex items-center gap-3 text-xs text-[#1B3B6F] font-medium bg-[#F8FAFC] p-2 rounded-lg border border-[#E2E8F0]">
                                                                        {parseUserAgent(log.userAgent).device === "Mobile" ? <Smartphone size={14} /> : <Monitor size={14} />}
                                                                        <span>{parseUserAgent(log.userAgent).os}</span>
                                                                        <span className="w-1 h-1 rounded-full bg-[#E2E8F0]" />
                                                                        <span className="text-[#A0AEC0]">{parseUserAgent(log.userAgent).browser}</span>
                                                                    </div>
                                                                )}
                                                                <p className="text-[10px] text-[#A0AEC0] mt-2 font-mono flex items-center gap-1">
                                                                    <Globe size={10}/> IP: {log.ipAddress || "Bilinmiyor"}
                                                                    <IpLocation ip={log.ipAddress} />
                                                                </p>
                                                            </div>
                                                        )}
                                                    </div>
                                                </div>
                                            </div>
                                        );
                                    })})()}
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}
