// Function to get the device ID using the FingerprintJS library and return a Promise
function getDeviceIdFunction() {
    return new Promise((resolve, reject) => {
        import('https://cdn.jsdelivr.net/npm/@fingerprintjs/fingerprintjs@4.5/+esm')
          .then(FingerprintJS => FingerprintJS.load())  // Initialize the agent
          .then(fp => fp.get())  // Get the fingerprint
          .then(result => {
            resolve(result.visitorId);  // Resolve the Promise with the visitor ID
          })
          .catch(error => {
            reject(error);  // Reject the Promise in case of an error
          });
      });
}
