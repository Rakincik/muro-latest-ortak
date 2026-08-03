"use client";

import { useEffect, useState, useMemo } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { courseApi, groupApi, getFileUrl, type CourseDto, type StudentGroupDto } from "@/lib/api";
import Link from "next/link";
import Image from "next/image";
import { useSearchParams, useRouter } from "next/navigation";
import { LayoutGrid, List, Layers, Clock, Activity, CheckCircle2, ArrowUpDown, Search, ChevronRight, Play, ArrowLeft, BookOpen } from "lucide-react";
import { CustomSelect } from "@/components/ui/CustomSelect";

const renderTextWithLinks = (text: string) => {
    if (!text) return null;
    const urlRegex = /(https?:\/\/[^\s]+)/g;
    const parts = text.split(urlRegex);
    return parts.map((part, index) => {
        if (part.match(urlRegex)) {
            return (
                <a
                    key={index}
                    href={part}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-[#1B3B6F] hover:underline font-bold break-all"
                    onClick={(e) => e.stopPropagation()}
                >
                    {part}
                </a>
            );
        }
        return part;
    });
};

export default function CoursesPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [courses, setCourses] = useState<CourseDto[]>([]);
    const [groups, setGroups] = useState<StudentGroupDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [groupsLoading, setGroupsLoading] = useState(true);
    const [search, setSearch] = useState("");
    const [statusFilter, setStatusFilter] = useState<"all" | "completed" | "in_progress" | "not_started">("all");
    const [sortBy, setSortBy] = useState<"date" | "name" | "sessions" | "completion">("date");
    const [currentPage, setCurrentPage] = useState(1);
    const [viewMode, setViewMode] = useState<"grid" | "list">("list");
    const pageSize = 12;

    const searchParams = useSearchParams();
    const router = useRouter();
    const urlGroupId = searchParams.get("groupId");

    useEffect(() => {
        if (!token || !tenantId) return;
        setLoading(true);
        courseApi.list(token, tenantId)
            .then(setCourses)
            .catch(console.error)
            .finally(() => setLoading(false));

        setGroupsLoading(true);
        groupApi.myGroups(token, tenantId)
            .then(setGroups)
            .catch(console.error)
            .finally(() => setGroupsLoading(false));
    }, [token, tenantId]);

    // Arama, filtre veya sıralama değiştiğinde ilk sayfaya dön
    useEffect(() => {
        setCurrentPage(1);
    }, [search, statusFilter, sortBy]);

    // Bireysel dersleri hesapla (herhangi bir gruba ait olmayan dersler)
    const individualCourses = useMemo(() => {
        const allGroupCourseIds = new Set(groups.flatMap(g => g.courseIds || []));
        return courses.filter(c => !allGroupCourseIds.has(c.id));
    }, [courses, groups]);

    const selectedGroup = useMemo(() => {
        if (!urlGroupId) return null;
        if (urlGroupId === "individual") {
            return {
                id: "individual",
                name: "Bireysel Derslerim",
                description: "Herhangi bir gruba ait olmayan, doğrudan adınıza tanımlanmış dersleriniz.",
                color: "#64748B",
                courseIds: individualCourses.map(c => c.id)
            };
        }
        return groups.find(g => g.id === urlGroupId) || null;
    }, [urlGroupId, groups, individualCourses]);

    // Klasör Modu Kontrolü: Öğrenci bir gruba üye ise ve URL'de grup seçilmemişse klasör listesini gösterir
    const isFolderMode = useMemo(() => {
        return groups.length > 0 && !urlGroupId;
    }, [groups, urlGroupId]);

    const filteredAndSorted = useMemo(() => {
        const normalizeText = (text: string) => {
            if (!text) return "";
            return text
                .toLocaleLowerCase("tr")
                .replace(/ı/g, "i")
                .replace(/ğ/g, "g")
                .replace(/ü/g, "u")
                .replace(/ş/g, "s")
                .replace(/ö/g, "o")
                .replace(/ç/g, "c")
                .trim();
        };

        const searchWords = normalizeText(search).split(/\s+/).filter(Boolean);

        // Aktif grup filtreleme
        let baseCourses = courses;
        if (groups.length > 0) {
            if (urlGroupId === "individual") {
                baseCourses = individualCourses;
            } else if (urlGroupId) {
                const courseIdsSet = new Set(selectedGroup?.courseIds || []);
                baseCourses = courses.filter(c => courseIdsSet.has(c.id));
            }
        }

        const result = baseCourses.filter(c => {
            const normalizedTitle = normalizeText(c.title);
            const matchSearch = searchWords.every(word => normalizedTitle.includes(word));
            let matchStatus = true;
            const comp = c.completionPercentage ?? 0;
            
            if (statusFilter === "completed") matchStatus = comp >= 100;
            else if (statusFilter === "in_progress") matchStatus = comp > 0 && comp < 100;
            else if (statusFilter === "not_started") matchStatus = comp === 0;
            
            return matchSearch && matchStatus;
        });

        if (sortBy === "name") {
            return [...result].sort((a, b) => a.title.localeCompare(b.title, 'tr'));
        } else if (sortBy === "sessions") {
            return [...result].sort((a, b) => b.sessionCount - a.sessionCount);
        } else if (sortBy === "completion") {
            return [...result].sort((a, b) => (b.completionPercentage ?? 0) - (a.completionPercentage ?? 0));
        }

        return result;
    }, [courses, groups, urlGroupId, selectedGroup, individualCourses, search, statusFilter, sortBy]);

    const totalPages = Math.ceil(filteredAndSorted.length / pageSize) || 1;
    const paginated = filteredAndSorted.slice((currentPage - 1) * pageSize, currentPage * pageSize);

    const handleSelectGroup = (id: string | null) => {
        if (id) {
            router.push(`/dashboard/courses?groupId=${id}`);
        } else {
            router.push(`/dashboard/courses`);
        }
    };

    return (
        <div className="w-full max-w-[1600px] mx-auto px-4 lg:px-8">
            {/* Header */}
            <div className="flex flex-col gap-4 mb-8">
                {isFolderMode ? (
                    <div className="flex items-center justify-between">
                        <div>
                            <h1 className="text-2xl font-bold text-[#0A1931]">Derslerim</h1>
                            <p className="text-[#A9A9A9] text-sm mt-1">Lütfen çalışmak istediğiniz grubu seçin</p>
                        </div>
                    </div>
                ) : urlGroupId ? (
                    <div className="flex items-center gap-3.5 animate-fade-in">
                        <button
                            onClick={() => handleSelectGroup(null)}
                            className="p-2.5 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 transition-all flex items-center justify-center shrink-0 shadow-sm group animate-fade-in"
                        >
                            <ArrowLeft size={18} className="text-[#1B3B6F] group-hover:-translate-x-0.5 transition-transform" />
                        </button>
                        <div>
                            <div className="flex items-center gap-2">
                                <h1 className="text-2xl font-bold text-[#0A1931]">{selectedGroup?.name}</h1>
                                <span 
                                    className="px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase tracking-wide"
                                    style={{ backgroundColor: `${selectedGroup?.color || '#1B3B6F'}15`, color: selectedGroup?.color || '#1B3B6F' }}
                                >
                                    Grup
                                </span>
                            </div>
                            {selectedGroup?.description && (
                                <p className="text-xs text-[#A9A9A9] mt-1">{selectedGroup.description}</p>
                            )}
                        </div>
                    </div>
                ) : (
                    <div className="hidden md:flex md:items-center justify-between">
                        <div>
                            <h1 className="text-2xl font-bold text-[#0A1931]">Derslerim</h1>
                            <p className="text-[#A9A9A9] text-sm mt-1">{courses.length} kurs kayıtlı</p>
                        </div>
                    </div>
                )}

                {/* Filtre ve Arama Çubuğu (Klasör modunda gizlenir) */}
                {!isFolderMode && (
                    <div className="flex flex-col md:flex-row md:items-center justify-between gap-3">
                        {/* Search input with icon */}
                        <div className="w-full md:w-auto relative">
                            <input
                                type="text"
                                placeholder="Kurs ara..."
                                value={search}
                                onChange={e => setSearch(e.target.value)}
                                className="pl-10 pr-4 py-2.5 bg-white border border-[#E2E8F0] rounded-xl text-[#0A1931] text-sm placeholder-[#A0AEC0] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#1B3B6F] w-full md:w-56 transition-all shadow-sm"
                            />
                            <Search className="absolute left-3.5 top-3.5 text-[#A0AEC0]" size={16} />
                        </div>

                        {/* Filters & Actions Container */}
                        <div className="flex items-center gap-3 w-full md:w-auto justify-between overflow-visible">
                            {/* Desktop: CustomSelect */}
                            <div className="hidden md:block shrink-0">
                                <CustomSelect
                                    value={statusFilter}
                                    onChange={(val) => setStatusFilter(val as any)}
                                    icon={Layers}
                                    options={[
                                        { label: "Tüm Dersler", value: "all", icon: Layers },
                                        { label: "Başlamadıklarım", value: "not_started", icon: Clock },
                                        { label: "Devam Edenler", value: "in_progress", icon: Activity },
                                        { label: "Tamamlananlar", value: "completed", icon: CheckCircle2 }
                                    ]}
                                />
                            </div>

                            {/* Mobile: Horizontal scrollable pills */}
                            <div className="flex md:hidden items-center gap-1.5 overflow-x-auto scrollbar-none py-1 flex-1">
                                {[
                                    { label: "Tüm Dersler", value: "all" },
                                    { label: "Başlamadıklarım", value: "not_started" },
                                    { label: "Devam Edenler", value: "in_progress" },
                                    { label: "Tamamlananlar", value: "completed" }
                                ].map((opt) => (
                                    <button
                                        key={opt.value}
                                        onClick={() => setStatusFilter(opt.value as any)}
                                        className={`px-3.5 py-1.5 rounded-full text-xs font-bold transition-all shrink-0 border ${
                                            statusFilter === opt.value
                                                ? "bg-[#1B3B6F] border-[#1B3B6F] text-white shadow-sm"
                                                : "bg-white border-[#E2E8F0] text-[#A0AEC0]"
                                        }`}
                                    >
                                        {opt.label}
                                    </button>
                                ))}
                            </div>

                            {/* Sort & View Actions */}
                            <div className="flex items-center gap-2 shrink-0">
                                <CustomSelect
                                    value={sortBy}
                                    onChange={(val) => setSortBy(val as any)}
                                    icon={ArrowUpDown}
                                    options={[
                                        { label: "Tarihe Göre", value: "date", icon: Clock },
                                        { label: "İsme Göre", value: "name", icon: ArrowUpDown },
                                        { label: "Video Sayısı", value: "sessions", icon: Layers },
                                        { label: "Duruma Göre", value: "completion", icon: CheckCircle2 }
                                    ]}
                                />
                                <div className="flex bg-[#E2E8F0]/30 p-1 rounded-xl">
                                    <button
                                        onClick={() => setViewMode("list")}
                                        className={`p-1.5 rounded-lg transition-colors ${viewMode === "list" ? "bg-white shadow-sm text-[#1B3B6F]" : "text-[#A0AEC0] hover:text-[#0A1931]"}`}
                                    >
                                        <List size={18} />
                                    </button>
                                    <button
                                        onClick={() => setViewMode("grid")}
                                        className={`p-1.5 rounded-lg transition-colors ${viewMode === "grid" ? "bg-white shadow-sm text-[#1B3B6F]" : "text-[#A0AEC0] hover:text-[#0A1931]"}`}
                                    >
                                        <LayoutGrid size={18} />
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                )}
            </div>

            {loading || (isFolderMode && groupsLoading) ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                    {[...Array(6)].map((_, i) => (
                        <div key={i} className="glass-card p-4 sm:p-5 animate-pulse min-h-[160px] sm:min-h-[190px] w-full">
                            <div className="w-10 h-10 sm:w-11 sm:h-11 bg-[#1B3B6F]/5 rounded-xl sm:rounded-2xl mb-3" />
                            <div className="h-4 bg-[#1B3B6F]/10 rounded w-2/3 mb-2" />
                            <div className="h-3 bg-[#1B3B6F]/5 rounded w-1/2" />
                        </div>
                    ))}
                </div>
            ) : isFolderMode ? (
                // 📂 KLASÖR GÖRÜNÜMÜ
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 animate-fade-in">
                    {groups.map((group) => {
                        const groupColor = group.color || "#1B3B6F";
                        const groupCoursesCount = group.courseIds?.length ?? 0;
                        return (
                            <div
                                key={group.id}
                                onClick={() => handleSelectGroup(group.id)}
                                className="cursor-pointer glass-card p-4 sm:p-5 flex flex-col items-start text-left group hover:border-[#1B3B6F]/30 hover:shadow-lg transition-all duration-300 relative overflow-hidden min-h-[160px] sm:min-h-[190px] w-full"
                            >
                                <div 
                                    className="absolute -top-12 -right-12 w-32 h-32 rounded-full blur-2xl opacity-10 pointer-events-none group-hover:scale-110 transition-transform duration-300"
                                    style={{ backgroundColor: groupColor }}
                                />
                                
                                <div 
                                    className="w-10 h-10 sm:w-11 sm:h-11 rounded-xl sm:rounded-2xl flex items-center justify-center shrink-0 mb-3 shadow-sm"
                                    style={{ backgroundColor: `${groupColor}15`, color: groupColor }}
                                >
                                    <Layers size={18} className="sm:hidden" />
                                    <Layers size={20} className="hidden sm:block" />
                                </div>
                                
                                <h3 className="text-[#0A1931] font-bold text-sm sm:text-base mb-1 line-clamp-1 group-hover:text-[#1B3B6F] transition-colors shrink-0">
                                    {group.name}
                                </h3>
                                
                                {group.description && (
                                    <p className="text-[#A9A9A9] text-[11px] sm:text-xs line-clamp-2 mb-2 leading-relaxed shrink-0">
                                        {renderTextWithLinks(group.description)}
                                    </p>
                                )}
                                
                                <div className="mt-auto flex items-center justify-between w-full border-t border-slate-100/50 pt-2 sm:pt-2.5">
                                    <span className="text-[10px] sm:text-[11px] font-bold text-[#A0AEC0] uppercase tracking-wider">
                                        {groupCoursesCount} Ders içeriyor
                                    </span>
                                    <ChevronRight size={14} className="sm:hidden text-[#A0AEC0] group-hover:translate-x-1 group-hover:text-[#1B3B6F] transition-all" />
                                    <ChevronRight size={16} className="hidden sm:block text-[#A0AEC0] group-hover:translate-x-1 group-hover:text-[#1B3B6F] transition-all" />
                                </div>
                            </div>
                        );
                    })}

                    {/* Bireysel Dersler Klasörü */}
                    {individualCourses.length > 0 && (
                        <div
                            onClick={() => handleSelectGroup("individual")}
                            className="cursor-pointer glass-card p-4 sm:p-5 flex flex-col items-start text-left group hover:border-slate-300 hover:shadow-lg transition-all duration-300 relative overflow-hidden min-h-[160px] sm:min-h-[190px] w-full"
                        >
                            <div 
                                className="absolute -top-12 -right-12 w-32 h-32 rounded-full blur-2xl opacity-10 bg-slate-500 group-hover:scale-110 transition-transform duration-300"
                            />
                            
                            <div className="w-10 h-10 sm:w-11 sm:h-11 rounded-xl sm:rounded-2xl bg-slate-100 text-slate-600 flex items-center justify-center shrink-0 mb-3 shadow-sm">
                                <BookOpen size={18} className="sm:hidden" />
                                <BookOpen size={20} className="hidden sm:block" />
                            </div>
                            
                            <h3 className="text-[#0A1931] font-bold text-sm sm:text-base mb-1 line-clamp-1 group-hover:text-slate-600 transition-colors shrink-0">
                                Bireysel Derslerim
                            </h3>
                            
                            <p className="text-[#A9A9A9] text-[11px] sm:text-xs line-clamp-2 mb-2 leading-relaxed shrink-0">
                                Herhangi bir gruba ait olmayan, doğrudan tanımlanmış dersleriniz.
                            </p>
                            
                            <div className="mt-auto flex items-center justify-between w-full border-t border-slate-100/50 pt-2 sm:pt-2.5">
                                <span className="text-[10px] sm:text-[11px] font-bold text-[#A0AEC0] uppercase tracking-wider">
                                    {individualCourses.length} Ders içeriyor
                                </span>
                                <ChevronRight size={14} className="sm:hidden text-[#A0AEC0] group-hover:translate-x-1 group-hover:text-slate-600 transition-all" />
                                <ChevronRight size={16} className="hidden sm:block text-[#A0AEC0] group-hover:translate-x-1 group-hover:text-slate-600 transition-all" />
                            </div>
                        </div>
                    )}
                </div>
            ) : filteredAndSorted.length === 0 ? (
                <div className="text-center py-20">
                    <p className="text-5xl mb-4">📭</p>
                    <p className="text-[#A0AEC0] text-lg font-medium">Kurs bulunamadı</p>
                    <p className="text-[#1B3B6F] text-sm mt-1">Farklı bir arama terimi deneyin</p>
                </div>
            ) : (
                // 📚 DERS LİSTESİ GÖRÜNÜMÜ
                viewMode === "grid" ? (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        {paginated.map((course) => (
                            <Link
                                key={course.id}
                                href={`/dashboard/courses/${course.id}`}
                                className="glass-card overflow-hidden hover:border-[#A0AEC0] transition-all flex flex-row md:flex-col group animate-fade-in"
                            >
                                <div className="w-28 sm:w-40 md:w-full h-24 sm:h-28 md:h-auto md:aspect-video bg-gradient-to-br from-indigo-900/50 to-purple-900/50 relative overflow-hidden shrink-0 m-2.5 md:m-0 rounded-xl md:rounded-none">
                                    {course.thumbnailUrl ? (
                                        <Image src={getFileUrl(course.thumbnailUrl)} alt={course.title} width={400} height={225} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" unoptimized />
                                    ) : (
                                        <div className="w-full h-full flex items-center justify-center">
                                            <span className="text-3xl md:text-5xl opacity-30 group-hover:opacity-50 transition-opacity">📚</span>
                                        </div>
                                    )}
                                    <div className="absolute top-1.5 left-1.5 md:top-3 md:right-3 md:left-auto">
                                        <span className="px-1.5 py-0.5 md:px-2 md:py-1 bg-black/60 backdrop-blur-md text-[9px] md:text-xs text-white rounded-md md:rounded-full font-medium">
                                            {course.sessionCount} içerik
                                        </span>
                                    </div>
                                </div>

                                <div className="p-3 md:p-5 flex-1 min-w-0 flex flex-col justify-center">
                                    <h3 className="text-[#0A1931] font-bold text-xs md:text-sm mb-1.5 md:mb-2 line-clamp-2 group-hover:text-[#1B3B6F] transition-colors leading-tight">
                                        {course.title}
                                    </h3>
                                    {course.description && (
                                        <p className="text-[#A9A9A9] text-[10px] md:text-xs line-clamp-1 md:line-clamp-2 mb-2 md:mb-3">{course.description}</p>
                                    )}
                                    {(course.completionPercentage ?? 0) > 0 && (
                                        <div className="mb-2 md:mb-3">
                                            <div className="flex items-center justify-between mb-1">
                                                <span className="text-[10px] md:text-xs text-[#A9A9A9]">İlerleme</span>
                                                <span className={`text-[10px] md:text-xs font-semibold ${(course.completionPercentage ?? 0) >= 100 ? 'text-emerald-500' : 'text-[#1B3B6F]'}`}>
                                                    %{Math.round(course.completionPercentage ?? 0)}
                                                </span>
                                            </div>
                                            <div className="h-1.5 bg-[#E2E8F0] rounded-full overflow-hidden">
                                                <div
                                                    className={`h-full rounded-full transition-all ${(course.completionPercentage ?? 0) >= 100 ? 'bg-emerald-500' : 'bg-[#1B3B6F]'}`}
                                                    style={{ width: `${Math.min(100, course.completionPercentage ?? 0)}%` }}
                                                />
                                            </div>
                                        </div>
                                    )}
                                    <div className="flex items-center justify-between mt-auto">
                                        <span className="text-[10px] md:text-xs text-[#A0AEC0] hidden md:block">{course.sessionCount} içerik</span>
                                        <span className="text-[#1B3B6F] text-[10px] md:text-xs font-bold group-hover:underline ml-auto">
                                            {(course.completionPercentage ?? 0) >= 100 ? '✓ Tamamlandı' : 'Devam Et →'}
                                        </span>
                                    </div>
                                </div>
                            </Link>
                        ))}
                    </div>
                ) : (
                    <div className="flex flex-col gap-3">
                        {paginated.map(course => (
                            <Link
                                key={course.id}
                                href={`/dashboard/courses/${course.id}`}
                                className="bg-white rounded-xl border border-[#E2E8F0]/60 p-3 hover:border-blue-200 hover:shadow-md active:scale-[0.98] active:bg-slate-50/50 transition-all duration-150 flex items-center justify-between group animate-fade-in"
                            >
                                <div className="flex items-center gap-3.5 flex-1 min-w-0">
                                    <div className="w-12 h-12 bg-gradient-to-br from-indigo-900/50 to-purple-900/50 rounded-lg overflow-hidden shrink-0 relative flex items-center justify-center">
                                        {course.thumbnailUrl ? (
                                            <Image src={getFileUrl(course.thumbnailUrl)} alt={course.title} width={48} height={48} className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500" unoptimized />
                                        ) : (
                                            <span className="text-xl opacity-50">📚</span>
                                        )}
                                    </div>
                                    <div className="min-w-0 flex-1">
                                        <h3 className="text-xs sm:text-sm font-semibold text-[#0A1931] group-hover:text-blue-600 transition-colors leading-tight line-clamp-2">{course.title}</h3>
                                        <div className="text-[10px] sm:text-xs text-[#A0AEC0] mt-1 flex items-center gap-1.5 font-medium">
                                            <Play size={10} className="text-[#1B3B6F]/60 fill-[#1B3B6F]/40" />
                                            {course.sessionCount} video
                                        </div>
                                    </div>
                                </div>
                                <div className="flex items-center gap-4 shrink-0 ml-3">
                                    {(course.completionPercentage ?? 0) > 0 && (
                                        <div className="w-20 sm:w-28 hidden md:block">
                                            <div className="flex items-center justify-between mb-1">
                                                <span className="text-[10px] text-[#A9A9A9]">İlerleme</span>
                                                <span className={`text-[10px] font-semibold ${(course.completionPercentage ?? 0) >= 100 ? 'text-emerald-500' : 'text-[#1B3B6F]'}`}>%{Math.round(course.completionPercentage ?? 0)}</span>
                                            </div>
                                            <div className="h-1 bg-[#E2E8F0] rounded-full overflow-hidden">
                                                <div className={`h-full rounded-full ${(course.completionPercentage ?? 0) >= 100 ? 'bg-emerald-500' : 'bg-[#1B3B6F]'}`} style={{ width: `${Math.min(100, course.completionPercentage ?? 0)}%` }} />
                                            </div>
                                        </div>
                                    )}
                                    <div className="w-7 h-7 rounded-full bg-slate-50 border border-slate-100 flex items-center justify-center text-[#1B3B6F] group-hover:bg-[#1B3B6F] group-hover:text-white transition-all shadow-sm">
                                        {(course.completionPercentage ?? 0) >= 100 ? (
                                            <CheckCircle2 size={14} className="text-emerald-500 group-hover:text-white" />
                                        ) : (
                                            <ChevronRight size={14} className="group-hover:translate-x-0.5 transition-transform" />
                                        )}
                                    </div>
                                </div>
                            </Link>
                        ))}
                    </div>
                )
            )}

            {/* Pagination Controls */}
            {!isFolderMode && !loading && totalPages > 1 && (
                <div className="mt-8 flex items-center justify-center gap-2">
                    <button
                        onClick={() => {
                            setCurrentPage(prev => Math.max(1, prev - 1));
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }}
                        disabled={currentPage === 1}
                        className="px-4 py-2 bg-white border border-[#E2E8F0] rounded-xl text-sm font-semibold text-[#0A1931] disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#E2E8F0]/30 transition-colors shadow-sm"
                    >
                        Önceki
                    </button>
                    <span className="text-sm font-medium text-[#A0AEC0] px-4">
                        Sayfa <strong className="text-[#0A1931]">{currentPage}</strong> / {totalPages}
                    </span>
                    <button
                        onClick={() => {
                            setCurrentPage(prev => Math.min(totalPages, prev + 1));
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }}
                        disabled={currentPage === totalPages}
                        className="px-4 py-2 bg-white border border-[#E2E8F0] rounded-xl text-sm font-semibold text-[#0A1931] disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#E2E8F0]/30 transition-colors shadow-sm"
                    >
                        Sonraki
                    </button>
                </div>
            )}
        </div>
    );
}
