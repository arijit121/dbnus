{{flutter_js}}
{{flutter_build_config}}


/**
        * Creates a Promise that resolves after a specified delay.
        *
        * @param {number} delay - The delay duration in milliseconds.
        * @returns {Promise} A Promise that resolves after the specified delay.
        */
function addDelay(delay) {
  return new Promise((resolve) => setTimeout(resolve, delay));
}

/**
 * Returns how long the loading screen should stay visible.
 * Slower connection => longer loading animation.
 */
async function getConnectionDelay() {
  const connection = navigator.connection;

  // --- STRATEGY 1: Chromium Shortcut (Chrome, Edge, Android) ---
  if (connection && typeof connection.downlink === 'number' && typeof connection.rtt === 'number') {
    const downlink = connection.downlink;
    const rtt = connection.rtt;
    
    if (downlink <= 0.5 || rtt >= 2000) return 6000;
    if (downlink <= 1.0 || rtt >= 1000) return 5000;
    if (downlink <= 2.0 || rtt >= 600)  return 4000;
    if (downlink <= 5.0 || rtt >= 400)  return 3000;
    if (downlink <= 10.0 || rtt >= 150) return 2000;
    return 1000;
  }

  // --- STRATEGY 2: Cross-Platform Fallback (Safari, Firefox, iOS) ---
  try {
    // We fetch a tiny, un-cacheable file to measure real-time latency
    const startTime = performance.now();
    
    await fetch('icons/favicon.ico', { 
      cache: 'no-store', // Crucial: forces a fresh network request
      mode: 'no-cors' 
    });
    
    const endTime = performance.now();
    const duration = endTime - startTime; // This acts as our real-time RTT

    console.log(`Cross-platform measured latency: ${duration.toFixed(2)} ms`);

    // Map the measured latency directly to your tiers
    if (duration >= 2000) return 7000;
    if (duration >= 1000) return 6000;
    if (duration >= 600)  return 5000;
    if (duration >= 400)  return 4000;
    if (duration >= 150)  return 3000;
    return 2000;

  } catch (error) {
    console.warn("Network ping failed, defaulting.", error);
    return 2000; // Safe default if user is offline or fetch fails
  }
}

var web_loader = document.getElementById("web-loader");
var seoLoader = document.getElementById("web-seo-content-loader");

const assetBase = window.location.origin + "/";

const searchParams = new URLSearchParams(window.location.search);
const renderer = searchParams.get('renderer');

_flutter.loader.load({
    config: {
         renderer: renderer,
         // Load main.dart.js from CDN
         entrypointBaseUrl: assetBase,
         // Load assets from CDN
         assetBase: assetBase,
        // Load CanvasKit from CDN
         canvasKitBaseUrl:`${assetBase}canvaskit/`,
    },
    serviceWorkerSettings: {
        serviceWorkerVersion: {{flutter_service_worker_version}},
    },
    onEntrypointLoaded: async function (engineInitializer) {

        const appRunner = await engineInitializer.initializeEngine({assetBase: assetBase});

        await appRunner.runApp();

        window.flutterAssetBase = assetBase;
        window.flutterLoaded = true;

        const networkDelay = await getConnectionDelay();
        console.log(`Returned Delay: ${networkDelay}ms`);

        // Hide SEO loaders from the user once Flutter is loaded, but keep in DOM
        if (seoLoader) {
            const duration = networkDelay;
            await addDelay(duration);
            const doc = new DOMParser().parseFromString(seoLoader.innerHTML, "text/html");
            seoLoader.innerHTML = doc.body.innerHTML;
        }

        if (web_loader) {
            const duration = networkDelay + 300;
            // Smooth fade out immediately when the build is loaded and running
            web_loader.style.pointerEvents = "none";
            web_loader.style.transition = `opacity ${duration / 1000}s ease`;
            web_loader.style.opacity = "0";

            await addDelay(duration); // Wait for fade-out transition
            web_loader.remove();
        }
    }
});