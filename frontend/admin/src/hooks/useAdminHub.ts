"use client";

import { useEffect, useRef } from "react";
import { HubConnectionBuilder, LogLevel } from "@microsoft/signalr";
import { useAuth } from "@/contexts/AuthContext";

interface AdminHubCallbacks {
    onDashboardUpdate?: (stats: Record<string, unknown>) => void;
    onLiveSessionUpdate?: (session: Record<string, unknown>) => void;
    onOnlineCountUpdate?: (data: { count: number }) => void;
}

/**
 * Admin dashboard'a özel WebSocket hook — real-time güncellemeler.
 * 
 * Channels:
 * - DashboardUpdate → istatistik güncellemesi
 * - LiveSessionUpdate → canlı ders başladı/bitti
 * - OnlineCountUpdate → anlık online admin sayısı
 */
export function useAdminHub(callbacks: AdminHubCallbacks) {
    const { token } = useAuth();
    const callbackRef = useRef(callbacks);
    callbackRef.current = callbacks;

    useEffect(() => {
        if (!token) return;

        const apiBase = (process.env.NEXT_PUBLIC_API_URL || "http://localhost:5292").replace("/api/v1", "");
        const connection = new HubConnectionBuilder()
            .withUrl(`${apiBase}/hubs/admin`, {
                accessTokenFactory: () => token,
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.None)
            .build();

        connection.on("DashboardUpdate", (stats) => {
            callbackRef.current.onDashboardUpdate?.(stats);
        });

        connection.on("LiveSessionUpdate", (session) => {
            callbackRef.current.onLiveSessionUpdate?.(session);
        });

        connection.on("OnlineCountUpdate", (data) => {
            callbackRef.current.onOnlineCountUpdate?.(data);
        });

        connection.start().catch(() => {
            // Admin hub bağlantı hatası — sessizce devam et
        });

        return () => {
            connection.stop().catch(() => { });
        };
    }, [token]);
}
