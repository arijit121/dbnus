/**
 * Dynamic loader for llamadart WebGPU Bridge Runtime.
 * Loads same-origin WebGPU bridge assets from webgpu_bridge/ or assets/js/webgpu_bridge/
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

    function getAbsoluteUrl(relativePath) {
        try {
            const baseUrl = window.location.origin + window.location.pathname.replace(/\/[^\/]*$/, '/');
            return new URL(relativePath, baseUrl).toString();
        } catch (_) {
            return relativePath;
        }
    }

    async function ensureLlamaWebGpuBridge() {
        if (window.LlamaWebGpuBridge && window.__llamadartBridgeReady) {
            return true;
        }
        try {
            let bridgeUrl = getAbsoluteUrl("webgpu_bridge/llama_webgpu_bridge.js");
            let mod;
            try {
                mod = await import(bridgeUrl);
            } catch (_) {
                bridgeUrl = getAbsoluteUrl("assets/js/webgpu_bridge/llama_webgpu_bridge.js");
                mod = await import(bridgeUrl);
            }

            if (mod && mod.LlamaWebGpuBridge) {
                const baseDir = bridgeUrl.substring(0, bridgeUrl.lastIndexOf('/') + 1);
                window.LlamaWebGpuBridge = mod.LlamaWebGpuBridge;
                window.__llamadartBridgeModuleUrl = bridgeUrl;
                window.__llamadartBridgeCoreModuleUrl = baseDir + "llama_webgpu_core.js";
                window.__llamadartBridgeCoreModuleUrlMem64 = baseDir + "llama_webgpu_core_mem64.js";
                window.__llamadartBridgeWasmUrl = baseDir + "llama_webgpu_core.wasm";
                window.__llamadartBridgeWasmUrlMem64 = baseDir + "llama_webgpu_core.wasm";
                window.__llamadartBridgeWorkerUrl = baseDir + "llama_webgpu_bridge_worker.js";
                window.__llamadartBridgePreferMemory64 = false;
                window.__llamadartBridgeLoadError = null;

                window.__llamadartBridgeReady = true;
                if (__resolveBridgeReady) {
                    __resolveBridgeReady();
                }
                return true;
            }
        } catch (err) {
            console.warn("llamadart same-origin WebGPU bridge load warning:", err);
            window.__llamadartBridgeLoadError = String(err);
            if (__rejectBridgeReady) {
                __rejectBridgeReady(err);
            }
        }
        return false;
    }

    window.ensureLlamaWebGpuBridge = ensureLlamaWebGpuBridge;
})();
