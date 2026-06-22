"use client";
import React, { useState, useRef, useEffect } from "react";
import { ChevronDown, Search } from "lucide-react";

interface Option {
    label: string;
    value: string | number;
}

interface CustomSelectProps {
    value: string | number;
    onChange: (value: string | number) => void;
    options: Option[];
    className?: string;
    placeholder?: string;
    icon?: React.ReactNode;
    searchable?: boolean;
}

export function CustomSelect({ value, onChange, options, className = "", placeholder, icon, searchable = false }: CustomSelectProps) {
    const [isOpen, setIsOpen] = useState(false);
    const [searchQuery, setSearchQuery] = useState("");
    const selectRef = useRef<HTMLDivElement>(null);
    const inputRef = useRef<HTMLInputElement>(null);

    const selectedOption = options.find((opt) => opt.value === value) || options[0];

    useEffect(() => {
        if (isOpen && searchable && inputRef.current) {
            inputRef.current.focus();
        }
    }, [isOpen, searchable]);

    useEffect(() => {
        if (!isOpen) {
            setSearchQuery("");
        }
    }, [isOpen]);

    const filteredOptions = searchable 
        ? options.filter(opt => opt.label.toLowerCase().includes(searchQuery.toLowerCase()))
        : options;

    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (selectRef.current && !selectRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        };

        if (isOpen) {
            document.addEventListener("mousedown", handleClickOutside);
        }
        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, [isOpen]);

    return (
        <div ref={selectRef} className={`relative inline-block text-left ${className}`}>
            <button
                type="button"
                onClick={() => setIsOpen(!isOpen)}
                className={`flex items-center justify-between w-full px-4 py-2.5 text-xs sm:text-sm font-bold text-[#1B3B6F] bg-white border border-[#E2E8F0] rounded-2xl shadow-sm hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 transition-all ${isOpen ? 'ring-2 ring-[#1B3B6F]/20 border-[#1B3B6F]/50' : ''}`}
            >
                <div className="flex items-center gap-2">
                    {icon && <span className="text-[#64748B]">{icon}</span>}
                    <span className="truncate">{selectedOption ? selectedOption.label : placeholder}</span>
                </div>
                <ChevronDown size={14} className={`ml-2 text-[#64748B] transition-transform duration-200 ${isOpen ? "rotate-180" : ""}`} />
            </button>

            {isOpen && (
                <div className="absolute z-50 w-full min-w-[140px] mt-2 origin-top-right bg-white border border-[#E2E8F0] rounded-xl shadow-lg ring-1 ring-black ring-opacity-5 animate-in fade-in slide-in-from-top-2 duration-200 overflow-hidden">
                    {searchable && (
                        <div className="px-3 py-2 border-b border-[#E2E8F0] bg-slate-50 relative sticky top-0">
                            <Search size={14} className="absolute left-5 top-1/2 -translate-y-1/2 text-[#A0AEC0]" />
                            <input
                                ref={inputRef}
                                type="text"
                                placeholder="Ara..."
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                className="w-full pl-8 pr-2 py-1.5 text-xs border border-[#E2E8F0] rounded-lg focus:outline-none focus:ring-2 focus:ring-[#1B3B6F]/20 text-[#0A1931]"
                            />
                        </div>
                    )}
                    <div className="py-1 max-h-60 overflow-auto custom-scrollbar">
                        {filteredOptions.length === 0 ? (
                            <div className="px-4 py-3 text-xs text-[#A0AEC0] text-center">Sonuç bulunamadı</div>
                        ) : (
                            filteredOptions.map((option, index) => (
                                <button
                                    key={index}
                                    onClick={() => {
                                        onChange(option.value);
                                        setIsOpen(false);
                                    }}
                                    className={`w-full text-left px-4 py-2.5 text-xs sm:text-sm transition-colors ${
                                        value === option.value
                                            ? "bg-[#1B3B6F] text-white font-bold"
                                            : "text-[#0A1931] hover:bg-[#F8FAFC] font-medium"
                                    }`}
                                >
                                    {option.label}
                                </button>
                            ))
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
