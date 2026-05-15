"use client";

import { useEffect, useRef } from "react";

export function useStatusBar() {
    const initialized = useRef(false);

    useEffect(() => {
        if (initialized.current) return;
        initialized.current = true;

        const initStatusBar = async () => {
            try {
                const { Capacitor } = await import("@capacitor/core");
                if (Capacitor.isNativePlatform()) {
                    const { StatusBar, Style } = await import("@capacitor/status-bar");
                    // Set status bar text to light (for dark backgrounds)
                    await StatusBar.setStyle({ style: Style.Dark });
                    // Set background color to MURO Navy
                    await StatusBar.setBackgroundColor({ color: "#0A1931" });
                    // Optional: You could use StatusBar.setOverlaysWebView({ overlay: true }) if you want the app to draw under the status bar, but setting the color is safer for layouts.
                }
            } catch (err) {
                if (process.env.NODE_ENV === "development") {
                    console.error("📱 Failed to initialize status bar:", err);
                }
            }
        };

        initStatusBar();
    }, []);
}
