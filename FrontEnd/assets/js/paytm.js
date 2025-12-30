// Load Paytm Checkout JS script dynamically and handle the payment process.
function paytm(txnToken, orderId, amount, mid) {
    return new Promise(function (resolve, reject) {
        // Check if the script is already loaded to avoid duplicates
        if (document.getElementById('paytm-script')) {
            _onScriptLoad(txnToken, orderId, amount, mid).then(resolve).catch(reject);
            return;
        }

        const script = document.createElement('script');
        script.id = 'paytm-script';  // Give an ID to the script to avoid loading it multiple times
        script.src = 'https://securegw-stage.paytm.in/merchantpgpui/checkoutjs/merchants/' + mid + '.js';
        script.type = 'application/javascript';
        script.crossOrigin = 'anonymous';

        // Once the script is loaded, initialize Paytm CheckoutJS
        script.onload = function () {
            _onScriptLoad(txnToken, orderId, amount, mid).then(resolve).catch(reject);
        };

        // If there is an error loading the script, reject the promise
        script.onerror = function (error) {
            reject('Error loading Paytm Checkout JS script: ' + error);
        };

        // Append the script to the document head
        document.head.appendChild(script);
    });
}

async function _onScriptLoad(txnToken, orderId, amount, mid) {
    let promise = new Promise(function (resolve, reject) {
        var config = {
            "root": "",
            "flow": "DEFAULT",
            "style": {
                "headerBackgroundColor": "#8dd8ff",
                "headerColor": "#3f3f40"
            },
            "merchant": {
                "mid": mid,
                "name": "GenuPathLab",
                "logo": "https://res.genupathlabs.com/genu_path_lab/live/customer_V2/images/genu-logo-transparent-mark2.png",
                "redirect": false
            },
            "data": {
                "orderId": orderId,
                "token": txnToken,
                "tokenType": "TXN_TOKEN",
                "amount": amount
            },
            "handler": {
                "notifyMerchant": function (eventName, data) {
                    if (eventName === 'SESSION_EXPIRED') {
                        alert("Your session has expired!!");
                        location.reload();
                    }
                    console.log("Event Name ==> ", eventName);
                    console.log("Data ==> ", data);

                    if (eventName === "APP_CLOSED") {
                        document.getElementById('paytm-checkoutjs')?.remove(); // Use native JS to remove
                        resolve(eventName);
                    }
                },
                "transactionStatus": function transactionStatus(paymentStatus) {
                    console.log("Payment Status ==> ", paymentStatus);
                    document.getElementById('paytm-checkoutjs')?.remove();
                    resolve(JSON.stringify(paymentStatus));
                    // location.reload();
                }
            }
        };

        if (window.Paytm && window.Paytm.CheckoutJS) {
            // Initialize configuration using init method
            window.Paytm.CheckoutJS.init(config).then(function onSuccess() {
                console.log('Before JS Checkout invoke');
                // After successfully updating configuration, invoke CheckoutJS
                window.Paytm.CheckoutJS.invoke();
            }).catch(function onError(error) {
                console.log("Error ==> ", error);
                reject(error);  // Reject the promise on error
            });
        } else {
            reject("Paytm CheckoutJS is not available.");
        }
    });

    let result = await promise;
    return result;
}

// ✅ Expose to Flutter
window._initiatePaytm = paytm;
