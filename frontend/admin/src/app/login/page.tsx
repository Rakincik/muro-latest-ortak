"use client";

import { useEffect } from "react";

export default function LoginPage() {
    useEffect(() => {
        if (typeof window !== "undefined") {
            const currentHost = window.location.hostname;
            let studentHost = currentHost;
            
            if (currentHost.startsWith("3u-ad.")) {
                studentHost = currentHost.replace("3u-ad.", "3u.");
            } else if (currentHost.includes("-adm.")) {
                studentHost = currentHost.replace("-adm.", ".");
            } else if (currentHost.includes("-ad.")) {
                studentHost = currentHost.replace("-ad.", ".");
            } else if (currentHost.startsWith("admin.")) {
                studentHost = currentHost.replace("admin.", "");
            }
            
            if (currentHost === "localhost") {
                window.location.href = "http://localhost:3000/";
            } else {
                window.location.href = `https://${studentHost}/`;
            }
        }
    }, []);

    return (
        <div className="min-h-screen flex items-center justify-center bg-[#E2E8F0]/20">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#0A1931]"></div>
        </div>
    );
}
