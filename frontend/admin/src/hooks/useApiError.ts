import { useCallback } from "react";
import { useToast } from "@/components/toast";
import { ApiError } from "@/lib/api";

/**
 * Reusable hook for handling API errors with user-friendly toast notifications.
 * Usage:
 *   const { handleError } = useApiError();
 *   try { await someApiCall(); } catch (err) { handleError(err); }
 */
export function useApiError() {
    const { error: showError, toast } = useToast();

    const handleError = useCallback(
        (err: unknown, customMessage?: string) => {
            if (err instanceof ApiError) {
                switch (err.statusCode) {
                    case 401:
                        showError("Oturum Hatası", "Oturumunuz sona ermiş olabilir. Lütfen tekrar giriş yapın.");
                        break;
                    case 403:
                        showError("Yetki Hatası", "Bu işlemi gerçekleştirme yetkiniz yok.");
                        break;
                    case 404:
                        showError("Bulunamadı", customMessage ?? "İstenen kayıt bulunamadı.");
                        break;
                    case 429:
                        showError("Çok Fazla İstek", "Lütfen biraz bekleyip tekrar deneyin.");
                        break;
                    default:
                        if (err.statusCode >= 500) {
                            showError("Sunucu Hatası", customMessage ?? "Bir sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.");
                        } else {
                            showError("Hata", customMessage ?? err.message);
                        }
                }
            } else if (err instanceof TypeError && err.message === "Failed to fetch") {
                showError("Bağlantı Hatası", "Sunucuya bağlanılamıyor. İnternet bağlantınızı kontrol edin.");
            } else {
                showError("Beklenmeyen Hata", customMessage ?? "Bir şeyler ters gitti.");
            }

            // Always log for debugging
            console.error("[useApiError]", err);
        },
        [showError, toast]
    );

    return { handleError };
}
