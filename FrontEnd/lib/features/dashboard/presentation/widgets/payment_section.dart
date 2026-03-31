import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

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
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConst.violate.withValues(alpha: 0.05),
                  ColorConst.sidebarSelected.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [ColorConst.violate, ColorConst.sidebarSelected],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ColorConst.violate.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(FeatherIcons.creditCard,
                      color: Colors.white, size: 20),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        "Paytm Gateway",
                        fontWeight: FontWeight.w700,
                        size: 16,
                        color: ColorConst.primaryDark,
                      ),
                      2.ph,
                      CustomText(
                        "Secure payment processing",
                        size: 12,
                        color: ColorConst.secondaryDark,
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ColorConst.deepGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: ColorConst.deepGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      4.pw,
                      const CustomText(
                        "Active",
                        size: 11,
                        color: ColorConst.deepGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: ColorConst.lineGrey),

          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _buildStep("1", "Amount", true),
                _buildStepLine(),
                _buildStep("2", "MID", true),
                _buildStepLine(),
                _buildStep("3", "Order", true),
                _buildStepLine(),
                _buildStep("4", "Token", true),
                _buildStepLine(),
                _buildStep("5", "Pay", false),
              ],
            ),
          ),

          // Form fields
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: amountController,
                  title: 'Amount',
                ),
                14.ph,
                CustomTextFormField(
                  controller: midController,
                  title: 'MID',
                ),
                14.ph,
                CustomTextFormField(
                  controller: orderIdController,
                  title: 'Order ID',
                ),
                14.ph,
                CustomTextFormField(
                  title: 'Txn Token',
                  controller: txnTokenController,
                ),
              ],
            ),
          ),

          20.ph,

          // Pay button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FeatherIcons.shield,
                          color: Colors.white, size: 18),
                      8.pw,
                      const CustomText("Pay with Paytm",
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ],
                  )),
            ),
          ),

          12.ph,

          // Security badge
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FeatherIcons.lock,
                      size: 12,
                      color: ColorConst.secondaryDark.withValues(alpha: 0.6)),
                  6.pw,
                  CustomText(
                    "Secured by 256-bit encryption",
                    size: 11,
                    color: ColorConst.secondaryDark.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String label, bool filled) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? ColorConst.violate.withValues(alpha: 0.1)
                  : ColorConst.lineGrey,
              border: Border.all(
                color: filled ? ColorConst.violate : ColorConst.grey,
                width: 1.5,
              ),
            ),
            child: Center(
              child: CustomText(
                number,
                size: 10,
                fontWeight: FontWeight.w700,
                color: filled ? ColorConst.violate : ColorConst.grey,
              ),
            ),
          ),
          4.ph,
          CustomText(
            label,
            size: 9,
            color: filled ? ColorConst.primaryDark : ColorConst.grey,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 12,
      height: 1.5,
      color: ColorConst.violate.withValues(alpha: 0.2),
    );
  }
}
