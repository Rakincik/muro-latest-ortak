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

    // 3. DevTools / Debugger Trap
    // This constantly throws a debugger statement. 
    // If DevTools is open, it pauses execution and causes a delay.
    let debuggerInterval: NodeJS.Timeout;
    const startDebuggerTrap = () => {
        let isDevToolsOpen = false;
        
        debuggerInterval = setInterval(() => {
            const start = performance.now();
            
            // The debugger statement will halt execution if DevTools is open
            // eslint-disable-next-line no-debugger
            debugger;
            
            const end = performance.now();
            
            // If the execution took more than 100ms, it means the debugger paused it
            if (end - start > 100) {
                isDevToolsOpen = true;
                onViolation();
            }
        }, 1000);
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
