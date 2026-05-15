"use client";

import { useState, useEffect } from "react";
import { heavyTap } from "@/hooks/useHaptics";

export default function OfflineIndicator() {
    const [isOffline, setIsOffline] = useState(false);

    useEffect(() => {
        let networkListener: any = null;

        const initNetwork = async () => {
            try {
                const { Capacitor } = await import("@capacitor/core");
                if (Capacitor.isNativePlatform()) {
                    const { Network } = await import("@capacitor/network");
                    
                    // Initial status
                    const status = await Network.getStatus();
                    setIsOffline(!status.connected);

                    // Listener
                    networkListener = await Network.addListener('networkStatusChange', status => {
                        setIsOffline(!status.connected);
                        if (!status.connected) {
                            heavyTap();
                        }
                    });
                } else {
                    // Web fallback
                    setIsOffline(!navigator.onLine);
                    const handleOffline = () => { setIsOffline(true); heavyTap(); };
                    const handleOnline = () => setIsOffline(false);
                    
                    window.addEventListener("offline", handleOffline);
                    window.addEventListener("online", handleOnline);
                    
                    networkListener = {
                        remove: () => {
                            window.removeEventListener("offline", handleOffline);
                            window.removeEventListener("online", handleOnline);
                        }
                    };
                }
            } catch {
                // Fallback
                setIsOffline(!navigator.onLine);
            }
        };

        initNetwork();

        return () => {
            if (networkListener && typeof networkListener.remove === 'function') {
                networkListener.remove();
            }
        };
    }, []);

    if (!isOffline) return null;

    return (
        <div className="fixed top-0 left-0 right-0 z-[999] bg-orange-500/90 backdrop-blur-md shadow-lg transition-transform duration-300 translate-y-0"
             style={{ paddingTop: "env(safe-area-inset-top, 0px)" }}>
            <div className="flex items-center justify-center gap-2 py-2.5 px-4">
                <svg viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth={2} className="w-4 h-4 flex-shrink-0 animate-pulse">
                    <path strokeLinecap="round" strokeLinejoin="round" d="M8.288 15.038a5.25 5.25 0 0 1 7.424 0M5.106 11.856c3.807-3.808 9.98-3.808 13.788 0M1.924 8.674c5.565-5.565 14.587-5.565 20.152 0" />
                    <line x1="4" y1="4" x2="20" y2="20" stroke="white" strokeWidth="2" strokeLinecap="round" />
                </svg>
                <p className="text-white text-xs font-medium tracking-wide">
                    Çevrimdışı moddasınız. Kayıtlı verilere erişebilirsiniz.
                </p>
            </div>
        </div>
    );
}
