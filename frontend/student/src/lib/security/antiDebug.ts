"use client";

/**
 * Initializes anti-debugging, right-click, and shortcut protections.
 * Returns a cleanup function.
 * @param onViolation Callback triggered when a DevTools opening is detected.
 */
export function initSecurityKiosk(onViolation: () => void): () => void {
    // 1. Prevent Right-Click
    const handleContextMenu = (e: MouseEvent) => {
        e.preventDefault();
    };

    // 2. Prevent Keyboard Shortcuts (F12, Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U, etc.)
    const handleKeyDown = (e: KeyboardEvent) => {
        // F12
        if (e.keyCode === 123) {
            e.preventDefault();
            onViolation();
        }
        // Ctrl+Shift+I / J / C
        if (e.ctrlKey && e.shiftKey && (e.keyCode === 73 || e.keyCode === 74 || e.keyCode === 67)) {
            e.preventDefault();
            onViolation();
        }
        // Ctrl+U (View Source)
        if (e.ctrlKey && e.keyCode === 85) {
            e.preventDefault();
            onViolation();
        }
    };

    // 3. DevTools / Debugger Trap (Only on Desktop, with false-positive protection)
    let debuggerInterval: NodeJS.Timeout;
    const startDebuggerTrap = () => {
        // Mobil ve tabletlerde F12/DevTools yoktur; CPU lag'leri ve video buffer gecikmeleri
        // öğrenciyi dersten atmasın diye mobilde debugger tuzağını pasif yapıyoruz.
        if (typeof window === "undefined") return;
        const isMobileOrTablet = /Mobi|Android|iPhone|iPad|iPod|Tablet/i.test(navigator.userAgent) || 
                                 (typeof window !== "undefined" && window.innerWidth < 1024);
        if (isMobileOrTablet) return;

        let consecutiveLagCount = 0;
        
        debuggerInterval = setInterval(() => {
            const start = performance.now();
            
            // eslint-disable-next-line no-debugger
            debugger;
            
            const end = performance.now();
            const elapsed = end - start;
            
            // DevTools açıksa debugger execution'ı durdurur ve elapsed > 250ms olur.
            // Tek seferlik CPU/video takılmalarını önlemek için arka arkaya 3 kez kontrol ediyoruz.
            if (elapsed > 250) {
                consecutiveLagCount++;
                if (consecutiveLagCount >= 3) {
                    onViolation();
                }
            } else {
                consecutiveLagCount = 0;
            }
        }, 2000);
    };

    // Attach events
    document.addEventListener("contextmenu", handleContextMenu);
    document.addEventListener("keydown", handleKeyDown);
    
    // Start trap
    startDebuggerTrap();

    // Return cleanup
    return () => {
        document.removeEventListener("contextmenu", handleContextMenu);
        document.removeEventListener("keydown", handleKeyDown);
        if (debuggerInterval) clearInterval(debuggerInterval);
    };
}
