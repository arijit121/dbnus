/* ===================================================
   PWA Helper – cross-platform (iOS, Android, Desktop)
   Returns boolean from promptInstall on all platforms.
   =================================================== */

/* ---------------------------
   EARLY CAPTURE
---------------------------- */

if (typeof window.__pwa_deferred_prompt === 'undefined') {
    window.__pwa_deferred_prompt = null;
}

window.addEventListener('beforeinstallprompt', function (e) {
    e.preventDefault();
    window.__pwa_deferred_prompt = e;
    console.log('[PWA] beforeinstallprompt captured');
});

/* ---------------------------
   PLATFORM DETECTION
---------------------------- */

function getPlatform() {
    var ua = navigator.userAgent.toLowerCase();
    if (/iphone|ipad|ipod/.test(ua)) return "ios";
    if (/android/.test(ua)) return "android";
    if (/windows/.test(ua)) return "windows";
    if (/macintosh/.test(ua)) return "macintosh";
    if (/linux/.test(ua)) return "linux";
    return "unknown";
}

function _detectPlatformInfo() {
    var ua = navigator.userAgent.toLowerCase();
    var isIOS = /iphone|ipad|ipod/.test(ua);
    var isAndroid = /android/.test(ua);
    var isDesktop = /windows|macintosh|linux/.test(ua);

    var platform = isIOS ? "ios" : isAndroid ? "android" : isDesktop ? "desktop" : "unknown";

    var isSafari = /safari/.test(ua) && !/chrome|crios|fxios|edgios|opios/.test(ua);
    var isChrome = /chrome/.test(ua) && !/edg|opr/.test(ua);
    var isEdge = /edg/.test(ua);
    var isFirefox = /firefox|fxios/.test(ua);
    var isOpera = /opr|opera/.test(ua);
    var isSamsungBrowser = /samsungbrowser/.test(ua);

    var browser = isSafari ? "safari"
        : isChrome ? "chrome"
            : isEdge ? "edge"
                : isFirefox ? "firefox"
                    : isOpera ? "opera"
                        : isSamsungBrowser ? "samsung"
                            : "other";

    return { platform: platform, browser: browser, isIOS: isIOS, isAndroid: isAndroid, isDesktop: isDesktop };
}

function isAppInstalled() {
    var isStandalone = window.matchMedia('(display-mode: standalone)').matches;
    var isIOSStandalone = window.navigator.standalone === true;
    return isStandalone || isIOSStandalone;
}

/* ---------------------------
   INCOGNITO / PRIVATE BROWSING
   DETECTION
---------------------------- */

function _detectPrivateBrowsing() {
    return new Promise(function (resolve) {
        // --- Chrome / Edge / Opera (Chromium-based) ---
        // In incognito, storage quota is significantly limited (~120MB vs several GB)
        if (navigator.storage && navigator.storage.estimate) {
            navigator.storage.estimate().then(function (estimate) {
                // Quota under 200MB strongly suggests incognito
                if (estimate.quota && estimate.quota < 200 * 1024 * 1024) {
                    resolve(true);
                    return;
                }
                resolve(false);
            }).catch(function () {
                resolve(false);
            });
            return;
        }

        // --- Safari (all versions) ---
        // In private mode, Safari limits storage and may throw on write
        if (window.safari !== undefined || /safari/.test(navigator.userAgent.toLowerCase())) {
            try {
                var testKey = '__pwa_private_test__';
                window.localStorage.setItem(testKey, '1');
                window.localStorage.removeItem(testKey);

                // Safari 15+: check if IndexedDB is restricted
                if (window.indexedDB) {
                    var dbReq = window.indexedDB.open('__pwa_private_test_db__');
                    dbReq.onerror = function () {
                        resolve(true);
                    };
                    dbReq.onsuccess = function () {
                        dbReq.result.close();
                        window.indexedDB.deleteDatabase('__pwa_private_test_db__');
                        resolve(false);
                    };
                    return;
                }

                resolve(false);
            } catch (e) {
                resolve(true);
            }
            return;
        }

        // --- Firefox ---
        // In private mode, IndexedDB open throws or is restricted
        if (window.indexedDB) {
            try {
                var db = window.indexedDB.open('__pwa_private_test_db__');
                db.onerror = function () {
                    resolve(true);
                };
                db.onsuccess = function () {
                    db.result.close();
                    window.indexedDB.deleteDatabase('__pwa_private_test_db__');
                    resolve(false);
                };
            } catch (e) {
                resolve(true);
            }
            return;
        }

        resolve(false);
    });
}

