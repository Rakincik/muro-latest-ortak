const fs = require('fs');
const file = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let lines = fs.readFileSync(file, 'utf8').split('\n');
lines[345] = '                            <p className="text-[#0A1931] font-semibold mb-1">Şu an canlı ders yok</p>';
lines[588] = '                                            <span>•</span>';
fs.writeFileSync(file, lines.join('\n'), 'utf8');
