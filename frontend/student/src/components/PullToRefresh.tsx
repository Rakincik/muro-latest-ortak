"use client";

import { useRef, useState, useCallback, type ReactNode } from "react";
import { useRouter } from "next/navigation";
import { mediumTap } from "@/hooks/useHaptics";

interface PullToRefreshProps {
    children: ReactNode;
    /** Custom refresh handler instead of router.refresh() */
    onRefresh?: () => Promise<void> | void;
}

const THRESHOLD = 80;   // px needed to trigger refresh
const MAX_PULL = 120;   // max pull distance
const RESISTANCE = 2.5; // pull resistance factor

export default function PullToRefresh({ children, onRefresh }: PullToRefreshProps) {
    const router = useRouter();
    const containerRef = useRef<HTMLDivElement>(null);
    const startY = useRef(0);
    const isPulling = useRef(false);
    const [pullDistance, setPullDistance] = useState(0);
    const [isRefreshing, setIsRefreshing] = useState(false);

    const isAtTop = useCallback(() => {
        const el = containerRef.current;
        if (!el) return true;
        // Check if container or window is scrolled to top
        return window.scrollY <= 0;
    }, []);

    const handleTouchStart = useCallback((e: React.TouchEvent) => {
        if (!isAtTop() || isRefreshing) return;
        startY.current = e.touches[0].clientY;
        isPulling.current = true;
    }, [isAtTop, isRefreshing]);

    const handleTouchMove = useCallback((e: React.TouchEvent) => {
        if (!isPulling.current || isRefreshing) return;
        const delta = e.touches[0].clientY - startY.current;
        if (delta <= 0) {
            setPullDistance(0);
            return;
        }
        const adjusted = Math.min(delta / RESISTANCE, MAX_PULL);
        setPullDistance(adjusted);
    }, [isRefreshing]);

    const handleTouchEnd = useCallback(async () => {
        if (!isPulling.current) return;
        isPulling.current = false;

        if (pullDistance >= THRESHOLD && !isRefreshing) {
            setIsRefreshing(true);
            mediumTap();
            try {
                if (onRefresh) {
                    await onRefresh();
                } else {
                    router.refresh();
                    // Small delay to show the spinner
                    await new Promise(r => setTimeout(r, 800));
                }
            } catch { /* */ }
            setIsRefreshing(false);
        }
        setPullDistance(0);
    }, [pullDistance, isRefreshing, onRefresh, router]);

    const progress = Math.min(pullDistance / THRESHOLD, 1);
    const showIndicator = pullDistance > 10 || isRefreshing;

    return (
        <div
            ref={containerRef}
            onTouchStart={handleTouchStart}
            onTouchMove={handleTouchMove}
            onTouchEnd={handleTouchEnd}
            className="pull-to-refresh-container"
        >
            {/* Pull indicator */}
            <div
                className="pull-indicator"
                style={{
                    height: isRefreshing ? 48 : pullDistance > 10 ? pullDistance : 0,
                    opacity: showIndicator ? 1 : 0,
                    transition: isPulling.current ? "none" : "all 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
                }}
            >
                <div
                    className="pull-spinner-wrapper"
                    style={{
                        transform: `rotate(${progress * 360}deg) scale(${0.5 + progress * 0.5})`,
                    }}
                >
                    {isRefreshing ? (
                        <svg className="pull-spinner animate-spin" viewBox="0 0 24 24" fill="none">
                            <circle cx="12" cy="12" r="10" stroke="#1B3B6F" strokeWidth="3" strokeLinecap="round" strokeDasharray="60" strokeDashoffset="20" />
                        </svg>
                    ) : (
                        <svg className="pull-spinner" viewBox="0 0 24 24" fill="none" stroke="#1B3B6F" strokeWidth="2.5">
                            <path strokeLinecap="round" strokeLinejoin="round"
                                d="M19.5 13.5 12 21m0 0-7.5-7.5M12 21V3"
                                style={{
                                    opacity: progress,
                                    transform: progress >= 1 ? "rotate(180deg)" : "none",
                                    transformOrigin: "center",
                                    transition: "transform 0.15s ease",
                                }}
                            />
                        </svg>
                    )}
                </div>
            </div>

            {/* Content */}
            <div
                style={{
                    transform: pullDistance > 10 ? `translateY(${pullDistance * 0.3}px)` : "none",
                    transition: isPulling.current ? "none" : "transform 0.3s cubic-bezier(0.4, 0, 0.2, 1)",
                }}
            >
                {children}
            </div>
        </div>
    );
}
