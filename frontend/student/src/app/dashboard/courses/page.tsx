"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { courseApi, getFileUrl, type CourseDto } from "@/lib/api";
import Link from "next/link";
import Image from "next/image";

export default function CoursesPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [courses, setCourses] = useState<CourseDto[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState("");

    useEffect(() => {
        if (!token || !tenantId) return;
        courseApi.list(token, tenantId)
            .then(setCourses)
            .catch(console.error)
            .finally(() => setLoading(false));
    }, [token, tenantId]);

    const filtered = courses.filter(c =>
        c.title.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div className="w-full max-w-[1600px] mx-auto px-4 lg:px-8">
            {/* Header */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931]">📚 Derslerim</h1>
                    <p className="text-[#A9A9A9] text-sm mt-1">{courses.length} kurs kayıtlı</p>
                </div>
                <input
                    type="text"
                    placeholder="Kurs ara..."
                    value={search}
                    onChange={e => setSearch(e.target.value)}
                    className="px-4 py-2 bg-white border border-[#E2E8F0] rounded-xl text-[#0A1931] text-sm placeholder-[#A0AEC0] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 focus:border-[#1B3B6F] w-full sm:w-56 transition-all shadow-sm"
                />
            </div>

            {loading ? (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {[...Array(6)].map((_, i) => (
                        <div key={i} className="glass-card p-5 animate-pulse">
                            <div className="aspect-video bg-[#1B3B6F]/50 rounded-lg mb-4" />
                            <div className="h-4 bg-[#1B3B6F]/50 rounded w-3/4 mb-2" />
                            <div className="h-3 bg-[#1B3B6F]/50 rounded w-1/2" />
                        </div>
                    ))}
                </div>
            ) : filtered.length === 0 ? (
                <div className="text-center py-20">
                    <p className="text-5xl mb-4">📭</p>
                    <p className="text-[#A0AEC0] text-lg font-medium">Kurs bulunamadı</p>
                    <p className="text-[#1B3B6F] text-sm mt-1">Farklı bir arama terimi deneyin</p>
                </div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                    {filtered.map((course) => (
                        <Link
                            key={course.id}
                            href={`/dashboard/courses/${course.id}`}
                            className="glass-card overflow-hidden hover:border-[#A0AEC0] transition-all block group"
                        >
                            {/* Thumbnail */}
                            <div className="aspect-video bg-gradient-to-br from-indigo-900/50 to-purple-900/50 relative overflow-hidden">
                                {course.thumbnailUrl ? (
                                    <Image src={getFileUrl(course.thumbnailUrl)} alt={course.title} width={400} height={225} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" unoptimized />
                                ) : (
                                    <div className="w-full h-full flex items-center justify-center">
                                        <span className="text-5xl opacity-30 group-hover:opacity-50 transition-opacity">📚</span>
                                    </div>
                                )}
                                <div className="absolute top-3 right-3">
                                    <span className="px-2 py-1 bg-black/50 backdrop-blur-sm text-xs text-[#A0AEC0] rounded-full">
                                        {course.sessionCount} içerik
                                    </span>
                                </div>
                            </div>

                            {/* Info */}
                            <div className="p-5">
                                <h3 className="text-[#0A1931] font-semibold text-sm mb-2 line-clamp-2 group-hover:text-[#1B3B6F] transition-colors">
                                    {course.title}
                                </h3>
                                {course.description && (
                                    <p className="text-[#A9A9A9] text-xs line-clamp-2 mb-3">{course.description}</p>
                                )}
                                {/* İlerleme çubuğu */}
                                {(course.completionPercentage ?? 0) > 0 && (
                                    <div className="mb-3">
                                        <div className="flex items-center justify-between mb-1">
                                            <span className="text-xs text-[#A9A9A9]">İlerleme</span>
                                            <span className={`text-xs font-semibold ${(course.completionPercentage ?? 0) >= 100 ? 'text-emerald-400' : 'text-violet-400'}`}>
                                                %{Math.round(course.completionPercentage ?? 0)}
                                            </span>
                                        </div>
                                        <div className="h-1.5 bg-white/5 rounded-full overflow-hidden">
                                            <div
                                                className={`h-full rounded-full transition-all ${(course.completionPercentage ?? 0) >= 100 ? 'bg-emerald-500' : 'bg-gradient-to-r from-indigo-500 to-violet-500'}`}
                                                style={{ width: `${Math.min(100, course.completionPercentage ?? 0)}%` }}
                                            />
                                        </div>
                                    </div>
                                )}
                                <div className="flex items-center justify-between">
                                    <span className="text-xs text-[#1B3B6F]">{course.sessionCount} içerik</span>
                                    <span className="text-violet-400 text-xs font-medium group-hover:text-[#1B3B6F]">
                                        {(course.completionPercentage ?? 0) >= 100 ? '✓ Tamamlandı' : 'Devam Et →'}
                                    </span>
                                </div>
                            </div>
                        </Link>
                    ))}
                </div>
            )}
        </div>
    );
}
