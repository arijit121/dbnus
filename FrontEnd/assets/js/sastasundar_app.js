function isEligibleForOpenSastaSundarApp() {
    return new Promise((resolve) => {
        const ua = navigator.userAgent || navigator.vendor || window.opera;

        const isAndroid = /Android/i.test(ua);
        const isIOS = /iPhone|iPad|iPod/i.test(ua);

        const isMobile = isAndroid || isIOS;

        const isSupportedBrowser =
            /Chrome|CriOS|Safari|EdgiOS|EdgA/i.test(ua);

        _detectPrivateBrowsing()
            .then((isPrivateBrowsing) => {
                resolve(
                    isMobile &&
                    isSupportedBrowser &&
                    !isPrivateBrowsing
                );
            })
            .catch(() => {
                resolve(
                    isMobile &&
                    isSupportedBrowser
                );
            });
    });
}

function _detectPrivateBrowsing() {
    return new Promise((resolve) => {
        const on = () => resolve(true);
        const off = () => resolve(false);

        try {
            if (window.webkitRequestFileSystem) {
                window.webkitRequestFileSystem(
                    window.TEMPORARY,
                    1,
                    off,
                    on
                );
                return;
            }

            if ('MozAppearance' in document.documentElement.style) {
                const db = indexedDB.open('test');
                db.onerror = on;
                db.onsuccess = off;
                return;
            }

            try {
                localStorage.setItem('test', '1');
                localStorage.removeItem('test');
                off();
            } catch (e) {
                on();
            }
        } catch (e) {
            off();
        }
    });
}

function openSastaSundarApp() {
    const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent);
    const isAndroid = /Android/.test(navigator.userAgent);

    let appOpened = false;

    const markAppOpened = () => {
        appOpened = true;

        document.removeEventListener(
            "visibilitychange",
            visibilityHandler
        );
        window.removeEventListener("blur", blurHandler);
        window.removeEventListener("pagehide", pageHideHandler);

        if (fallbackTimer) {
            clearTimeout(fallbackTimer);
        }
    };

    const visibilityHandler = () => {
        if (document.hidden) {
            markAppOpened();
        }
    };

    const blurHandler = () => {
        markAppOpened();
    };

    const pageHideHandler = () => {
        markAppOpened();
    };

    document.addEventListener(
        "visibilitychange",
        visibilityHandler
    );

    window.addEventListener("blur", blurHandler);

    window.addEventListener("pagehide", pageHideHandler);

    const currentRoute =
        window.location.pathname +
        window.location.search +
        window.location.hash;

    const deepLink =
        `sspl://sastasundar.com${currentRoute}`;

    window.location.href = deepLink;

    const fallbackTimer = setTimeout(() => {
        if (appOpened) {
            return;
        }

        if (isIOS) {
            window.location.href =
                "https://apps.apple.com/in/app/sastasundar-online-pharmacy/id6738185605";
        } else if (isAndroid) {
            window.location.href =
                "https://play.google.com/store/apps/details?id=com.shtpl.sastasundar";
        }
    }, 2000);
}