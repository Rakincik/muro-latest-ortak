"use client";

import React, { useEffect, useRef, useState } from "react";
import { Plyr, APITypes, PlyrProps } from "plyr-react";
import Hls from "hls.js";

interface PremiumPlayerProps {
    src: string;
    mediaId?: string;
    onLoaded?: () => void;
    onEnded?: () => void;
    autoplay?: boolean;
    poster?: string | null;
    initialTime?: number | null;
    autoResume?: boolean;
}

const fmtTime = (sec: number) => {
    if (!sec || sec <= 0) return "0 saniye";
    const h = Math.floor(sec / 3600);
    const m = Math.floor((sec % 3600) / 60);
    const s = Math.floor(sec % 60);
    
    if (h > 0) {
        return `${h} saat ${m} dakika ${s} saniye`;
    }
    if (m > 0) {
        return `${m} dakika ${s} saniye`;
    }
    return `${s} saniye`;
};

export const PremiumPlayer = React.memo(function PremiumPlayer({ src, mediaId, onLoaded, onEnded, autoplay = false, poster, initialTime, autoResume = false }: PremiumPlayerProps) {
    const plyrRef = useRef<APITypes>(null);
    const hlsRef = useRef<Hls | null>(null);
    
    // NEW RESUME SYSTEM STATES
    // To completely prevent race conditions, we read the saved time exactly ONCE when mediaId/initialTime changes.
    const [showResumeBanner, setShowResumeBanner] = useState(false);
    const [resumeTime, setResumeTime] = useState(0);
    
    // Refs to track resume workflow without triggering re-renders
    const resumeStateRef = useRef<{
        hasChecked: boolean;
        hasHandled: boolean;
        timeToResume: number;
    }>({
        hasChecked: false,
        hasHandled: false,
        timeToResume: 0
    });

    const lastValidSrcRef = useRef<string>(src);
    const [supported, setSupported] = useState(true);
    const [qualities, setQualities] = useState<number[]>([]);

    const [isLocked, setIsLocked] = useState(false);
    const [unlockTapActive, setUnlockTapActive] = useState(false);
    const [brightness, setBrightness] = useState(1.0); // 1.0 = normal, 0.2 = dark

    // Only run this ONCE when the component mounts or mediaId changes
    useEffect(() => {
        if (!mediaId && (!initialTime || initialTime <= 0)) return;

        // Reset state for new media
        resumeStateRef.current = {
            hasChecked: true,
            hasHandled: false,
            timeToResume: 0
        };
        setShowResumeBanner(false);

        // 1. Determine saved time synchronously
        let savedTime = 0;
        if (mediaId) {
            try {
                const savedTimeStr = localStorage.getItem(`muro_video_time_${mediaId}`);
                if (savedTimeStr) savedTime = parseFloat(savedTimeStr);
            } catch { }
        }
        if (savedTime <= 0 && initialTime && initialTime > 0) {
            savedTime = initialTime;
        }

        // 2. If valid saved time, trigger banner or auto-resume
        if (savedTime > 10) {
            resumeStateRef.current.timeToResume = savedTime;
            setResumeTime(savedTime);
            
            if (autoResume) {
                // Instantly resume without banner
                resumeStateRef.current.hasHandled = true;
                
                // We need to wait for media to be ready to seek. This will be handled by the onLoaded metadata event or we can do it directly.
                // We'll set a flag so the player initialization logic knows it needs to perform a seek once ready.
                // Actually, handleAcceptResume does exactly what we need, but we can't call it here easily without risking a race condition if media isn't mounted.
                // We'll let initializePlayer's handleLoadedMetadata check timeToResume if hasHandled is true.
            } else {
                setShowResumeBanner(true);
                // Auto-hide banner after 8 seconds and consider it "handled" (ignored)
                setTimeout(() => {
                    setShowResumeBanner((current) => {
                        if (current) {
                            resumeStateRef.current.hasHandled = true;
                        }
                        return false;
                    });
                }, 8000);
            }
        } else {
            // No saved time, consider resume fully handled
            resumeStateRef.current.hasHandled = true;
        }
    }, [mediaId, initialTime, autoResume]);

    const performSeek = (targetTime: number) => {
        const plyrInstance = plyrRef.current?.plyr;
        const media = (plyrInstance as any)?.media as HTMLVideoElement;
        if (!plyrInstance || !media) return;

        // HLS.js specifically needs aggressive seeking on some setups
        let seekAttempts = 0;
        const attemptSeek = setInterval(() => {
            seekAttempts++;
            try { media.currentTime = targetTime; } catch {}
            try { plyrInstance.currentTime = targetTime; } catch {}
            
            if (Math.abs(media.currentTime - targetTime) < 2 || seekAttempts > 20) {
                clearInterval(attemptSeek);
                const p = media.play();
                if (p) p.catch(() => {});
            }
        }, 100);
    };

    const handleAcceptResume = () => {
        setShowResumeBanner(false);
        resumeStateRef.current.hasHandled = true;

        const plyrInstance = plyrRef.current?.plyr;
        const media = (plyrInstance as any)?.media as HTMLVideoElement;
        if (!plyrInstance || !media) return;

        if (media.readyState >= 1 && media.duration > 0) {
            performSeek(resumeStateRef.current.timeToResume);
        } else {
            const onReady = () => {
                performSeek(resumeStateRef.current.timeToResume);
                media.removeEventListener("loadedmetadata", onReady);
                media.removeEventListener("canplay", onReady);
            };
            media.addEventListener("loadedmetadata", onReady);
            media.addEventListener("canplay", onReady);
        }
    };

    const handleDeclineResume = () => {
        setShowResumeBanner(false);
        resumeStateRef.current.hasHandled = true;

        const plyrInstance = plyrRef.current?.plyr;
        if (plyrInstance) {
            plyrInstance.currentTime = 0;
            plyrInstance.play().catch(() => {});
        }
        if (mediaId) {
            try { localStorage.removeItem(`muro_video_time_${mediaId}`); } catch { }
        }
    };
    const [longPressActive, setLongPressActive] = useState(false);
    const [gestureFeedback, setGestureFeedback] = useState<{ type: "volume" | "brightness"; percent: number } | null>(null);
    const [doubleTapFeedback, setDoubleTapFeedback] = useState<{ dir: "left" | "right"; text: string } | null>(null);

    const touchRef = useRef<{
        startX: number;
        startY: number;
        lastTapTime: number;
        longPressTimer: any;
        singleClickTimeout: any;
        isDragging: boolean;
        dragType: "volume" | "brightness" | null;
        startVolume: number;
        startBrightness: number;
        originalSpeed: number;
    }>({
        startX: 0,
        startY: 0,
        lastTapTime: 0,
        longPressTimer: null,
        singleClickTimeout: null,
        isDragging: false,
        dragType: null,
        startVolume: 1.0,
        startBrightness: 1.0,
        originalSpeed: 1.0,
    });

    const handleStart = (clientX: number, clientY: number, rect: DOMRect) => {
        if (isLocked) return;

        const videoElement = (plyrRef.current?.plyr as any)?.media as HTMLVideoElement;
        if (!videoElement) return;

        const x = clientX - rect.left;
        const width = rect.width;

        touchRef.current.startX = clientX;
        touchRef.current.startY = clientY;
        touchRef.current.isDragging = false;

        // Check if the player is in fullscreen mode
        const isFullscreen = !!(
            typeof document !== "undefined" && (
                document.fullscreenElement ||
                (document as any).webkitFullscreenElement ||
                (document as any).mozFullScreenElement ||
                (document as any).msFullscreenElement
            ) || 
            (plyrRef.current?.plyr && (plyrRef.current.plyr as any).fullscreen?.active)
        );

        // Only enable volume/brightness swipe gestures in fullscreen to prevent conflict with page scrolling
        touchRef.current.dragType = isFullscreen 
            ? (x < width * 0.4 ? "brightness" : x > width * 0.6 ? "volume" : null)
            : null;

        touchRef.current.startVolume = videoElement.volume;
        touchRef.current.startBrightness = brightness;

        if (videoElement.paused === false) {
            touchRef.current.longPressTimer = setTimeout(() => {
                touchRef.current.originalSpeed = videoElement.playbackRate || 1.0;
                videoElement.playbackRate = 2.0;
                setLongPressActive(true);
                if (typeof navigator !== 'undefined' && navigator.vibrate) {
                    navigator.vibrate(50);
                }
            }, 600);
        }
    };

    const handleMove = (clientX: number, clientY: number, rect: DOMRect) => {
        if (isLocked) return;

        const videoElement = (plyrRef.current?.plyr as any)?.media as HTMLVideoElement;
        if (!videoElement) return;

        const deltaX = clientX - touchRef.current.startX;
        const deltaY = clientY - touchRef.current.startY;

        if (Math.abs(deltaX) > 10 || Math.abs(deltaY) > 10) {
            if (touchRef.current.longPressTimer) {
                clearTimeout(touchRef.current.longPressTimer);
                touchRef.current.longPressTimer = null;
            }
        }

        if (longPressActive) return;

        if (Math.abs(deltaY) > 15 && !touchRef.current.isDragging && touchRef.current.dragType) {
            touchRef.current.isDragging = true;
        }

        if (touchRef.current.isDragging && touchRef.current.dragType) {
            const dragPercent = deltaY / rect.height;
            
            if (touchRef.current.dragType === "volume") {
                const nextVol = Math.max(0, Math.min(1, touchRef.current.startVolume - dragPercent * 1.5));
                videoElement.volume = nextVol;
                setGestureFeedback({ type: "volume", percent: Math.round(nextVol * 100) });
            } else if (touchRef.current.dragType === "brightness") {
                const nextBright = Math.max(0.2, Math.min(1.0, touchRef.current.startBrightness - dragPercent * 1.5));
                setBrightness(nextBright);
                setGestureFeedback({ type: "brightness", percent: Math.round(((nextBright - 0.2) / 0.8) * 100) });
            }
        }
    };

    const handleEnd = (clientX: number, clientY: number, rect: DOMRect) => {
        if (touchRef.current.longPressTimer) {
            clearTimeout(touchRef.current.longPressTimer);
            touchRef.current.longPressTimer = null;
        }

        const plyrInstance = plyrRef.current?.plyr;
        const videoElement = (plyrInstance as any)?.media as HTMLVideoElement;
        if (!plyrInstance || !videoElement) return;

        if (longPressActive) {
            videoElement.playbackRate = touchRef.current.originalSpeed;
            setLongPressActive(false);
            return;
        }

        setGestureFeedback(null);

        if (isLocked) return;

        if (!touchRef.current.isDragging) {
            plyrInstance.togglePlay();
        }
    };

    const handleTouchStart = (e: React.TouchEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        const touch = e.touches[0];
        handleStart(touch.clientX, touch.clientY, rect);
    };

    const handleTouchMove = (e: React.TouchEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        const touch = e.touches[0];
        handleMove(touch.clientX, touch.clientY, rect);

        // Prevent page scrolling/bouncing only if we are actively dragging a gesture in fullscreen
        if (touchRef.current.isDragging && touchRef.current.dragType) {
            if (e.cancelable) {
                e.preventDefault();
            }
        }
    };

    const handleTouchEnd = (e: React.TouchEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        const touch = e.changedTouches[0];
        handleEnd(touch.clientX, touch.clientY, rect);
    };

    const handleMouseDown = (e: React.MouseEvent<HTMLDivElement>) => {
        if (e.button !== 0) return;
        const rect = e.currentTarget.getBoundingClientRect();
        handleStart(e.clientX, e.clientY, rect);
    };

    const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        handleMove(e.clientX, e.clientY, rect);
    };

    const handleMouseUp = (e: React.MouseEvent<HTMLDivElement>) => {
        const rect = e.currentTarget.getBoundingClientRect();
        handleEnd(e.clientX, e.clientY, rect);
    };

    const handleWrapperClick = (e: React.MouseEvent<HTMLDivElement>) => {
        const target = e.target as HTMLElement;
        const rewindBtn = target.closest('.plyr__control--custom-rewind');
        const forwardBtn = target.closest('.plyr__control--custom-forward');
        
        if (rewindBtn || forwardBtn) {
            e.stopPropagation();
            e.preventDefault();
            const plyrInstance = plyrRef.current?.plyr;
            if (plyrInstance) {
                if (rewindBtn) {
                    plyrInstance.currentTime = Math.max(0, plyrInstance.currentTime - 10);
                } else {
                    plyrInstance.currentTime = Math.min(plyrInstance.duration || 0, plyrInstance.currentTime + 10);
                }
            }
        }
    };

    const handleLockClick = (e: React.MouseEvent) => {
        e.stopPropagation();
        if (isLocked) {
            if (unlockTapActive) {
                setIsLocked(false);
                setUnlockTapActive(false);
            } else {
                setUnlockTapActive(true);
                setTimeout(() => setUnlockTapActive(false), 2500);
            }
        } else {
            setIsLocked(true);
        }
    };

    if (src) {
        lastValidSrcRef.current = src;
    }
    const currentSrc = src || lastValidSrcRef.current || "";

    if (!currentSrc) return null;

    const fullSrc = currentSrc.startsWith("/") 
        ? `${process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") || "http://localhost:5292"}${currentSrc}`
        : currentSrc;

    const isHls = fullSrc.includes(".m3u8");

    // The old reactive initialTime watcher is removed because we handle it synchronously in the new mount useEffect.

    useEffect(() => {
        let videoElementCleanup: HTMLVideoElement | null = null;
        let handleLoadedMetadataCleanup: (() => void) | null = null;
        let handleTimeUpdateCleanup: (() => void) | null = null;
        let handleCanPlayCleanup: (() => void) | null = null;
        let handlePlayCleanup: (() => void) | null = null;
        let handlePlayingCleanup: (() => void) | null = null;
        let handleEndedCleanup: (() => void) | null = null;
        let playerElCleanup: Element | null = null;
        let captureListener: ((e: any) => void) | null = null;

        // HLS Kurulumu
        const initializePlayer = () => {
            const plyrInstance = plyrRef.current?.plyr;
            if (!plyrInstance) return false;

            const videoElement = (plyrInstance as any).media as HTMLVideoElement;
            if (!videoElement) return false;
            videoElementCleanup = videoElement;

            // Seek buttons are now rendered via React JSX overlay — no DOM manipulation needed
            const playerEl = videoElement.closest('.plyr');
            if (playerEl) {
                playerElCleanup = playerEl;
                captureListener = (e: MouseEvent) => {
                    const target = e.target as HTMLElement;
                    const rewindBtn = target.closest('.plyr__control--custom-rewind');
                    const forwardBtn = target.closest('.plyr__control--custom-forward');
                    
                    if (rewindBtn || forwardBtn) {
                        e.stopPropagation();
                        e.preventDefault();
                        if (rewindBtn) {
                            plyrInstance.currentTime = Math.max(0, plyrInstance.currentTime - 10);
                        } else {
                            plyrInstance.currentTime = Math.min(plyrInstance.duration || 0, plyrInstance.currentTime + 10);
                        }
                    }
                };
                playerEl.addEventListener('click', captureListener, true);
            }

            const handleLoadedMetadata = () => {
                if (autoResume && resumeStateRef.current.timeToResume > 0) {
                    performSeek(resumeStateRef.current.timeToResume);
                }
                if (onLoaded) onLoaded();
            };
            handleLoadedMetadataCleanup = handleLoadedMetadata;

            const handleTimeUpdate = () => {
                // Do not save time if resume logic is still pending/unhandled!
                if (!resumeStateRef.current.hasHandled) return;

                if (mediaId && videoElement.currentTime > 0 && !videoElement.seeking) {
                    const duration = videoElement.duration || 1;
                    const percent = (videoElement.currentTime / duration) * 100;
                    try {
                        if (percent > 98) {
                            localStorage.removeItem(`muro_video_time_${mediaId}`);
                        } else {
                            localStorage.setItem(`muro_video_time_${mediaId}`, videoElement.currentTime.toString());
                        }
                    } catch { }
                }
            };
            handleTimeUpdateCleanup = handleTimeUpdate;

            const handleEnded = () => {
                if (onEnded) onEnded();
            };
            handleEndedCleanup = handleEnded;

            videoElement.addEventListener("loadedmetadata", handleLoadedMetadata);
            videoElement.addEventListener("timeupdate", handleTimeUpdate);
            videoElement.addEventListener("ended", handleEnded);

            // Race-condition check: if metadata is already loaded, apply progress immediately
            if (videoElement.readyState >= 1 || videoElement.duration > 0) {
                handleLoadedMetadata();
            }

            if (isHls) {
                const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
                const isAppleDevice = /iPad|iPhone|iPod|Macintosh/i.test(navigator.userAgent) || (typeof navigator !== 'undefined' && navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
                const useNativeHls = (isSafari || isAppleDevice) && videoElement.canPlayType("application/vnd.apple.mpegurl");

                if (Hls.isSupported() && !useNativeHls) {
                    if (hlsRef.current) {
                        hlsRef.current.destroy();
                    }

                    const hls = new Hls({ maxBufferLength: 30 });
                    hls.loadSource(fullSrc);
                    hls.attachMedia(videoElement);
                    
                    hls.on(Hls.Events.MANIFEST_PARSED, (event, data) => {
                        const availableQualities = data.levels.map((l) => l.height).sort((a, b) => b - a);
                        setQualities(availableQualities);
                        if (onLoaded) onLoaded();
                        if (autoplay) {
                            const playPromise = videoElement.play();
                            if (playPromise !== undefined) {
                                playPromise.catch(() => { /* Autoplay engellendi */ });
                            }
                        }
                    });

                    hlsRef.current = hls;

                } else if (videoElement.canPlayType("application/vnd.apple.mpegurl")) {
                    // Native HLS (Safari vb.)
                    videoElement.src = fullSrc;
                    videoElement.addEventListener("loadedmetadata", handleLoadedMetadata);
                    if (videoElement.readyState >= 1 || videoElement.duration > 0) {
                        handleLoadedMetadata();
                    }
                } else {
                    setSupported(false);
                }
            } else {
                // Native MP4 (Direct File)
                // videoElement.src = fullSrc; // Plyr's JSX wrapper already sets this. Manual setting restarts/resets the player state!
                videoElement.addEventListener("loadedmetadata", handleLoadedMetadata);
                if (videoElement.readyState >= 1 || videoElement.duration > 0) {
                    handleLoadedMetadata();
                }
            }
            return true;
        };

        // Fullscreen orientation lock/unlock listeners
        const handleFullscreenChange = () => {
            const isFullscreen = document.fullscreenElement !== null;
            if (isFullscreen) {
                const orientation = window.screen?.orientation as any;
                if (orientation && orientation.lock) {
                    orientation.lock("landscape").catch(() => {});
                }
            } else {
                const orientation = window.screen?.orientation as any;
                if (orientation && orientation.unlock) {
                    orientation.unlock();
                }
            }
        };
        document.addEventListener("fullscreenchange", handleFullscreenChange);

        // Poll every 50ms until plyrInstance is ready, up to 200 times (10 seconds)
        let attempts = 0;
        const initInterval = setInterval(() => {
            attempts++;
            const success = initializePlayer();
            if (success || attempts > 200) {
                clearInterval(initInterval);
            }
        }, 50);

        return () => {
            clearInterval(initInterval);
            document.removeEventListener("fullscreenchange", handleFullscreenChange);
            if (playerElCleanup && captureListener) {
                playerElCleanup.removeEventListener('click', captureListener, true);
            }
            if (videoElementCleanup) {
                if (handleLoadedMetadataCleanup) {
                    videoElementCleanup.removeEventListener("loadedmetadata", handleLoadedMetadataCleanup);
                }
                if (handleTimeUpdateCleanup) {
                    videoElementCleanup.removeEventListener("timeupdate", handleTimeUpdateCleanup);
                }
                if (handleCanPlayCleanup) {
                    videoElementCleanup.removeEventListener("canplay", handleCanPlayCleanup);
                }
                if (handlePlayCleanup) {
                    videoElementCleanup.removeEventListener("play", handlePlayCleanup);
                }
                if (handlePlayingCleanup) {
                    videoElementCleanup.removeEventListener("playing", handlePlayingCleanup);
                }
                if (handleEndedCleanup) {
                    videoElementCleanup.removeEventListener("ended", handleEndedCleanup);
                }
            }
            if (hlsRef.current) {
                try { hlsRef.current.destroy(); } catch (e) { console.error("HLS destroy error", e); }
                hlsRef.current = null;
            }
        };
    }, [fullSrc, isHls, onLoaded, onEnded, autoplay, mediaId, initialTime]);

    if (!supported) {
        return (
            <div className="w-full h-full flex items-center justify-center bg-[#0A1931] text-white/50 text-sm">
                Tarayıcınız bu video formatını desteklemiyor.
            </div>
        );
    }

    const vttPath = fullSrc.includes("master.m3u8") 
        ? fullSrc.replace("master.m3u8", "thumbnails.vtt")
        : undefined;

    const plyrOptions: any = {
        ratio: "16:9",
        clickToPlay: true,
        container: ".premium-player-wrapper",
        fullscreen: { enabled: true, fallback: true, iosNative: true },
        playsinline: true,
        controls: ['play-large', 'play', 'rewind', 'fast-forward', 'progress', 'current-time', 'duration', 'mute', 'volume', 'captions', 'settings', 'pip', 'airplay', 'fullscreen'],
        settings: isHls ? ["quality", "speed", "loop"] : ["speed", "loop"],
        ...(isHls && {
            quality: {
                default: qualities.length > 0 ? qualities[0] : 1080,
                options: qualities.length > 0 ? qualities : [1080, 720, 480, 360],
                forced: true,
                onChange: (q: number) => {
                    if (hlsRef.current) {
                        const levelIndex = hlsRef.current.levels.findIndex(l => l.height === q);
                        if (levelIndex !== -1) {
                            hlsRef.current.currentLevel = levelIndex;
                        }
                    }
                }
            }
        }),
        speed: { selected: 1, options: [0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 2.25, 2.5] },
        disableContextMenu: true,
        keyboard: { focused: true, global: true },
        tooltips: { controls: true, seek: true },
        previewThumbnails: vttPath ? { enabled: true, src: vttPath } : { enabled: false },
    };

    const posterFullUrl = poster 
        ? (poster.startsWith("/") ? `${process.env.NEXT_PUBLIC_API_URL?.replace("/api/v1", "") || "http://localhost:5292"}${poster}` : poster)
        : undefined;

    return (
        <div className={`w-full h-full premium-player-wrapper bg-black ${isLocked ? "premium-player-locked" : ""}`} onContextMenu={e => e.preventDefault()} onClick={handleWrapperClick}>
            <style dangerouslySetInnerHTML={{__html: `
                .premium-player-wrapper {
                    position: relative;
                    user-select: none;
                    -webkit-user-select: none;
                    overflow: hidden;
                }
                /* Kill the bouncing/scaling animation on the center play button */
                .premium-player-wrapper .plyr__control--overlaid {
                    animation: none !important;
                    transform: translate(-50%, -50%) !important;
                    transition: opacity 0.2s ease !important;
                }
                @media (hover: none) and (pointer: coarse) {
                    .premium-player-wrapper .plyr__control--overlaid {
                        /* On mobile, hide the big center play button entirely since we use touch overlay */
                        display: none !important;
                    }
                }
                /* Disable gesture overlay when Plyr settings menu is open to allow clicking speed/quality options on mobile */
                .premium-player-wrapper:has(.plyr--menu-open) .custom-overlay {
                    pointer-events: none !important;
                }
                .plyr__control--custom-rewind svg, .plyr__control--custom-forward svg {
                    transition: transform 0.2s;
                    fill: none !important;
                    stroke: currentColor !important;
                }
                .plyr__control--custom-rewind svg text, .plyr__control--custom-forward svg text {
                    fill: currentColor !important;
                    stroke: none !important;
                }
                .plyr__control--custom-rewind:hover svg {
                    transform: rotate(-15deg);
                }
                .plyr__control--custom-forward:hover svg {
                    transform: rotate(15deg);
                }
                .premium-player-locked .plyr__controls {
                    display: none !important;
                    pointer-events: none !important;
                }
                .premium-player-locked .plyr__video-wrapper {
                    pointer-events: none !important;
                }
                /* Defensive layout overrides against global CSS pollution */
                .premium-player-wrapper .plyr__volume {
                    flex: 0 1 80px !important;
                    min-width: 60px !important;
                    max-width: 80px !important;
                    margin-right: 10px !important;
                }
                .premium-player-wrapper .plyr__progress {
                    flex: 1 !important;
                }
                .premium-player-wrapper .plyr__time {
                    padding: 0 !important;
                    margin: 0 1px !important;
                }
                .premium-player-wrapper .plyr__time + .plyr__time::before {
                    content: '/' !important;
                    margin-right: 3px !important;
                    margin-left: 1px !important;
                }
                .brightness-overlay {
                    position: absolute;
                    inset: 0;
                    background: black;
                    pointer-events: none;
                    z-index: 5;
                    mix-blend-mode: multiply;
                }
                .custom-overlay {
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 60px; /* Don't block controls */
                    z-index: 10;
                    pointer-events: none; /* Disable overlay capture on desktop */
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                @media (hover: none) and (pointer: coarse) {
                    .custom-overlay {
                        pointer-events: auto; /* Enable touch gestures on mobile */
                    }
                }
                .lock-btn {
                    position: absolute;
                    top: 20px;
                    left: 20px;
                    background: rgba(0,0,0,0.6);
                    border: 1px solid rgba(255,255,255,0.2);
                    border-radius: 50%;
                    padding: 10px;
                    color: white;
                    cursor: pointer;
                    pointer-events: auto; /* Always clickable */
                    z-index: 20;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    transition: all 0.2s;
                }
                .lock-btn:hover {
                    background: rgba(0,0,0,0.8);
                    transform: scale(1.05);
                }
                .double-tap-indicator {
                    position: absolute;
                    top: 50%;
                    transform: translateY(-50%);
                    background: rgba(0,0,0,0.6);
                    border-radius: 50%;
                    width: 70px;
                    height: 70px;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 11px;
                    font-weight: bold;
                    pointer-events: none;
                }
                .double-tap-left { left: 15%; }
                .double-tap-right { right: 15%; }
                .speed-indicator {
                    position: absolute;
                    top: 20px;
                    right: 20px;
                    background: rgba(239, 68, 68, 0.85);
                    color: white;
                    font-size: 11px;
                    font-weight: 800;
                    padding: 6px 12px;
                    border-radius: 20px;
                    z-index: 15;
                    pointer-events: none;
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.3);
                    text-transform: uppercase;
                }
                .gesture-indicator {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    background: rgba(0,0,0,0.8);
                    color: white;
                    padding: 16px 24px;
                    border-radius: 16px;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 8px;
                    z-index: 15;
                    pointer-events: none;
                    min-width: 110px;
                }
                .gesture-bar-container {
                    width: 80px;
                    height: 4px;
                    background: rgba(255,255,255,0.2);
                    border-radius: 2px;
                    overflow: hidden;
                }
                .gesture-bar {
                    height: 100%;
                    background: #3B82F6;
                    border-radius: 2px;
                }
                .unlock-warning {
                    position: absolute;
                    bottom: 60px;
                    background: rgba(0,0,0,0.85);
                    color: white;
                    font-size: 12px;
                    font-weight: 600;
                    padding: 10px 18px;
                    border-radius: 25px;
                    border: 1px solid rgba(255,255,255,0.1);
                }
                .resume-banner {
                    position: absolute;
                    bottom: 70px;
                    left: 20px;
                    right: 20px;
                    background: rgba(10, 25, 49, 0.95);
                    border: 1px solid rgba(255, 255, 255, 0.15);
                    backdrop-filter: blur(10px);
                    border-radius: 16px;
                    padding: 12px 18px;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    gap: 12px;
                    z-index: 40;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
                    animation: slideUp 0.3s ease-out;
                    pointer-events: auto;
                }
                @keyframes slideUp {
                    from { transform: translateY(20px); opacity: 0; }
                    to { transform: translateY(0); opacity: 1; }
                }
            `}} />

            {brightness < 1.0 && (
                <div className="brightness-overlay" style={{ opacity: 1 - brightness }} />
            )}

            <Plyr
                ref={plyrRef}
                source={{
                    type: "video",
                    poster: posterFullUrl,
                    sources: [
                        {
                            src: fullSrc,
                            type: isHls ? "application/x-mpegURL" : "video/mp4",
                        }
                    ]
                }}
                options={plyrOptions}
            />



            <div 
                className="custom-overlay"
                onTouchStart={handleTouchStart}
                onTouchMove={handleTouchMove}
                onTouchEnd={handleTouchEnd}
                onMouseDown={handleMouseDown}
                onMouseMove={handleMouseMove}
                onMouseUp={handleMouseUp}
            >
                <button className="lock-btn" onClick={handleLockClick} title={isLocked ? "Kilidi Aç" : "Ekranı Kilitle"}>
                    {isLocked ? (
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth="2.5" width="20" height="20">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0 1 10 0v4" />
                        </svg>
                    ) : (
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth="2.5" width="20" height="20">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2" />
                            <path d="M7 11V7a5 5 0 0 1 9.9-1" />
                        </svg>
                    )}
                </button>

                {isLocked && unlockTapActive && (
                    <div className="unlock-warning">
                        Kilidi açmak için tekrar dokunun
                    </div>
                )}

                {longPressActive && (
                    <div className="speed-indicator">
                        <svg className="w-3.5 h-3.5 animate-pulse" fill="currentColor" viewBox="0 0 24 24" width="14" height="14">
                            <path d="M8 5v14l11-7z" />
                        </svg>
                        2X Hız
                    </div>
                )}

                {doubleTapFeedback && (
                    <div className={`double-tap-indicator double-tap-${doubleTapFeedback.dir}`}>
                        {doubleTapFeedback.dir === 'left' ? (
                            <svg className="w-6 h-6 mb-1" fill="currentColor" viewBox="0 0 24 24" width="24" height="24">
                                <path d="M11 18V6l-8.5 6 8.5 6zm.5-6l8.5 6V6l-8.5 6z"/>
                            </svg>
                        ) : (
                            <svg className="w-6 h-6 mb-1" fill="currentColor" viewBox="0 0 24 24" width="24" height="24">
                                <path d="M4 18l8.5-6L4 6v12zm9-12v12l8.5-6L13 6z"/>
                            </svg>
                        )}
                        <span>{doubleTapFeedback.text}</span>
                    </div>
                )}

                {gestureFeedback && (
                    <div className="gesture-indicator">
                        {gestureFeedback.type === 'volume' ? (
                            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth="2" width="24" height="24">
                                <path d="M15.54 8.46a5 5 0 0 1 0 7.07M19.07 4.93a10 10 0 0 1 0 14.14M6 15H4a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1h2l4.58-4.58A1 1 0 0 1 15 5.13v13.74a1 1 0 0 1-1.42.9L6 15z" />
                            </svg>
                        ) : (
                            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" strokeWidth="2" width="24" height="24">
                                <circle cx="12" cy="12" r="5" />
                                <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.07l1.42-1.42M18.36 5.64l1.42-1.42" />
                            </svg>
                        )}
                        <span className="text-xs font-bold">{gestureFeedback.percent}%</span>
                        <div className="gesture-bar-container">
                            <div className="gesture-bar" style={{ width: `${gestureFeedback.percent}%` }} />
                        </div>
                    </div>
                )}

                {showResumeBanner && (
                    <div className="resume-banner" onMouseDown={e => e.stopPropagation()} onTouchStart={e => e.stopPropagation()} onClick={e => e.stopPropagation()}>
                        <div className="flex-1 min-w-0">
                            <p className="text-white text-xs font-bold">Kaldığın yerden devam et?</p>
                            <p className="text-white/60 text-[10px] mt-0.5 font-medium">Bu videoyu en son {fmtTime(resumeTime)} konumunda bırakmıştınız.</p>
                        </div>
                        <div className="flex items-center gap-2 shrink-0">
                            <button onClick={handleAcceptResume} className="px-3.5 py-1.5 bg-blue-600 hover:bg-blue-700 text-white text-[11px] font-bold rounded-lg transition-colors shadow-md">
                                Devam Et
                            </button>
                            <button onClick={handleDeclineResume} className="px-2.5 py-1.5 bg-white/10 hover:bg-white/20 text-white text-[11px] font-bold rounded-lg transition-colors">
                                Baştan İzle
                            </button>
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
}, (prevProps, nextProps) => {
    return prevProps.src === nextProps.src && 
           prevProps.poster === nextProps.poster && 
           prevProps.autoplay === nextProps.autoplay;
});
