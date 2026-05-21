const fs = require('fs');
const path = 'c:/Users/Rüstem/.gemini/antigravity/scratch/muro-v2/frontend/student/src/app/dashboard/questions/page.tsx';
let content = fs.readFileSync(path, 'utf8');

if (!content.includes('import { ConfirmDialog }')) {
    content = content.replace(
        'import { useAudioRecorder } from "@/hooks/useAudioRecorder";',
        'import { useAudioRecorder } from "@/hooks/useAudioRecorder";\nimport { ConfirmDialog } from "@/components/confirm-dialog";'
    );
}

if (!content.includes('const [confirmConfig')) {
    content = content.replace(
        'const [lightboxUrl, setLightboxUrl] = useState<string | null>(null);',
        'const [lightboxUrl, setLightboxUrl] = useState<string | null>(null);\n    const [confirmConfig, setConfirmConfig] = useState<{open: boolean, title: string, message: string, onConfirm: () => void}>({ open: false, title: "", message: "", onConfirm: () => {} });'
    );
}

content = content.replace(
    /if \(!confirm\("Bu soruyu silmek istediğinize emin misiniz\?"\)\) return;/g,
    `setConfirmConfig({
            open: true,
            title: "Soruyu Sil",
            message: "Bu soruyu silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
            onConfirm: async () => {
                try {
                    await questionApi.deleteQuestion(token, tenantId, selected.id);
                    setQuestions(prev => prev.filter(q => q.id !== selected.id));
                    setSelectedId(null);
                    window.dispatchEvent(new CustomEvent("toast:show", { detail: { message: "Soru silindi", type: "success" } }));
                } catch (e: any) {
                    window.dispatchEvent(new CustomEvent("toast:show", { detail: { message: e.message || "Soru silinemedi", type: "error" } }));
                }
            }
        });
        return;`
);

// Clean up the rest of handleDelete since it's now in onConfirm
content = content.replace(
    /        try \{\n            await questionApi\.deleteQuestion\(token, tenantId, selected\.id\);\n            setQuestions\(prev => prev\.filter\(q => q\.id !== selected\.id\)\);\n            setSelectedId\(null\);\n            window\.dispatchEvent\(new CustomEvent\("toast:show", \{ detail: \{ message: "Soru silindi", type: "success" \} \}\)\);\n        \} catch \(e: any\) \{\n            window\.dispatchEvent\(new CustomEvent\("toast:show", \{ detail: \{ message: e\.message \|\| "Soru silinemedi", type: "error" \} \}\)\);\n        \}/g,
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
console.log('Student QuestionsPage updated.');
