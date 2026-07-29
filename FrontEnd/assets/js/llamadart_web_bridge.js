/**
 * Dynamic loader for llamadart WebGPU Bridge Runtime.
 * Converts cross-origin CDN Web Worker scripts to same-origin Blob URLs.
 */
(function () {
    const cdnBase = "https://cdn.jsdelivr.net/gh/leehack/llama-web-bridge-assets@v0.1.18/";
    const bridgeUrl = cdnBase + "llama_webgpu_bridge.js";

    async function fetchAsBlobUrl(url) {
        try {
            const resp = await fetch(url);
            if (!resp.ok) return null;
            const text = await resp.text();
            const blob = new Blob([text], { type: 'application/javascript' });
            return URL.createObjectURL(blob);
        } catch (e) {
            console.warn('Failed to fetch script for Blob URL:', url, e);
            return null;
        }
    }

    async function ensureLlamaWebGpuBridge() {
        if (window.LlamaWebGpuBridge) {
            return true;
        }
        try {
            // Create same-origin Blob URLs for cross-origin Web Worker scripts
            const coreUrl = cdnBase + "llama_webgpu_core.js";
            const blobCoreUrl = await fetchAsBlobUrl(coreUrl);
            if (blobCoreUrl) {
                window.__llamadartBridgeCoreModuleUrl = blobCoreUrl;
            }

            const workerUrl = cdnBase + "llama_webgpu_bridge_worker.js";
            const blobWorkerUrl = await fetchAsBlobUrl(workerUrl);
            if (blobWorkerUrl) {
                window.__llamadartBridgeWorkerUrl = blobWorkerUrl;
            }

            const mod = await import(bridgeUrl);
            if (mod && mod.LlamaWebGpuBridge) {
                window.LlamaWebGpuBridge = mod.LlamaWebGpuBridge;
                window.__llamadartBridgeReady = true;
                return true;
            }
        } catch (err) {
            console.warn("llamadart WebGPU bridge import warning:", err);
        }
        return false;
    }

    window.ensureLlamaWebGpuBridge = ensureLlamaWebGpuBridge;
})();
