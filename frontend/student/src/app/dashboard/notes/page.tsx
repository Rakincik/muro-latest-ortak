"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { courseApi, videoApi, sessionRecordingApi, type VideoNoteDto, type CourseDto, type RecordingDto } from "@/lib/api";
import { Trash2, Search, StickyNote, Clock } from "lucide-react";

interface NoteWithContext extends VideoNoteDto {
    courseTitle?: string;
    sessionTitle?: string;
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
            const courses: CourseDto[] = await courseApi.list(token, tenantId);
            const allNotes: NoteWithContext[] = [];

            // 1) Session-based notes (eski yöntem)
            for (const course of courses) {
                const sessions = await courseApi.getSessions(token, tenantId, course.id);
                for (const session of sessions) {
                    if (session.videoUrl) {
                        try {
                            const sessionNotes = await videoApi.getNotes(token, tenantId, session.id);
                            sessionNotes.forEach(n => allNotes.push({ ...n, courseTitle: course.title, sessionTitle: session.title }));
                        } catch { /* session may not have notes */ }
                    }
                }
            }

            // 2) Recording-based notes
            try {
                const recs: RecordingDto[] = await sessionRecordingApi.list(token, tenantId);
                for (const rec of recs) {
                    if (rec.status !== "Ready") continue;
                    try {
                        const recNotes = await videoApi.getNotes(token, tenantId, rec.id);
                        recNotes.forEach(n => {
                            // Deduplicate: skip if already added from session
                            if (!allNotes.some(existing => existing.id === n.id)) {
                                allNotes.push({ ...n, courseTitle: rec.courseTitle, sessionTitle: rec.sessionTitle });
                            }
                        });
                    } catch { /* recording may not have notes */ }
                }
            } catch { /* ignore recording fetch error */ }

            allNotes.sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime());
            setNotes(allNotes);
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
                                    <div key={note.id} className="glass-card p-4 group hover:border-violet-500/20 transition-all">
                                        <div className="flex items-start justify-between gap-3">
                                            <div className="flex-1 min-w-0">
                                                <div className="flex items-center gap-2 mb-2 flex-wrap">
                                                    <span className="font-mono text-[#1B3B6F] text-xs bg-[#1B3B6F]/10 px-2 py-0.5 rounded-full flex items-center gap-1">
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
                                            <button
                                                onClick={() => deleteNote(note.id)}
                                                className="text-[#A0AEC0] hover:text-red-400 text-sm opacity-0 group-hover:opacity-100 transition-all flex-shrink-0 mt-1"
                                                title="Notu sil"
                                            >
                                                <Trash2 size={14} />
                                            </button>
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
