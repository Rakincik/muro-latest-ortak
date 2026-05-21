const fs = require('fs');
const files = [
  'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/courses/[courseId]/page.tsx',
  'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/exams/[examId]/solve/page.tsx'
];
files.forEach(f => {
  let c = fs.readFileSync(f, 'utf8');
  c = c.replace(/Ä±/g, 'ı')
       .replace(/ÄŸ/g, 'ğ')
       .replace(/ÅŸ/g, 'ş')
       .replace(/Ã¼/g, 'ü')
       .replace(/Ã§/g, 'ç')
       .replace(/Ã¶/g, 'ö')
       .replace(/Ä°/g, 'İ')
       .replace(/Ã‡/g, 'Ç')
       .replace(/Ã–/g, 'Ö')
       .replace(/Åž/g, 'Ş')
       .replace(/Ãœ/g, 'Ü')
       .replace(/Äž/g, 'Ğ')
       .replace(/â”€/g, '─')
       .replace(/ğŸ“„/g, '📄')
       .replace(/ğŸ”´/g, '🔴');
  fs.writeFileSync(f, c, 'utf8');
});
