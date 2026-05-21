"use client";

import { useEffect, useRef } from "react";
import { HubConnectionBuilder, LogLevel } from "@microsoft/signalr";
import { useAuth } from "@/contexts/AuthContext";

interface StudentHubCallbacks {
    onLiveSessionStarted?: (data: { sessionTitle: string; courseTitle: string; courseId: string; sessionId: string }) => void;
    onLiveSessionEnded?: (data: { sessionTitle: string }) => void;
    onNewNotification?: (data: { title: string; body: string }) => void;
}

/**
 * Öğrenci SignalR hub — canlı ders bildirimleri.
 * Backend NotificationHub üzerinden gelen mesajları dinler.
 * Canlı ders başladığında toast göstermek için kullanılır.
 */
export function useStudentHub(callbacks: StudentHubCallbacks) {
    const { token } = useAuth();
    const callbackRef = useRef(callbacks);
    callbackRef.current = callbacks;

    useEffect(() => {
        if (!token) return;

        const apiBase = process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") || "http://localhost:5292";
        const connection = new HubConnectionBuilder()
            .withUrl(`${apiBase}/hubs/notifications`, {
                accessTokenFactory: () => token,
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.None)
            .build();

        // Canlı ders başladığında
        connection.on("LiveSessionStarted", (data) => {
            callbackRef.current.onLiveSessionStarted?.(data);
        });

        // Canlı ders bittiğinde
        connection.on("LiveSessionEnded", (data) => {
            callbackRef.current.onLiveSessionEnded?.(data);
        });

        // Genel bildirim
        connection.on("ReceiveNotification", (data) => {
            callbackRef.current.onNewNotification?.(data);
        });

        connection.start().catch(() => {
            // SignalR bağlantı hatası — sessizce devam et
        });

        return () => {
            connection.stop().catch(() => { });
        };
    }, [token]);
}
