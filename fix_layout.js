const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');
content = content.replace(/max-w-5xl/g, 'max-w-[1400px]');
fs.writeFileSync(filePath, content, 'utf8');
console.log('SUCCESS');
