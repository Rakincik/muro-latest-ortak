const fs = require('fs');
const path = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/questions/page.tsx';

let content = fs.readFileSync(path, 'utf8');

const targetStr = `                            <div className="px-6 py-4 border-b border-[#E2E8F0]/60">
                                <div className="flex items-center gap-2 mb-1">
                                    <h2 className="text-base font-bold text-[#0A1931]">{selected.subject}</h2>
                                    <span className={\`text-[10px] font-semibold px-2 py-0.5 rounded-lg \${(statusStyles[mapQuestionStatus(selected.status)] || statusStyles.Bekliyor).bg} \${(statusStyles[mapQuestionStatus(selected.status)] || statusStyles.Bekliyor).text}\`}>
                                        {mapQuestionStatus(selected.status)}
                                    </span>
                                </div>
                                <p className="text-xs text-[#A0AEC0]">{selected.courseTitle || "Ders"} • {new Date(selected.createdAt).toLocaleString("tr-TR")}</p>
                            </div>`;

const replaceStr = `                            <div className="px-6 py-4 border-b border-[#E2E8F0]/60 flex items-start justify-between">
                                <div>
                                    <div className="flex items-center gap-2 mb-1">
                                        <h2 className="text-base font-bold text-[#0A1931]">{selected.subject}</h2>
                                        <span className={\`text-[10px] font-semibold px-2 py-0.5 rounded-lg \${(statusStyles[mapQuestionStatus(selected.status)] || statusStyles.Bekliyor).bg} \${(statusStyles[mapQuestionStatus(selected.status)] || statusStyles.Bekliyor).text}\`}>
                                            {mapQuestionStatus(selected.status)}
                                        </span>
                                    </div>
                                    <p className="text-xs text-[#A0AEC0]">{selected.courseTitle || "Ders"} • {new Date(selected.createdAt).toLocaleString("tr-TR")}</p>
                                </div>
                                {mapQuestionStatus(selected.status) === "Bekliyor" && (
                                    <button onClick={handleDelete} title="Soruyu Sil"
                                        className="p-2 text-[#A0AEC0] hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors">
                                        <Trash2 size={16} />
                                    </button>
                                )}
                            </div>`;

// Check if there is an alternate character for the dot
const regex = /<div className="px-6 py-4 border-b border-\[#E2E8F0\]\/60\">[\s\S]*?<p className=\"text-xs text-\[#A0AEC0\]\">\{selected\.courseTitle \|\| "Ders"\} [^\{]* \{new Date\(selected\.createdAt\)\.toLocaleString\("tr-TR"\)\}<\/p>\s*<\/div>/m;

if (content.includes(targetStr)) {
    content = content.replace(targetStr, replaceStr);
    fs.writeFileSync(path, content, 'utf8');
    console.log("Replaced using exact string match.");
} else if (regex.test(content)) {
    content = content.replace(regex, replaceStr);
    fs.writeFileSync(path, content, 'utf8');
    console.log("Replaced using regex.");
} else {
    console.log("Could not find the target string or regex match.");
}
