"use client";

import { useEffect, useRef } from "react";
import { useRouter } from "next/navigation";

/**
 * Deep Linking & Back Button handler for Capacitor native apps.
 * 
 * Handles:
 * 1. Custom URL scheme: muro://dashboard/courses/123
 * 2. Universal links: https://app.murolms.com/dashboard/live
 * 3. Push notification deep links (via data.route)
 * 4. Android hardware back button
 * 
 * On browser: silently skips.
 */

/** Map external deep link paths to internal Next.js routes */
function resolveDeepLink(url: string): string | null {
    try {
        // Handle custom scheme: muro://dashboard/courses
        // Handle universal link: https://app.murolms.com/dashboard/courses
        let path = "";

        if (url.startsWith("muro://")) {
            path = "/" + url.replace("muro://", "").replace(/^\/+/, "");
        } else {
            const parsed = new URL(url);
            path = parsed.pathname;
        }

        // Clean up path
        path = path.replace(/\/+$/, "") || "/dashboard";

        // Known route patterns
        const validRoutes = [
            /^\/dashboard$/,
            /^\/dashboard\/courses$/,
            /^\/dashboard\/courses\/[a-zA-Z0-9-]+$/,
            /^\/dashboard\/live$/,
            /^\/dashboard\/calendar$/,
            /^\/dashboard\/profile$/,
            /^\/dashboard\/notifications$/,
            /^\/dashboard\/assignments$/,
            /^\/dashboard\/attendance$/,
            /^\/dashboard\/exams$/,
            /^\/dashboard\/podcast$/,
            /^\/dashboard\/questions$/,
            /^\/dashboard\/notes$/,
        ];

        if (validRoutes.some(r => r.test(path))) {
            return path;
        }

        // Default: go to dashboard
        if (process.env.NODE_ENV === "development") console.log("🔗 Unknown deep link path:", path);
        return "/dashboard";
    } catch {
        return "/dashboard";
    }
}

export function useDeepLink() {
    const router = useRouter();
    const initialized = useRef(false);

    useEffect(() => {
        if (initialized.current) return;
        initialized.current = true;

        (async () => {
            try {
                const { Capacitor } = await import("@capacitor/core");
                if (!Capacitor.isNativePlatform()) return;

                const { App } = await import("@capacitor/app");

                // ── Deep Link: app opened via URL ──
                App.addListener("appUrlOpen", (event: { url: string }) => {
                    if (process.env.NODE_ENV === "development") console.log("🔗 Deep link opened:", event.url);
                    const route = resolveDeepLink(event.url);
                    if (route) {
                        router.push(route);
                    }
                });

                // ── Android Back Button ──
                App.addListener("backButton", ({ canGoBack }: { canGoBack: boolean }) => {
                    if (canGoBack) {
                        window.history.back();
                    } else {
                        // At root — minimize app instead of closing
                        App.minimizeApp();
                    }
                });

                // ── App State (resume from background) ──
                App.addListener("appStateChange", (state: { isActive: boolean }) => {
                    if (state.isActive) {
                        if (process.env.NODE_ENV === "development") console.log("📱 App resumed from background");
                        // Dispatch event for components to refresh data
                        window.dispatchEvent(new CustomEvent("app:resumed"));
                    }
                });

                // Check if app was launched with a deep link
                const launchUrl = await App.getLaunchUrl();
                if (launchUrl?.url) {
                    if (process.env.NODE_ENV === "development") console.log("🔗 App launched with deep link:", launchUrl.url);
                    const route = resolveDeepLink(launchUrl.url);
                    if (route && route !== "/dashboard") {
                        // Small delay to let the app initialize first
                        setTimeout(() => router.push(route), 500);
                    }
                }

                if (process.env.NODE_ENV === "development") console.log("🔗 Deep linking initialized");
            } catch {
                // Not in Capacitor or plugin not available
            }
        })();
    }, [router]);
}
