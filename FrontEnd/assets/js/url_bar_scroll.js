/* ===================================================
   URL Bar Scroll Controller
   Hides browser URL bar on scroll-down,
   shows it on scroll-up for Flutter Web apps.

   Flutter renders inside a fixed canvas and handles
   scrolling internally, so the browser never sees
   native body scrolling. This script bridges that gap
   by tracking touch gestures and translating them into
   tiny native body scrolls that trigger the browser's
   URL bar auto-hide/show behavior.

   Usage from Dart (via dynamicJsLoader):
     - initUrlBarScroll()   → activate
     - disposeUrlBarScroll() → deactivate & clean up
   =================================================== */

(function () {
    "use strict";

    /* ---------- state ---------- */
    var _initialized = false;
    var _spacer = null;
    var _startY = 0;
    var _lastY = 0;
    var _scrollDirection = 0;           // 1 = down, -1 = up
    var _threshold = 10;                // px before we commit to a direction
    var _locked = false;                // prevent rapid toggling
    var _lockTimer = null;
    var _lockDuration = 300;            // ms cooldown between toggles
    var _isStandalone = false;

    /* ---------- helpers ---------- */

    /** True when running as an installed PWA — URL bar is already gone. */
    function _checkStandalone() {
        return (
            window.matchMedia("(display-mode: standalone)").matches ||
            window.matchMedia("(display-mode: fullscreen)").matches ||
            window.navigator.standalone === true
        );
    }

    /** True on mobile (where URL bar hiding matters). */
    function _isMobile() {
        return /android|iphone|ipad|ipod/i.test(navigator.userAgent);
    }

    /* ---------- spacer management ---------- */

    /**
     * Insert an invisible spacer div that makes the document taller
     * than the viewport. This is what lets the browser "scroll" and
     * trigger URL bar hide/show.
     */
    function _createSpacer() {
        if (_spacer) return;

        _spacer = document.createElement("div");
        _spacer.id = "__url_bar_spacer";
        _spacer.setAttribute("aria-hidden", "true");
        _spacer.style.cssText =
            "position:absolute;" +
            "top:0;left:0;" +
            "width:1px;" +
            "height:calc(100vh + 100px);" +       // taller than viewport
            "height:calc(100dvh + 100px);" +       // dynamic vh for modern browsers
            "pointer-events:none;" +
            "opacity:0;" +
            "z-index:-99999;";

        document.body.appendChild(_spacer);

        // Ensure body can scroll the spacer
        document.documentElement.style.setProperty("overflow-y", "auto", "important");
        document.body.style.setProperty("overflow-y", "auto", "important");
        // Prevent visual overscroll bounce on iOS
        document.body.style.setProperty("overscroll-behavior-y", "none");
        document.documentElement.style.setProperty("overscroll-behavior-y", "none");
    }

    function _removeSpacer() {
        if (_spacer && _spacer.parentNode) {
            _spacer.parentNode.removeChild(_spacer);
        }
        _spacer = null;
    }

    /* ---------- scroll logic ---------- */

    /**
     * Scroll the native body to trigger URL bar behavior.
     * direction: 1 = scroll down (hide bar), -1 = scroll up (show bar)
     */
    function _nativeScroll(direction) {
        if (_locked) return;

        _locked = true;
        clearTimeout(_lockTimer);
        _lockTimer = setTimeout(function () {
            _locked = false;
        }, _lockDuration);

        if (direction === 1) {
            // Scroll down → hide URL bar
            window.scrollTo({ top: 1, behavior: "instant" });
        } else {
            // Scroll up → show URL bar
            window.scrollTo({ top: 0, behavior: "instant" });
        }
    }

    /* ---------- touch handlers ---------- */

    function _onTouchStart(e) {
        _startY = e.touches[0].clientY;
        _lastY = _startY;
        _scrollDirection = 0;
    }

    function _onTouchMove(e) {
        var currentY = e.touches[0].clientY;
        var deltaFromStart = _startY - currentY;   // positive = finger moved up = content scrolls down
        var deltaFromLast = _lastY - currentY;

        _lastY = currentY;

        // Only act once we pass the threshold
        if (Math.abs(deltaFromStart) < _threshold) return;

        var newDirection = deltaFromLast > 0 ? 1 : -1;

        // Only fire when direction actually changes
        if (newDirection !== _scrollDirection) {
            _scrollDirection = newDirection;
            _nativeScroll(_scrollDirection);
        }
    }

    function _onTouchEnd() {
        _scrollDirection = 0;
    }

    /* ---------- wheel handler (for desktop testing) ---------- */

    function _onWheel(e) {
        var direction = e.deltaY > 0 ? 1 : -1;
        _nativeScroll(direction);
    }

    /* ---------- public API ---------- */

    /**
     * Initialize URL bar scroll behavior.
     * Call from Dart via dynamicJsLoader.
     * Returns "initialized" | "skipped" (string).
     */
    window.initUrlBarScroll = function () {
        // Skip if already initialized
        if (_initialized) return "already_initialized";

        // Skip on desktop browsers (URL bar doesn't auto-hide)
        if (!_isMobile()) return "skipped_desktop";

        // Skip if running as installed PWA (no URL bar to hide)
        _isStandalone = _checkStandalone();
        if (_isStandalone) return "skipped_standalone";

        _createSpacer();

        // Start scrolled down so URL bar is already collapsed
        setTimeout(function () {
            window.scrollTo(0, 1);
        }, 300);

        // Attach touch listeners with passive: true so we don't
        // block Flutter's own gesture handling.
        document.addEventListener("touchstart", _onTouchStart, { passive: true });
        document.addEventListener("touchmove", _onTouchMove, { passive: true });
        document.addEventListener("touchend", _onTouchEnd, { passive: true });
        document.addEventListener("wheel", _onWheel, { passive: true });

        // Listen for transition to standalone (app installed while page open)
        try {
            var mql = window.matchMedia("(display-mode: standalone)");
            var handler = function (e) {
                if (e.matches) {
                    // App is now installed — clean up
                    disposeUrlBarScroll();
                }
            };
            if (mql.addEventListener) {
                mql.addEventListener("change", handler);
            } else if (mql.addListener) {
                mql.addListener(handler);
            }
        } catch (_) { /* ignore */ }

        _initialized = true;
        console.log("[UrlBarScroll] initialized — URL bar will auto-hide on scroll");
        return "initialized";
    };

    /**
     * Clean up – remove spacer and event listeners.
     * Call from Dart when navigating away or no longer needed.
     */
    window.disposeUrlBarScroll = function () {
        if (!_initialized) return "not_initialized";

        document.removeEventListener("touchstart", _onTouchStart);
        document.removeEventListener("touchmove", _onTouchMove);
        document.removeEventListener("touchend", _onTouchEnd);
        document.removeEventListener("wheel", _onWheel);

        clearTimeout(_lockTimer);
        _removeSpacer();

        // Restore overflow
        document.documentElement.style.removeProperty("overflow-y");
        document.body.style.removeProperty("overflow-y");
        document.body.style.removeProperty("overscroll-behavior-y");
        document.documentElement.style.removeProperty("overscroll-behavior-y");

        _initialized = false;
        console.log("[UrlBarScroll] disposed");
        return "disposed";
    };

    /**
     * Manually trigger URL bar hide.
     * Useful when Flutter detects a scroll-down itself.
     */
    window.hideUrlBar = function () {
        if (_isStandalone || !_isMobile()) return;
        window.scrollTo({ top: 1, behavior: "instant" });
    };

    /**
     * Manually trigger URL bar show.
     * Useful when Flutter detects a scroll-to-top.
     */
    window.showUrlBar = function () {
        if (_isStandalone || !_isMobile()) return;
        window.scrollTo({ top: 0, behavior: "instant" });
    };

})();
