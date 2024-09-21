// Function to get the device ID using FingerprintJS library and return a Promise
async function getDeviceIdFunction() {
  let promise = new Promise(function (resolve, reject) {
      const fpPromise = import('https://openfpcdn.io/fingerprintjs/v4')
          .then(FingerprintJS => FingerprintJS.load())

      // Get the visitor identifier when you need it.
      fpPromise
          .then(fp => fp.get())
          .then(result => {
              // This is the visitor identifier:
              const visitorId = result.visitorId;
              resolve(visitorId);  // Resolve the promise with the visitorId
          })
          .catch(error => reject(error));  // In case of an error, reject the promise
  });

  let result = await promise;
  return result;
}
