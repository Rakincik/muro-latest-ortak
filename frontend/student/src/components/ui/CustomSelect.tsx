"use client";
import React, { useState, useRef, useEffect } from "react";
import { ChevronDown, Search, Check } from "lucide-react";

interface Option {
    label: string;
    value: string | number;
    icon?: any;
}

interface CustomSelectProps {
    value: string | number;
    onChange: (value: string | number) => void;
    options: Option[];
    className?: string;
    placeholder?: string;
    icon?: any;
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

    const renderIconNode = (ic: any) => {
        if (!ic) return null;
        if (typeof ic === 'function' || (typeof ic === 'object' && ic.render)) {
            const IconComp = ic;
            return <IconComp size={16} className={`shrink-0 transition-colors ${isOpen ? 'text-[#0A1931]' : 'text-slate-400 group-hover:text-slate-500'}`} />;
        }
        return <span className={`shrink-0 transition-colors ${isOpen ? 'text-[#0A1931]' : 'text-slate-400 group-hover:text-slate-500'}`}>{ic}</span>;
    };

    return (
        <div ref={selectRef} className={`relative inline-block text-left ${className}`}>
            <button
                type="button"
                onClick={() => setIsOpen(!isOpen)}
                className={`group flex items-center justify-between w-full px-4 py-2.5 text-xs sm:text-sm bg-white border rounded-2xl transition-all duration-200 shadow-sm ${isOpen ? 'border-slate-300 ring-4 ring-slate-100/60 shadow-sm' : 'border-slate-200 hover:border-slate-300 hover:bg-slate-50/50 hover:shadow-md hover:shadow-slate-200/60'}`}
            >
                <div className="flex items-center gap-2 min-w-0">
                    {renderIconNode(icon || selectedOption?.icon)}
                    <span className="truncate text-[#0A1931] font-semibold">{selectedOption ? selectedOption.label : placeholder}</span>
                </div>
                <ChevronDown size={16} className={`text-slate-400 transition-transform duration-200 shrink-0 ml-2 group-hover:text-slate-500 ${isOpen ? "rotate-180" : ""}`} />
            </button>

            {isOpen && (
                <div className="absolute z-50 left-0 w-max min-w-full md:min-w-[240px] mt-2 bg-white/95 backdrop-blur-md rounded-2xl border border-slate-200/60 shadow-[0_12px_38px_rgba(15,23,42,0.12)] p-1.5 flex flex-col origin-top transition-all duration-200 animate-fade-in">
                    {searchable && (
                        <div className="px-2 pb-2 mb-1.5 border-b border-slate-100">
                            <div className="relative">
                                <Search size={14} className="absolute left-2.5 top-1/2 -translate-y-1/2 text-slate-400" />
                                <input
                                    ref={inputRef}
                                    type="text"
                                    placeholder="Ara..."
                                    value={searchQuery}
                                    onChange={(e) => setSearchQuery(e.target.value)}
                                    className="w-full pl-8 pr-2 py-1.5 text-xs border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-100 focus:border-slate-300 transition-all text-[#0A1931]"
                                />
                            </div>
                        </div>
                    )}
                    <div className={`py-0.5 ${searchable ? 'max-h-60 overflow-y-auto custom-scrollbar' : ''} flex flex-col gap-0.5`}>
                        {filteredOptions.length === 0 ? (
                            <div className="px-4 py-3 text-xs text-slate-400 font-medium text-center">Sonuç bulunamadı</div>
                        ) : (
                            filteredOptions.map((option, index) => {
                                const isSelected = value === option.value;
                                const OptionIcon = option.icon;
                                return (
                                    <div key={index} className="flex flex-col gap-0.5">
                                        <button
                                            type="button"
                                            onClick={() => {
                                                onChange(option.value);
                                                setIsOpen(false);
                                            }}
                                            className={`group w-full flex items-center justify-between px-3.5 py-2.5 text-xs sm:text-sm text-left rounded-xl transition-all duration-150 ${
                                                isSelected
                                                    ? "bg-slate-50 text-[#0A1931]"
                                                    : "text-slate-600 hover:bg-slate-50 hover:text-slate-900 active:bg-slate-100"
                                            }`}
                                        >
                                            <div className="flex items-center gap-3 min-w-0">
                                                {OptionIcon && (
                                                    typeof OptionIcon === 'function' || (typeof OptionIcon === 'object' && OptionIcon.render)
                                                        ? React.createElement(OptionIcon, { size: 16, className: `shrink-0 transition-colors ${isSelected ? 'text-[#0A1931]' : 'text-slate-400 group-hover:text-slate-500'}` })
                                                        : <span className="shrink-0 text-slate-400">{OptionIcon}</span>
                                                )}
                                                <span className={`whitespace-nowrap ${isSelected ? "font-semibold text-[#0A1931]" : "font-medium text-slate-600 group-hover:text-slate-800"}`}>
                                                    {option.label}
                                                </span>
                                            </div>
                                            {isSelected && (
                                                <Check size={16} strokeWidth={2.5} className="text-blue-600 shrink-0 ml-2" />
                                            )}
                                        </button>
                                        {index === 0 && filteredOptions.length > 1 && (
                                            <div className="my-1 border-t border-slate-100/80" />
                                        )}
                                    </div>
                                );
                            })
                        )}
                    </div>
                </div>
            )}
        </div>
    );
}
