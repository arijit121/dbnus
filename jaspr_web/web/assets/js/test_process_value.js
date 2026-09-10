async function processValueWithPromise(value) {
  return new Promise((resolve, reject) => {
    // Simulate some asynchronous processing
    setTimeout(() => {
      const result = `Processed value: ${value}`;
      resolve(result);  // Resolve the promise with the result
    }, 2000);  // Simulated delay (e.g., async operation)
  });
}

function processValueWithCallback(value, callback) {
  console.log('Processing value (with callback):', value);

  // Simulate some processing
  setTimeout(() => {
    const result = `Processed value with Callback: ${value}`;
    callback(result);  // Call the callback with the result
  }, 2000);
}