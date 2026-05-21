const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');

// 1. Imports
content = content.replace(
    'import { useVideoPlayer, usePlayerNotes } from "@/hooks/useVideoPlayer";\nimport { openUrl } from "@/lib/openUrl";',
    'import { useVideoPlayer, usePlayerNotes } from "@/hooks/useVideoPlayer";\nimport { PremiumPlayer } from "@/components/video/PremiumPlayer";\nimport InlineQuizModal from "@/components/InlineQuizModal";\nimport { openUrl } from "@/lib/openUrl";'
).replace(
    'import { useVideoPlayer, usePlayerNotes } from "@/hooks/useVideoPlayer";\r\nimport { openUrl } from "@/lib/openUrl";',
    'import { useVideoPlayer, usePlayerNotes } from "@/hooks/useVideoPlayer";\r\nimport { PremiumPlayer } from "@/components/video/PremiumPlayer";\r\nimport InlineQuizModal from "@/components/InlineQuizModal";\r\nimport { openUrl } from "@/lib/openUrl";'
);

// 2. Remove HlsVideoPlayer
content = content.replace(/function HlsVideoPlayer[\s\S]*?return <video[\s\S]*?;\r?\n}/, '// Removed HlsVideoPlayer, using PremiumPlayer');

// 3. State and Width
content = content.replace(
    'const [joiningId, setJoiningId] = useState<string | null>(null);',
    'const [joiningId, setJoiningId] = useState<string | null>(null);\n    const [isExamOpen, setIsExamOpen] = useState(false);'
);

content = content.replace(
    'const { selectedRec, setSelectedRec, isFullscreen, toggleFullscreen, sidebarOpen, setSidebarOpen,\n        iframeLoaded, setIframeLoaded, watchedMap, playerContainerRef, sortedRecordings,\n        watchedCount, progressPercent, lastWatchedRec } = player;',
    'const { selectedRec, setSelectedRec, isFullscreen, toggleFullscreen, sidebarOpen, setSidebarOpen,\n        iframeLoaded, setIframeLoaded, watchedMap, playerContainerRef, sortedRecordings,\n        watchedCount, progressPercent, lastWatchedRec } = player;\n\n    const activeRecId = selectedRec?.id || sortedRecordings[0]?.id;\n    useEffect(() => {\n        const activeRec = selectedRec || sortedRecordings[0];\n        if (activeRec?.type === \'Exam\') {\n            setIsExamOpen(true);\n        } else {\n            setIsExamOpen(false);\n        }\n    }, [activeRecId]);'
).replace(
    'const { selectedRec, setSelectedRec, isFullscreen, toggleFullscreen, sidebarOpen, setSidebarOpen,\r\n        iframeLoaded, setIframeLoaded, watchedMap, playerContainerRef, sortedRecordings,\r\n        watchedCount, progressPercent, lastWatchedRec } = player;',
    'const { selectedRec, setSelectedRec, isFullscreen, toggleFullscreen, sidebarOpen, setSidebarOpen,\r\n        iframeLoaded, setIframeLoaded, watchedMap, playerContainerRef, sortedRecordings,\r\n        watchedCount, progressPercent, lastWatchedRec } = player;\r\n\r\n    const activeRecId = selectedRec?.id || sortedRecordings[0]?.id;\r\n    useEffect(() => {\r\n        const activeRec = selectedRec || sortedRecordings[0];\r\n        if (activeRec?.type === \'Exam\') {\r\n            setIsExamOpen(true);\r\n        } else {\r\n            setIsExamOpen(false);\r\n        }\r\n    }, [activeRecId]);'
);

content = content.replace(/max-w-5xl/g, 'max-w-[1400px]');

// 4. Data Mapping
const oldMapping = `                        sessionTitle: cm.mediaTitle || cm.sessionTitle || cm.examTitle || 'İçerik',
                        courseId: cm.courseId,
                        courseTitle: courseData?.title || '',
                        playbackUrl: matchRec?.playbackUrl || '', // Get from recordings!
                        hlsPath: cm.mediaHlsPath,
                        thumbnailPath: cm.mediaThumbnailPath,
                        durationSeconds: cm.mediaDurationSeconds || matchRec?.durationSeconds || 0,
                        participantsCount: 0,
                        status: "Ready", // Assume ready if it's in course medias
                        createdAt: cm.createdAt,
                        scheduledStart: cm.sessionScheduledStart || undefined,
                        type: cm.examId ? 'Exam' : (cm.mediaAssetId ? 'Video' : 'Recording')`;

const newMapping = `                        sessionTitle: cm.mediaAsset?.title || cm.sessionTitle || cm.examTitle || 'İçerik',
                        courseId: cm.courseId,
                        courseTitle: courseData?.title || '',
                        playbackUrl: matchRec?.playbackUrl || '', // Get from recordings!
                        hlsPath: cm.mediaAsset?.hlsPath,
                        thumbnailPath: cm.mediaAsset?.thumbnailPath,
                        durationSeconds: cm.mediaAsset?.durationSeconds || matchRec?.durationSeconds || 0,
                        participantsCount: 0,
                        status: "Ready", // Assume ready if it's in course medias
                        createdAt: cm.createdAt,
                        scheduledStart: cm.sessionScheduledStart || undefined,
                        type: cm.examId ? 'Exam' : (cm.mediaAssetId ? 'Video' : 'Recording'),
                        examId: cm.examId || undefined`;