/**
 * Public function: returns Promise<boolean>
 * true = likely incognito/private browsing
 */
function isPrivateBrowsing() {
    return _detectPrivateBrowsing();
}

/* ---------------------------
   INSTALL INSTRUCTION DIALOG
   Works on ALL platforms as
   a universal fallback.
---------------------------- */

function _getInstallSteps(info) {
    var steps = [];

    if (info.isIOS) {
        // iOS
        if (info.browser !== 'safari') {
            steps.push({ icon: '🌐', text: 'Open this website in <b>Safari</b> browser' });
        }
        steps.push({ icon: '📤', text: 'Tap the <b>Share</b> button <span style="font-size:18px">⬆</span> at the bottom' });
        steps.push({ icon: '📱', text: 'Scroll down and tap <b>"Add to Home Screen"</b>' });
        steps.push({ icon: '✅', text: 'Tap <b>"Add"</b> in the top-right corner' });

    } else if (info.isAndroid) {
        // Android
        if (info.browser === 'chrome') {
            steps.push({ icon: '⋮', text: 'Tap the <b>three-dot menu</b> (⋮) in the top-right' });
            steps.push({ icon: '📲', text: 'Tap <b>"Install app"</b> or <b>"Add to Home screen"</b>' });
            steps.push({ icon: '✅', text: 'Tap <b>"Install"</b> to confirm' });
        } else if (info.browser === 'samsung') {
            steps.push({ icon: '☰', text: 'Tap the <b>menu icon</b> (☰) at the bottom' });
            steps.push({ icon: '📲', text: 'Tap <b>"Add page to"</b> → <b>"Home screen"</b>' });
            steps.push({ icon: '✅', text: 'Tap <b>"Add"</b> to confirm' });
        } else if (info.browser === 'firefox') {
            steps.push({ icon: '⋮', text: 'Tap the <b>three-dot menu</b> (⋮)' });
            steps.push({ icon: '📲', text: 'Tap <b>"Install"</b>' });
            steps.push({ icon: '✅', text: 'Tap <b>"Add"</b> to confirm' });
        } else {
            steps.push({ icon: '⋮', text: 'Open your <b>browser menu</b>' });
            steps.push({ icon: '📲', text: 'Look for <b>"Install"</b> or <b>"Add to Home screen"</b>' });
            steps.push({ icon: '✅', text: 'Confirm the installation' });
        }

    } else {
        // Desktop (Windows / Mac / Linux)
        if (info.browser === 'chrome') {
            steps.push({ icon: '📥', text: 'Click the <b>Install icon</b> (⊕) in the <b>address bar</b> (right side)' });
            steps.push({ icon: '✅', text: 'Click <b>"Install"</b> in the popup to confirm' });
        } else if (info.browser === 'edge') {
            steps.push({ icon: '📥', text: 'Click the <b>App available icon</b> (⊕) in the <b>address bar</b>' });
            steps.push({ icon: '✅', text: 'Click <b>"Install"</b> to confirm' });
        } else if (info.browser === 'opera') {
            steps.push({ icon: '📥', text: 'Click the <b>install icon</b> in the <b>address bar</b>' });
            steps.push({ icon: '✅', text: 'Click <b>"Install"</b> to confirm' });
        } else {
            steps.push({ icon: '🌐', text: 'Open this site in <b>Google Chrome</b> or <b>Microsoft Edge</b>' });
            steps.push({ icon: '📥', text: 'Click the <b>Install icon</b> (⊕) in the address bar' });
            steps.push({ icon: '✅', text: 'Click <b>"Install"</b> to confirm' });
        }
    }

    return steps;
}

