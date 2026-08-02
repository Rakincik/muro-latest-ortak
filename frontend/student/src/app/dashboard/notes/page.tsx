"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { courseApi, videoApi, type VideoNoteDto, type CourseDto } from "@/lib/api";
import { Trash2, Search, StickyNote, Clock } from "lucide-react";
import Link from "next/link";

interface NoteWithContext extends VideoNoteDto {
    courseTitle?: string;
    sessionTitle?: string;
    courseId?: string;
    recordingId?: string;
}

const fmtClockTime = (iso: string) => {
    try { return new Date(iso).toLocaleTimeString("tr-TR", { hour: "2-digit", minute: "2-digit" }); }
    catch { return "--:--"; }
};

export default function MyNotesPage() {
    const { token, currentTenantId: tenantId } = useAuth();
    const [notes, setNotes] = useState<NoteWithContext[]>([]);
    const [loading, setLoading] = useState(true);
    const [search, setSearch] = useState("");

    useEffect(() => {
        if (!token || !tenantId) return;

        const fetchNotes = async () => {
            try {
                const courses: CourseDto[] = await courseApi.list(token, tenantId);
                const allNotes: NoteWithContext[] = [];

                for (const course of courses) {
                    try {
                        const courseMedias = await courseApi.getCourseMedias(token, tenantId, course.id);
                        for (const cm of courseMedias) {
                            const targetId = cm.mediaAssetId || cm.id;
                            try {
                                const recNotes = await videoApi.getNotes(token, tenantId, targetId);
                                recNotes.forEach(n => {
                                    if (!allNotes.some(existing => existing.id === n.id)) {
                                        allNotes.push({
                                            ...n,
                                            courseTitle: course.title,
                                            sessionTitle: cm.mediaAsset?.title || cm.sessionTitle || cm.examTitle || 'İçerik',
                                            courseId: course.id,
                                            recordingId: cm.id
                                        });
                                    }
                                });
                            } catch { /* ignore notes for this media */ }
                        }
                    } catch { /* ignore course medias error */ }
                }

                allNotes.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
                setNotes(allNotes);
            } catch (e) {
                console.error(e);
            }
        };

        fetchNotes().catch(console.error).finally(() => setLoading(false));
    }, [token, tenantId]);

    const deleteNote = async (noteId: string) => {
        if (!token || !tenantId) return;
        await videoApi.deleteNote(token, tenantId, noteId);
        setNotes(prev => prev.filter(n => n.id !== noteId));
    };

    const filtered = notes.filter(n =>
        n.text.toLowerCase().includes(search.toLowerCase()) ||
        (n.courseTitle || "").toLowerCase().includes(search.toLowerCase()) ||
        (n.sessionTitle || "").toLowerCase().includes(search.toLowerCase())
    );

    // Group by date
    type GroupedNotes = Record<string, NoteWithContext[]>;
    const grouped = filtered.reduce<GroupedNotes>((acc, n) => {
        const day = new Date(n.createdAt).toLocaleDateString("tr-TR", { weekday: "long", day: "numeric", month: "long" });
        if (!acc[day]) acc[day] = [];
        acc[day].push(n);
        return acc;
    }, {});

    return (
        <div className="max-w-3xl mx-auto">
            <div className="flex items-center justify-between mb-8">
                <div>
                    <h1 className="text-2xl font-bold text-[#0A1931]">📓 Tüm Notlarım</h1>
                    <p className="text-[#A9A9A9] text-sm mt-1">{notes.length} not</p>
                </div>
                <div className="relative">
                    <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A9A9A9]" />
                    <input
                        type="text"
                        placeholder="Notlarda ara..."
                        value={search}
                        onChange={e => setSearch(e.target.value)}
                        className="pl-9 pr-4 py-2 bg-[#1B3B6F]/15 border border-[#1B3B6F]/30 rounded-xl text-[#0A1931] text-sm placeholder-[#A9A9A9] focus:outline-none focus:ring-2 focus:ring-[#1B3B6F] w-52 transition-all"
                    />
                </div>
            </div>

            {loading ? (
                <div className="space-y-3">
                    {[...Array(4)].map((_, i) => <div key={i} className="glass-card p-4 animate-pulse h-20" />)}
                </div>
            ) : notes.length === 0 ? (
                <div className="text-center py-20">
                    <StickyNote size={48} className="mx-auto text-[#A0AEC0] opacity-30 mb-4" />
                    <p className="text-[#A0AEC0] font-medium">Henüz hiç video notu yok</p>
                    <p className="text-[#A0AEC0] text-sm mt-1">Video izlerken not ekleyerek başlayın</p>
                </div>
            ) : filtered.length === 0 ? (
                <div className="text-center py-16">
                    <p className="text-[#A0AEC0]">Arama sonucu yok</p>
                </div>
            ) : (
                <div className="space-y-6">
                    {Object.entries(grouped).map(([day, dayNotes]) => (
                        <div key={day}>
                            <h2 className="text-[#A9A9A9] text-xs font-semibold uppercase tracking-widest mb-3">{day}</h2>
                            <div className="space-y-2">
                                {dayNotes.map(note => (
                                    <div key={note.id} className="glass-card p-0 group border border-[#E2E8F0] hover:border-indigo-400 hover:shadow-md transition-all rounded-xl overflow-hidden bg-white">
                                        <div className="flex items-stretch">
                                            {note.courseId && note.recordingId ? (
                                                <Link 
                                                    href={`/dashboard/courses/${note.courseId}/watch/${note.recordingId}`}
                                                    className="flex-1 p-4 min-w-0 flex flex-col justify-center"
                                                >
                                                    <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                                                        <span className="font-mono text-[#1B3B6F] text-[10px] bg-[#1B3B6F]/5 px-2 py-0.5 rounded-full flex items-center gap-1 font-bold">
                                                            <Clock size={10} /> {fmtClockTime(note.createdAt)}
                                                        </span>
                                                        {note.courseTitle && (
                                                            <span className="text-[#1B3B6F] text-xs font-semibold hover:underline truncate">{note.courseTitle}</span>
                                                        )}
                                                        {note.sessionTitle && (
                                                            <span className="text-[#A0AEC0] text-[10px] truncate">• {note.sessionTitle}</span>
                                                        )}
                                                    </div>
                                                    <p className="text-[#0A1931] text-sm leading-relaxed">{note.text}</p>
                                                </Link>
                                            ) : (
                                                <div className="flex-1 p-4 min-w-0">
                                                    <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                                                        <span className="font-mono text-[#1B3B6F] text-[10px] bg-[#1B3B6F]/5 px-2 py-0.5 rounded-full flex items-center gap-1 font-bold">
                                                            <Clock size={10} /> {fmtClockTime(note.createdAt)}
                                                        </span>
                                                        {note.courseTitle && (
                                                            <span className="text-[#A0AEC0] text-xs truncate">{note.courseTitle}</span>
                                                        )}
                                                        {note.sessionTitle && (
                                                            <span className="text-[#A0AEC0] text-[10px] truncate">• {note.sessionTitle}</span>
                                                        )}
                                                    </div>
                                                    <p className="text-[#5A6A7A] text-sm leading-relaxed">{note.text}</p>
                                                </div>
                                            )}
                                            <div className="flex items-center justify-center px-4 border-l border-[#E2E8F0]/40 shrink-0">
                                                <button
                                                    onClick={() => deleteNote(note.id)}
                                                    className="text-[#A0AEC0] hover:text-red-500 transition-colors p-1.5 rounded-lg hover:bg-red-50"
                                                    title="Notu sil"
                                                >
                                                    <Trash2 size={14} />
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
