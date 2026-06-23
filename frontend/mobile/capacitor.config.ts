import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
    appId: 'com.monopoluzem.app',
    appName: 'Monopoluzem',
    webDir: 'www',
    server: {
        // Remote URL — uygulama bu adresi yükler
        // White-label build script bu alanı kuruma göre değiştirir
        url: 'https://online.monopoluzem.com.tr',
        cleartext: false  // development için — production'da false olacak
    },
    plugins: {
        SplashScreen: {
            launchShowDuration: 2000,
            launchAutoHide: true,
            backgroundColor: '#0A1931',
            showSpinner: false
        },
        StatusBar: {
            style: 'DARK',
            backgroundColor: '#0A1931'
        },
        PushNotifications: {
            presentationOptions: ['badge', 'sound', 'alert']
        }
    },
    android: {
        allowMixedContent: false,
        backgroundColor: '#0A1931'
    }
};

export default config;
