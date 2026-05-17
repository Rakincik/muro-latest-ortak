"use client";
import { useState, useMemo, useRef, useEffect } from "react";
import {
    Users, UserPlus, UserCheck, Search, Download, Upload, Trash2, Edit3,
    ChevronLeft, ChevronRight, X, Check, Shield, ArrowUpDown, ArrowUp, ArrowDown,
    GraduationCap, Briefcase, Mail, Phone, Calendar as CalendarIcon,
    BookOpen, ClipboardList, Activity, ToggleLeft, ToggleRight,
    KeyRound, Clock, TrendingUp, Award, BarChart3, ChevronUp, ChevronDown, Lock, RefreshCw, Copy,
    ArrowLeft, Flame, Target, CreditCard, Eye, Zap, MessageCircle, AlertTriangle, ExternalLink
} from "lucide-react";
import { API_URL } from "@/lib/api/core";
import { KpiGrid } from "@/components/ui/KpiGrid";
import { useToast } from "@/components/toast";
import { ConfirmDialog } from "@/components/confirm-dialog";
import { useAuth } from "@/contexts/AuthContext";
import { userApi, groupsApi, type UserDto, type PagedUsersResult, type CreateUserRequest } from "@/lib/api";

// ── Types ──
interface User {
    id: string; firstName: string; lastName: string; email: string; phone: string;
    role: string;
    studentType: string | null; isActive: boolean;
    createdAt: string; lastLoginAt: string | null; groupNames: string[];
}

const _default = { bg: "bg-[#E2E8F0]/20 border border-[#E2E8F0]", text: "text-[#1B3B6F]", avatar: "bg-[#A0AEC0]", hero: "bg-[#A0AEC0]" };
const rc: Record<string, { bg: string; text: string; avatar: string; hero: string }> = {
    Admin: { bg: "bg-blue-50 border border-blue-200", text: "text-blue-700", avatar: "bg-blue-600", hero: "bg-blue-600" },
    SuperAdmin: { bg: "bg-rose-50 border border-rose-200", text: "text-rose-700", avatar: "bg-rose-600", hero: "bg-rose-600" },
    Instructor: { bg: "bg-purple-50 border border-purple-200", text: "text-purple-700", avatar: "bg-purple-600", hero: "bg-purple-600" },
    Student: { bg: "bg-emerald-50 border border-emerald-200", text: "text-emerald-700", avatar: "bg-emerald-500", hero: "bg-emerald-500" },
    Accountant: { bg: "bg-amber-50 border border-amber-200", text: "text-amber-700", avatar: "bg-amber-500", hero: "bg-amber-500" },
    Assistant: { bg: "bg-indigo-50 border border-indigo-200", text: "text-indigo-700", avatar: "bg-indigo-500", hero: "bg-indigo-500" },
    // Türkçe eski roller (geriye uyum)
    Eğitmen: { bg: "bg-purple-50 border border-purple-200", text: "text-purple-700", avatar: "bg-purple-600", hero: "bg-purple-600" },
    Öğrenci: { bg: "bg-emerald-50 border border-emerald-200", text: "text-emerald-700", avatar: "bg-emerald-500", hero: "bg-emerald-500" },
    Muhasebe: { bg: "bg-amber-50 border border-amber-200", text: "text-amber-700", avatar: "bg-amber-500", hero: "bg-amber-500" },
    Asistan: { bg: "bg-indigo-50 border border-indigo-200", text: "text-indigo-700", avatar: "bg-indigo-500", hero: "bg-indigo-500" },
};
const roleIcons: Record<string, typeof Shield> = { Admin: Shield, SuperAdmin: Shield, Instructor: Briefcase, Student: GraduationCap, Accountant: Briefcase, Assistant: Briefcase, Eğitmen: Briefcase, Öğrenci: GraduationCap, Muhasebe: Briefcase, Asistan: Briefcase };
const roleLabel: Record<string, string> = { Student: "Öğrenci", Instructor: "Eğitmen", Admin: "Admin", Accountant: "Muhasebe", Assistant: "Asistan", SuperAdmin: "Süper Admin", Öğrenci: "Öğrenci", Eğitmen: "Eğitmen", Muhasebe: "Muhasebe", Asistan: "Asistan" };
// groupOptions artık API'den dinamik olarak çekiliyor
const PER_PAGE_OPTIONS = [10, 50, 100];
type SortField = "name" | "role" | "group" | "status" | "lastLogin"; type SortDir = "asc" | "desc";

function mapApiUser(u: UserDto): User {
    return { ...u, phone: u.phone || "", groupNames: u.groupNames || [] };
}

