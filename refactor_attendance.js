const fs = require('fs');
const file = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/admin/src/app/dashboard/course-attendance/page.tsx';
let code = fs.readFileSync(file, 'utf8');

// Replace studentMap memo
code = code.replace(
    /const studentMap = useMemo\(\(\) => \{[\s\S]*?return map;\r?\n    \}, \[sessionDetails\]\);/,
    `const studentMap = useMemo(() => {
        const map = new Map<string, { name: string; sessions: Map<string, boolean> }>();
        
        // Önce kayıtlı tüm öğrencileri map'e ekle (0% olarak başlasınlar)
        if (report?.enrolledStudents) {
            report.enrolledStudents.forEach(st => {
                map.set(st.userId, { name: st.fullName, sessions: new Map() });
            });
        }
        
        // Sonra oturum katılımlarını işle
        sessionDetails.forEach(sd => {
            sd.attendees.forEach(a => {
                if (!map.has(a.userId)) map.set(a.userId, { name: a.userFullName, sessions: new Map() });
                map.get(a.userId)!.sessions.set(sd.sessionId, a.isPresent);
            });
        });
        return map;
    }, [sessionDetails, report]);`
);

// Replace Empty state and Risk Panel
code = code.replace(
    /\{riskStudents\.length > 0 \? \(\r?\n                                    <div className="space-y-2 max-h-\[200px\] overflow-y-auto">[\s\S]*?<\/div>\r?\n                                \) : \(\r?\n                                    <p className="text-xs text-emerald-600">Tüm öğrenciler %50 üzeri devam oranına sahip 🎉<\/p>\r?\n                                \)\}/,
    `{students.length === 0 ? (
                                    <p className="text-xs text-[#A0AEC0]">Henüz devam verisi oluşmadı.</p>
                                ) : riskStudents.length > 0 ? (
                                    <div className="space-y-2 max-h-[200px] overflow-y-auto">
                                        {riskStudents.map(s => (
                                            <div key={s.id} className="flex items-center justify-between p-2.5 bg-white rounded-lg border border-red-200">
                                                <div>
                                                    <p className="text-xs font-bold text-[#0A1931]">{s.name}</p>
                                                    <p className="text-[10px] text-red-500">{s.present}/{s.total} oturum</p>
                                                </div>
                                                <span className="text-sm font-bold text-red-600">{s.rate.toFixed(0)}%</span>
                                            </div>
                                        ))}
                                    </div>
                                ) : (
                                    <p className="text-xs text-emerald-600">Tüm öğrenciler %50 üzeri devam oranına sahip 🎉</p>
                                )}`
);

// Replace Risk Altında title header based on empty state
code = code.replace(
    /\{riskStudents\.length > 0 \? "Risk Altındaki Öğrenciler" : "Tüm Öğrenciler İyi Durumda"\}/,
    `{students.length === 0 ? "Risk Durumu" : riskStudents.length > 0 ? "Risk Altındaki Öğrenciler" : "Tüm Öğrenciler İyi Durumda"}`
);

// Optimize heatmap check/cross icons
code = code.replace(
    /\{v === undefined \? \([\s\S]*?\}<\/td>/g,
    `{v === undefined || v === false ? (
                                                                    <div className="w-5 h-5 mx-auto rounded bg-[#E2E8F0]/30 border border-[#E2E8F0]/50" title="Katılmadı" />
                                                                ) : (
                                                                    <div className="w-5 h-5 mx-auto rounded bg-emerald-500 border border-emerald-600/20" title="Katıldı" />
                                                                )}
                                                            </td>`
);

// Optimize Rate Colors to show gray on 0
code = code.replace(
    /function rateColor\(rate: number\) \{\r?\n    if \(rate >= 80\) return "text-emerald-600";\r?\n    if \(rate >= 60\) return "text-amber-600";\r?\n    return "text-red-600";\r?\n\}/,
    `function rateColor(rate: number) {
    if (rate === 0) return "text-[#A0AEC0]";
    if (rate >= 80) return "text-emerald-600";
    if (rate >= 60) return "text-amber-600";
    return "text-red-600";
}`
);

code = code.replace(
    /function rateBg\(rate: number\) \{\r?\n    if \(rate >= 80\) return "bg-emerald-500";\r?\n    if \(rate >= 60\) return "bg-amber-500";\r?\n    return "bg-red-500";\r?\n\}/,
    `function rateBg(rate: number) {
    if (rate === 0) return "bg-[#E2E8F0]";
    if (rate >= 80) return "bg-emerald-500";
    if (rate >= 60) return "bg-amber-500";
    return "bg-red-500";
}`
);

fs.writeFileSync(file, code, 'utf8');
