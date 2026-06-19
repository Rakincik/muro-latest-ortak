"use client";

import { createContext, useContext, useState, useEffect, useCallback, useRef, ReactNode } from "react";
import { authApi, UserDto, clearCache } from "@/lib/api";

interface AuthContextType {
    user: UserDto | null;
    token: string | null;
    isLoading: boolean;
    login: (email: string, password: string) => Promise<void>;
    logout: () => void;
    currentTenantId: string | null;
    setCurrentTenantId: (id: string) => void;
    isDevMode: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

const DEV_MODE = process.env.NEXT_PUBLIC_DEV_AUTOLOGIN === "true";
const DEV_EMAIL = process.env.NEXT_PUBLIC_DEV_EMAIL || "ogrenci@demo.com";
const DEV_PASSWORD = process.env.NEXT_PUBLIC_DEV_PASSWORD || "123456";

function getActiveTenantId(user: UserDto): string | null {
    const tenants = user.tenants ?? [];
    const active = tenants.filter(t => t.status === "active");
    return (active[0] ?? tenants[0])?.tenantId ?? null;
}

export function AuthProvider({ children }: { children: ReactNode }) {
    const [user, setUser] = useState<UserDto | null>(null);
    const [token, setToken] = useState<string | null>(null);
    const [currentTenantId, setCurrentTenantId] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(true);

    const applyAuth = (res: { token: string; refreshToken: string; user: UserDto }) => {
        setToken(res.token);
        setUser(res.user);
        localStorage.setItem("muro_student_token", res.token);
        localStorage.setItem("muro_student_refresh", res.refreshToken);
        const tid = getActiveTenantId(res.user);
        if (tid) setCurrentTenantId(tid);
    };

    // session:kicked: başka cihazdan giriş yapıldığında api.ts buraya event atar
    useEffect(() => {
        const handler = (e: Event) => {
            const detail = (e as CustomEvent).detail;
            const msg = typeof detail === 'string' ? detail : (detail?.message ?? "Hesabınıza başka bir cihazdan giriş yapıldı. Oturumunuz kapatıldı.");
            const failedToken = typeof detail === 'object' ? detail?.token : null;
            
            const currentToken = localStorage.getItem("muro_student_token");
            if (failedToken && currentToken && failedToken !== currentToken) {
                // Biz başka sekmede YENİ bir giriş yapmışız, bu sekme eski token yüzünden patlamış!
                window.location.reload();
                return;
            }

            logout();
            window.dispatchEvent(new CustomEvent("toast:show", { detail: { message: msg as string, type: "warning", title: "🔐 Güvenlik Uyarısı" } }));
        };
        window.addEventListener("session:kicked", handler);
        return () => window.removeEventListener("session:kicked", handler);
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    useEffect(() => {
        const init = async () => {
            const saved = localStorage.getItem("muro_student_token");
            if (saved) {
                try {
                    const u = await authApi.me(saved);
                    setToken(saved);
                    setUser(u);
                    const tid = getActiveTenantId(u);
                    if (tid) setCurrentTenantId(tid);
                    return;
                } catch {
                    // Token geçersiz — refresh dene
                    const refresh = localStorage.getItem("muro_student_refresh");
                    if (refresh) {
                        try {
                            const res = await authApi.refresh(refresh);
                            applyAuth(res);
                            return;
                        } catch {
                            localStorage.removeItem("muro_student_refresh");
                        }
                    }
                    localStorage.removeItem("muro_student_token");
                }
            }
            if (DEV_MODE) {
                try {
                    const res = await authApi.login(DEV_EMAIL, DEV_PASSWORD);
                    applyAuth(res);
                } catch {
                    // sessizce geç
                }
            }
        };
        init().finally(async () => {
            setIsLoading(false);
            try {
                const { Capacitor } = await import("@capacitor/core");
                if (Capacitor.isNativePlatform()) {
                    const { SplashScreen } = await import("@capacitor/splash-screen");
                    await SplashScreen.hide();
                }
            } catch { /* ignore */ }
        });
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    // 🚀 Proactive Token Refresh — visibility-aware (arka planda çalışmaz, pil tasarrufu)
    const tokenRef = useRef(token);
    tokenRef.current = token;

    const checkTokenRefresh = useCallback(async () => {
        const currentToken = tokenRef.current;
        if (!currentToken) return;
        try {
            const payload = JSON.parse(atob(currentToken.split(".")[1]));
            const exp = payload.exp * 1000;
            const remaining = exp - Date.now();

            if (remaining < 5 * 60_000 && remaining > 0) {
                const refresh = localStorage.getItem("muro_student_refresh");
                if (refresh) {
                    try {
                        const res = await authApi.refresh(refresh);
                        applyAuth(res);
                        console.log("🔄 Token otomatik yenilendi");
                    } catch {
                        logout();
                        window.dispatchEvent(new CustomEvent("toast:show", { detail: { message: "Oturumunuz sona erdi. Lütfen tekrar giriş yapın.", type: "warning", title: "🔐 Oturum Süresi" } }));
                    }
                }
            } else if (remaining <= 0) {
                logout();
                setTimeout(() => alert("🔐 Oturumunuz sona erdi. Lütfen tekrar giriş yapın."), 200);
            }
        } catch { /* invalid token format */ }
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    // Visibility-aware: pause when app is backgrounded (saves battery on mobile)
    useEffect(() => {
        if (!token) return;
        let interval: ReturnType<typeof setInterval> | null = null;

        const start = () => {
            if (interval) return;
            checkTokenRefresh(); // check immediately on becoming visible
            interval = setInterval(checkTokenRefresh, 60_000); // 60s instead of 30s
        };
        const stop = () => {
            if (interval) { clearInterval(interval); interval = null; }
        };
        const onVisibility = () => document.hidden ? stop() : start();

        if (!document.hidden) start();
        document.addEventListener("visibilitychange", onVisibility);
        return () => {
            stop();
            document.removeEventListener("visibilitychange", onVisibility);
        };
    }, [token, checkTokenRefresh]);

    const login = async (email: string, password: string) => {
        const res = await authApi.login(email, password);
        applyAuth(res);
    };

    const logout = () => {
        setToken(null);
        setUser(null);
        setCurrentTenantId(null);
        localStorage.removeItem("muro_student_token");
        localStorage.removeItem("muro_student_refresh");
        // Admin key'lerini de temizle — redirect loop önle
        localStorage.removeItem("muro_token");
        localStorage.removeItem("muro_refresh");
        clearCache(); // Clear API cache on logout
    };

    return (
        <AuthContext.Provider value={{
            user, token, isLoading, login, logout,
            currentTenantId, setCurrentTenantId,
            isDevMode: DEV_MODE,
        }}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const ctx = useContext(AuthContext);
    if (!ctx) throw new Error("useAuth must be used within AuthProvider");
    return ctx;
}
