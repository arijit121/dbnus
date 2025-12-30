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
                            try {
                              forceCloseRazorpayModal();
                            } catch (e) {
                              console.warn('Unable to close Razorpay modal:', e);
                            }
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
                    try {
                      forceCloseRazorpayModal();
                    } catch (e) {
                      console.warn('Unable to close Razorpay modal:', e);
                    }
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

function forceCloseRazorpayModal() {
    try {
        // Remove Razorpay containers
        document.querySelectorAll(
            '.razorpay-container, .razorpay-checkout-frame'
        ).forEach(el => el.remove());

        // Remove overlays
        document.querySelectorAll(
            '.razorpay-overlay, .razorpay-backdrop'
        ).forEach(el => el.remove());

        // Restore scroll
        document.body.style.overflow = 'auto';
        document.body.style.position = 'static';

        // Remove Razorpay-specific classes
        document.body.classList.remove('razorpay-blur');
        document.documentElement.classList.remove('razorpay-blur');

        // 🔥 Reset Razorpay internal state (dirty workaround)
        if (window.Razorpay && Razorpay._instance) {
            Razorpay._instance = null;
        }
        // Remove existing script
        const existing = document.querySelector('script[src*="checkout.razorpay"]');
        if (existing) existing.remove();

        console.log('Razorpay modal force closed and state reset');
    } catch (e) {
        console.warn('Error in force close:', e);
    }
}