let axiosInstancePromise;

function loadAxios() {
  if (!axiosInstancePromise) {
    axiosInstancePromise = import('https://esm.sh/axios')
      .then(({ default: axios }) => axios)
      .catch(error => {
        console.error('Failed to load Axios:', error);
        axiosInstancePromise = null;
        throw error;
      });
  }
  return axiosInstancePromise;
}


function download(url, filename, headers = {}) {
  return new Promise((resolve, reject) => {
    loadAxios()
      .then(axios => {
        return axios.get(url, {
          responseType: 'blob',
          headers: {
            'Content-Type': 'application/octet-stream',
            ...headers
          }
        });
      })
      .then(response => {
        const blob = response.data;
        const downloadUrl = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = downloadUrl;
        a.download = filename;

        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        window.URL.revokeObjectURL(downloadUrl);

        resolve({ success: true, message: 'Download completed' });
      })
      .catch(error => {
        console.error('Download failed:', error);
        reject({ success: false, error: error.message });
      });
  });
}
