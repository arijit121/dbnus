 
// Load Paytm Checkout JS script dynamically and handle the payment process.
function paytm(txnToken, orderId, amount, mid) {
    return new Promise(function (resolve, reject) {
        // Check if Paytm CheckoutJS is already loaded
        if (!window.Paytm || !window.Paytm.CheckoutJS) {
            const script = document.createElement('script');
            script.src = 'https://securegw-stage.paytm.in/merchantpgpui/checkoutjs/merchants/sastas46579384879393.js';
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
        } else {
            // If script is already loaded, initialize the checkout directly
            _onScriptLoad(txnToken, orderId, amount, mid).then(resolve).catch(reject);
        }
    });
}


async function _onScriptLoad(txnToken, orderId, amount, mid) {
     let promise = new Promise(function(resolve, reject) {
        var config = {
                    "root": "",
                    "flow": "DEFAULT",
                     "style":{
                         "headerBackgroundColor":"#8dd8ff",
                         "headerColor":"#3f3f40"
                    },
                    "merchant":{
                            "mid": mid,
                            "name":"GenuPathLab",
                            "logo":"https://res.genupathlabs.com/genu_path_lab/live/customer_V2/images/genu-logo-transparent-mark2.png",
                            "redirect": false
                              },
                    "data": {
                        "orderId": orderId,
                        "token": txnToken,
                        "tokenType": "TXN_TOKEN",
                        "amount": amount
                    },
                    "handler":{
                         "notifyMerchant": function (eventName, data) {
                            if(eventName == 'SESSION_EXPIRED'){
                                alert("Your session has expired!!");
                                location.reload();
                            }
                             console.log("Event Name ==> ",eventName);
                             console.log("Data ==> ",data);
                             
                             if(eventName=="APP_CLOSED"){    
                                $("#paytm-checkoutjs").remove();                        
                                resolve(eventName);
                             }
                         },
                         "transactionStatus": function transactionStatus(paymentStatus){
                                              console.log("Payment Status ==> ",paymentStatus);
                                              $("#paytm-checkoutjs").remove();
                                              resolve(JSON.stringify(paymentStatus));
                                              // location.reload();
                                           }
                    }
                };


           if (window.Paytm && window.Paytm.CheckoutJS) {
                      // initialze configuration using init method
                      window.Paytm.CheckoutJS.init(config).then(function onSuccess() {
                          console.log('Before JS Checkout invoke');
                          // after successfully update configuration invoke checkoutjs
                          window.Paytm.CheckoutJS.invoke();
                      }).catch(function onError(error) {
                          console.log("Error ==> ", error);
                      });
                  }
        });
        let result = await promise;
        return result;

    }
