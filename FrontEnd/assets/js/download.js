async function download(url, filename, headers = {}) {
    try {
        // Create request with custom headers
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/octet-stream',
                ...headers
            }
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        // Get the blob data
        const blob = await response.blob();

        // Create download link
        const downloadUrl = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = downloadUrl;
        a.download = filename;

        // Trigger download
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        // Clean up
        window.URL.revokeObjectURL(downloadUrl);

        return { success: true, message: 'Download completed' };
    } catch (error) {
        console.error('Download failed:', error);
        return { success: false, error: error.message };
    }
}