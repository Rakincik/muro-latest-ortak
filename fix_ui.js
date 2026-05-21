const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');

const lines = content.split('\n');

for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes('<Video size={8} />') && lines[i+1].includes('fmtDuration')) {
        lines[i] = `                                                            {rec.type === 'Exam' ? (\r`;
        lines[i+1] = `                                                                <><FileText size={8} /> Sınav / Quiz</>\r`;
        lines.splice(i+2, 0, `                                                            ) : (\r`);
        lines.splice(i+3, 0, `                                                                <><Video size={8} /> {rec.durationSeconds && rec.durationSeconds > 0 ? fmtDuration(rec.durationSeconds) : "Kayıt"}</>\r`);
        lines.splice(i+4, 0, `                                                            )}\r`);
        break;
    }
}

fs.writeFileSync(filePath, lines.join('\n'), 'utf8');
console.log('SUCCESS');
