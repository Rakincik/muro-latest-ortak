"use client";
import React, { useState, useRef, useEffect } from "react";
import { ChevronDown, Search, Check, X } from "lucide-react";

interface Option {
    label: string;
    value: string | number;
    icon?: any;
}

interface CustomSelectProps {
    value: any; // string | number | (string | number)[]
    onChange: (value: any) => void;
    options: Option[];
    className?: string;
    placeholder?: string;
    icon?: any;
    searchable?: boolean;
    isMulti?: boolean;
}

export function CustomSelect({ value, onChange, options, className = "", placeholder, icon, searchable = false, isMulti = false }: CustomSelectProps) {
    const [isOpen, setIsOpen] = useState(false);
    const [searchQuery, setSearchQuery] = useState("");
    const selectRef = useRef<HTMLDivElement>(null);
    const inputRef = useRef<HTMLInputElement>(null);

    // Multi select logic
    const selectedValues = Array.isArray(value) ? value : (value ? [value] : []);
    
    // For single select display
    const selectedOption = !isMulti ? (options.find((opt) => opt.value === value) || options[0]) : null;

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

    const handleSelect = (optValue: string | number) => {
        if (isMulti) {
            const isSelected = selectedValues.includes(optValue);
            if (isSelected) {
                onChange(selectedValues.filter((v: any) => v !== optValue));
            } else {
                onChange([...selectedValues, optValue]);
            }
        } else {
            onChange(optValue);
            setIsOpen(false);
        }
    };

    const handleRemoveChip = (e: React.MouseEvent, optValue: string | number) => {
        e.stopPropagation();
        onChange(selectedValues.filter((v: any) => v !== optValue));
    };

    return (
        <div ref={selectRef} className={`relative inline-block text-left ${className}`}>
            <button
                type="button"
                onClick={() => setIsOpen(!isOpen)}
                className={`group flex items-center justify-between w-full px-4 py-2 text-xs sm:text-sm bg-white border rounded-2xl transition-all duration-200 shadow-sm min-h-[44px] ${isOpen ? 'border-slate-300 ring-4 ring-slate-100/60 shadow-sm' : 'border-slate-200 hover:border-slate-300 hover:bg-slate-50/50 hover:shadow-md hover:shadow-slate-200/60'}`}
            >
                <div className="flex items-center gap-2 min-w-0 flex-1">
                    {!isMulti && renderIconNode(icon || selectedOption?.icon)}
                    
                    {isMulti ? (
                        selectedValues.length > 0 ? (
                            <div className="flex flex-wrap gap-1.5 py-0.5">
                                {selectedValues.map((v: any) => {
                                    const opt = options.find(o => o.value === v);
                                    if (!opt) return null;
                                    return (
                                        <span key={v} className="inline-flex items-center gap-1 pl-2 pr-1.5 py-0.5 bg-indigo-50 text-indigo-700 border border-indigo-100 rounded-lg text-xs font-bold">
                                            <span className="truncate max-w-[120px]">{opt.label}</span>
                                            <span onClick={(e) => handleRemoveChip(e, v)} className="p-0.5 hover:bg-indigo-200 rounded-md transition-colors cursor-pointer text-indigo-500 hover:text-indigo-800">
                                                <X size={12} />
                                            </span>
                                        </span>
                                    )
                                })}
                            </div>
                        ) : (
                            <span className="truncate text-slate-400 font-medium py-1">{placeholder}</span>
                        )
                    ) : (
                        <span className="truncate text-[#0A1931] font-semibold py-1">{selectedOption ? selectedOption.label : placeholder}</span>
                    )}
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
                                const isSelected = isMulti ? selectedValues.includes(option.value) : value === option.value;
                                const OptionIcon = option.icon;
                                return (
                                    <div key={index} className="flex flex-col gap-0.5">
                                        <button
                                            type="button"
                                            onClick={() => handleSelect(option.value)}
                                            className={`group w-full flex items-center justify-between px-3.5 py-2.5 text-xs sm:text-sm text-left rounded-xl transition-all duration-150 ${
                                                isSelected
                                                    ? "bg-slate-50 text-[#0A1931]"
                                                    : "text-slate-600 hover:bg-slate-50 hover:text-slate-900 active:bg-slate-100"
                                            }`}
                                        >
                                            <div className="flex items-center gap-3 min-w-0">
                                                {isMulti ? (
                                                    <div className={`w-4 h-4 rounded border flex items-center justify-center shrink-0 transition-colors ${isSelected ? 'bg-indigo-600 border-indigo-600 text-white' : 'border-slate-300 bg-white group-hover:border-indigo-400'}`}>
                                                        {isSelected && <Check size={12} strokeWidth={3} />}
                                                    </div>
                                                ) : (
                                                    OptionIcon && (
                                                        typeof OptionIcon === 'function' || (typeof OptionIcon === 'object' && OptionIcon.render)
                                                            ? React.createElement(OptionIcon, { size: 16, className: `shrink-0 transition-colors ${isSelected ? 'text-[#0A1931]' : 'text-slate-400 group-hover:text-slate-500'}` })
                                                            : <span className="shrink-0 text-slate-400">{OptionIcon}</span>
                                                    )
                                                )}
                                                
                                                <span className={`whitespace-nowrap ${isSelected ? "font-semibold text-[#0A1931]" : "font-medium text-slate-600 group-hover:text-slate-800"}`}>
                                                    {option.label}
                                                </span>
                                            </div>
                                            {!isMulti && isSelected && (
                                                <Check size={16} strokeWidth={2.5} className="text-blue-600 shrink-0 ml-2" />
                                            )}
                                        </button>
                                        {!isMulti && index === 0 && filteredOptions.length > 1 && (
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
