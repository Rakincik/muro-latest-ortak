"use client";

import React, { Component, ErrorInfo, ReactNode } from "react";

interface Props {
    children: ReactNode;
    fallback?: ReactNode;
    pageName?: string;
}

interface State {
    hasError: boolean;
    error?: Error;
}

export class ErrorBoundary extends Component<Props, State> {
    constructor(props: Props) {
        super(props);
        this.state = { hasError: false };
    }

    static getDerivedStateFromError(error: Error): State {
        return { hasError: true, error };
    }

    componentDidCatch(error: Error, info: ErrorInfo) {
        console.error(`[ErrorBoundary] ${this.props.pageName ?? "Page"} crashed:`, error, info);
    }

    render() {
        if (this.state.hasError) {
            if (this.props.fallback) return this.props.fallback;
            return (
                <div className="flex flex-col items-center justify-center py-20 text-center">
                    <div className="w-16 h-16 rounded-2xl bg-red-50 flex items-center justify-center mb-4">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#ef4444" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="8" x2="12" y2="12" />
                            <line x1="12" y1="16" x2="12.01" y2="16" />
                        </svg>
                    </div>
                    <h2 className="text-[#1e293b] text-lg font-semibold mb-2">Bir şeyler ters gitti</h2>
                    <p className="text-[#64748b] text-sm mb-6 max-w-sm">
                        {this.props.pageName ? `"${this.props.pageName}" sayfası` : "Bu sayfa"} yüklenirken beklenmedik bir hata oluştu.
                    </p>
                    <button
                        onClick={() => this.setState({ hasError: false, error: undefined })}
                        className="px-5 py-2.5 bg-[#1B3B6F] hover:bg-[#15305a] text-white text-sm font-medium rounded-xl transition-all shadow-sm"
                    >
                        Tekrar Dene
                    </button>
                    {process.env.NODE_ENV === "development" && this.state.error && (
                        <pre className="mt-6 text-left text-xs text-red-600 bg-red-50 border border-red-200 rounded-xl p-4 max-w-lg overflow-auto">
                            {this.state.error.message}
                            {"\n"}
                            {this.state.error.stack}
                        </pre>
                    )}
                </div>
            );
        }
        return this.props.children;
    }
}
