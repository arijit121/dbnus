/**
 * Dynamic loader for llamadart WebGPU Bridge Runtime.
 * Loads same-origin WebGPU bridge assets strictly from assets/js/webgpu_bridge/
 */
(function () {
    let __resolveBridgeReady;
    let __rejectBridgeReady;

    if (!window.__llamadartBridgeReadyPromise) {
        window.__llamadartBridgeReady = false;
        window.__llamadartBridgeReadyPromise = new Promise((resolve, reject) => {
            __resolveBridgeReady = resolve;
            __rejectBridgeReady = reject;
        });
        window.__llamadartBridgeReadyPromise.catch(function () {});
    }

    function getBridgeBaseDir() {
        try {
            const scriptEl = document.querySelector('script[src*="llamadart_web_bridge.js"]');
            if (scriptEl && scriptEl.src) {
                const src = scriptEl.src;
                return src.substring(0, src.lastIndexOf('/') + 1);
            }
        } catch (_) {}

        let base = window.flutterAssetBase || (window.location.origin + window.location.pathname);
        if (!base.endsWith('/')) {
            base += '/';
        }

        const isReleaseBuild = document.querySelector('script[src*="assets/assets/"]') !== null;
        return base + (isReleaseBuild ? 'assets/assets/js/' : 'assets/js/');
    }

    async function ensureLlamaWebGpuBridge() {
        if (window.LlamaWebGpuBridge && window.__llamadartBridgeReady) {
            return true;
        }
        try {
            const baseDir = getBridgeBaseDir();
            const bridgeUrl = baseDir + "webgpu_bridge/llama_webgpu_bridge.js";
            const mod = await import(bridgeUrl);

            if (mod && mod.LlamaWebGpuBridge) {
                const bridgeDir = baseDir + "webgpu_bridge/";
                window.LlamaWebGpuBridge = mod.LlamaWebGpuBridge;
                window.__llamadartBridgeModuleUrl = bridgeUrl;
                window.__llamadartBridgeCoreModuleUrl = bridgeDir + "llama_webgpu_core.js";
                window.__llamadartBridgeCoreModuleUrlMem64 = bridgeDir + "llama_webgpu_core_mem64.js";
                window.__llamadartBridgeWasmUrl = bridgeDir + "llama_webgpu_core.wasm";
                window.__llamadartBridgeWasmUrlMem64 = bridgeDir + "llama_webgpu_core.wasm";
                window.__llamadartBridgeWorkerUrl = bridgeDir + "llama_webgpu_bridge_worker.js";
                window.__llamadartBridgePreferMemory64 = false;
                window.__llamadartBridgeLoadError = null;

                window.__llamadartBridgeReady = true;
                if (__resolveBridgeReady) {
                    __resolveBridgeReady();
                }
                return true;
            }
        } catch (err) {
            console.warn("llamadart assets WebGPU bridge load warning:", err);
            window.__llamadartBridgeLoadError = String(err);
            if (__rejectBridgeReady) {
                __rejectBridgeReady(err);
            }
        }
        return false;
    }

    window.ensureLlamaWebGpuBridge = ensureLlamaWebGpuBridge;
})();
