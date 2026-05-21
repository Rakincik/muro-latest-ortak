const fs = require('fs');
const file = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let c = fs.readFileSync(file, 'utf8');

c = c.replace(/Åžu an canlÄ± ders yok/g, 'Şu an canlı ders yok')
     .replace(/Åžu/g, 'Şu')
     .replace(/â€”/g, '—')
     .replace(/â€¢/g, '•')
     .replace(/ğŸ• /g, '🕒')
     .replace(/ğŸ”´/g, '🔴')
     .replace(/ğŸ“„/g, '📄');

fs.writeFileSync(file, c, 'utf8');

const file2 = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/exams/[examId]/solve/page.tsx';
let c2 = fs.readFileSync(file2, 'utf8');
c2 = c2.replace(/Åžu/g, 'Şu')
       .replace(/â€”/g, '—')
       .replace(/â€¢/g, '•')
       .replace(/ğŸ• /g, '🕒')
       .replace(/ğŸ”´/g, '🔴')
       .replace(/ğŸ“„/g, '📄');
fs.writeFileSync(file2, c2, 'utf8');
