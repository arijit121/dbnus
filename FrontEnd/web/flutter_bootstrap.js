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

var web_loader = document.getElementById("web-loader");
var seoLoader = document.getElementById("web-seo-content-loader");

const assetBase = window.location.origin + "/";

const searchParams = new URLSearchParams(window.location.search);
const renderer = searchParams.get('renderer');

_flutter.loader.load({
    config: {
         renderer: renderer,
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

        // Hide SEO loaders from the user once Flutter is loaded, but keep in DOM
        if (seoLoader) {
            await addDelay(400);
            const doc = new DOMParser().parseFromString(seoLoader.innerHTML, "text/html");
            seoLoader.innerHTML = doc.body.innerHTML;
        }

        if (web_loader) {
            // Add a delay using the addDelay function.
            await addDelay(10000);
            web_loader.remove();
        }
    }
});