export default function UsersPage() {
    const { success, error: toastError } = useToast();
    const { token, currentTenantId: tenantId } = useAuth();
    const [users, setUsers] = useState<User[]>([]);
    const [loading, setLoading] = useState(true);
    const [groupOptions, setGroupOptions] = useState<string[]>([]);

    // ── Fetch users from API ──
    const fetchUsers = async () => {
        if (!token || !tenantId) return;
        try {
            setLoading(true);
            const result = await userApi.list(token, tenantId, { pageSize: 200 });
            setUsers(result.items.map(mapApiUser));
        } catch (e) { console.error('Failed to fetch users:', e); }
        finally { setLoading(false); }
    };

    useEffect(() => { fetchUsers(); }, [token, tenantId]);
    useEffect(() => {
        if (!token || !tenantId) return;
        groupsApi.list(token, tenantId, { pageSize: 200 })
            .then(res => setGroupOptions(res.items.map((g: any) => g.name)))
            .catch(() => {});
    }, [token, tenantId]);
    const [search, setSearch] = useState(""); const [roleFilter, setRoleFilter] = useState("all"); const [statusFilter, setStatusFilter] = useState("all");
    const [page, setPage] = useState(1); const [perPage, setPerPage] = useState(10); const [selected, setSelected] = useState<Set<string>>(new Set());
    const [showAddModal, setShowAddModal] = useState(false); const [editUser, setEditUser] = useState<User | null>(null);
    const [detailUser, setDetailUser] = useState<User | null>(null);
    const [deleteTarget, setDeleteTarget] = useState<string | null>(null); const [bulkDeleteOpen, setBulkDeleteOpen] = useState(false);
    const [sortField, setSortField] = useState<SortField>("name"); const [sortDir, setSortDir] = useState<SortDir>("asc");

    const filtered = useMemo(() => {
        let r = users.filter(u => {
            const ms = !search || `${u.firstName} ${u.lastName}`.toLowerCase().includes(search.toLowerCase()) || u.email.toLowerCase().includes(search.toLowerCase()) || (u.phone && u.phone.includes(search));
            const mr = roleFilter === "all" || u.role === roleFilter || roleLabel[u.role] === roleLabel[roleFilter];
            const md = statusFilter === "all" || (statusFilter === "active" && u.isActive) || (statusFilter === "inactive" && !u.isActive) || (statusFilter === "demo" && u.studentType === "Demo");
            return ms && mr && md;
        });
        r.sort((a, b) => { let c = 0; switch (sortField) { case "name": c = `${a.firstName} ${a.lastName}`.localeCompare(`${b.firstName} ${b.lastName}`); break; case "role": c = a.role.localeCompare(b.role); break; case "group": c = (a.groupNames[0] || "zzz").localeCompare(b.groupNames[0] || "zzz"); break; case "status": c = Number(b.isActive) - Number(a.isActive); break; default: c = 0; } return sortDir === "desc" ? -c : c; });
        return r;
    }, [users, search, roleFilter, statusFilter, sortField, sortDir]);

    const totalPages = Math.ceil(filtered.length / perPage);
    const paginated = filtered.slice((page - 1) * perPage, page * perPage);
    const stats = { total: users.length, active: users.filter(u => (u.role === "Student" || u.role === "Öğrenci") && u.studentType !== "Demo" && u.isActive).length, students: users.filter(u => u.role === "Student" || u.role === "Öğrenci").length, demo: users.filter(u => u.studentType === "Demo").length };

    const toggleSort = (f: SortField) => { if (sortField === f) setSortDir(d => d === "asc" ? "desc" : "asc"); else { setSortField(f); setSortDir("asc"); } };
    const SI = ({ f }: { f: SortField }) => sortField !== f ? <ArrowUpDown size={12} className="text-[#A0AEC0] ml-1" /> : sortDir === "asc" ? <ArrowUp size={12} className="text-[#0A1931] ml-1" /> : <ArrowDown size={12} className="text-[#0A1931] ml-1" />;
    const toggleSel = (id: string) => { const n = new Set(selected); n.has(id) ? n.delete(id) : n.add(id); setSelected(n); };
    const selAll = () => { selected.size === paginated.length ? setSelected(new Set()) : setSelected(new Set(paginated.map(u => u.id))); };
    const del = async (id: string) => {
        if (!token || !tenantId) return;
        try { await userApi.delete(token, tenantId, id); setUsers(p => p.filter(u => u.id !== id)); setDeleteTarget(null); success("Kullanıcı Silindi"); }
        catch (e: any) { toastError("Hata", e.message || "Silme başarısız"); setDeleteTarget(null); }
    };
    const bulkDel = async () => {
        if (!token || !tenantId) return;
        try { await userApi.bulkDelete(token, tenantId, Array.from(selected)); setUsers(p => p.filter(u => !selected.has(u.id))); success(`${selected.size} Kullanıcı Silindi`); }
        catch (e: any) { toastError("Hata", e.message || "Toplu silme başarısız"); }
        finally { setSelected(new Set()); setBulkDeleteOpen(false); }
    };
    const ini = (u: User) => `${(u.firstName?.[0] || "")}${(u.lastName?.[0] || "")}`.toUpperCase();
    const toggleActive = async (id: string) => {
        if (!token || !tenantId) return;
        const u = users.find(x => x.id === id); if (!u) return;
        try { await userApi.update(token, tenantId, id, { isActive: !u.isActive }); setUsers(p => p.map(x => x.id === id ? { ...x, isActive: !x.isActive } : x)); success(u.isActive ? "Hesap Pasife Alındı" : "Hesap Aktif Edildi"); if (detailUser?.id === id) setDetailUser(p => p ? { ...p, isActive: !p.isActive } : null); }
        catch (e: any) { toastError("Hata", e.message || "Güncelleme başarısız"); }
    };
    const changeRole = async (id: string, role: string) => {
        if (!token || !tenantId) return;
        try { await userApi.update(token, tenantId, id, { role }); setUsers(p => p.map(u => u.id === id ? { ...u, role } : u)); success("Rol Güncellendi"); if (detailUser?.id === id) setDetailUser(p => p ? { ...p, role } : null); }
        catch (e: any) { toastError("Hata", e.message || "Rol güncellenemedi"); }
    };
    const saveUser = async (d: Partial<User> & { password?: string }) => {
        if (!token || !tenantId) return;
        try {
            // Backend expects "Active" or "Demo", UI uses "Aktif" or "Demo"
            const apiStudentType = d.studentType === "Aktif" ? "Active" : d.studentType;

            if (editUser) {
                await userApi.update(token, tenantId, editUser.id, { 
                    firstName: d.firstName, 
                    lastName: d.lastName, 
                    email: d.email, 
                    role: d.role, 
                    phone: d.phone,
                    studentType: apiStudentType
                });
                setUsers(p => p.map(u => u.id === editUser.id ? { ...u, ...d, studentType: apiStudentType as any } : u)); 
                success("Güncellendi"); 
                setEditUser(null);
            } else {
                const created = await userApi.create(token, tenantId, { 
                    firstName: d.firstName || "", 
                    lastName: d.lastName || "", 
                    email: d.email || "", 
                    password: d.password || "123456", 
                    role: d.role || "Student", 
                    studentType: apiStudentType || undefined, 
                    phone: d.phone 
                });
                setUsers(p => [mapApiUser(created), ...p]); 
                success("Kullanıcı Eklendi"); 
                setShowAddModal(false);
            }
        } catch (e: any) { toastError("Hata", e.message || "İşlem başarısız"); }
    };

    const exportExcel = async () => {
        if (token && tenantId) {
            try {
                // Sadece seçili olanları veya filtredeki herkesi indir
                const idsToExport = selected.size > 0 
                    ? Array.from(selected) 
                    : filtered.map(u => u.id);

                await userApi.exportExcel(token, tenantId, idsToExport);
                success('İndirildi', 'Kullanıcılar Excel olarak indirildi.');
            } catch {
                toastError('Hata', 'İndirme sırasında bir hata oluştu.');
            }
        }
    };

    const downloadTemplate = async () => {
        if (token && tenantId) {
            try {
                await userApi.exportTemplate(token, tenantId);
                success('Şablon İndirildi', 'Öğrenci yükleme şablonu başarıyla indirildi.');
            } catch {
                toastError('Hata', 'Şablon indirme sırasında bir hata oluştu.');
            }
        }
    };

    // ── Bulk Upload ──
    const [bulkModalOpen, setBulkModalOpen] = useState(false);
    const [bulkFile, setBulkFile] = useState<File | null>(null);
    const [bulkLoading, setBulkLoading] = useState(false);
    const [bulkResult, setBulkResult] = useState<{ ok: number; fail: number } | null>(null);

    // ── Quick Password Reset ──
    const [resetPwModalOpen, setResetPwModalOpen] = useState<{id: string, name: string} | null>(null);
    const [manualPw, setManualPw] = useState('');
    const [resetPwLoading, setResetPwLoading] = useState(false);

    const handleQuickReset = (u: any) => {
        setResetPwModalOpen({ id: u.id, name: `${u.firstName} ${u.lastName}` });
        setManualPw('');
    };

    const handleSaveNewPassword = async () => {
        if (!token || !tenantId || !resetPwModalOpen || !manualPw) return;
        setResetPwLoading(true);
        try {
            await userApi.update(token, tenantId, resetPwModalOpen.id, { password: manualPw });
            success("Şifre başarıyla yenilendi");
            if (detailUser?.id === resetPwModalOpen.id) {
                setDetailUser(p => p ? { ...p, password: manualPw } : null);
            }
            setResetPwModalOpen(null);
        } catch {
            toastError("Hata", "Şifre sıfırlanamadı");
        } finally {
            setResetPwLoading(false);
        }
    };

    const handleBulkFile = (file: File) => {
        setBulkFile(file);
        setBulkResult(null);
    };

    const handleBulkUpload = async () => {
        if (!token || !tenantId || !bulkFile) return;
        setBulkLoading(true);
        try {
            const result = await userApi.importExcel(token, tenantId, bulkFile);
            setBulkResult({ ok: result.importedCount, fail: 0 });
            success('Toplu Yükleme Tamamlandı', result.message);
        } catch (e: any) {
            setBulkResult({ ok: 0, fail: 1 });
        } finally { setBulkLoading(false); }
    };

    const passwordResetModalNode = resetPwModalOpen ? (
        <div className="fixed inset-0 z-[110] flex items-center justify-center p-4">
            <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" onClick={() => setResetPwModalOpen(null)} />
            <div className="relative w-full max-w-sm bg-white rounded-3xl shadow-2xl p-7 text-center animate-fade-in">
                <div className="absolute top-5 right-5">
                    <button onClick={() => setResetPwModalOpen(null)} className="p-1.5 rounded-xl hover:bg-[#E2E8F0]/50 text-[#A0AEC0] transition-colors"><X size={18} /></button>
                </div>
                <div className="w-14 h-14 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mx-auto mb-5 ring-4 ring-blue-50/50 shadow-inner">
                    <KeyRound size={24} />
                </div>
                <h3 className="text-xl font-extrabold text-[#0A1931] mb-2 tracking-tight">Şifre Belirle</h3>
                <p className="text-xs text-[#64748B] mb-6">
                    <strong className="text-[#1B3B6F]">{resetPwModalOpen.name}</strong> adlı kullanıcı için yeni şifreyi aşağıya giriniz:
                </p>
                <div className="relative mb-8 text-left">
                    <Lock size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                    <input 
                        type="text" 
                        value={manualPw} 
                        onChange={e => setManualPw(e.target.value)}
                        placeholder="Yeni şifre..."
                        autoFocus
                        className="w-full pl-11 pr-4 py-3.5 text-sm font-bold bg-[#F8FAFC] border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0] transition-all shadow-inner"
                    />
                </div>
                <div className="flex gap-3">
                    <button onClick={() => setResetPwModalOpen(null)} className="flex-1 py-3.5 bg-white border border-[#E2E8F0] text-[#475569] text-xs font-bold rounded-xl hover:bg-[#F8FAFC] transition-colors shadow-sm">
                        İptal
                    </button>
                    <button onClick={handleSaveNewPassword} disabled={!manualPw || resetPwLoading} className="flex-1 py-3.5 bg-[#0A1931] text-white text-xs font-bold rounded-xl hover:bg-[#1B3B6F] transition-all disabled:opacity-50 active:scale-[0.98] shadow-lg shadow-black/10">
                        {resetPwLoading ? 'Kaydediliyor...' : 'Kaydet'}
                    </button>
                </div>
            </div>
        </div>
    ) : null;

    // ── DETAIL VIEW ──
    if (detailUser) {
        const u = detailUser; const c = rc[u.role] || rc['Student']; const RI = roleIcons[u.role] || Shield;
        const phoneClean = u.phone?.replace(/\s/g, '').replace(/^\+?0?/, '+90') || '';
        const lastLoginText = u.lastLoginAt ? new Date(u.lastLoginAt).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric", hour: "2-digit", minute: "2-digit" }) : "Henüz giriş yok";

        return (
            <div className="space-y-5 animate-fade-in max-w-5xl mx-auto">
                {/* Back */}
                <button onClick={() => setDetailUser(null)} className="flex items-center gap-2 text-sm text-[#A9A9A9] hover:text-[#0A1931] transition-colors group">
                    <ArrowLeft size={16} className="group-hover:-translate-x-0.5 transition-transform" /> Kullanıcı Listesine Dön
                </button>

                {/* Hero Header */}
                <div className="relative rounded-[2rem] bg-white p-8 flex items-center gap-8 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-[#E2E8F0] mb-6">
                    {/* Avatar */}
                    <div className={`w-28 h-28 rounded-3xl ${c.hero} flex items-center justify-center text-white text-4xl font-extrabold shadow-xl shadow-${c.hero.split('-')[1]}-500/30 relative overflow-hidden`}>
                        <div className="absolute inset-0 bg-gradient-to-br from-white/30 to-transparent pointer-events-none" />
                        <span className="drop-shadow-md uppercase relative z-10">{ini(u)}</span>
                    </div>

                    <div className="flex-1">
                        {/* Name */}
                        <h1 className="text-3xl font-extrabold text-[#0A1931] tracking-tight capitalize mb-3">
                            {u.firstName.toLowerCase()} {u.lastName.toLowerCase()}
                        </h1>
                        
                        {/* Badges */}
                        <div className="flex items-center gap-2 flex-wrap">
                            <span className="inline-flex items-center gap-1.5 text-[11px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl bg-[#F0F4F8] text-[#1B3B6F]">
                                <RI size={14} className="opacity-70" /> {roleLabel[u.role] || u.role}
                            </span>
                            
                            <span className={`inline-flex items-center gap-1.5 text-[11px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl ${u.isActive ? "bg-emerald-50 text-emerald-600" : "bg-[#F0F4F8] text-[#A0AEC0]"}`}>
                                <span className={`w-1.5 h-1.5 rounded-full ${u.isActive ? "bg-emerald-500" : "bg-[#A0AEC0]"}`} /> {u.isActive ? "AKTİF" : "PASİF"}
                            </span>
                            
                            {u.studentType === "Demo" && (
                                <span className="inline-flex items-center gap-1.5 text-[11px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl bg-amber-50 text-amber-600">
                                    <Target size={14} className="opacity-70"/> DEMO
                                </span>
                            )}
                            
                            {u.groupNames.slice(0, 3).map(g => (
                                <span key={g} className="text-[11px] font-bold px-3 py-1.5 rounded-xl bg-white border border-[#E2E8F0] text-[#475569] shadow-sm">
                                    {g}
                                </span>
                            ))}
                            
                            {u.groupNames.length > 3 && (
                                <span title={u.groupNames.slice(3).join(', ')} className="text-[11px] font-bold px-3 py-1.5 rounded-xl bg-[#F0F4F8] text-[#64748B] cursor-help">
                                    +{u.groupNames.length - 3} Diğer
                                </span>
                            )}
                        </div>
                    </div>

                    {/* Stats Box */}
                    <div className="flex flex-col items-center justify-center px-8 py-5 rounded-[1.5rem] bg-[#F8FAFC] border border-[#E2E8F0] shadow-sm">
                        <p className="text-3xl font-black text-[#0A1931]">{u.groupNames.length}</p>
                        <p className="text-[10px] font-extrabold text-[#64748B] mt-1 uppercase tracking-widest">Grup</p>
                    </div>
                </div>

                {/* ── Hızlı Aksiyon Barı (Control Bar) ── */}
                <div className="bg-white/90 backdrop-blur-xl rounded-2xl border border-[#E2E8F0] p-2 flex items-center shadow-sm flex-wrap gap-2">
                    <div className="flex items-center gap-1 px-2 border-r border-[#E2E8F0]">
                        {u.phone && (
                            <a href={`tel:${u.phone.replace(/\s/g, '')}`} className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#0A1931] text-white text-xs font-bold hover:bg-[#1B3B6F] transition-all active:scale-[0.97] shadow-md shadow-[#0A1931]/20">
                                <Phone size={14} /> Ara
                            </a>
                        )}
                        {u.phone && (
                            <a href={`https://wa.me/${phoneClean}`} target="_blank" rel="noopener noreferrer" className="flex items-center gap-2 px-4 py-2.5 rounded-xl bg-[#25D366] text-white text-xs font-bold hover:bg-[#1DA851] transition-all active:scale-[0.97] shadow-md shadow-[#25D366]/20">
                                <MessageCircle size={14} /> WhatsApp
                            </a>
                        )}
                        <a href={`mailto:${u.email}`} className="flex items-center gap-2 px-4 py-2.5 rounded-xl text-[#1B3B6F] text-xs font-bold hover:bg-[#E2E8F0]/50 transition-all active:scale-[0.97]">
                            <Mail size={14} /> E-posta
                        </a>
                    </div>
                    
                    <div className="flex items-center gap-1 px-2 md:border-r border-[#E2E8F0]">
                        <button onClick={() => handleQuickReset(u)} className="flex items-center gap-2 px-4 py-2.5 rounded-xl text-[#1B3B6F] text-xs font-bold hover:bg-[#E2E8F0]/50 transition-all active:scale-[0.97]">
                            <KeyRound size={14} /> Şifre Sıfırla
                        </button>
                        <button onClick={() => toggleActive(u.id)} className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-xs font-bold transition-all active:scale-[0.97] ${u.isActive ? "text-orange-600 hover:bg-orange-50" : "text-emerald-600 hover:bg-emerald-50"}`}>
                            {u.isActive ? <><ToggleRight size={14} /> Pasife Al</> : <><ToggleLeft size={14} /> Aktif Et</>}
                        </button>
                    </div>

                    <div className="flex items-center gap-2 px-4 py-2 hover:bg-[#E2E8F0]/50 rounded-xl transition-colors cursor-pointer mx-1">
                        <Shield size={14} className="text-[#A0AEC0]" />
                        <select value={u.role} onChange={e => changeRole(u.id, e.target.value)} className="text-xs font-bold text-[#1B3B6F] bg-transparent border-none outline-none cursor-pointer">
                            <option value="Student">Öğrenci</option><option value="Instructor">Eğitmen</option><option value="Admin">Admin</option><option value="Accountant">Muhasebe</option><option value="Assistant">Asistan</option>
                        </select>
                    </div>
                    
                    <div className="flex-1" />
                    
                    <button onClick={() => setDeleteTarget(u.id)} className="flex items-center gap-2 px-5 py-2.5 rounded-xl text-red-600 text-xs font-bold hover:bg-red-50 hover:shadow-sm transition-all active:scale-[0.97] mr-1">
                        <Trash2 size={14} /> Sil
                    </button>
                </div>

                {/* ── İletişim Bilgileri ── */}
                <div className="bg-white rounded-3xl border border-[#E2E8F0]/60 p-6 shadow-sm">
                    <h3 className="text-[11px] font-extrabold text-[#A0AEC0] uppercase tracking-widest mb-5">İletişim Bilgileri</h3>
                    <div className="space-y-1">
                        {[
                            { icon: Mail, label: "E-posta", value: u.email, bg: "bg-blue-50 text-blue-600" },
                            { icon: Phone, label: "Telefon", value: u.phone || "—", bg: "bg-emerald-50 text-emerald-600" },
                            { icon: KeyRound, label: "Şifre", value: u.password || "Gizli (Lütfen sıfırlayın)", bg: "bg-amber-50 text-amber-600", action: u.password ? () => { navigator.clipboard.writeText(u.password!); success("Şifre kopyalandı"); } : undefined },
                            { icon: CalendarIcon, label: "Kayıt Tarihi", value: new Date(u.createdAt).toLocaleDateString("tr-TR", { day: "numeric", month: "long", year: "numeric" }), bg: "bg-purple-50 text-purple-600" },
                            { icon: Clock, label: "Son Giriş", value: lastLoginText, bg: "bg-[#F0F4F8] text-[#A0AEC0]" },
                        ].map((r, idx) => (
                            <div key={idx} className="flex items-center gap-4 group/item p-3 hover:bg-[#F8FAFC] rounded-2xl transition-colors">
                                <div className={`w-10 h-10 rounded-xl ${r.bg} flex items-center justify-center shrink-0`}><r.icon size={18} /></div>
                                <div className="flex-1 min-w-0">
                                    <p className="text-[10px] text-[#A0AEC0] uppercase tracking-widest font-bold mb-0.5">{r.label}</p>
                                    <p className="text-[15px] font-bold text-[#0A1931] truncate">{r.value}</p>
                                </div>
                                {r.action && (
                                    <button onClick={r.action} title="Kopyala" className="p-2.5 rounded-xl opacity-0 group-hover/item:opacity-100 bg-white shadow-sm border border-[#E2E8F0] hover:bg-[#F0F4F8] text-[#1B3B6F] transition-all">
                                        <Copy size={16} />
                                    </button>
                                )}
                            </div>
                        ))}
                    </div>
                </div>

                {/* ── Dahil Olduğu Gruplar ── */}
                {u.groupNames.length > 0 && (
                    <div className="bg-white rounded-3xl border border-[#E2E8F0]/60 p-6 shadow-sm">
                        <h3 className="text-[11px] font-extrabold text-[#A0AEC0] uppercase tracking-widest mb-5 flex items-center gap-2">
                            <Users size={16} className="text-[#A0AEC0]" /> Dahil Olduğu Gruplar
                            <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-[#E2E8F0]/50 text-[#1B3B6F] ml-1">{u.groupNames.length}</span>
                        </h3>
                        <div className="flex flex-wrap gap-2.5">
                            {u.groupNames.map((g, i) => {
                                const colors = [
                                    "bg-blue-50 text-blue-700 ring-blue-200",
                                    "bg-violet-50 text-violet-700 ring-violet-200",
                                    "bg-emerald-50 text-emerald-700 ring-emerald-200",
                                    "bg-amber-50 text-amber-700 ring-amber-200",
                                    "bg-rose-50 text-rose-700 ring-rose-200",
                                ];
                                return (
                                    <span key={g} className={`inline-flex items-center gap-2 text-xs font-bold px-4 py-2 rounded-xl ring-1 ring-inset ${colors[i % colors.length]}`}>
                                        <span className="w-1.5 h-1.5 rounded-full bg-current opacity-60" />
                                        {g}
                                    </span>
                                );
                            })}
                        </div>
                    </div>
                )}

                {/* Detail view delete confirm */}
                <ConfirmDialog
                    open={deleteTarget === u.id}
                    onClose={() => setDeleteTarget(null)}
                    onConfirm={async () => {
                        await del(u.id);
                        setDetailUser(null);
                    }}
                    title="Kullanıcıyı Sil"
                    message={`"${u.firstName} ${u.lastName}" kullanıcısını silmek istediğinize emin misiniz?\n\nBu işlem geri alınamaz!`}
                />
                {passwordResetModalNode}
            </div>
        );
    }


    // ── LIST VIEW ──
    return (
        <div className="space-y-6 pb-24 lg:pb-0">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-2xl sm:text-3xl font-bold text-[#0A1931] tracking-tight flex items-center gap-3">Kullanıcılar</h1>
                    <p className="text-xs sm:text-sm font-semibold uppercase tracking-widest text-[#A9A9A9] mt-1 opacity-60">Kullanıcı ve Rol Yönetimi</p>
                </div>
                <div className="flex flex-wrap items-center gap-2 sm:gap-3">
                    <button className="flex-1 sm:flex-none px-4 py-2.5 text-xs sm:text-sm font-bold bg-white text-[#1B3B6F] border border-[#E2E8F0] rounded-xl hover:bg-[#E2E8F0]/20 transition-all flex items-center justify-center gap-2 shadow-sm" onClick={downloadTemplate}><Download size={16} className="shrink-0" /> <span className="hidden sm:inline">Şablon</span></button>
                    <button onClick={exportExcel} className="flex-1 sm:flex-none px-4 py-2.5 text-xs sm:text-sm font-bold bg-white text-emerald-600 border border-emerald-200 rounded-xl hover:bg-emerald-50 transition-all flex items-center justify-center gap-2 shadow-sm" title="Excel olarak indir">
                        <Download size={16} className="shrink-0" /> <span className="hidden sm:inline">İndir</span>
                    </button>
                    <button onClick={() => { setBulkModalOpen(true); setBulkFile(null); setBulkResult(null); }} className="flex-1 sm:flex-none px-4 py-2.5 text-xs sm:text-sm font-bold bg-white text-[#1B3B6F] border border-[#E2E8F0] rounded-xl hover:bg-[#E2E8F0]/20 transition-all flex items-center justify-center gap-2 shadow-sm"><Upload size={16} className="shrink-0" /> <span className="hidden sm:inline">Toplu Ekle</span></button>
                    <button onClick={() => { setEditUser(null); setShowAddModal(true); }} className="w-full sm:w-auto px-6 py-3 text-sm sm:text-base font-bold bg-[#0A1931] text-white rounded-xl hover:bg-[#1B3B6F] transition-all flex items-center justify-center gap-2 shadow-xl shadow-[#0A1931]/20"><UserPlus size={20} className="shrink-0" /> Yeni Kullanıcı</button>
                </div>
            </div>
            <KpiGrid 
                items={[
                    { label: "Toplam Kullanıcı", value: stats.total, icon: Users, colorClass: "text-indigo-600", bgClass: "bg-indigo-50" },
                    { label: "Aktif Öğrenci", value: stats.active, icon: UserCheck, colorClass: "text-emerald-600", bgClass: "bg-emerald-50" },
                    { label: "Öğrenci", value: stats.students, icon: GraduationCap, colorClass: "text-blue-600", bgClass: "bg-blue-50" },
                    { label: "Demo", value: stats.demo, icon: CalendarIcon, colorClass: "text-amber-600", bgClass: "bg-amber-50" }
                ]}
            />
            <div className="bg-white rounded-2xl border border-[#E2E8F0]/60 p-4 flex flex-col lg:flex-row lg:items-center gap-3 sm:gap-4">
                <div className="w-full lg:flex-1 relative">
                    <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                    <input type="text" placeholder="İsim, e-posta veya telefon ile ara..." value={search} onChange={e => { setSearch(e.target.value); setPage(1); }} className="w-full pl-9 pr-4 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0] transition-all" />
                </div>
                <div className="grid grid-cols-2 gap-3 w-full lg:w-auto lg:flex">
                    <select value={roleFilter} onChange={e => { setRoleFilter(e.target.value); setPage(1); }} className="w-full lg:w-auto px-4 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0] transition-all">
                        <option value="all">Tüm Roller</option>
                        <option value="Admin">Admin</option>
                        <option value="Eğitmen">Eğitmen</option>
                        <option value="Öğrenci">Öğrenci</option>
                        <option value="Muhasebe">Muhasebe</option>
                        <option value="Asistan">Asistan</option>
                    </select>
                    <select value={statusFilter} onChange={e => { setStatusFilter(e.target.value); setPage(1); }} className="w-full lg:w-auto px-4 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0] transition-all">
                        <option value="all">Tüm Durum</option>
                        <option value="active">Aktif</option>
                        <option value="inactive">Pasif</option>
                        <option value="demo">Demo</option>
                    </select>
                </div>
                {selected.size > 0 && <button onClick={() => setBulkDeleteOpen(true)} className="w-full lg:w-auto px-4 py-2.5 text-sm font-medium bg-red-50 text-red-600 rounded-xl hover:bg-red-100 flex items-center justify-center gap-2"><Trash2 size={16} /> {selected.size} Seçiliyi Sil</button>}
            </div>
            <div className="bg-white rounded-xl border border-[#E2E8F0]/60 overflow-hidden">
                {/* ── DESKTOP TABLE ── */}
                <div className="hidden lg:block overflow-x-auto">
                    <table className="w-full min-w-[900px]"><thead><tr className="border-b border-[#A0AEC0]/40 bg-[#E2E8F0]/50">
                        <th className="w-10 px-4 py-4"><input type="checkbox" checked={selected.size === paginated.length && paginated.length > 0} onChange={selAll} className="w-4 h-4 rounded border-[#A0AEC0] text-[#1B3B6F]" /></th>
                        <th className="text-left px-4 py-4"><button onClick={() => toggleSort("name")} className="flex items-center text-sm font-extrabold text-[#0A1931] uppercase tracking-widest hover:text-[#1B3B6F]">Kullanıcı<SI f="name" /></button></th>
                        <th className="text-left px-4 py-4"><button onClick={() => toggleSort("role")} className="flex items-center text-sm font-extrabold text-[#0A1931] uppercase tracking-widest hover:text-[#1B3B6F]">Rol<SI f="role" /></button></th>
                        <th className="text-left px-4 py-4"><button onClick={() => toggleSort("group")} className="flex items-center text-sm font-extrabold text-[#0A1931] uppercase tracking-widest hover:text-[#1B3B6F]">Grup<SI f="group" /></button></th>
                        <th className="text-left px-4 py-4"><button onClick={() => toggleSort("status")} className="flex items-center text-sm font-extrabold text-[#0A1931] uppercase tracking-widest hover:text-[#1B3B6F]">Durum<SI f="status" /></button></th>
                        <th className="text-left px-4 py-4 text-sm font-extrabold text-[#0A1931] uppercase tracking-widest">Telefon</th>
                        <th className="text-left px-4 py-4 text-sm font-extrabold text-[#0A1931] uppercase tracking-widest">Kayıt Tarihi</th>
                        <th className="text-left px-4 py-4 text-sm font-extrabold text-[#0A1931] uppercase tracking-widest">Son Giriş</th>
                        <th className="w-36 text-center text-sm font-extrabold text-[#0A1931] uppercase tracking-widest px-4 py-4">Hızlı İşlemler</th>
                    </tr></thead><tbody>
                            {paginated.map((u, idx) => {
                                const c = rc[u.role] || _default;
                                const rowBg = selected.has(u.id) ? "bg-[#E2E8F0]/20" : idx % 2 === 0 ? "bg-white" : "bg-[#F0F4F8]";
                                return (
                                    <tr key={u.id} onClick={() => setDetailUser(u)} className={`border-b border-[#E2E8F0]/40 hover:bg-[#DCE5EF] transition-colors cursor-pointer ${rowBg}`}>
                                        <td className="px-4 py-3" onClick={e => e.stopPropagation()}><input type="checkbox" checked={selected.has(u.id)} onChange={() => toggleSel(u.id)} className="w-4 h-4 rounded border-[#A0AEC0] text-[#0A1931]" /></td>
                                        <td className="px-4 py-3"><div className="flex items-center gap-3"><div className={`w-10 h-10 rounded-xl ${c.avatar} flex items-center justify-center text-white text-[10px] font-bold shadow-sm border border-white/10`}>{ini(u)}</div><div><p className="text-sm font-bold text-[#0A1931] tracking-tight">{u.firstName} {u.lastName}</p><p className="text-[11px] text-[#A0AEC0] font-medium">{u.email}</p></div></div></td>
                                        <td className="px-4 py-3"><span className={`inline-flex items-center gap-1 text-[10px] font-bold uppercase tracking-widest px-2.5 py-1 rounded-lg ${c.bg} ${c.text}`}>{roleLabel[u.role] || u.role}</span></td>
                                        <td className="px-4 py-3">{u.groupNames.length > 0 ? <div className="relative group/grp inline-flex"><span className="inline-flex items-center gap-1.5 text-[11px] font-bold px-3 py-1 rounded-lg bg-[#1B3B6F]/10 text-[#1B3B6F] border border-[#1B3B6F]/20 cursor-default"><Users size={12} className="text-[#A0AEC0]" />{u.groupNames.length}</span><div className="absolute left-0 top-full mt-1 z-50 hidden group-hover/grp:block"><div className="bg-[#0A1931] text-white rounded-xl shadow-2xl p-3 min-w-[160px] border border-[#1B3B6F]/30"><p className="text-[10px] font-bold uppercase tracking-wider text-[#A0AEC0] mb-2">Gruplar</p><div className="space-y-1">{u.groupNames.map(g => <div key={g} className="text-[11px] font-medium px-2 py-1 rounded-lg bg-white/10">{g}</div>)}</div></div></div></div> : <span className="text-[11px] text-[#A0AEC0]">—</span>}</td>
                                        <td className="px-4 py-3"><span className={`inline-flex items-center gap-1.5 text-[11px] font-bold ${u.isActive ? "text-emerald-600" : "text-[#A0AEC0]"}`}><span className={`w-1.5 h-1.5 rounded-full ${u.isActive ? "bg-emerald-500" : "bg-[#A0AEC0]"}`} />{u.isActive ? "AKTİF" : "PASİF"}{u.studentType === "Demo" && <span className="text-[10px] px-1.5 py-0.5 rounded-lg bg-amber-50 text-amber-600 font-bold ml-2">DEMO</span>}</span></td>
                                        <td className="px-4 py-3" onClick={e => e.stopPropagation()}>{u.phone ? <div className="flex items-center gap-2"><a href={`tel:${u.phone.replace(/\s/g, '')}`} className="text-[11px] font-medium text-[#1B3B6F] hover:text-[#0A1931] flex items-center gap-1.5 transition-colors"><Phone size={12} className="text-[#A0AEC0]" />{u.phone}</a><a href={`https://wa.me/${u.phone.replace(/\s/g, '').replace(/^\+?0?/, '+90')}`} target="_blank" rel="noopener noreferrer" title="WhatsApp" className="p-1.5 rounded-lg bg-[#25D366]/10 hover:bg-[#25D366]/20 transition-all hover:scale-110"><svg viewBox="0 0 24 24" width="14" height="14" fill="#25D366"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" /></svg></a></div> : <span className="text-[11px] text-[#A0AEC0]">—</span>}</td>
                                        <td className="px-4 py-3"><span className="text-[11px] font-medium text-[#1B3B6F] flex items-center gap-1.5"><CalendarIcon size={12} className="text-[#A0AEC0]" />{new Date(u.createdAt).toLocaleDateString("tr-TR")}</span></td>
                                        <td className="px-4 py-3"><span className="text-[11px] font-medium text-[#A0AEC0] flex items-center gap-1.5"><Clock size={12} />{u.lastLoginAt ? new Date(u.lastLoginAt).toLocaleDateString("tr-TR") : "—"}</span></td>
                                        <td className="px-4 py-3" onClick={e => e.stopPropagation()}>
                                            <div className="flex items-center justify-center gap-2">
                                                <button onClick={() => setDetailUser(u)} title="Detay" className="p-2 rounded-lg hover:bg-[#E2E8F0]/30 text-[#A0AEC0] hover:text-[#1B3B6F]"><Eye size={18} /></button>
                                                <button onClick={() => { setEditUser(u); setShowAddModal(true); }} title="Düzenle" className="p-2 rounded-lg hover:bg-amber-50 text-[#A0AEC0] hover:text-amber-600"><Edit3 size={18} /></button>
                                                <button onClick={() => toggleActive(u.id)} title={u.isActive ? "Pasife Al" : "Aktif Et"} className={`p-2 rounded-lg ${u.isActive ? "hover:bg-orange-50 text-[#A0AEC0] hover:text-orange-500" : "hover:bg-emerald-50 text-[#A0AEC0] hover:text-emerald-500"}`}>{u.isActive ? <ToggleRight size={18} /> : <ToggleLeft size={18} />}</button>
                                                <button onClick={() => setDeleteTarget(u.id)} title="Sil" className="p-2 rounded-lg hover:bg-red-50 text-[#A0AEC0] hover:text-red-600"><Trash2 size={18} /></button>
                                            </div>
                                        </td>
                                    </tr>
                                );
                            })}
                        </tbody></table>
                </div>

                {/* ── PREMIUM MOBILE CARDS VIEW ── */}
                <div className="lg:hidden flex flex-col gap-4">
                    <div className="px-5 py-4 bg-white rounded-2xl border border-[#E2E8F0]/60 shadow-sm flex items-center justify-between">
                        <label className="flex items-center gap-3 cursor-pointer">
                            <input type="checkbox" checked={selected.size === paginated.length && paginated.length > 0} onChange={selAll} className="w-5 h-5 rounded border-[#A0AEC0] text-[#1B3B6F] focus:ring-[#1B3B6F]" />
                            <span className="text-sm font-extrabold text-[#0A1931] uppercase tracking-widest">Tümünü Seç ({paginated.length})</span>
                        </label>
                    </div>
                    {paginated.map((u) => {
                        const c = rc[u.role] || _default;
                        const isSelected = selected.has(u.id);
                        return (
                            <div key={u.id} className={`relative p-5 rounded-2xl border transition-all duration-300 shadow-sm ${isSelected ? "bg-blue-50/50 border-blue-300 ring-2 ring-blue-500/20" : "bg-white border-[#E2E8F0]/60 hover:shadow-md"}`}>
                                {/* Checkbox Absolute Top Right */}
                                <div className="absolute top-5 right-5 z-10">
                                    <input type="checkbox" checked={isSelected} onChange={() => toggleSel(u.id)} className="w-5 h-5 rounded border-[#A0AEC0] text-[#0A1931] focus:ring-[#0A1931]" />
                                </div>

                                <div className="flex flex-col gap-4" onClick={() => setDetailUser(u)}>
                                    {/* Header: Avatar + Info */}
                                    <div className="flex items-center gap-4 pr-8">
                                        <div className={`w-14 h-14 rounded-2xl ${c.avatar} flex items-center justify-center text-white text-lg font-bold shadow-lg shrink-0 border-2 border-white`}>
                                            {ini(u)}
                                        </div>
                                        <div className="flex-1 min-w-0">
                                            <p className="text-base font-extrabold text-[#0A1931] tracking-tight truncate">{u.firstName} {u.lastName}</p>
                                            <p className="text-xs text-[#A0AEC0] font-medium truncate mt-0.5">{u.email}</p>
                                        </div>
                                    </div>
                                    
                                    {/* Badges */}
                                    <div className="flex flex-wrap items-center gap-2">
                                        <span className={`inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl ${c.bg} ${c.text} shadow-sm border`}>
                                            {roleLabel[u.role] || u.role}
                                        </span>
                                        <span className={`inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl shadow-sm border ${u.isActive ? "bg-emerald-50 text-emerald-600 border-emerald-200" : "bg-[#F0F4F8] text-[#A0AEC0] border-[#E2E8F0]"}`}>
                                            <span className={`w-1.5 h-1.5 rounded-full ${u.isActive ? "bg-emerald-500" : "bg-[#A0AEC0]"}`} />
                                            {u.isActive ? "AKTİF" : "PASİF"}
                                        </span>
                                        {u.studentType === "Demo" && (
                                            <span className="inline-flex items-center gap-1.5 text-[10px] font-bold uppercase tracking-widest px-3 py-1.5 rounded-xl bg-amber-50 text-amber-600 border border-amber-200 shadow-sm">
                                                DEMO
                                            </span>
                                        )}
                                    </div>
                                    
                                    {/* Contact */}
                                    {u.phone && (
                                        <div className="flex items-center gap-2 bg-[#F8FAFC] p-2.5 rounded-xl border border-[#E2E8F0]/50">
                                            <a href={`tel:${u.phone.replace(/\s/g, '')}`} onClick={e => e.stopPropagation()} className="flex-1 flex items-center justify-center gap-2 text-xs font-bold text-[#1B3B6F] bg-white py-2 rounded-lg shadow-sm border border-[#E2E8F0]">
                                                <Phone size={14} className="text-[#A0AEC0]" /> {u.phone}
                                            </a>
                                            <a href={`https://wa.me/${u.phone.replace(/\s/g, '').replace(/^\+?0?/, '+90')}`} onClick={e => e.stopPropagation()} target="_blank" rel="noopener noreferrer" className="flex items-center justify-center w-10 h-10 rounded-lg bg-[#25D366]/10 text-[#25D366] hover:bg-[#25D366]/20 transition-colors">
                                                <MessageCircle size={18} />
                                            </a>
                                        </div>
                                    )}

                                    {/* Actions */}
                                    <div className="flex items-center justify-between mt-2 pt-4 border-t border-[#E2E8F0]/60" onClick={e => e.stopPropagation()}>
                                        <button onClick={() => setDetailUser(u)} className="flex items-center gap-2 text-xs font-bold text-[#1B3B6F] px-4 py-2.5 rounded-xl hover:bg-[#F0F4F8] transition-colors">
                                            <Eye size={16} /> Profili İncele
                                        </button>
                                        <div className="flex items-center gap-2">
                                            <button onClick={() => { setEditUser(u); setShowAddModal(true); }} className="w-10 h-10 flex items-center justify-center rounded-xl bg-white border border-[#E2E8F0] shadow-sm text-[#A0AEC0] hover:text-amber-600 hover:border-amber-200 transition-colors"><Edit3 size={16} /></button>
                                            <button onClick={() => toggleActive(u.id)} className={`w-10 h-10 flex items-center justify-center rounded-xl border shadow-sm transition-colors ${u.isActive ? "bg-white border-[#E2E8F0] text-[#A0AEC0] hover:text-orange-500 hover:border-orange-200" : "bg-emerald-50 border-emerald-200 text-emerald-600"}`}>{u.isActive ? <ToggleRight size={16} /> : <ToggleLeft size={16} />}</button>
                                            <button onClick={() => setDeleteTarget(u.id)} className="w-10 h-10 flex items-center justify-center rounded-xl bg-white border border-[#E2E8F0] shadow-sm text-[#A0AEC0] hover:text-red-600 hover:border-red-200 transition-colors"><Trash2 size={16} /></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        );
                    })}
                </div>
                <div className="flex items-center justify-between px-6 py-4 border-t border-[#E2E8F0]/60 bg-[#E2E8F0]/15">
                    <div className="flex items-center gap-4">
                        <p className="text-[11px] font-bold text-[#A0AEC0] uppercase tracking-widest">{filtered.length} Kayıt · {filtered.length > 0 ? `${(page - 1) * perPage + 1}–${Math.min(page * perPage, filtered.length)}` : '0'}</p>
                        <div className="flex items-center gap-1.5">
                            <span className="text-[10px] font-bold text-[#A0AEC0] uppercase tracking-wider">Göster:</span>
                            {PER_PAGE_OPTIONS.map(opt => (
                                <button key={opt} onClick={() => { setPerPage(opt); setPage(1); }} className={`px-2.5 py-1 rounded-lg text-[11px] font-bold transition-all ${perPage === opt ? 'bg-[#0A1931] text-white shadow-md' : 'bg-white text-[#A9A9A9] border border-[#E2E8F0] hover:border-[#A0AEC0] hover:text-[#1B3B6F]'}`}>{opt}</button>
                            ))}
                        </div>
                    </div>
                    {totalPages > 1 && <div className="flex items-center gap-1.5"><button onClick={() => setPage(p => Math.max(1, p - 1))} disabled={page === 1} className="p-2 rounded-xl hover:bg-white text-[#A0AEC0] disabled:opacity-30 border border-transparent hover:border-[#E2E8F0] transition-all"><ChevronLeft size={16} /></button>{Array.from({ length: Math.min(totalPages, 7) }, (_, i) => { if (totalPages <= 7) return i + 1; if (page <= 4) return i + 1; if (page >= totalPages - 3) return totalPages - 6 + i; return page - 3 + i; }).map(p => <button key={p} onClick={() => setPage(p)} className={`w-9 h-9 rounded-xl text-xs font-bold transition-all ${p === page ? "bg-[#0A1931] text-white shadow-lg shadow-black/10" : "hover:bg-white text-[#A9A9A9] border border-transparent hover:border-[#E2E8F0]"}`}>{p}</button>)}<button onClick={() => setPage(p => Math.min(totalPages, p + 1))} disabled={page === totalPages} className="p-2 rounded-xl hover:bg-white text-[#A0AEC0] disabled:opacity-30 border border-transparent hover:border-[#E2E8F0] transition-all"><ChevronRight size={16} /></button></div>}
                </div>
                {paginated.length === 0 && <div className="flex flex-col items-center justify-center py-16 text-[#A0AEC0]"><Users size={40} className="mb-3 opacity-30" /><p className="text-sm font-medium">Kullanıcı bulunamadı</p></div>}
            </div>
            {showAddModal && <UserFormModal user={editUser} onClose={() => { setShowAddModal(false); setEditUser(null); }} onSave={saveUser} />}
            <ConfirmDialog open={deleteTarget !== null && !detailUser} onClose={() => setDeleteTarget(null)} onConfirm={() => deleteTarget && del(deleteTarget)} title="Kullanıcıyı Sil" message="Bu kullanıcıyı silmek istediğinize emin misiniz? Bu işlem geri alınamaz!" />
            <ConfirmDialog open={bulkDeleteOpen} onClose={() => setBulkDeleteOpen(false)} onConfirm={bulkDel} title={`${selected.size} Kullanıcı Sil`} message={`Seçili ${selected.size} kullanıcıyı silmek istediğinize emin misiniz? Bu işlem geri alınamaz!`} />
            
            {/* Quick Password Reset Modal */}
            {passwordResetModalNode}

            {bulkModalOpen && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={() => setBulkModalOpen(false)}>
                    <div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
                    <div className="relative w-full max-w-lg bg-white rounded-2xl shadow-xl animate-fade-in" onClick={e => e.stopPropagation()}>
                        <div className="flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]/60">
                            <h2 className="text-lg font-bold text-[#0A1931] flex items-center gap-2"><Upload size={18} /> Toplu Kullanıcı Yükleme</h2>
                            <button onClick={() => setBulkModalOpen(false)} className="p-1.5 rounded-lg hover:bg-[#E2E8F0]/40 text-[#A0AEC0]"><X size={18} /></button>
                        </div>
                        <div className="p-6 space-y-4">
                            <div className="border-2 border-dashed border-[#E2E8F0] rounded-xl p-8 text-center hover:border-[#1B3B6F]/40 transition-colors">
                                <input type="file" accept=".xlsx" className="hidden" id="bulk-file"
                                    onChange={e => { if (e.target.files?.[0]) handleBulkFile(e.target.files[0]); }} />
                                <label htmlFor="bulk-file" className="cursor-pointer">
                                    <Upload size={32} className="mx-auto text-[#A0AEC0] mb-3" />
                                    <p className="text-sm font-medium text-[#0A1931]">{bulkFile?.name ?? 'Excel dosyası (.xlsx) seçin'}</p>
                                    <p className="text-[10px] text-[#A9A9A9] mt-1">Sütunlar: Ad, Soyad, Telefon, Email, Rol</p>
                                    <p className="text-[10px] text-emerald-600 mt-1 font-medium">Şifreler otomatik olarak telefon numarasının son 6 hanesi olarak atanır.</p>
                                </label>
                            </div>

                            {bulkResult && (
                                <div className={`rounded-xl p-4 ${bulkResult.fail === 0 ? 'bg-emerald-50 border border-emerald-200' : 'bg-amber-50 border border-amber-200'}`}>
                                    <p className="text-sm font-bold">{bulkResult.ok > 0 ? `${bulkResult.ok} kullanıcı başarıyla eklendi.` : 'Yükleme başarısız.'}</p>
                                </div>
                            )}
                        </div>
                        <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-[#E2E8F0]/60 bg-[#E2E8F0]/15 rounded-b-2xl">
                            <button onClick={() => setBulkModalOpen(false)} className="px-5 py-2.5 text-sm font-bold text-[#A9A9A9] hover:text-[#0A1931]">İptal</button>
                            <button onClick={handleBulkUpload} disabled={!bulkFile || bulkLoading}
                                className="px-6 py-3 text-sm font-bold text-white bg-[#0A1931] rounded-xl hover:bg-[#1B3B6F] shadow-lg disabled:opacity-40 transition-all">
                                {bulkLoading ? 'Yükleniyor...' : `Yüklemeyi Başlat`}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );

    function GroupDropdown({ groups, selected, onToggle }: { groups: string[]; selected: string[]; onToggle: (g: string) => void }) {
        const [open, setOpen] = useState(false);
        const ref = useRef<HTMLDivElement>(null);
        useEffect(() => {
            const handler = (e: MouseEvent) => { if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false); };
            document.addEventListener("mousedown", handler);
            return () => document.removeEventListener("mousedown", handler);
        }, []);
        return (
            <div ref={ref} className="relative">
                <label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">Gruplar</label>
                <button type="button" onClick={() => setOpen(!open)}
                    className={`w-full flex items-center justify-between px-3 py-2.5 text-sm bg-[#E2E8F0]/20 border rounded-xl transition-all ${open ? 'border-[#A0AEC0] ring-2 ring-[#0A1931]/10' : 'border-[#E2E8F0]'}`}>
                    <span className={selected.length > 0 ? "text-[#0A1931] font-medium" : "text-[#A9A9A9]"}>
                        {selected.length > 0 ? `${selected.length} grup seçili` : "Grup seçin"}
                    </span>
                    <ChevronDown size={16} className={`text-[#A0AEC0] transition-transform ${open ? 'rotate-180' : ''}`} />
                </button>
                {open && (
                    <div className="absolute z-50 left-0 right-0 mt-1.5 bg-white rounded-xl border border-[#E2E8F0] shadow-xl shadow-black/10 py-1 max-h-48 overflow-y-auto animate-fade-in">
                        {groups.map(g => (
                            <button key={g} type="button" onClick={() => onToggle(g)}
                                className="w-full flex items-center gap-3 px-3 py-2.5 text-left hover:bg-[#E2E8F0]/30 transition-colors">
                                <div className={`w-4.5 h-4.5 rounded-md border-2 flex items-center justify-center transition-all shrink-0 ${selected.includes(g) ? 'bg-[#0A1931] border-[#0A1931]' : 'border-[#A0AEC0]'}`}
                                    style={{ width: 18, height: 18 }}>
                                    {selected.includes(g) && <Check size={12} className="text-white" />}
                                </div>
                                <span className={`text-sm ${selected.includes(g) ? 'font-bold text-[#0A1931]' : 'text-[#1B3B6F]'}`}>{g}</span>
                            </button>
                        ))}
                    </div>
                )}
                {selected.length > 0 && (
                    <div className="flex flex-wrap gap-1.5 mt-2">
                        {selected.map(g => (
                            <span key={g} className="inline-flex items-center gap-1 text-[10px] font-bold px-2 py-1 rounded-lg bg-[#0A1931] text-white">
                                {g}
                                <button type="button" onClick={() => onToggle(g)} className="hover:bg-white/20 rounded p-0.5 transition-colors"><X size={10} /></button>
                            </span>
                        ))}
                    </div>
                )}
            </div>
        );
    }

    function UserFormModal({ user, onClose, onSave }: { user: User | null; onClose: () => void; onSave: (d: Partial<User> & { password?: string }) => void }) {
        const [f, sF] = useState({ firstName: user?.firstName || "", lastName: user?.lastName || "", email: user?.email || "", phone: user?.phone || "", role: user?.role || "Student", groupNames: user?.groupNames || [] as string[], studentType: user?.studentType || "Aktif" });
        const u = (k: string, v: string) => sF(p => ({ ...p, [k]: v }));
        const toggleGroup = (g: string) => sF(p => ({ ...p, groupNames: p.groupNames.includes(g) ? p.groupNames.filter(x => x !== g) : [...p.groupNames, g] }));

        const [manualPw, setManualPw] = useState('');
        const currentPassword = manualPw || undefined;

        return (
            <div className="fixed inset-0 z-[100] flex items-center justify-center p-4" onClick={onClose}><div className="absolute inset-0 bg-black/40 backdrop-blur-sm" />
                <div className="relative w-full max-w-lg max-h-[90vh] bg-white rounded-2xl shadow-xl animate-fade-in flex flex-col" onClick={e => e.stopPropagation()}>
                    <div className="flex items-center justify-between px-6 py-4 border-b border-[#E2E8F0]/60 shrink-0"><h2 className="text-lg font-bold text-[#0A1931]">{user ? "Kullanıcı Düzenle" : "Yeni Kullanıcı"}</h2><button onClick={onClose} className="p-1.5 rounded-lg hover:bg-[#E2E8F0]/40 text-[#A0AEC0]"><X size={18} /></button></div>
                    <div className="flex-1 overflow-y-auto p-6 space-y-4">
                        <div className="grid grid-cols-2 gap-4">
                            <div><label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">Ad</label><input type="text" value={f.firstName} onChange={e => u("firstName", e.target.value)} className="w-full px-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0]" placeholder="Ad" /></div>
                            <div><label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">Soyad</label><input type="text" value={f.lastName} onChange={e => u("lastName", e.target.value)} className="w-full px-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0]" placeholder="Soyad" /></div>
                        </div>
                        <div><label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">E-posta</label><div className="relative"><Mail size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" /><input type="email" value={f.email} onChange={e => u("email", e.target.value)} className="w-full pl-9 pr-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0]" placeholder="email@sirket.com" /></div></div>
                        <div><label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">Telefon</label><div className="relative"><Phone size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" /><input type="tel" value={f.phone} onChange={e => u("phone", e.target.value)} className="w-full pl-9 pr-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0]" placeholder="0532 000 0000" /></div></div>

                        {/* Şifre Alanı */}
                        <div className="pt-2 border-t border-[#E2E8F0]/60">
                            <label className="block text-xs font-medium text-[#1B3B6F] mb-2">{user ? "Şifre Sıfırla (Opsiyonel)" : "Şifre"}</label>
                            <div className="relative">
                                <Lock size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                                <input type="text" value={manualPw} onChange={e => setManualPw(e.target.value)}
                                    className="w-full pl-9 pr-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0]"
                                    placeholder="Manuel Şifre Girin..." />
                            </div>
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">Rol</label>
                                <select value={f.role} onChange={e => {
                                    const r = e.target.value;
                                    sF(p => ({ ...p, role: r, groupNames: (r === "Student" || r === "Öğrenci") ? p.groupNames : [] }));
                                }} className="w-full px-3 py-2.5 text-sm bg-[#E2E8F0]/20 border border-[#E2E8F0] rounded-xl focus:outline-none focus:ring-2 focus:ring-[#0A1931]/10 focus:border-[#A0AEC0]">
                                    <option value="Student">Öğrenci</option>
                                    <option value="Instructor">Eğitmen</option>
                                    <option value="Admin">Admin</option>
                                    <option value="Accountant">Muhasebe</option>
                                    <option value="Assistant">Asistan</option>
                                </select>
                            </div>
                            {(f.role === "Student" || f.role === "Öğrenci") ? (
                                <GroupDropdown groups={groupOptions} selected={f.groupNames} onToggle={toggleGroup} />
                            ) : (
                                <div>
                                    <label className="block text-xs font-medium text-[#A0AEC0] mb-1.5">Gruplar</label>
                                    <div className="w-full px-3 py-2.5 text-sm bg-[#E2E8F0]/40 border border-[#E2E8F0] rounded-xl text-[#A0AEC0] cursor-not-allowed">
                                        Bu rol gruba atanamaz
                                    </div>
                                </div>
                            )}
                        </div>
                        {(f.role === "Student" || f.role === "Öğrenci") && <div><label className="block text-xs font-medium text-[#1B3B6F] mb-1.5">Öğrenci Tipi</label><div className="flex gap-3">{(["Aktif", "Demo"] as const).map(t => <button key={t} type="button" onClick={() => u("studentType", t)} className={`flex-1 py-2.5 text-sm font-medium rounded-xl border transition-all ${f.studentType === t || (t === "Aktif" && f.studentType === "Active") ? "bg-[#E2E8F0]/30 border-[#A0AEC0] text-[#0A1931]" : "bg-[#E2E8F0]/20 border-[#E2E8F0] text-[#A9A9A9] hover:bg-[#E2E8F0]/40"}`}>{t}</button>)}</div></div>}
                    </div>
                    <div className="flex items-center justify-end gap-3 px-6 py-4 border-t border-[#E2E8F0]/60 bg-[#E2E8F0]/15 rounded-b-2xl shrink-0">
                        <button onClick={onClose} className="px-5 py-2.5 text-sm font-bold text-[#A9A9A9] hover:text-[#0A1931] transition-colors">İptal</button>
                        <button onClick={() => onSave({ ...f, role: f.role as User["role"], groupNames: f.groupNames, studentType: (f.role === "Student" || f.role === "Öğrenci") ? f.studentType as User["studentType"] : null, ...(currentPassword && { password: currentPassword }) })} className="px-6 py-3 text-sm font-bold text-white bg-[#0A1931] rounded-xl hover:bg-[#1B3B6F] shadow-lg shadow-black/10 transition-all active:scale-[0.98]">{user ? "Güncelle" : "Oluştur"}</button>
                    </div>
                </div>
            </div>
        );
    }
}
