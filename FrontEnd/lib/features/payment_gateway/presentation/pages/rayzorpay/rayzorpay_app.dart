import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/core/network/models/razorpay_merchant_details.dart';
import 'package:dbnus/core/models/user_model.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/core/services/context_service.dart';
import 'package:dbnus/core/services/value_handler.dart';
import 'package:dbnus/core/storage/user_preference.dart';
import 'package:dbnus/shared/utils/text_utils.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/indicators/loading_widget.dart';

class RayzorPay extends StatefulWidget {
  const RayzorPay({super.key, required this.razorpayMerchantDetails});

  final RazorpayMerchantDetails razorpayMerchantDetails;

  @override
  State<RayzorPay> createState() => _RayzorPayState();
}

class _RayzorPayState extends State<RayzorPay> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // _razorpay.on("error", _handlePaymentError);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      openCheckout();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> openCheckout() async {
    UserModel? userModel = await UserPreference().getData();
    var options = {
      'order_id': widget.razorpayMerchantDetails.id,
      'key': widget.razorpayMerchantDetails.razorpayKey,
      'currency': widget.razorpayMerchantDetails.currency,
      'amount':
          ValueHandler.numify("${widget.razorpayMerchantDetails.amount ?? 0}"),
      // 'name': widget.razorpayMerchantDetails.["payment_name"],
      // 'description': widget.razorpayMerchantDetails.d["payment_description"],
      // 'image': widget.razorpayMerchantDetails.["payment_image"],
      'prefill': {
        'contact': userModel?.mobileNo,
        'email': userModel?.emailId,
        // "method": widget.rayzorPayDetails["method"],
        // "issuers": widget.rayzorPayDetails["issuers"]
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      AppLog.e(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var successReturnBody = {
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
      "razorpay_order_id": response.orderId,
      "receipt": widget.razorpayMerchantDetails.receipt,
      "amount": widget.razorpayMerchantDetails.amount,
      "PayMent_STATUS": "TXN_SUCCESS"
    };

    BuildContext context = CurrentContext().context;
    if (context.mounted) {
      Navigator.of(context).pop(successReturnBody);
    }

    // PopUpItems.
    //     .toastMessage("SUCCESS: " + response.paymentId.toString(), black);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    var errorReturnBody = {
      "code": response.code,
      "message": response.message,
      "PayMent_STATUS": "TXN_FAILED"
    };

    BuildContext context = CurrentContext().context;
    if (context.mounted) {
      Navigator.of(context).pop(errorReturnBody);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // PopUpItems.toastMessage(
    //     "EXTERNAL_WALLET: " + response.walletName.toString(), black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.clear_outlined,
              size: 24,
              color: ColorConst.primaryDark,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
        leading: Container(),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingWidget(height: 60, width: 60),
              ],
            ),
            20.ph,
            CustomText(
              TextUtils.loading,
              color: ColorConst.primaryDark,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
