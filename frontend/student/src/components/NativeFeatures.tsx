"use client";

import { useEffect } from "react";
import { useStatusBar } from "@/hooks/useStatusBar";
// import DisableDevtool removed to prevent Object.defineProperty crashes.
export default function NativeFeatures() {
    useStatusBar();

    useEffect(() => {
        // disable-devtool Next.js 14+ development sunucusunda 'Object.defineProperty called on non-object'
        // hatasına neden olduğu için devredışı bırakıldı. Yerleşik antiDebug.ts zaten devrede.
        /* DisableDevtool({
            disableMenu: true,
            disableSelect: false,
            disableCopy: false,
            disableCut: false,
            clearLog: true,
        }); */
    }, []);

    return null;
}
