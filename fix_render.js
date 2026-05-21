const fs = require('fs');
const files = [
    'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/admin/src/app/dashboard/questions/page.tsx',
    'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/questions/page.tsx'
];

for (const path of files) {
    let content = fs.readFileSync(path, 'utf8');
    
    // Fix return statement
    const searchReturn = '    return (\r\n        <div className="space-y-6">';
    const searchReturn2 = '    return (\n        <div className="space-y-6">';
    const replaceReturn = `    return (
        <>
        <ConfirmDialog
            open={confirmConfig.open}
            onClose={() => setConfirmConfig(prev => ({ ...prev, open: false }))}
            onConfirm={confirmConfig.onConfirm}
            title={confirmConfig.title}
            message={confirmConfig.message}
            confirmText="Evet, Sil"
            cancelText="İptal"
            variant="danger"
        />
        <div className="space-y-6">`;
    
    if (content.includes(searchReturn)) {
        content = content.replace(searchReturn, replaceReturn);
        console.log('Replaced return with \\r\\n in ' + path);
    } else if (content.includes(searchReturn2)) {
        content = content.replace(searchReturn2, replaceReturn);
        console.log('Replaced return with \\n in ' + path);
    } else {
        console.log('Could not find return statement in ' + path);
        
        // Let's try with regex
        if (!content.includes('<ConfirmDialog')) {
            content = content.replace(/return\s*\(\s*<div className=\"space-y-6\">/, replaceReturn);
            console.log('Replaced return with regex in ' + path);
        }
    }
    
    // Fix end of file
    const searchEnd = '        </div>\r\n    );\r\n}';
    const searchEnd2 = '        </div>\n    );\n}';
    const replaceEnd = '        </div>\n        </>\n    );\n}';
    
    if (content.includes(searchEnd)) {
        content = content.replace(searchEnd, replaceEnd);
        console.log('Replaced end with \\r\\n in ' + path);
    } else if (content.includes(searchEnd2)) {
        content = content.replace(searchEnd2, replaceEnd);
        console.log('Replaced end with \\n in ' + path);
    } else {
        console.log('Could not find end statement in ' + path);
        // regex fallback
        content = content.replace(/<\/div>\s*\);\s*}\s*$/m, '</div>\n        </>\n    );\n}');
        console.log('Used regex fallback for end statement');
    }
    
    fs.writeFileSync(path, content, 'utf8');
}
