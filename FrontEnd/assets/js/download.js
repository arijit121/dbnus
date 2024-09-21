function download(url, name){
  if (typeof axios == 'undefined') {
    // Create a script element to load Axios from the CDN
    const script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/axios@1.6.7/dist/axios.min.js';

    // Once Axios is loaded, define the download function
    script.onload = function() {
      _download(url, name);
    };

    // Append the script to the document head
    document.head.appendChild(script);
  } else {
    // If Axios is already loaded, set up the download function immediately
    _download(url, name);
  }
}

// Function to download a file using Axios and trigger download
function _download(url, fileName) {
  axios({
      url: url,  // The file's download URL
      method: 'GET',  // HTTP GET request
      responseType: 'blob'  // Important: ensure the response is a Blob (binary data)
  })
  .then(function (response) {
      // Create a Blob from the response data
      const blob = new Blob([response.data]);

      // Create a download URL for the Blob object
      const downloadUrl = window.URL.createObjectURL(blob);

      // Create an anchor element and set its href and download attributes
      const link = document.createElement('a');
      link.href = downloadUrl;
      link.download = fileName;

      // Append the anchor to the body (required for Firefox)
      document.body.appendChild(link);

      // Trigger the download by programmatically clicking the anchor
      link.click();

      // Clean up: remove the anchor and revoke the object URL
      document.body.removeChild(link);
      window.URL.revokeObjectURL(downloadUrl);
  })
  .catch(function (error) {
      console.error('Download failed:', error);  // Handle errors here
  });
}

