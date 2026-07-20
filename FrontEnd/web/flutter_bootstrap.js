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
 * Calculates a dynamic loading delay based on network conditions.
 *
 * Delay Range:
 *   1000ms (Fast)
 *   6000ms (Very Slow)
 */
async function getConnectionDelay() {
  const MIN_DELAY = 1000;
  const MAX_DELAY = 6000;

  const clamp = (value) =>
    Math.min(Math.max(Math.round(value), MIN_DELAY), MAX_DELAY);

  const connection = navigator.connection;

  // ==========================================================
  // Chrome / Edge / Android
  // ==========================================================
  if (
    connection &&
    typeof connection.downlink === "number" &&
    typeof connection.rtt === "number"
  ) {
    const downlink = Math.max(connection.downlink, 0.1);
    const rtt = Math.max(connection.rtt, 0);

    console.log(`Downlink: ${downlink.toFixed(2)} Mbps`);
    console.log(`RTT: ${rtt} ms`);

    // Slow speed contributes more delay
    const speedDelay = (1 / downlink) * 2200;

    // High latency contributes more delay
    const latencyDelay = rtt * 2;

    // Combine both (70% speed, 30% latency)
    const delay = speedDelay * 0.7 + latencyDelay * 0.3;

    const finalDelay = clamp(delay);

    console.log(`Loading Delay: ${finalDelay} ms`);

    return finalDelay;
  }

  // ==========================================================
  // Safari / Firefox / iOS
  // ==========================================================
  try {
    const start = performance.now();

    await fetch(`icons/favicon.ico?t=${Date.now()}`, {
      cache: "no-store",
    });

    const latency = performance.now() - start;

    console.log(`Measured latency: ${latency.toFixed(0)} ms`);

    const finalDelay = clamp(latency * 2);

    console.log(`Loading Delay: ${finalDelay} ms`);

    return finalDelay;
  } catch (e) {
    console.warn("Unable to measure network.", e);

    return 3000;
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
            const duration = networkDelay;
            // Smooth fade out immediately when the build is loaded and running
            web_loader.style.pointerEvents = "none";
            web_loader.style.transition = `opacity ${duration / 1000}s ease`;
            web_loader.style.opacity = "0";

            await addDelay(duration); // Wait for fade-out transition
            web_loader.remove();
        }
    }
});