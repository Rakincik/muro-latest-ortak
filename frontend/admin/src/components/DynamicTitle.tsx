"use client";
import { useEffect, useState } from "react";
import { usePathname } from "next/navigation";
import { tenantApi } from "@/lib/api";

export default function DynamicTitle() {
    const pathname = usePathname();
    const [brandName, setBrandName] = useState<string | null>(null);
    const [faviconUrl, setFaviconUrl] = useState<string | null>(null);

    useEffect(() => {
        tenantApi.getBranding()
            .then(res => {
                if (res && res.name) {
                    setBrandName(res.name);
                }
                if (res && res.faviconUrl) {
                    setFaviconUrl(res.faviconUrl);
                }
            })
            .catch(() => {});
    }, []);

    useEffect(() => {
        if (brandName) {
            document.title = brandName;
        }
        if (faviconUrl) {
            let link = document.querySelector("link[rel~='icon']") as HTMLLinkElement;
            if (!link) {
                link = document.createElement('link');
                link.rel = 'icon';
                document.head.appendChild(link);
            }
            link.href = faviconUrl;
        }
    }, [pathname, brandName, faviconUrl]);

    return null;
}
