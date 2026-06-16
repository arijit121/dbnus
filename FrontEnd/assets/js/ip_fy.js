function getIPv6() {
    return new Promise((resolve, reject) => {
        fetch('https://api6.ipify.org?format=json')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                resolve(data.ip);
            })
            .catch(reject);
    });
}

function getIPv4() {
    return new Promise((resolve, reject) => {
        fetch('https://api.ipify.org?format=json')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                resolve(data.ip);
            })
            .catch(reject);
    });
}

function getIP() {
    return new Promise((resolve, reject) => {
        fetch('https://api64.ipify.org/?format=json')
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                resolve(data.ip);
            })
            .catch(reject);
    });
}

