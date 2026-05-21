const fs = require('fs');
const path = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/components/video/PremiumPlayer.tsx';
let content = fs.readFileSync(path, 'utf8');

// Replace the manifest parsed event handling
content = content.replace(
    /hls\.on\(Hls\.Events\.MANIFEST_PARSED, \(\) => \{\n\s*if \(onLoaded\)/,
    `hls.on(Hls.Events.MANIFEST_PARSED, (event, data) => {
                        const availableQualities = data.levels.map((l) => l.height).sort((a, b) => b - a);
                        setQualities(availableQualities);
                        if (onLoaded)`
);

// Add state for qualities
if (!content.includes('const [qualities, setQualities]')) {
    content = content.replace(
        'const [supported, setSupported] = useState(true);',
        'const [supported, setSupported] = useState(true);\n    const [qualities, setQualities] = useState<number[]>([]);'
    );
}

// Add quality object to plyrOptions
if (!content.includes('quality: {')) {
    content = content.replace(
        'settings: ["quality", "speed"],',
        `settings: ["quality", "speed"],
        quality: qualities.length > 0 ? {
            default: qualities[0],
            options: qualities,
            forced: true,
            onChange: (q: number) => {
                if (hlsRef.current) {
                    const levelIndex = hlsRef.current.levels.findIndex(l => l.height === q);
                    if (levelIndex !== -1) {
                        hlsRef.current.currentLevel = levelIndex;
                    }
                }
            }
        } : undefined,`
    );
}

fs.writeFileSync(path, content, 'utf8');
console.log('Fixed Plyr quality settings.');
