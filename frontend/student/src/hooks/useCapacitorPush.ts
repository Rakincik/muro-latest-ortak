"use client";

import { useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/contexts/AuthContext";
import { notificationApi } from "@/lib/api";

/**
 * Registers push notification listeners on Capacitor native platforms.
 * On browser: silently skips everything.
 *
 * Flow:
 *  1. Check permissions → request if needed
 *  2. Register → get FCM token
 *  3. Listen for foreground notifications (toast)
 *  4. Listen for tap-on-notification → navigate
 */
export function useCapacitorPush() {
    const router = useRouter();
    const { token } = useAuth();
    const initialized = useRef(false);
    const fcmTokenRef = useRef<string | null>(null);

    // Effect for handling the push token when auth becomes available
    useEffect(() => {
        if (token && fcmTokenRef.current) {
            notificationApi.registerDeviceToken(token, fcmTokenRef.current).catch(err => {
                if (process.env.NODE_ENV === "development") console.error("📱 Failed to register push token:", err);
            });
        }
    }, [token]);

    useEffect(() => {
        if (initialized.current) return;
        initialized.current = true;

        (async () => {
            try {
                // Dynamic import to avoid SSR issues
                const { Capacitor } = await import(/* webpackIgnore: true */ "@capacitor/core");
                if (!Capacitor.isNativePlatform()) return;

                const { PushNotifications } = await import(/* webpackIgnore: true */ "@capacitor/push-notifications");

                // Check / request permission
                let perm = await PushNotifications.checkPermissions();
                if (perm.receive === "prompt") {
                    perm = await PushNotifications.requestPermissions();
                }
                if (perm.receive !== "granted") {
                    if (process.env.NODE_ENV === "development") console.log("📱 Push permission denied");
                    return;
                }

                // Register
                await PushNotifications.register();

                // Token received
                PushNotifications.addListener("registration", (tokenObj: { value: string }) => {
                    if (process.env.NODE_ENV === "development") console.log("📱 Push token:", tokenObj.value);
                    fcmTokenRef.current = tokenObj.value;
                    
                    // If already logged in, send immediately
                    if (token) {
                        notificationApi.registerDeviceToken(token, tokenObj.value).catch(err => {
                            if (process.env.NODE_ENV === "development") console.error("📱 Failed to register push token:", err);
                        });
                    }
                });

                // Registration error
                PushNotifications.addListener("registrationError", (err: { error: string }) => {
                    console.error("📱 Push registration error:", err);
                });

                // Foreground notification received
                PushNotifications.addListener("pushNotificationReceived", (notification: { title?: string; body?: string; data?: Record<string, string> }) => {
                    if (process.env.NODE_ENV === "development") console.log("📱 Push received (foreground):", notification);
                    // Show as in-app toast — dispatch custom event
                    window.dispatchEvent(new CustomEvent("push:received", {
                        detail: {
                            title: notification.title || "Bildirim",
                            body: notification.body || "",
                            data: notification.data,
                        }
                    }));
                });

                // Notification tapped
                PushNotifications.addListener("pushNotificationActionPerformed", (action: { notification?: { data?: Record<string, string> } }) => {
                    if (process.env.NODE_ENV === "development") console.log("📱 Push tapped:", action);
                    const data = action.notification?.data;
                    if (data?.route) {
                        router.push(data.route);
                    } else {
                        router.push("/dashboard/notifications");
                    }
                });

                if (process.env.NODE_ENV === "development") console.log("📱 Push notifications initialized");
            } catch {
                // Not in Capacitor or plugin not available
            }
        })();
    }, [router]);
}
