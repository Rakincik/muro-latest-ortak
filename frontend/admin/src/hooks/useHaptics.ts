"use client";

/**
 * Haptic feedback utility for Capacitor native apps.
 * On browser / non-native: all functions are no-ops.
 */

type ImpactStyle = "Heavy" | "Medium" | "Light";

let _Haptics: any = null;
let _isNative = false;

// Lazy-load Capacitor modules only once
const init = async () => {
    if (_Haptics !== null) return;
    try {
        // @ts-ignore
        const { Capacitor } = await import("@capacitor/core");
        if (Capacitor.isNativePlatform()) {
            // @ts-ignore
            const mod = await import("@capacitor/haptics");
            _Haptics = mod.Haptics;
            _isNative = true;
        }
    } catch {
        // Not in Capacitor environment — silent no-op
    }
};

// Auto-init on module load
if (typeof window !== "undefined") init();

/** Light tap — tab switches, minor interactions */
export async function lightTap() {
    await init();
    if (!_isNative || !_Haptics) return;
    try {
        await _Haptics.impact({ style: "Light" as ImpactStyle });
    } catch { /* */ }
}

/** Medium tap — pull-to-refresh trigger, confirmations */
export async function mediumTap() {
    await init();
    if (!_isNative || !_Haptics) return;
    try {
        await _Haptics.impact({ style: "Medium" as ImpactStyle });
    } catch { /* */ }
}

/** Heavy tap — destructive actions, errors */
export async function heavyTap() {
    await init();
    if (!_isNative || !_Haptics) return;
    try {
        await _Haptics.impact({ style: "Heavy" as ImpactStyle });
    } catch { /* */ }
}

/** Selection tap — picker scrolls, toggle switches */
export async function selectionTap() {
    await init();
    if (!_isNative || !_Haptics) return;
    try {
        await _Haptics.selectionStart();
        await _Haptics.selectionChanged();
        await _Haptics.selectionEnd();
    } catch { /* */ }
}

/** Success notification vibration */
export async function successVibrate() {
    await init();
    if (!_isNative || !_Haptics) return;
    try {
        await _Haptics.notification({ type: "SUCCESS" });
    } catch { /* */ }
}
