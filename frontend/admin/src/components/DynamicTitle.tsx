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
        if (!brandName) return;

        const updateMetadata = () => {
            const currentTitle = document.title;
            if (currentTitle.includes("Yönetim Paneli")) {
                const newTitle = currentTitle.replace("Yönetim Paneli", brandName);
                if (document.title !== newTitle) {
                    document.title = newTitle;
                }
            } else if (!currentTitle) {
                document.title = brandName;
            }

            const metaDesc = document.querySelector("meta[name='description']") as HTMLMetaElement;
            if (metaDesc) {
                const targetDesc = `${brandName} Uzaktan Eğitim Platformu`;
                if (metaDesc.content !== targetDesc) {
                    metaDesc.content = targetDesc;
                }
            }
        };

        // Run initially
        updateMetadata();

        // Listen for Next.js metadata overrides
        const target = document.querySelector('title');
        if (!target) return;

        const observer = new MutationObserver(() => {
            updateMetadata();
        });

        observer.observe(target, {
            childList: true,
            characterData: true,
            subtree: true
        });

        return () => observer.disconnect();
    }, [pathname, brandName]);

    useEffect(() => {
        if (faviconUrl) {
            let link = document.querySelector("link[rel~='icon']") as HTMLLinkElement;
            if (!link) {
                link = document.createElement('link');
                link.rel = 'icon';
                document.head.appendChild(link);
            }
            link.href = faviconUrl;
        }
    }, [pathname, faviconUrl]);

    return null;
}
