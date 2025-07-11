import 'dart:collection';
import 'dart:convert';
import 'dart:js_interop';
import 'package:dbnus/extension/spacing.dart';
import 'package:flutter/material.dart';
import '../../../../../const/color_const.dart';
import '../../../../../data/model/razorpay_merchant_details.dart';
import '../../../../../data/model/user_model.dart';
import '../../../../../extension/logger_extension.dart';
import '../../../../../service/JsService/library/js_library.dart';
import '../../../../../service/JsService/provider/js_provider.dart';
import '../../../../../service/context_service.dart';
import '../../../../../service/value_handler.dart';
import '../../../../../storage/user_preference.dart';
import '../../../../../utils/text_utils.dart';
import '../../../../../widget/custom_text.dart';
import '../../../../../widget/loading_widget.dart';

class RayzorPay extends StatefulWidget {
  const RayzorPay({super.key, required this.razorpayMerchantDetails});

  final RazorpayMerchantDetails razorpayMerchantDetails;

  @override
  State<RayzorPay> createState() => _RayzorPayState();
}

class _RayzorPayState extends State<RayzorPay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await JsProvider()
          .loadJs(jsPath: "https://checkout.razorpay.com/v1/checkout.js");
      openCheckout();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  Future<void> openCheckout() async {
    UserModel? userModel = await UserPreference().getData();

    try {
      Map<String, dynamic> testOptions = {
        // "order_id": "order_QrjEvdurSTfvLS",
        "key": "rzp_test_mcVTv1hbk8fMc9",
        "currency": "INR",
        "amount": 13300,
        "prefill": {
          "contact": "8918951655",
          "email": "1arijitsarkar45@gmail.com"
        }
      };

      /*var options = {
        'order_id': widget.razorpayMerchantDetails.id,
        'key': widget.razorpayMerchantDetails.razorpayKey,
        'currency': widget.razorpayMerchantDetails.currency,
        'amount': ValueHandler()
            .numify("${widget.razorpayMerchantDetails.amount ?? 0}"),
        // 'name': widget.razorpayMerchantDetails.["payment_name"],
        // 'description': widget.razorpayMerchantDetails.d["payment_description"],
        // 'image': widget.razorpayMerchantDetails.["payment_image"],
        'prefill': {
          'contact': userModel?.mobileNo,
          'email': userModel?.emailId,
          // "method": widget.rayzorPayDetails["method"],
          // "issuers": widget.rayzorPayDetails["issuers"]
        },
      };*/

      // Create the payment using dynamicJsLoader
      final jsOptions = LoadJsOptions(
        jsPath: 'assets/js/razorpay_wrapper.js',
        jsFunctionName: 'createRazorpayPayment',
        jsFunctionArgs: [testOptions.jsify()].toJS,
        usePromise: true,
      );

      final result = await dynamicJsLoader(jsOptions).toDart;
      final linkedMap = (result?.dartify() as LinkedHashMap<Object?, Object?>?);
      Map<String, dynamic>? resultMap =
          linkedMap?.map((key, value) => MapEntry(key.toString(), value));
      AppLog.i(json.encode(resultMap), tag: "resultMap");

      if (resultMap?['success'].toString() == "true") {
        var successReturnBody = {};
        // onPaymentSuccess?.call(paymentResult);
        // var successReturnBody = {
        //   "razorpay_payment_id": response.paymentId,
        //   "razorpay_signature": response.signature,
        //   "razorpay_order_id": response.orderId,
        //   "receipt": widget.razorpayMerchantDetails.receipt,
        //   "amount": widget.razorpayMerchantDetails.amount,
        //   "PayMent_STATUS": "TXN_SUCCESS"
        // };
        //
        BuildContext context = CurrentContext().context;
        if (context.mounted) {
          Navigator.of(context).pop(successReturnBody);
        }
      } else {
        var errorReturnBody = {};
        BuildContext context = CurrentContext().context;
        if (context.mounted) {
          Navigator.of(context).pop(errorReturnBody);
        }
      }
    } catch (e) {
      AppLog.e(e.toString());
    }
  }

  // void _handlePaymentSuccess(RpaySuccessResponse response) {
  //   var successReturnBody = {
  //     "razorpay_payment_id": response.paymentId,
  //     "razorpay_signature": response.signature,
  //     "razorpay_order_id": response.orderId,
  //     "receipt": widget.razorpayMerchantDetails.receipt,
  //     "amount": widget.razorpayMerchantDetails.amount,
  //     "PayMent_STATUS": "TXN_SUCCESS"
  //   };
  //
  //   BuildContext context = CurrentContext().context;
  //   if (context.mounted) {
  //     Navigator.of(context).pop(successReturnBody);
  //   }
  //
  //   // PopUpItems()
  //   //     .toastMessage("SUCCESS: " + response.paymentId.toString(), black);
  // }

  // void _handlePaymentCancel(RpayCancelResponse response) {
  //   var errorReturnBody = {
  //     "code": response.status,
  //     "message": response.desc,
  //     "PayMent_STATUS": "TXN_FAILED"
  //   };
  //
  //   BuildContext context = CurrentContext().context;
  //   if (context.mounted) {
  //     Navigator.of(context).pop(errorReturnBody);
  //   }
  // }

  // void _handlePaymentError(RpayFailedResponse response) {
  //   var errorReturnBody = {
  //     "code": response.status,
  //     "message": response.desc,
  //     "PayMent_STATUS": "TXN_FAILED"
  //   };
  //
  //   BuildContext context = CurrentContext().context;
  //   if (context.mounted) {
  //     Navigator.of(context).pop(errorReturnBody);
  //   }
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // PopUpItems().toastMessage(
  //   //     "EXTERNAL_WALLET: " + response.walletName.toString(), black);
  // }

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
