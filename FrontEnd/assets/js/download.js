function download(url, name, headers = {}) {
    axios({
        url: url,
        method: 'GET',
        responseType: 'blob', // This ensures the response is treated as binary data
        headers: headers, // Custom headers are passed here
    })
    .then((response) => {
        // Create a Blob URL for the downloaded data
        const blobUrl = window.URL.createObjectURL(response.data);
        const link = document.createElement('a');
        link.href = blobUrl;
        link.setAttribute('download', name); // Set the file name
        document.body.appendChild(link);
        link.click(); // Trigger the download
        document.body.removeChild(link); // Clean up the DOM
        window.URL.revokeObjectURL(blobUrl); // Free up memory
    })
    .catch((error) => {
        console.error("Download failed:", error);
        if (error.response) {
            console.error("Server response:", error.response);
        }
    });
}