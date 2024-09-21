function download(url, fileName) {
  // Use the Fetch API to get the file as a blob
  fetch(url)
      .then(response => {
          if (!response.ok) {
              throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.blob();  // Convert response to a Blob
      })
      .then(blob => {
          const downloadUrl = window.URL.createObjectURL(blob);  // Create a URL for the blob

          // Create an anchor element and set its attributes
          const link = document.createElement('a');
          link.href = downloadUrl;
          link.download = fileName;

          // Append the link to the document body (required for Firefox)
          document.body.appendChild(link);

          // Trigger the download
          link.click();

          // Clean up: remove the link and revoke the object URL
          document.body.removeChild(link);
          window.URL.revokeObjectURL(downloadUrl);
      })
      .catch(error => {
          console.error('Error downloading file:', error);
      });
}

