// Function to get the device ID using the FingerprintJS library and return a Promise
function getDeviceIdFunction() {
    return new Promise(async (resolve, reject) => {
        try {
            // Dynamically import the FingerprintJS library from the CDN
            const FingerprintJS = await import('https://openfpcdn.io/fingerprintjs/v4');

            // Load the FingerprintJS instance
            const fp = await FingerprintJS.load();

            // Get the visitor identifier
            const result = await fp.get();
            const visitorId = result.visitorId;  // This is the visitor identifier

            resolve(visitorId);  // Resolve the promise with the visitorId
        } catch (error) {
            console.error('Error getting device ID:', error);
            reject(error);  // Reject the promise in case of an error
        }
    });
}
