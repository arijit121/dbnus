function createRazorpayPayment(options) {
    return new Promise((resolve, reject) => {
        try {
            // Check if Razorpay is available
            if (typeof Razorpay === 'undefined') {
                reject(new Error('Razorpay is not loaded'));
                return;
            }

            // Create Razorpay instance
            const rzp = new Razorpay({
                ...options,
                handler: function (response) {
                    // Success callback
                    resolve({
                        razorpay_payment_id: response.razorpay_payment_id,
                        razorpay_order_id: response.razorpay_order_id,
                        razorpay_signature: response.razorpay_signature,
                        success: true
                    });
                },
                modal: {
                    ondismiss: function() {
                        // Delay close slightly
                        setTimeout(() => {
                            rzp.close();
                        }, 100);
                        // Payment cancelled
                        resolve({
                            error: 'Payment cancelled by user',
                            success: false
                        });
                    }
                }
            });

            // Handle payment failure
            rzp.on('payment.failed', function (response) {
                // Delay close slightly
                setTimeout(() => {
                    rzp.close();
                }, 100);
                resolve({
                    error: response.error.description || 'Payment failed',
                    error_code: response.error.code,
                    success: false
                });
            });

            // Open payment modal
            rzp.open();

        } catch (error) {
            reject(new Error('Failed to create Razorpay payment: ' + error.message));
        }
    });
}