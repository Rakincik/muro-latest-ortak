"use client";

import { useEffect, useRef, useCallback } from "react";
import {
    HubConnectionBuilder,
    HubConnection,
    LogLevel,
} from "@microsoft/signalr";
import { useAuth } from "@/contexts/AuthContext";
import { type NotificationDto } from "@/lib/api";

interface UseNotificationsOptions {
    onReceive: (notif: NotificationDto) => void;
}

/**
 * SignalR ile backend'e bağlanır.
 * Yeni bildirim gelince `onReceive` callback'ini çağırır.
 * Bileşen unmount'ta bağlantı temizlenir.
 * 
 * Fix: onReceive ref ile stabilize edildi — gereksiz reconnect önlendi.
 */
export function useNotifications({ onReceive }: UseNotificationsOptions) {
    const { token } = useAuth();
    const connectionRef = useRef<HubConnection | null>(null);
    // Stabilize callback reference to prevent reconnections
    const onReceiveRef = useRef(onReceive);
    onReceiveRef.current = onReceive;

    const connect = useCallback(() => {
        if (!token || connectionRef.current) return;

        const API_URL =
            process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") ??
            "http://localhost:5292";

        const connection = new HubConnectionBuilder()
            .withUrl(`${API_URL}/hubs/notifications?access_token=${token}`, {
                accessTokenFactory: () => token,
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.Warning)
            .build();

        connection.on("ReceiveNotification", (notif: NotificationDto) => {
            onReceiveRef.current(notif);
        });

        connection.start().catch(console.warn);
        connectionRef.current = connection;
    }, [token]); // ✅ Only depends on token now — no reconnect on callback change

    useEffect(() => {
        connect();
        return () => {
            connectionRef.current?.stop();
            connectionRef.current = null;
        };
    }, [connect]);
}
