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

var web_initial_loader = document.getElementById("web-initial-loader");
_flutter.loader.load({
    serviceWorkerSettings: {
        serviceWorkerVersion: {{flutter_service_worker_version}},
    },
    onEntrypointLoaded: async function (engineInitializer) {

        const assetBase = window.location.origin + "/";

        let appRunner = await engineInitializer.initializeEngine({
            assetBase: assetBase,
          });

        window.flutterAssetBase = assetBase;

        await appRunner.runApp();

        // Add a delay using the addDelay function.
        await addDelay(10000);

        if (web_initial_loader) {
            web_initial_loader.remove();
        }
    }
});