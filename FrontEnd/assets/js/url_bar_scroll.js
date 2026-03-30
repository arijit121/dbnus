/* ===================================================
   URL Bar Scroll Controller — Flutter Web Edition v4
   Hides browser URL bar on scroll-down,
   shows it on scroll-up for Flutter Web apps.

   Strategy:
   1. Make body scrollable (height:auto, overflow:auto)
   2. Pin flutter-view with position:fixed so app stays
      in place while body scrolls
   3. Use passive touch listeners to detect scroll
      direction and call window.scrollTo() from within
      the user gesture context
   4. Do NOT override touch-action — that breaks
      Flutter's internal scroll handling

   Usage from Dart (via dynamicJsLoader):
     - initUrlBarScroll()    → activate
     - disposeUrlBarScroll() → deactivate & clean up
     - hideUrlBar()          → manual hide
     - showUrlBar()          → manual show
   =================================================== */

(function () {
    "use strict";

    /* ---------- state ---------- */
    var _initialized = false;
    var _spacer = null;
    var _styleTag = null;
    var _flutterContainer = null;
    var _isStandalone = false;

    var _startY = 0;
    var _lastY = 0;
    var _scrollDirection = 0;     // 1 = down, -1 = up
    var _threshold = 10;          // px before committing
    var _locked = false;
    var _lockTimer = null;
    var _lockDuration = 300;      // ms cooldown

    /* ---------- helpers ---------- */

    function _checkStandalone() {
        return (
            window.matchMedia("(display-mode: standalone)").matches ||
            window.matchMedia("(display-mode: fullscreen)").matches ||
            window.navigator.standalone === true
        );
    }

    function _isMobile() {
        return /android|iphone|ipad|ipod/i.test(navigator.userAgent);
    }

    function _findFlutterContainer() {
        return document.querySelector('flutter-view') ||
               document.querySelector('flt-glass-pane') ||
               null;
    }

    /* ---------- DOM setup ---------- */

    function _setupStyles() {
        // Inject style with !important overrides for body/html
        _styleTag = document.createElement("style");
        _styleTag.id = "__url_bar_scroll_styles";
        _styleTag.textContent = [
            "html.__url-bar-scroll {",
            "  height: auto !important;",
            "  min-height: 100% !important;",
            "  overflow-y: auto !important;",
            "  overflow-x: hidden !important;",
            "  overscroll-behavior-y: none !important;",
            "}",
            "body.__url-bar-scroll {",
            "  height: auto !important;",
            "  min-height: calc(100vh + 2px) !important;",
            "  min-height: calc(100dvh + 2px) !important;",
            "  overflow-y: auto !important;",
            "  overflow-x: hidden !important;",
            "  overscroll-behavior-y: none !important;",
            "}",
            ".__url-bar-scroll-pinned {",
            "  position: fixed !important;",
            "  top: 0 !important;",
            "  left: 0 !important;",
            "  width: 100% !important;",
            "  height: 100vh !important;",
            "  height: 100dvh !important;",
            "  z-index: 1 !important;",
            "}"
        ].join("\n");
        document.head.appendChild(_styleTag);

        // Add classes
        document.documentElement.classList.add("__url-bar-scroll");
        document.body.classList.add("__url-bar-scroll");

        // Inline styles as backup (Flutter may reset CSS)
        document.documentElement.style.setProperty("height", "auto", "important");
        document.documentElement.style.setProperty("overflow-y", "auto", "important");
        document.body.style.setProperty("height", "auto", "important");
        document.body.style.setProperty("overflow-y", "auto", "important");

        // Pin Flutter container
        _flutterContainer = _findFlutterContainer();
        if (_flutterContainer) {
            _flutterContainer.classList.add("__url-bar-scroll-pinned");
            console.log("[UrlBarScroll] Flutter container found and pinned:", _flutterContainer.tagName);
        } else {
            console.warn("[UrlBarScroll] Flutter container not found, retrying...");
            setTimeout(function () {
                _flutterContainer = _findFlutterContainer();
                if (_flutterContainer) {
                    _flutterContainer.classList.add("__url-bar-scroll-pinned");
                    console.log("[UrlBarScroll] Flutter container found on retry:", _flutterContainer.tagName);
                } else {
                    console.error("[UrlBarScroll] Flutter container still not found!");
                }
            }, 1000);
        }
    }

    function _createSpacer() {
        if (_spacer) return;
        _spacer = document.createElement("div");
        _spacer.id = "__url_bar_spacer";
        _spacer.setAttribute("aria-hidden", "true");
        _spacer.style.cssText =
            "width:1px;height:1px;" +
            "pointer-events:none;opacity:0;" +
            "position:relative;z-index:-99999;";
        document.body.appendChild(_spacer);
    }

    /* ---------- cleanup ---------- */

    function _removeStyles() {
        if (_styleTag && _styleTag.parentNode) {
            _styleTag.parentNode.removeChild(_styleTag);
        }
        _styleTag = null;

        document.documentElement.classList.remove("__url-bar-scroll");
        document.body.classList.remove("__url-bar-scroll");

        document.documentElement.style.removeProperty("height");
        document.documentElement.style.removeProperty("overflow-y");
        document.body.style.removeProperty("height");
        document.body.style.removeProperty("overflow-y");

        if (_flutterContainer) {
            _flutterContainer.classList.remove("__url-bar-scroll-pinned");
        }
        _flutterContainer = null;
    }

    function _removeSpacer() {
        if (_spacer && _spacer.parentNode) {
            _spacer.parentNode.removeChild(_spacer);
        }
        _spacer = null;
    }

    /* ---------- scroll logic ---------- */

    function _nativeScroll(direction) {
        if (_locked) return;
        _locked = true;
        clearTimeout(_lockTimer);
        _lockTimer = setTimeout(function () { _locked = false; }, _lockDuration);

        if (direction === 1) {
            window.scrollTo({ top: 1, behavior: "instant" });
        } else {
            window.scrollTo({ top: 0, behavior: "instant" });
        }
    }

    /* ---------- touch handlers ---------- */

    function _onTouchStart(e) {
        if (!e.touches || !e.touches.length) return;
        _startY = e.touches[0].clientY;
        _lastY = _startY;
        _scrollDirection = 0;
    }

    function _onTouchMove(e) {
        if (!e.touches || !e.touches.length) return;
        var currentY = e.touches[0].clientY;
        var deltaFromStart = _startY - currentY;
        var deltaFromLast = _lastY - currentY;
        _lastY = currentY;

        if (Math.abs(deltaFromStart) < _threshold) return;

        var newDirection = deltaFromLast > 0 ? 1 : -1;
        if (newDirection !== _scrollDirection) {
            _scrollDirection = newDirection;
            _nativeScroll(_scrollDirection);
        }
    }

    function _onTouchEnd() {
        _scrollDirection = 0;
    }

    function _onWheel(e) {
        var direction = e.deltaY > 0 ? 1 : -1;
        _nativeScroll(direction);
    }

    /* ---------- public API ---------- */

    window.initUrlBarScroll = function () {
        if (_initialized) return "already_initialized";
        if (!_isMobile()) return "skipped_desktop";

        _isStandalone = _checkStandalone();
        if (_isStandalone) return "skipped_standalone";

        _setupStyles();
        _createSpacer();

        // Initial scroll to hide URL bar
        setTimeout(function () {
            window.scrollTo(0, 1);
        }, 500);

        // Passive touch listeners — these fire alongside
        // Flutter's pointer events without interfering
        document.addEventListener("touchstart", _onTouchStart, { passive: true });
        document.addEventListener("touchmove", _onTouchMove, { passive: true });
        document.addEventListener("touchend", _onTouchEnd, { passive: true });
        document.addEventListener("wheel", _onWheel, { passive: true });

        // Auto-cleanup if app becomes standalone (PWA installed)
        try {
            var mql = window.matchMedia("(display-mode: standalone)");
            var handler = function (e) {
                if (e.matches) window.disposeUrlBarScroll();
            };
            if (mql.addEventListener) mql.addEventListener("change", handler);
            else if (mql.addListener) mql.addListener(handler);
        } catch (_) { }

        _initialized = true;
        console.log("[UrlBarScroll] initialized — body is scrollable, touch listeners active");
        console.log("[UrlBarScroll] body scrollHeight:", document.body.scrollHeight, "innerHeight:", window.innerHeight);
        return "initialized";
    };

    window.disposeUrlBarScroll = function () {
        if (!_initialized) return "not_initialized";

        document.removeEventListener("touchstart", _onTouchStart);
        document.removeEventListener("touchmove", _onTouchMove);
        document.removeEventListener("touchend", _onTouchEnd);
        document.removeEventListener("wheel", _onWheel);

        clearTimeout(_lockTimer);
        _removeSpacer();
        _removeStyles();
        window.scrollTo(0, 0);

        _initialized = false;
        console.log("[UrlBarScroll] disposed");
        return "disposed";
    };

    window.hideUrlBar = function () {
        if (_isStandalone || !_isMobile() || !_initialized) return;
        window.scrollTo({ top: 1, behavior: "instant" });
    };

    window.showUrlBar = function () {
        if (_isStandalone || !_isMobile() || !_initialized) return;
        window.scrollTo({ top: 0, behavior: "instant" });
    };

})();