content = content.replace(oldMapping, newMapping);
content = content.replace(oldMapping.replace(/\n/g, '\r\n'), newMapping.replace(/\n/g, '\r\n'));

// 5. Video Rendering
const oldRender = `                                    {activeRec.hlsPath ? (
                                        <HlsVideoPlayer 
                                            key={activeRec.id} 
                                            src={activeRec.hlsPath} 
                                            onLoaded={() => setIframeLoaded(true)} 
                                        />
                                    ) : (`;

const newRender = `                                    {activeRec.type === 'Exam' ? (
                                        <div className="absolute inset-0 z-[5] bg-[#F8F9FA] flex items-center justify-center">
                                            <div className="text-center">
                                                <div className="w-16 h-16 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center mx-auto mb-4 shadow-sm border border-indigo-100">
                                                    <FileText size={28} />
                                                </div>
                                                <h3 className="text-xl font-bold text-[#0A1931] mb-2">{activeRec.sessionTitle}</h3>
                                                <p className="text-sm text-[#A0AEC0] mb-6">Bu adımda bir sınav/quiz yer almaktadır.</p>
                                                <button onClick={() => setIsExamOpen(true)} className="px-6 py-3 bg-[#1B3B6F] hover:bg-[#0A1931] text-white font-bold rounded-xl shadow-lg shadow-[#1B3B6F]/20 transition-all flex items-center justify-center gap-2 mx-auto">
                                                    <Play size={16} className="fill-current" /> Sınavı Başlat
                                                </button>
                                            </div>
                                        </div>
                                    ) : activeRec.hlsPath ? (
                                        <PremiumPlayer 
                                            key={activeRec.id} 
                                            src={activeRec.hlsPath} 
                                            poster={activeRec.thumbnailPath ? getFileUrl(activeRec.thumbnailPath) : null}
                                            onLoaded={() => setIframeLoaded(true)} 
                                        />
                                    ) : (`

content = content.replace(oldRender, newRender);
content = content.replace(oldRender.replace(/\n/g, '\r\n'), newRender.replace(/\n/g, '\r\n'));

// 6. Sidebar Absolute Layout + Exam Text
const oldSidebar = `<div className={\`bg-white border-l border-[#E2E8F0] flex flex-col shrink-0 transition-all duration-300 \${sidebarOpen ? 'w-full md:w-80' : 'w-0 overflow-hidden border-l-0'}\`}>`;
const newSidebar = `<div className={\`bg-white border-l border-[#E2E8F0] shrink-0 transition-all duration-300 md:relative \${sidebarOpen ? 'w-full md:w-80 flex flex-col md:block' : 'w-0 overflow-hidden border-l-0 hidden md:block'}\`}>\n                                <div className="md:absolute md:inset-0 flex flex-col w-full h-full">`;
content = content.replace(oldSidebar, newSidebar);

const oldSidebarClose = `                                </div>
                            </div>
                        </div>
                    </div>
                );
            })()}`;
const newSidebarClose = `                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                );
            })()}`;
content = content.replace(oldSidebarClose, newSidebarClose);
content = content.replace(oldSidebarClose.replace(/\n/g, '\r\n'), newSidebarClose.replace(/\n/g, '\r\n'));

const oldUi = `<span className="text-[10px] text-[#A0AEC0] flex items-center gap-0.5">
                                                            <Video size={8} />
                                                            {rec.durationSeconds && rec.durationSeconds > 0 ? fmtDuration(rec.durationSeconds) : "Kayıt"}
                                                        </span>`;
const newUi = `<span className="text-[10px] text-[#A0AEC0] flex items-center gap-0.5">
                                                            {rec.type === 'Exam' ? (
                                                                <><FileText size={8} /> Sınav / Quiz</>
                                                            ) : (
                                                                <><Video size={8} /> {rec.durationSeconds && rec.durationSeconds > 0 ? fmtDuration(rec.durationSeconds) : "Kayıt"}</>
                                                            )}
                                                        </span>`;
content = content.replace(oldUi, newUi);
content = content.replace(oldUi.replace(/\n/g, '\r\n'), newUi.replace(/\n/g, '\r\n'));

// 7. Exam Modal Render
const oldMaterials = `{/* ── Materials Tab ── */}`;
const newMaterials = `{/* Exam Modal Integration */}
            {activeTab === "videos" && (() => {
                const activeRec = selectedRec || sortedRecordings[0];
                return activeRec?.type === 'Exam' && activeRec.examId ? (
                    <InlineQuizModal
                        isOpen={isExamOpen}
                        onClose={() => setIsExamOpen(false)}
                        examId={activeRec.examId}
                        examTitle={activeRec.sessionTitle}
                    />
                ) : null;
            })()}

            {/* ── Materials Tab ── */}`;
content = content.replace(oldMaterials, newMaterials);

fs.writeFileSync(filePath, content, 'utf8');
console.log('SUCCESS');
