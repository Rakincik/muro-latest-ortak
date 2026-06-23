"use client";

import React from 'react';
import { AlertTriangle, X } from 'lucide-react';

interface ConfirmModalProps {
    isOpen: boolean;
    title: string;
    message: string;
    confirmText?: string;
    cancelText?: string;
    type?: 'danger' | 'warning' | 'info';
    onConfirm: () => void;
    onCancel: () => void;
}

export function ConfirmModal({ 
    isOpen, 
    title, 
    message, 
    confirmText = "Onayla", 
    cancelText = "İptal", 
    type = 'danger',
    onConfirm, 
    onCancel 
}: ConfirmModalProps) {
    if (!isOpen) return null;

    const getIconColor = () => {
        switch (type) {
            case 'danger': return 'text-red-600 bg-red-100';
            case 'warning': return 'text-amber-600 bg-amber-100';
            default: return 'text-blue-600 bg-blue-100';
        }
    };

    const getButtonColor = () => {
        switch (type) {
            case 'danger': return 'bg-red-600 hover:bg-red-700 focus:ring-red-500';
            case 'warning': return 'bg-amber-600 hover:bg-amber-700 focus:ring-amber-500';
            default: return 'bg-blue-600 hover:bg-blue-700 focus:ring-blue-500';
        }
    };

    return (
        <div className="fixed inset-0 z-[110] flex items-center justify-center sm:p-4 p-0 bg-black/40 backdrop-blur-md">
            <div className="bg-white border border-gray-100 shadow-[0_20px_60px_rgba(0,0,0,0.15)] w-full max-w-md sm:rounded-3xl rounded-t-[2.5rem] flex flex-col self-end sm:self-center animate-in fade-in slide-in-from-bottom-10 sm:zoom-in-95 duration-300">
                {/* Mobile Drag Handle */}
                <div className="w-12 h-1 bg-gray-200 rounded-full mx-auto my-3 sm:hidden" />

                <div className="p-6 relative">
                    {/* Close button in top-right */}
                    <button 
                        onClick={onCancel}
                        className="absolute top-4 right-4 p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-50 rounded-xl transition-all"
                        title="Kapat"
                    >
                        <X className="w-5 h-5" />
                    </button>

                    <div className="flex items-start gap-4 pr-6 sm:pr-0">
                        <div className={`w-12 h-12 rounded-2xl flex items-center justify-center shrink-0 shadow-sm ${getIconColor()}`}>
                            <AlertTriangle className="w-6 h-6" />
                        </div>
                        <div className="flex-1 mt-1">
                            <h3 className="text-lg font-bold text-gray-900 tracking-tight">{title}</h3>
                            <p className="text-sm text-gray-500 mt-2 leading-relaxed">{message}</p>
                        </div>
                    </div>
                </div>

                <div className="px-6 py-4 bg-gray-50 border-t border-gray-100 flex sm:justify-end justify-between gap-3 sm:rounded-b-3xl">
                    <button
                        onClick={onCancel}
                        className="flex-1 sm:flex-none px-5 py-2.5 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-xl hover:bg-gray-50 focus:outline-none focus:ring-4 focus:ring-gray-200 transition-all"
                    >
                        {cancelText}
                    </button>
                    <button
                        onClick={onConfirm}
                        className={`flex-1 sm:flex-none px-6 py-2.5 text-sm font-medium text-white rounded-xl focus:outline-none focus:ring-4 transition-all shadow-md ${getButtonColor()}`}
                    >
                        {confirmText}
                    </button>
                </div>
            </div>
        </div>
    );
}
