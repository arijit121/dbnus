/**
 * Reads the Flutter asset base URL.
 * Tries localStorage first (fastest, always available from first visit),
 * then falls back to the window variable.
 */
function getFlutterAssetBase() {
    return new Promise(function (resolve) {
        try {
            resolve(window.flutterAssetBase || (window.location.origin + '/'));
        } catch (_) {
            resolve("");
        }
    });
}