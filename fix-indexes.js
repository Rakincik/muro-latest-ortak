const fs = require('fs');

const filePaths = [
    'src/MURO.Infrastructure/Migrations/20260619201940_PreDropTenantCleanup.cs',
    'src/MURO.Infrastructure/Migrations/20260619220711_RemoveTenantId.cs'
];

filePaths.forEach(filePath => {
    if (!fs.existsSync(filePath)) return;
    
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Regular expression to match DropIndex calls
    const regex = /migrationBuilder\.DropIndex\(\s*name:\s*"([^"]+)",\s*table:\s*"[^"]+"\);/g;
    
    content = content.replace(regex, 'migrationBuilder.Sql("DROP INDEX IF EXISTS \\"$1\\";");');
    
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Updated ${filePath}`);
});
