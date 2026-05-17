"use client";

import { useEffect } from "react";
import { useStatusBar } from "@/hooks/useStatusBar";
import DisableDevtool from "disable-devtool";

export default function NativeFeatures() {
    useStatusBar();

    useEffect(() => {
        // Enforce anti-debugging and devtools blocking on client
        DisableDevtool({
            disableMenu: true,
            disableSelect: false, // Allow selecting text
            disableCopy: false, // Allow copying text
            disableCut: false,
            clearLog: true,
        });
    }, []);

    return null;
}
