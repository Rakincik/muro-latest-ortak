"use client";

import {
    createContext,
    useContext,
    useState,
    useEffect,
    ReactNode,
} from "react";
import { authApi, UserDto, clearCache } from "@/lib/api";

// ── DEV MODE: Backend olmadan demo giriş ──
const DEV_MODE = false;
const DEV_USER: UserDto = {
    id: "dev-admin-001",
    email: "admin@muro.com",
    firstName: "Admin",
    lastName: "Kullanıcı",
    phone: null,
    role: "Admin",
    studentType: null,
    demoExpiresAt: null,
    isActive: true,
    createdAt: new Date().toISOString(),
    lastLoginAt: null,
    groupNames: [],
    tenants: [{ tenantId: "tenant-001", tenantName: "MURO Eğitim", tenantCode: "muro", role: "Admin", status: "Active" }],
};
const DEV_PASSWORD = "123456";

interface AuthContextType {
    user: UserDto | null;
    token: string | null;
    isLoading: boolean;
    login: (email: string, password: string) => Promise<void>;
    logout: () => void;
    currentTenantId: string | null;
    setCurrentTenantId: (id: string) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
    const [user, setUser] = useState<UserDto | null>(null);
    const [token, setToken] = useState<string | null>(null);
    const [currentTenantId, setCurrentTenantId] = useState<string | null>(null);
    const [isLoading, setIsLoading] = useState(true);

    const applyAuth = (res: { token: string; refreshToken: string; user: UserDto }) => {
        setToken(res.token);
        setUser(res.user);
        localStorage.setItem("muro_token", res.token);
        localStorage.setItem("muro_refresh", res.refreshToken);
        if (res.user.tenants.length > 0 && !currentTenantId) {
            setCurrentTenantId(res.user.tenants[0].tenantId);
        }
    };

    // Session kicked dinleyicisi...
    useEffect(() => {
        const handler = (e: Event) => {
            const msg = (e as CustomEvent).detail
                ?? "Hesabınıza başka bir cihazdan giriş yapıldı. Oturumunuz kapatıldı.";
            logout();
            window.dispatchEvent(new CustomEvent("toast:show", { detail: { type: "warning", title: "🔐 Güvenlik Uyarısı", message: msg as string } }));
        };
        window.addEventListener("session:kicked", handler);
        return () => window.removeEventListener("session:kicked", handler);
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    useEffect(() => {
        // ── Token Handoff...
        if (typeof window !== "undefined") {
            const params = new URLSearchParams(window.location.search);
            const urlToken = params.get("_token");
            const urlRefresh = params.get("_refresh");
            if (urlToken) {
                localStorage.setItem("muro_token", urlToken);
                if (urlRefresh) localStorage.setItem("muro_refresh", urlRefresh);
                params.delete("_token");
                params.delete("_refresh");
                const clean = params.toString();
                const newUrl = window.location.pathname + (clean ? `?${clean}` : "");
                window.history.replaceState({}, "", newUrl);
            }
        }

        const saved = localStorage.getItem("muro_token");
        if (saved) {
            if (DEV_MODE) {
                setToken(saved);
                setUser(DEV_USER);
                setCurrentTenantId(DEV_USER.tenants[0].tenantId);
                setIsLoading(false);
                return;
            }
            setToken(saved);
            authApi
                .me(saved)
                .then((u) => {
                    setUser(u);
                    if (u.tenants.length > 0 && !currentTenantId) {
                        setCurrentTenantId(u.tenants[0].tenantId);
                    }
                })
                .catch(async () => {
                    const refresh = localStorage.getItem("muro_refresh");
                    if (refresh) {
                        try {
                            const res = await authApi.refresh(refresh);
                            applyAuth(res);
                            return;
                        } catch {
                            localStorage.removeItem("muro_refresh");
                        }
                    }
                    localStorage.removeItem("muro_token");
                    setToken(null);
                })
                .finally(() => setIsLoading(false));
        } else {
            setIsLoading(false);
        }
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    // Proactive refresh...
    useEffect(() => {
        if (!token || DEV_MODE) return;
        const checkRefresh = async () => {
            try {
                const payload = JSON.parse(atob(token.split(".")[1]));
                const exp = payload.exp;
                if (!exp) return;
                const remaining = exp * 1000 - Date.now();

                if (remaining < 5 * 60_000 && remaining > 0) {
                    const refresh = localStorage.getItem("muro_refresh");
                    if (refresh) {
                        try {
                            const res = await authApi.refresh(refresh);
                            applyAuth(res);
                            console.log("🔄 Admin token otomatik yenilendi");
                        } catch {
                            logout();
                            window.dispatchEvent(new CustomEvent("toast:show", { detail: { type: "warning", title: "⏰ Oturum Süresi", message: "Oturumunuz sona erdi. Lütfen tekrar giriş yapın." } }));
                        }
                    }
                } else if (remaining <= 0) {
                    logout();
                    window.dispatchEvent(new CustomEvent("toast:show", { detail: { type: "warning", title: "⏰ Oturum Süresi", message: "Oturumunuz sona erdi. Lütfen tekrar giriş yapın." } }));
                }
            } catch { /* invalid token format */ }
        };

        let interval: ReturnType<typeof setInterval> | null = null;
        const start = () => { if (!interval) { checkRefresh(); interval = setInterval(checkRefresh, 60_000); } };
        const stop = () => { if (interval) { clearInterval(interval); interval = null; } };
        const onVisibility = () => document.hidden ? stop() : start();

        if (!document.hidden) start();
        document.addEventListener("visibilitychange", onVisibility);
        return () => { stop(); document.removeEventListener("visibilitychange", onVisibility); };
    }, [token]); // eslint-disable-line react-hooks/exhaustive-deps

    const login = async (email: string, password: string) => {
        if (DEV_MODE) {
            if (password !== DEV_PASSWORD) {
                throw new Error("Geliştirme modu: Şifre '123456' olmalı");
            }
            const devToken = "dev-token-" + Date.now();
            setToken(devToken);
            setUser({ ...DEV_USER, email });
            localStorage.setItem("muro_token", devToken);
            setCurrentTenantId(DEV_USER.tenants[0].tenantId);
            return;
        }
        const res = await authApi.login(email, password);
        applyAuth(res);
    };

    const logout = () => {
        setToken(null);
        setUser(null);
        setCurrentTenantId(null);
        localStorage.removeItem("muro_token");
        localStorage.removeItem("muro_refresh");
        localStorage.removeItem("muro_student_token");
        localStorage.removeItem("muro_student_refresh");
        clearCache();
        
        // Nginx trailing slash loop (301 <-> 308) hatasını önlemek için window location ile "/admin/login" adresine gidiyoruz.
        if (typeof window !== "undefined") {
            window.location.href = "/admin/login";
        }
    };

    return (
        <AuthContext.Provider
            value={{ user, token, isLoading, login, logout, currentTenantId, setCurrentTenantId }}
        >
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const ctx = useContext(AuthContext);
    if (!ctx) throw new Error("useAuth must be used within AuthProvider");
    return ctx;
}
