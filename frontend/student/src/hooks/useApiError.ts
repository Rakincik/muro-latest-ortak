import { useCallback } from "react";
import { useToast } from "@/components/ToastProvider";
import { ApiError } from "@/lib/api";

/**
 * Reusable hook for handling API errors with user-friendly toast notifications.
 * Usage:
 *   const { handleError } = useApiError();
 *   try { await someApiCall(); } catch (err) { handleError(err); }
 */
export function useApiError() {
    const { showToast } = useToast();

    const handleError = useCallback(
        (err: unknown, customMessage?: string) => {
            if (err instanceof ApiError) {
                switch (err.statusCode) {
                    case 401:
                        showToast("Oturumunuz sona ermiş olabilir. Lütfen tekrar giriş yapın.", "error");
                        break;
                    case 403:
                        showToast("Bu işlemi gerçekleştirme yetkiniz yok.", "error");
                        break;
                    case 404:
                        showToast(customMessage ?? "İstenen kayıt bulunamadı.", "info");
                        break;
                    case 429:
                        showToast("Çok fazla istek. Lütfen biraz bekleyip tekrar deneyin.", "info");
                        break;
                    default:
                        if (err.statusCode >= 500) {
                            showToast(customMessage ?? "Bir sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.", "error");
                        } else {
                            showToast(customMessage ?? err.message, "error");
                        }
                }
            } else if (err instanceof TypeError && err.message === "Failed to fetch") {
                showToast("Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.", "error");
            } else {
                showToast(customMessage ?? "Bir şeyler ters gitti.", "error");
            }

            // Always log for debugging
            console.error("[useApiError]", err);
        },
        [showToast]
    );

    return { handleError };
}
