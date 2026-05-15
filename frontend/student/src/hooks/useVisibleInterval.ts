"use client";

import { useEffect, useRef, useCallback } from "react";

/**
 * Visibility-aware interval hook.
 * Stops the interval when the page/tab is hidden (background),
 * resumes when visible again. Critical for mobile Capacitor apps
 * to save battery and avoid unnecessary network requests.
 *
 * Also fires immediately when becoming visible again.
 */
export function useVisibleInterval(
    callback: () => void,
    delayMs: number | null,
    options: { fireOnVisible?: boolean } = { fireOnVisible: true },
) {
    const savedCallback = useRef(callback);
    const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

    // Keep callback ref fresh
    useEffect(() => {
        savedCallback.current = callback;
    }, [callback]);

    const start = useCallback(() => {
        if (intervalRef.current) return;
        if (delayMs === null) return;
        intervalRef.current = setInterval(() => savedCallback.current(), delayMs);
    }, [delayMs]);

    const stop = useCallback(() => {
        if (intervalRef.current) {
            clearInterval(intervalRef.current);
            intervalRef.current = null;
        }
    }, []);

    useEffect(() => {
        if (delayMs === null) return;

        const handleVisibility = () => {
            if (document.hidden) {
                stop();
            } else {
                if (options.fireOnVisible) savedCallback.current();
                start();
            }
        };

        // Start if currently visible
        if (!document.hidden) start();

        document.addEventListener("visibilitychange", handleVisibility);
        return () => {
            stop();
            document.removeEventListener("visibilitychange", handleVisibility);
        };
    }, [delayMs, start, stop, options.fireOnVisible]);
}
