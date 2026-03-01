function setLocalStorageItem(key, value) {
    return new Promise((resolve, reject) => {
        try {
            localStorage.setItem(key, value);
            resolve(true);
        } catch (err) {
            console.error(`❌ Error setting localStorage key "${key}":`, err);
            reject(err);
        }
    });
}

function setSessionStorageItem(key, value) {
    return new Promise((resolve, reject) => {
        try {
            sessionStorage.setItem(key, value);
            resolve(true);
        } catch (err) {
            console.error(`❌ Error setting sessionStorage key "${key}":`, err);
            reject(err);
        }
    });
}


function getLocalStorageItem(key) {
    return new Promise((resolve, reject) => {
        try {
            const item = localStorage.getItem(key);
            if (item === null) {
                resolve(null); // key not found
                return;
            }
            resolve(JSON.stringify(item));
        } catch (err) {
            console.error(`❌ Error reading key "${key}":`, err);
            reject(err);
        }
    });
}

function getSessionStorageItem(key) {
    return new Promise((resolve, reject) => {
        try {
            const item = sessionStorage.getItem(key);
            if (item === null) {
                resolve(null); // key not found
                return;
            }
            resolve(JSON.stringify(item));
        } catch (err) {
            console.error(`❌ Error reading key "${key}":`, err);
            reject(err);
        }
    });
}

function clearLocalStorageKey(key) {
    return new Promise((resolve, reject) => {
        try {
            localStorage.removeItem(key);
            resolve(true);
        } catch (err) {
            console.error(`❌ Error clearing localStorage key "${key}":`, err);
            reject(err);
        }
    });
}

function clearSessionStorageKey(key) {
    return new Promise((resolve, reject) => {
        try {
            sessionStorage.removeItem(key);
            resolve(true);
        } catch (err) {
            console.error(`❌ Error clearing sessionStorage key "${key}":`, err);
            reject(err);
        }
    });
}