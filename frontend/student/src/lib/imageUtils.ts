/**
 * Client-side image compression utility.
 * Resizes images to fit within maxWidth/maxHeight and compresses as JPEG.
 * Returns a base64 data URL.
 */
export async function compressImage(
    file: File,
    maxWidth = 1200,
    maxHeight = 1200,
    quality = 0.8
): Promise<string> {
    return new Promise((resolve, reject) => {
        const img = new Image();
        const url = URL.createObjectURL(file);

        img.onload = () => {
            URL.revokeObjectURL(url);

            let { width, height } = img;

            // Scale down if needed
            if (width > maxWidth || height > maxHeight) {
                const ratio = Math.min(maxWidth / width, maxHeight / height);
                width = Math.round(width * ratio);
                height = Math.round(height * ratio);
            }

            const canvas = document.createElement("canvas");
            canvas.width = width;
            canvas.height = height;

            const ctx = canvas.getContext("2d");
            if (!ctx) return reject(new Error("Canvas not supported"));

            ctx.drawImage(img, 0, 0, width, height);

            // Use JPEG for photos (much smaller than PNG)
            const dataUrl = canvas.toDataURL("image/jpeg", quality);
            resolve(dataUrl);
        };

        img.onerror = () => {
            URL.revokeObjectURL(url);
            reject(new Error("Image load failed"));
        };

        img.src = url;
    });
}

/**
 * Get human-readable file size
 */
export function formatFileSize(bytes: number): string {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}
