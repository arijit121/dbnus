function processValueAndCallback(value, callback) {
    console.log('Processing value:', value);
  
    // Simulate some processing
    setTimeout(() => {
      const result = `Processed value: ${value}`;
      callback(result); // Call the callback with the result
    }, 2000);  // Simulate delay (e.g., async operation)
  }
  