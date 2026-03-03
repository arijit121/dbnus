import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/features/payment_gateway/data/models/web_view_payment_gateway_model.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({
    super.key,
    required this.amountController,
    required this.midController,
    required this.orderIdController,
    required this.txnTokenController,
  });

  final TextEditingController amountController;
  final TextEditingController midController;
  final TextEditingController orderIdController;
  final TextEditingController txnTokenController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: amountController,
            title: 'Amount',
          ),
          16.ph,
          CustomTextFormField(
            controller: midController,
            title: 'MID',
          ),
          16.ph,
          CustomTextFormField(
            controller: orderIdController,
            title: 'Order ID',
          ),
          16.ph,
          CustomTextFormField(
            title: 'Txn Token',
            controller: txnTokenController,
          ),
          20.ph,
          SizedBox(
            width: double.infinity,
            child: CustomGOEButton(
                onPressed: () async {
                  CustomRoute.pushNamed(
                    name: RouteName.webViewPaymentGateway,
                    arguments: WebViewPaymentGatewayModel(
                      paymentLink:
                          'https://res.retailershakti.com/rs_live/msiteflutter/msite/static/paytm_view.html?amount=${amountController.text}&mid=${midController.text}&orderId=${orderIdController.text}&txnToken=${txnTokenController.text}',
                      redirectLink:
                          'https://www.retailershakti.com/retailCart/payment',
                      transactionId: orderIdController.text,
                      title: "Paytm",
                    ),
                  );
                },
                gradient: const LinearGradient(
                  colors: [ColorConst.violate, ColorConst.sidebarSelected],
                ),
                child: const CustomText("Pay with Paytm",
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
