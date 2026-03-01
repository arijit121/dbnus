let deferredPrompt = null;
let newServiceWorker = null;

/* ---------------------------
   PLATFORM DETECTION
---------------------------- */

function getPlatform() {
    const ua = navigator.userAgent.toLowerCase();

    if (/iphone|ipad|ipod/.test(ua)) return "ios";
    if (/android/.test(ua)) return "android";
    if (/windows/.test(ua)) return "windows";
    if (/macintosh/.test(ua)) return "macintosh";
    if (/linux/.test(ua)) return "linux";
    return "unknown";
}

function isIOS() {
    return /iphone|ipad|ipod/.test(navigator.userAgent.toLowerCase());
}

function isAppInstalled() {
    const isStandalone = window.matchMedia('(display-mode: standalone)').matches;
    const isIOSStandalone = window.navigator.standalone === true;
    return isStandalone || isIOSStandalone;
}

/* ---------------------------
   INSTALL PROMPT HANDLING
---------------------------- */

window.addEventListener('beforeinstallprompt', (e) => {
    e.preventDefault();
    deferredPrompt = e;
});

function promptInstall() {
    if (!deferredPrompt) return false;

    deferredPrompt.prompt();

    deferredPrompt.userChoice.then(() => {
        deferredPrompt = null;
    });

    return true;
}

/* ---------------------------
   INSTALL STATUS CHECK
---------------------------- */

function getPWAStatus() {
    const ua = navigator.userAgent.toLowerCase();
    const isIOS = /iphone|ipad|ipod/.test(ua);
    const isAndroid = /android/.test(ua);
    const isDesktop = /windows|macintosh|linux/.test(ua);

    const platform = isIOS
        ? "ios"
        : isAndroid
            ? "android"
            : isDesktop
                ? "desktop"
                : "unknown";

    const isStandalone = window.matchMedia('(display-mode: standalone)').matches;
    const isIOSStandalone = window.navigator.standalone === true;
    const installed = isStandalone || isIOSStandalone;

    let canInstall = false;
    let showIOSInstructions = false;
    let iosInstructions = null;

    if (platform === "ios") {
        showIOSInstructions = !installed;

        if (!installed) {
            iosInstructions = {
                step1: "Tap the Share button (square with arrow).",
                step2: "Scroll down and tap 'Add to Home Screen'.",
                step3: "Tap 'Add' to install the app."
            };
        }
    } else {
        canInstall = deferredPrompt !== null && !installed;
    }

    const result = {
        platform: platform,
        isInstalled: installed,
        canInstall: canInstall,
        showIOSInstructions: showIOSInstructions,
        iosInstructions: iosInstructions
    };

    return JSON.stringify(result);
}

/* ---------------------------
   UPDATE DETECTION (Flutter)
---------------------------- */

function initUpdateDetector() {
    if (!('serviceWorker' in navigator)) return;

    navigator.serviceWorker.register('flutter_service_worker.js')
        .then((registration) => {

            // Detect new service worker
            registration.onupdatefound = () => {
                newServiceWorker = registration.installing;

                newServiceWorker.onstatechange = () => {
                    if (
                        newServiceWorker.state === 'installed' &&
                        navigator.serviceWorker.controller
                    ) {
                        console.log("New update available");

                        if (window.updateAvailable) {
                            window.updateAvailable();
                        }
                    }
                };
            };
        });
}

// Force activate new version
function updateApp() {
    if (!newServiceWorker) return false;

    newServiceWorker.postMessage({ action: 'skipWaiting' });

    newServiceWorker.addEventListener('statechange', () => {
        if (newServiceWorker.state === 'activated') {
            window.location.reload();
        }
    });

    return true;
}

/* ---------------------------
   INSTALL COMPLETE EVENT
---------------------------- */

window.addEventListener('appinstalled', () => {
    deferredPrompt = null;

    if (window.appInstalled) {
        window.appInstalled();
    }
});