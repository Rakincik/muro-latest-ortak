import { useState, useRef, useEffect } from "react";
import { Shield, ChevronDown, Check } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";

interface RoleSelectProps {
    value: string;
    onChange: (newRole: string) => void;
}

const ROLES = [
    { value: "Student", label: "Öğrenci" },
    { value: "Instructor", label: "Eğitmen" },
    { value: "Admin", label: "Admin" },
    { value: "Accountant", label: "Muhasebe" },
    { value: "Assistant", label: "Asistan" }
];

export function RoleSelect({ value, onChange }: RoleSelectProps) {
    const [open, setOpen] = useState(false);
    const ref = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const handleClickOutside = (e: MouseEvent) => {
            if (ref.current && !ref.current.contains(e.target as Node)) {
                setOpen(false);
            }
        };
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    const selectedRole = ROLES.find(r => r.value === value) || ROLES[0];

    const { user, currentTenantId: tenantId } = useAuth();
    const isAssistant = user?.role === "Assistant" || user?.tenants?.find((t: any) => t.tenantId === tenantId)?.role === "Assistant";

    const availableRoles = ROLES.filter(r => {
        if (isAssistant && (r.value === "Admin" || r.value === "Accountant")) return false;
        return true;
    });

    return (
        <div className="relative" ref={ref}>
            <button
                type="button"
                onClick={() => setOpen(!open)}
                className="flex items-center gap-2 px-4 py-2 hover:bg-[#E2E8F0]/50 rounded-xl transition-colors cursor-pointer outline-none focus:ring-2 focus:ring-[#0A1931]/10 bg-white border border-[#E2E8F0]/80 shadow-sm"
            >
                <Shield size={14} className="text-[#A0AEC0]" />
                <span className="text-xs font-bold text-[#1B3B6F] min-w-[60px] text-left">
                    {selectedRole.label}
                </span>
                <ChevronDown size={14} className={`text-[#A0AEC0] transition-transform ${open ? "rotate-180" : ""}`} />
            </button>

            {open && (
                <div className="absolute z-50 mt-2 w-40 bg-white border border-[#E2E8F0] rounded-xl shadow-xl overflow-hidden py-1 right-0 animate-fade-in-up">
                    {availableRoles.map(role => (
                        <button
                            key={role.value}
                            onClick={() => {
                                onChange(role.value);
                                setOpen(false);
                            }}
                            className={`w-full text-left px-4 py-2.5 text-xs font-bold transition-colors flex items-center justify-between ${
                                value === role.value 
                                    ? "bg-blue-50 text-blue-700" 
                                    : "text-[#475569] hover:bg-[#F8FAFC]"
                            }`}
                        >
                            {role.label}
                            {value === role.value && <Check size={14} className="text-blue-600" />}
                        </button>
                    ))}
                </div>
            )}
        </div>
    );
}