function _showInstallDialog(info) {
    return new Promise(function (resolve) {
        var steps = _getInstallSteps(info);

        // Build steps HTML
        var stepsHtml = '';
        for (var i = 0; i < steps.length; i++) {
            stepsHtml += '<div style="display:flex;align-items:center;gap:12px;padding:14px 0;' +
                (i < steps.length - 1 ? 'border-bottom:1px solid rgba(255,255,255,0.08);' : '') + '">' +
                '<div style="width:36px;height:36px;border-radius:10px;background:rgba(255,255,255,0.1);display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0;">' + steps[i].icon + '</div>' +
                '<div style="font-size:14px;color:rgba(255,255,255,0.9);line-height:1.4;"><span style="color:rgba(255,255,255,0.5);font-size:12px;margin-right:4px;">' + (i + 1) + '.</span> ' + steps[i].text + '</div>' +
                '</div>';
        }

        // Subtitle
        var subtitle = info.isIOS
            ? 'Follow these steps to add to your home screen'
            : info.isAndroid
                ? 'Follow these steps to install the app'
                : 'Follow these steps to install the app on your computer';

        // Create overlay
        var overlay = document.createElement('div');
        overlay.id = '__pwa_install_overlay';
        overlay.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.6);z-index:999999;display:flex;align-items:center;justify-content:center;padding:12px;box-sizing:border-box;animation:__pwa_fadeIn 0.25s ease;-webkit-overflow-scrolling:touch;';

        // Dialog card
        var dialog = document.createElement('div');
        dialog.id = '__pwa_install_dialog';
        dialog.style.cssText = 'width:100%;max-width:400px;max-height:calc(100vh - 24px);max-height:calc(100dvh - 24px);overflow-y:auto;background:linear-gradient(145deg,#1c1c1e,#2c2c2e);border-radius:20px;padding:24px;color:#fff;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;box-shadow:0 20px 60px rgba(0,0,0,0.5);box-sizing:border-box;animation:__pwa_slideUp 0.3s ease;-webkit-overflow-scrolling:touch;';
        dialog.innerHTML =
            '<div style="text-align:center;margin-bottom:16px;">' +
            '  <div style="width:48px;height:48px;border-radius:14px;background:linear-gradient(135deg,#007AFF,#5856D6);display:flex;align-items:center;justify-content:center;margin:0 auto 10px;font-size:24px;">📲</div>' +
            '  <div style="font-size:17px;font-weight:700;letter-spacing:-0.3px;">Install App</div>' +
            '  <div style="font-size:12px;color:rgba(255,255,255,0.5);margin-top:4px;">' + subtitle + '</div>' +
            '</div>' +
            '<div style="background:rgba(255,255,255,0.05);border-radius:14px;padding:4px 14px;margin-bottom:16px;">' + stepsHtml + '</div>' +
            '<div style="padding-bottom:env(safe-area-inset-bottom,0px);">' +
            '  <button id="__pwa_close_btn" style="width:100%;padding:12px;border:none;border-radius:14px;background:linear-gradient(135deg,#007AFF,#5856D6);color:#fff;font-size:15px;font-weight:600;cursor:pointer;letter-spacing:-0.2px;transition:opacity 0.2s;-webkit-tap-highlight-color:transparent;">Got it</button>' +
            '</div>';

        overlay.appendChild(dialog);

        // Inject keyframes + responsive styles
        var styleEl = document.createElement('style');
        styleEl.id = '__pwa_install_style';
        styleEl.textContent =
            '@keyframes __pwa_fadeIn{from{opacity:0}to{opacity:1}}' +
            '@keyframes __pwa_slideUp{from{transform:translateY(100px);opacity:0}to{transform:translateY(0);opacity:1}}' +
            '@keyframes __pwa_slideDown{from{transform:translateY(0);opacity:1}to{transform:translateY(100px);opacity:0}}' +
            '@media(max-width:480px){' +
            '  #__pwa_install_overlay{padding:8px!important;align-items:flex-end!important;}' +
            '  #__pwa_install_dialog{padding:20px 16px!important;border-radius:20px 20px 0 0!important;max-height:85vh!important;max-height:85dvh!important;}' +
            '}' +
            '@media(max-height:500px){' +
            '  #__pwa_install_dialog{padding:16px 14px!important;max-height:calc(100vh - 16px)!important;max-height:calc(100dvh - 16px)!important;}' +
            '}';
        document.head.appendChild(styleEl);
        document.body.appendChild(overlay);

        // Close handler — check install status after dialog close
        function closeDialog() {
            dialog.style.animation = '__pwa_slideDown 0.25s ease forwards';
            overlay.style.animation = '__pwa_fadeIn 0.25s ease reverse forwards';

            setTimeout(function () {
                if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
                var s = document.getElementById('__pwa_install_style');
                if (s) s.parentNode.removeChild(s);

                // Check if user actually installed
                var nowStandalone = window.matchMedia('(display-mode: standalone)').matches;
                var nowIOSStandalone = window.navigator.standalone === true;
                resolve(nowStandalone || nowIOSStandalone);
            }, 280);
        }

        document.getElementById('__pwa_close_btn').addEventListener('click', closeDialog);
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) closeDialog();
        });
    });
}

