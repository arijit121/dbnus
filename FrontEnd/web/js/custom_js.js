//function loadScript(src) {
//    return new Promise((resolve, reject) => {
//        const script = document.createElement('script');
//        script.src = src;
//        script.onload = () => resolve(`Script loaded: ${src}`);
//        script.onerror = () => reject(`Failed to load script: ${src}`);
//        document.head.append(script); // Append the script to the document
//    });
//}

// Load multiple JS files
//Promise.all([
//    loadScript('./custom_js/device_id.js'),
//    loadScript('custom_js/device_id.js'),
//    // loadScript('script2.js'),
//    // loadScript('script3.js')
//])
//.then((messages) => {
//    console.log(messages);
//    // Initialize or run functions from the loaded scripts here if needed
//})
//.catch((error) => {
//    console.error(error);
//});

// importScripts('./custom_js/device_id.js');


import { getDeviceIdFunction } from './custom_js/device_id.js';
function getDeviceIdCJSFunction(){
    return new Promise(async (resolve, reject) => {
        const visitorId = await getDeviceIdFunction();
        resolve(visitorId);
  });
}
