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
                    <p className="text-5xl mb-4">⚠️</p>
                    <h2 className="text-white font-semibold mb-2">Bir şeyler ters gitti</h2>
                    <p className="text-[#A9A9A9] text-sm mb-6 max-w-sm">
                        {this.props.pageName ? `${this.props.pageName} sayfası` : "Bu sayfa"} yüklenirken hata oluştu.
                    </p>
                    <button
                        onClick={() => this.setState({ hasError: false, error: undefined })}
                        className="px-5 py-2 bg-[#1B3B6F] hover:bg-[#1B3B6F] text-white text-sm font-medium rounded-xl transition-all"
                    >
                        Tekrar Dene
                    </button>
                    {process.env.NODE_ENV === "development" && this.state.error && (
                        <pre className="mt-6 text-left text-xs text-red-400 bg-red-500/5 border border-red-500/20 rounded-xl p-4 max-w-lg overflow-auto">
                            {this.state.error.message}
                        </pre>
                    )}
                </div>
            );
        }
        return this.props.children;
    }
}
