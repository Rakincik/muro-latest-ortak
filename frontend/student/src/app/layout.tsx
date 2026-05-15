import type { Metadata } from "next";
import "./globals.css";
import { AuthProvider } from "@/contexts/AuthContext";
import { ToastProvider } from "@/components/ToastProvider";
import OfflineIndicator from "@/components/OfflineIndicator";
import NativeFeatures from "@/components/NativeFeatures";

export const metadata: Metadata = {
  title: "MURO",
  description: "MURO",
  viewport: "width=device-width, initial-scale=1.0, viewport-fit=cover, maximum-scale=1.0, user-scalable=no",
  other: {
    "mobile-web-app-capable": "yes",
    "apple-mobile-web-app-capable": "yes",
    "apple-mobile-web-app-status-bar-style": "black-translucent",
  },
  themeColor: "#0A1931",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="tr">
      <body className="antialiased">
        <AuthProvider>
          <ToastProvider>
            <NativeFeatures />
            <OfflineIndicator />
            {children}
          </ToastProvider>
        </AuthProvider>
      </body>
    </html>
  );
}
