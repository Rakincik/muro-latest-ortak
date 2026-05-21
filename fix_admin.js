const fs = require('fs');
const path = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/admin/src/app/dashboard/questions/page.tsx';
let content = fs.readFileSync(path, 'utf8');

if (!content.includes('import { ConfirmDialog }')) {
    content = content.replace(
        'import { questionApi, type QuestionDto } from "@/lib/api";',
        'import { questionApi, type QuestionDto } from "@/lib/api";\nimport { ConfirmDialog } from "@/components/confirm-dialog";'
    );
}

if (!content.includes('const [confirmConfig')) {
    content = content.replace(
        'const [replyText, setReplyText] = useState("");',
        'const [replyText, setReplyText] = useState("");\n    const [confirmConfig, setConfirmConfig] = useState<{open: boolean, title: string, message: string, onConfirm: () => void}>({ open: false, title: "", message: "", onConfirm: () => {} });'
    );
}

content = content.replace(
    /if \(!window\.confirm\("Bu soruyu tamamen silmek istediğinize emin misiniz\? Bu işlem geri alınamaz\."\)\) return;/g,
    `setConfirmConfig({
            open: true,
            title: "Soruyu Sil",
            message: "Bu soruyu tamamen silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
            onConfirm: async () => {
                try {
                    await questionApi.deleteQuestion(token, tenantId, selected.id);
                    setQuestions(prev => prev.filter(q => q.id !== selected.id));
                    setSelectedId(null);
                    success("Soru başarıyla silindi");
                } catch (e: any) {
                    success("Hata", e.message || "Soru silinemedi");
                }
            }
        });
        return;`
);

// We need to clean up the rest of handleDeleteQuestion since we moved the logic to onConfirm
content = content.replace(
    /        try \{\n            await questionApi\.deleteQuestion\(token, tenantId, selected\.id\);\n            setQuestions\(prev => prev\.filter\(q => q\.id !== selected\.id\)\);\n            setSelectedId\(null\);\n            success\("Soru başarıyla silindi"\);\n        \} catch \(e: any\) \{\n            success\("Hata", e\.message \|\| "Soru silinemedi"\);\n        \}/g,
    ''
);


content = content.replace(
    /if \(!window\.confirm\("Bu cevabı silmek istediğinize emin misiniz\? Soru tekrar 'Bekliyor' statüsüne dönecektir\."\)\) return;/g,
    `setConfirmConfig({
            open: true,
            title: "Cevabı Sil",
            message: "Bu cevabı silmek istediğinize emin misiniz? Soru tekrar 'Bekliyor' statüsüne dönecektir.",
            onConfirm: async () => {
                try {
                    const updated = await questionApi.deleteAnswer(token, tenantId, selected.id);
                    setQuestions(prev => prev.map(q => q.id === selected.id ? mapQuestion(updated) : q));
                    success("Cevap başarıyla silindi");
                } catch (e: any) {
                    success("Hata", e.message || "Cevap silinemedi");
                }
            }
        });
        return;`
);

// We need to clean up the rest of handleDeleteAnswer since we moved the logic to onConfirm
content = content.replace(
    /        try \{\n            const updated = await questionApi\.deleteAnswer\(token, tenantId, selected\.id\);\n            setQuestions\(prev => prev\.map\(q => q\.id === selected\.id \? mapQuestion\(updated\) : q\)\);\n            success\("Cevap başarıyla silindi"\);\n        \} catch \(e: any\) \{\n            success\("Hata", e\.message \|\| "Cevap silinemedi"\);\n        \}/g,
    ''
);


if (!content.includes('<ConfirmDialog')) {
    content = content.replace(
        'return (\n        <div className="space-y-6">',
        'return (\n        <>\n        <ConfirmDialog\n            open={confirmConfig.open}\n            onClose={() => setConfirmConfig(prev => ({ ...prev, open: false }))}\n            onConfirm={confirmConfig.onConfirm}\n            title={confirmConfig.title}\n            message={confirmConfig.message}\n            confirmText="Evet, Sil"\n            cancelText="İptal"\n            variant="danger"\n        />\n        <div className="space-y-6">'
    );
    content = content.replace(/<\/div>\n    \);\n}$/m, '</div>\n        </>\n    );\n}');
}

fs.writeFileSync(path, content, 'utf8');
console.log('Admin QuestionsPage updated.');
