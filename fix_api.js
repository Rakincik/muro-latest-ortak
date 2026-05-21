const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');

const fetchOldStr = `        // Fetch media assets
        const fetchMedia = async () => {
            try { return await mediaApi.list(token, tenantId, { courseId, pageSize: 100 }); }
            catch { return []; }
        };

        // Fetch materials
        const fetchMaterials = async () => {
            try { return await courseApi.getMaterials(token, tenantId, courseId); }
            catch { return []; }
        };

        Promise.all([fetchCourse(), fetchMedia(), fetchRecordings(), fetchMaterials()])
            .then(([courseData, vids, recs, mats]) => {
                setCourse(courseData);
                // Sessions come from course detail response
                const sess = courseData?.sessions ?? [];
                setSessions(sess);
                setVideos(vids);
                // Filter recordings to only this course's sessions
                const courseRecs = (recs as RecordingDto[]).filter(r =>
                    sess.some((s: SessionDto) => s.id === r.sessionId)
                );
                setRecordings(courseRecs.filter((r: RecordingDto) => r.status === "Ready"));
                setMaterials(mats || []);
            })`;

const fetchNewStr = `        // Fetch course medias as single source of truth
        const fetchCourseMedias = async () => {
            try { return await courseApi.getCourseMedias(token, tenantId, courseId); }
            catch { return []; }
        };

        // Fetch materials
        const fetchMaterials = async () => {
            try { return await courseApi.getMaterials(token, tenantId, courseId); }
            catch { return []; }
        };

        Promise.all([fetchCourse(), fetchCourseMedias(), fetchRecordings(), fetchMaterials()])
            .then(([courseData, courseMedias, recs, mats]) => {
                setCourse(courseData);
                // Sessions come from course detail response
                const sess = courseData?.sessions ?? [];
                setSessions(sess);
                
                const typedRecs = recs as RecordingDto[];

                // Map CourseMediaDto to RecordingDto for the player and sidebar
                const mappedRecordings: RecordingDto[] = courseMedias.map((cm: any) => {
                    const matchRec = typedRecs.find(r => r.sessionId === cm.sessionId);
                    return {
                        id: cm.id, // Using CourseMedia ID as the unique key
                        sessionId: cm.sessionId || cm.id,
                        sessionTitle: cm.mediaTitle || cm.sessionTitle || cm.examTitle || 'İçerik',
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
                        type: cm.examId ? 'Exam' : (cm.mediaType === 'Video' || cm.mediaHlsPath ? 'Video' : 'Recording'),
                        examId: cm.examId || undefined
                    };
                });
                
                setRecordings(mappedRecordings);
                setVideos([]); // Deprecated in unified architecture, keep empty to prevent crashes
                setMaterials(mats || []);
            })`;

if (content.includes(fetchOldStr)) {
    content = content.replace(fetchOldStr, fetchNewStr);
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('SUCCESS API CRLF');
} else if (content.includes(fetchOldStr.replace(/\n/g, '\r\n'))) {
    content = content.replace(fetchOldStr.replace(/\n/g, '\r\n'), fetchNewStr.replace(/\n/g, '\r\n'));
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('SUCCESS API LF');
} else {
    console.log('FAILED TO MATCH API BLOCK');
}
