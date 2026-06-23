function getOtpCodeFunction() {
    console.log("[WebOTP] Starting OTP retrieval...");
    
    return new Promise((resolve, reject) => {
        // Check browser support
        if (!('OTPCredential' in window)) {
            console.warn("[WebOTP] Browser doesn't support WebOTP API");
            reject("WebOTP API not supported");
            return;
        }

        // Check if we're on HTTPS
        if (location.protocol !== 'https:' && location.hostname !== 'localhost') {
            console.warn("[WebOTP] WebOTP requires HTTPS");
            reject("HTTPS required for WebOTP");
            return;
        }

        console.log("[WebOTP] Checking permissions and starting credential request...");
        
        const controller = new AbortController();
        
        // Set a timeout (optional)
        const timeout = setTimeout(() => {
            controller.abort();
            reject("OTP request timed out");
        }, 25000); // 5 minutes

        navigator.credentials.get({
            otp: { transport: ['sms'] }
        })
        .then(credential => {
            clearTimeout(timeout);
            console.log("[WebOTP] Raw credential received:", credential);
            
            if (credential && credential.code) {
                console.log("[WebOTP] OTP code extracted:", credential.code);
                resolve(credential.code);
            } else {
                console.warn("[WebOTP] Credential received but no code found");
                reject("No OTP code in credential");
            }
        })
        .catch(error => {
            clearTimeout(timeout);
            console.error("[WebOTP] Credential request failed:", error);
            console.error("[WebOTP] Error name:", error.name);
            console.error("[WebOTP] Error message:", error.message);
            reject(error);
        });
    });
}