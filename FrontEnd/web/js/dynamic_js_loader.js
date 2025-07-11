/**
 * Dynamically loads JavaScript files and executes functions
 * @param {Object} options - Configuration options
 * @param {string} [options.jsPath] - Path to the JavaScript file to load
 * @param {string} [options.id] - ID attribute for the script element
 * @param {string} [options.jsFunctionName] - Name of the JavaScript function to call
 * @param {Array} [options.jsFunctionArgs] - Arguments to pass to the JavaScript function
 * @param {boolean} [options.usePromise=false] - Whether to use Promise-based execution
 * @returns {Promise<*>} - Promise that resolves with the function result or null
 */
async function dynamicJsLoader({
    jsPath = null,
    id = null,
    jsFunctionName = null,
    jsFunctionArgs = null,
    usePromise = false
} = {}) {
    try {
        // Validate inputs
        if ((!jsPath || jsPath.trim() === '') && 
            (!jsFunctionName || jsFunctionName.trim() === '')) {
            throw new Error(
                "Both jsPath and jsFunctionName can't be null or empty. At least pass one value."
            );
        }

        // Load JavaScript file if path is provided
        if (jsPath && jsPath.trim() !== '') {
            let jsFilePath;
            
            // Check if it's a relative path (not absolute URL)
            if (!jsPath.includes('https://') && !jsPath.includes('http://')) {
                // For relative paths, you might want to adjust this based on your asset structure
                jsFilePath = jsPath.startsWith('assets/') ? jsPath : `assets/${jsPath}`;
                
                // If you have a base URL for assets, you can use it here
                const assetBase = window.flutterAssetBase || '';
                if (assetBase) {
                    jsFilePath = assetBase + jsFilePath;
                }
            } else {
                jsFilePath = jsPath;
            }

            // Check if the script is already loaded
            if (!document.querySelector(`script[src="${jsFilePath}"]`)) {
                // Create and load the script
                await new Promise((resolve, reject) => {
                    const script = document.createElement('script');
                    script.type = 'application/javascript';
                    script.src = jsFilePath;
                    
                    if (id && id.trim() !== '') {
                        script.id = id;
                    }
                    
                    script.onload = () => resolve();
                    script.onerror = (error) => reject(new Error(`Error loading JS script: ${error}`));
                    
                    document.head.appendChild(script);
                });
            }
        }

        // Execute JavaScript function if function name is provided
        if (jsFunctionName && jsFunctionName.trim() !== '') {
            if (usePromise) {
                // Promise-based execution
                try {
                    const func = window[jsFunctionName];
                    if (typeof func !== 'function') {
                        throw new Error(`Function '${jsFunctionName}' is not defined or not a function`);
                    }
                    
                    const result = func.apply(window, jsFunctionArgs || []);
                    
                    // If result is a Promise, await it; otherwise return it directly
                    return result instanceof Promise ? await result : result;
                } catch (error) {
                    throw new Error(`Error calling JS function with Promise: ${error.message}`);
                }
            } else {
                // Callback-based execution
                try {
                    return new Promise((resolve, reject) => {
                        const func = window[jsFunctionName];
                        if (typeof func !== 'function') {
                            reject(new Error(`Function '${jsFunctionName}' is not defined or not a function`));
                            return;
                        }
                        
                        // Add callback function as the last argument
                        const args = [...(jsFunctionArgs || []), (result) => {
                            resolve(result);
                        }];
                        
                        try {
                            func.apply(window, args);
                        } catch (error) {
                            reject(new Error(`Error executing callback function: ${error.message}`));
                        }
                    });
                } catch (error) {
                    throw new Error(`Error calling JS function with callback: ${error.message}`);
                }
            }
        }

        return null;
    } catch (error) {
        const errorContext = (!jsPath || jsPath.trim() === '') ? 
            "loadJs: You passed jsPath null or blank. Please check the jsPath or import the JS inside head of index.html." : 
            "";
        throw new Error(`Unexpected error in ${errorContext}: ${error.message}`);
    }
}

// Helper function to check if text is not empty or null (similar to ValueHandler)
function isTextNotEmptyOrNull(text) {
    return text !== null && text !== undefined && text.trim() !== '';
}

// Example usage:
/*
// Load a JavaScript file
await loadJs({ jsPath: 'path/to/your/script.js', id: 'myScript' });

// Call a function with Promise
const result = await loadJs({ 
    jsFunctionName: 'myFunction', 
    jsFunctionArgs: ['arg1', 'arg2'], 
    usePromise: true 
});

// Call a function with callback
const result = await loadJs({ 
    jsFunctionName: 'myCallbackFunction', 
    jsFunctionArgs: ['arg1', 'arg2'], 
    usePromise: false 
});

// Load script and call function
await loadJs({ 
    jsPath: 'path/to/script.js', 
    jsFunctionName: 'myFunction', 
    jsFunctionArgs: ['arg1'], 
    usePromise: true 
});
*/