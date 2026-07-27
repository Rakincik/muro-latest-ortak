"use client";
import { useEffect } from "react";
import { tenantApi } from "@/lib/api";

export default function DynamicTitle() {
    useEffect(() => {
        tenantApi.getBranding()
            .then(res => {
                if (res && res.name) {
                    document.title = res.name;
                }
                if (res && res.faviconUrl) {
                    let link = document.querySelector("link[rel~='icon']") as HTMLLinkElement;
                    if (!link) {
                        link = document.createElement('link');
                        link.rel = 'icon';
                        document.head.appendChild(link);
                    }
                    link.href = res.faviconUrl;
                }
            })
            .catch(() => {});
    }, []);
    return null;
}
