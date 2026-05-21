const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');

const badMapping = `                        sessionTitle: cm.mediaAsset?.title || cm.sessionTitle || cm.examTitle || 'İçerik',
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

const goodMapping = `                        sessionTitle: cm.mediaTitle || cm.sessionTitle || cm.examTitle || 'İçerik',
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
                        type: cm.examId ? 'Exam' : (cm.mediaAssetId ? 'Video' : 'Recording'),
                        examId: cm.examId || undefined`;

if (content.includes(badMapping)) {
    content = content.replace(badMapping, goodMapping);
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('SUCCESS CRLF');
} else if (content.includes(badMapping.replace(/\n/g, '\r\n'))) {
    content = content.replace(badMapping.replace(/\n/g, '\r\n'), goodMapping.replace(/\n/g, '\r\n'));
    fs.writeFileSync(filePath, content, 'utf8');
    console.log('SUCCESS LF');
} else {
    console.log('FAILED TO MATCH');
}
