const fs = require('fs');
const filePath = 'frontend/student/src/app/dashboard/courses/[courseId]/page.tsx';
let content = fs.readFileSync(filePath, 'utf8');
content = content.replace(/min-h-\[500px\]/g, 'h-[500px] md:h-[600px] lg:h-[700px]');
fs.writeFileSync(filePath, content, 'utf8');
console.log('SUCCESS');