/* ---------------------------
   INSTALL PROMPT (all platforms)

   Returns Promise<boolean>:
     true  – installed
     false – not installed / dismissed
---------------------------- */

function promptInstall() {
    return new Promise(function (resolve) {
        var isStandalone = window.matchMedia('(display-mode: standalone)').matches;
        var isIOSStandalone = window.navigator.standalone === true;
        var installed = isStandalone || isIOSStandalone;

        // Already installed
        if (installed) {
            console.log('[PWA] Already installed');
            resolve(false);
            return;
        }

        var info = _detectPlatformInfo();

        // Check if private/incognito — can't install in private mode
        _detectPrivateBrowsing().then(function (isPrivate) {
            if (isPrivate) {
                resolve(false);
                return;
            }

            // Try native prompt first (Android / Desktop Chromium)
            var prompt = window.__pwa_deferred_prompt;
            if (prompt && !info.isIOS) {
                prompt.prompt();
                prompt.userChoice
                    .then(function (choiceResult) {
                        console.log('[PWA] User choice:', choiceResult.outcome);
                        window.__pwa_deferred_prompt = null;
                        resolve(choiceResult.outcome === 'accepted');
                    })
                    .catch(function (err) {
                        console.error('[PWA] Prompt error:', err);
                        window.__pwa_deferred_prompt = null;
                        // Fallback to dialog
                        _showInstallDialog(info).then(resolve);
                    });
                return;
            }

            // Fallback: show instruction dialog for ALL platforms
            _showInstallDialog(info).then(resolve);
        });
    });
}

/* ---------------------------
   INSTALL STATUS CHECK
---------------------------- */

function getPWAStatus() {
    return new Promise(function (resolve) {
        var info = _detectPlatformInfo();

        var isStandalone = window.matchMedia('(display-mode: standalone)').matches;
        var isIOSStandalone = window.navigator.standalone === true;
        var installed = isStandalone || isIOSStandalone;

        // canInstall is true on all platforms when not installed
        // (we always have a fallback dialog)
        var canInstall = !installed;

        var iosInstructions = null;
        if (info.isIOS && !installed) {
            if (info.browser === 'safari') {
                iosInstructions = {
                    step1: "Tap the Share button (square with an arrow) at the bottom of Safari.",
                    step2: "Scroll down and tap 'Add to Home Screen'.",
                    step3: "Tap 'Add' in the top-right corner to install."
                };
            } else {
                iosInstructions = {
                    step1: "Open this website in Safari browser.",
                    step2: "Tap the Share button (square with an arrow).",
                    step3: "Scroll down and tap 'Add to Home Screen'.",
                    step4: "Tap 'Add' to install."
                };
            }
        }

        // Detect private/incognito browsing
        _detectPrivateBrowsing().then(function (isPrivate) {
            var result = {
                platform: info.platform,
                isInstalled: installed,
                canInstall: canInstall && !isPrivate,
                isPrivateBrowsing: isPrivate,
                iosInstructions: iosInstructions
            };

            resolve(JSON.stringify(result));
        });
    });
}

/* ---------------------------
   UPDATE DETECTION
---------------------------- */

var newServiceWorker = null;

function initUpdateDetector() {
    if (!('serviceWorker' in navigator)) return;

    navigator.serviceWorker.register('flutter_service_worker.js')
        .then(function (registration) {
            registration.onupdatefound = function () {
                newServiceWorker = registration.installing;

                newServiceWorker.onstatechange = function () {
                    if (
                        newServiceWorker.state === 'installed' &&
                        navigator.serviceWorker.controller
                    ) {
                        console.log('[PWA] New update available');
                        if (window.updateAvailable) {
                            window.updateAvailable();
                        }
                    }
                };
            };
        });
}

function updateApp() {
    if (!newServiceWorker) return false;

    newServiceWorker.postMessage({ action: 'skipWaiting' });

    newServiceWorker.addEventListener('statechange', function () {
        if (newServiceWorker.state === 'activated') {
            window.location.reload();
        }
    });

    return true;
}

/* ---------------------------
   INSTALL COMPLETE EVENT
---------------------------- */

window.addEventListener('appinstalled', function () {
    window.__pwa_deferred_prompt = null;
    console.log('[PWA] App installed successfully');
    if (window.appInstalled) {
        window.appInstalled();
    }
});