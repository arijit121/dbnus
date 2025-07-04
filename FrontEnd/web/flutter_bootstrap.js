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

        let appRunner = await engineInitializer.initializeEngine({assetBase: assetBase});

        await appRunner.runApp();

        window.flutterAssetBase = assetBase;

        // Add a delay using the addDelay function.
        await addDelay(10000);

        if (web_loader) {
            web_loader.remove();
        }
    }
});