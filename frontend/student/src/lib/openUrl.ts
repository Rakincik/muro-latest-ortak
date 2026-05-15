/**
 * Opens a URL using Capacitor's in-app browser on native platforms,
 * or window.open() in regular browsers.
 *
 * On native: opens an in-app browser overlay — user can close it to return.
 * On browser: opens a new tab as usual.
 */
export async function openUrl(url: string): Promise<void> {
    try {
        const { Capacitor } = await import("@capacitor/core");
        if (Capacitor.isNativePlatform()) {
            const { Browser } = await import("@capacitor/browser");
            await Browser.open({
                url,
                presentationStyle: "fullscreen",
                toolbarColor: "#0A1931",
            });
            return;
        }
    } catch {
        // Not in Capacitor — fall through to window.open
    }
    window.open(url, "_blank", "noopener");
}
