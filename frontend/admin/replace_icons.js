const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'src', 'app', 'dashboard', 'groups', 'page.tsx');
let content = fs.readFileSync(filePath, 'utf8');

// Replace lucide-react with pi
content = content.replace(
    /import \{\s*FolderTree, Plus, Users, Edit3, Trash2, X, Search,\s*BookOpen, Settings, ChevronDown, ChevronRight, Loader2,\s*RefreshCw, UserPlus, UserMinus, ArrowRight, Check,\s*AlertTriangle, BarChart3, Calendar, Copy\s*\} from "lucide-react";/g,
    `import {
    PiTreeStructureDuotone as FolderTree,
    PiPlusBold as Plus,
    PiUsersDuotone as Users,
    PiPencilSimpleDuotone as Edit3,
    PiTrashDuotone as Trash2,
    PiXBold as X,
    PiMagnifyingGlassDuotone as Search,
    PiBookOpenTextDuotone as BookOpen,
    PiGearDuotone as Settings,
    PiCaretDownBold as ChevronDown,
    PiCaretRightBold as ChevronRight,
    PiSpinnerGapDuotone as Loader2,
    PiArrowsClockwiseDuotone as RefreshCw,
    PiUserPlusDuotone as UserPlus,
    PiUserMinusDuotone as UserMinus,
    PiArrowRightBold as ArrowRight,
    PiCheckBold as Check,
    PiWarningDuotone as AlertTriangle,
    PiChartBarDuotone as BarChart3,
    PiCalendarDuotone as Calendar,
    PiCopyDuotone as Copy,
    PiVideoCameraDuotone,
    PiTentDuotone,
    PiNotePencilDuotone,
    PiTargetDuotone
} from "react-icons/pi";`
);

// Replace EDUCATION_MODE_EMOJIS constant
content = content.replace(
    /const EDUCATION_MODE_EMOJIS: Record<string, string> = \{\s*"Canlı": "🎥",\s*"Offline": "📖",\s*"Kamp": "🏕️",\s*"Sınav": "📝",\s*"Demo": "🎯"\s*\};/g,
    `const getEducationIcon = (type: string, size: number = 14) => {
    const icons: Record<string, React.ElementType> = {
        "Canlı": PiVideoCameraDuotone,
        "Offline": BookOpen,
        "Kamp": PiTentDuotone,
        "Sınav": PiNotePencilDuotone,
        "Demo": PiTargetDuotone
    };
    const Icon = icons[type];
    return Icon ? <Icon size={size} className="inline-block shrink-0" /> : null;
};`
);

// Replace usages of EDUCATION_MODE_EMOJIS
content = content.replace(
    /\{EDUCATION_MODE_EMOJIS\[group\.educationType\] \|\| ""\}/g,
    `{getEducationIcon(group.educationType, 12)}`
);

content = content.replace(
    /\{EDUCATION_MODE_EMOJIS\[detail\.educationType\] \|\| ""\}/g,
    `{getEducationIcon(detail.educationType, 12)}`
);

content = content.replace(
    /\{EDUCATION_MODE_EMOJIS\[formType\] \|\| ""\}/g,
    `{getEducationIcon(formType, 14)}`
);

// Add gap to flex containers where emojis were
content = content.replace(
    /className=\{\`text-\[10px\] font-bold px-1\.5 py-0\.5/g,
    `className={\`flex items-center gap-1 text-[10px] font-bold px-1.5 py-0.5`
);

content = content.replace(
    /text-\[11px\] rounded-lg font-bold border border-indigo-200/g,
    `text-[11px] rounded-lg font-bold border border-indigo-200 flex items-center gap-1`
);

content = content.replace(
    /rounded-xl text-\[11px\] font-bold shadow-sm/g,
    `rounded-xl text-[11px] font-bold flex items-center gap-1.5 shadow-sm`
);

// Replace form buttons
const oldFormButtons = `{Object.entries(EDUCATION_MODE_EMOJIS).map(([label, emoji]) => (
                                            <button key={label} type="button" onClick={() => setFormType(label)}
                                                className={\`flex flex-col items-center justify-center gap-1.5 p-3 rounded-xl border transition-all text-center bg-white \${formType === label ? "border-indigo-600 bg-indigo-50/30 ring-2 ring-indigo-600/20 shadow-sm" : "border-[#E2E8F0] hover:border-[#A0AEC0] hover:bg-[#F8FAFC]"}\`}>
                                                <span className="text-xl">{emoji}</span>
                                                <span className={\`text-[11px] font-bold \${formType === label ? "text-indigo-900" : "text-[#475569]"}\`}>{label}</span>
                                            </button>
                                        ))}`;

const newFormButtons = `{["Canlı", "Offline", "Kamp", "Sınav", "Demo"].map((label) => (
                                            <button key={label} type="button" onClick={() => setFormType(label)}
                                                className={\`flex flex-col items-center justify-center gap-1.5 p-3 rounded-xl border transition-all text-center bg-white \${formType === label ? "border-indigo-600 bg-indigo-50/30 ring-2 ring-indigo-600/20 shadow-sm text-indigo-600" : "border-[#E2E8F0] hover:border-[#A0AEC0] hover:bg-[#F8FAFC] text-[#64748B]"}\`}>
                                                <div className="text-[28px]">{getEducationIcon(label, 28)}</div>
                                                <span className={\`text-[11px] font-bold \${formType === label ? "text-indigo-900" : "text-[#475569]"}\`}>{label}</span>
                                            </button>
                                        ))}`;

content = content.replace(oldFormButtons, newFormButtons);

fs.writeFileSync(filePath, content);
console.log('Done');
