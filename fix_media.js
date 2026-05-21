const fs = require('fs');
const path = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/admin/src/app/dashboard/media/page.tsx';
let content = fs.readFileSync(path, 'utf8');

const getFileUrlStr = `const getFileUrl = (path: string | null) => {
    if (!path) return "";
    if (path.startsWith("http") || path.startsWith("blob:") || path.startsWith("data:")) return path;
    let hostname = "localhost";
    if (typeof window !== "undefined") {
        hostname = window.location.hostname;
    }
    return \`http://\${hostname}:5292\${path.startsWith("/") ? "" : "/"}\${path}\`;
};`;

if (!content.includes('const getFileUrl')) {
    content = content.replace(
        'const FallbackImage',
        `${getFileUrlStr}\n\nconst FallbackImage`
    );
}

if (!content.includes('<img src={getFileUrl(src)}')) {
    content = content.replace(
        'return <img src={src} alt="" className="w-full h-full object-cover" onError={() => setError(true)} />;',
        'return <img src={getFileUrl(src)} alt="" className="w-full h-full object-cover" onError={() => setError(true)} />;'
    );
}

fs.writeFileSync(path, content, 'utf8');
console.log('Fixed media thumbnails.');
