import 'package:material_ui/material_ui.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/navigation/router_name.dart';
import 'package:dbnus/features/payment_gateway/data/models/web_view_payment_gateway_model.dart';

class PaymentSection extends StatefulWidget {
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
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF131520) : Colors.white;
    final headerBg = isDark ? const Color(0xFF161A29) : const Color(0xFFFAFAFA);
    final accentColor = ColorConst.baseHexColor;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomSvgAssetImageView(
                    path: AssetsConst.featherCreditCard,
                    color: accentColor,
                    height: 18,
                    width: 18,
                  ),
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "Paytm Gateway",
                        fontWeight: FontWeight.w700,
                        size: 16,
                        color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
                      ),
                      2.ph,
                      CustomText(
                        "Secure payment processing",
                        size: 12,
                        color: isDark ? const Color(0xFF94A3B8) : ColorConst.secondaryDark,
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      4.pw,
                      const CustomText(
                        "Active",
                        size: 11,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                _buildStep(context, "1", "Amount", _currentStep >= 0),
                _buildStepLine(context, _currentStep >= 1),
                _buildStep(context, "2", "Merchant", _currentStep >= 1),
                _buildStepLine(context, _currentStep >= 2),
                _buildStep(context, "3", "Setup", _currentStep >= 2),
                _buildStepLine(context, _currentStep >= 3),
                _buildStep(context, "4", "Pay", _currentStep >= 3),
              ],
            ),
          ),

          // Form fields (Dynamic based on current step)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildCurrentForm(context, isDark, borderColor),
            ),
          ),

          16.ph,

          // Security badge
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSvgAssetImageView(
                    path: AssetsConst.featherLock,
                    height: 12,
                    width: 12,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  6.pw,
                  CustomText(
                    "Secured by Paytm Checkouts",
                    size: 11,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
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

  Widget _buildCurrentForm(BuildContext context, bool isDark, Color borderColor) {
    if (_currentStep == 0) {
      return Column(
        key: const ValueKey(0),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: widget.amountController,
            title: 'Enter Amount',
          ),
          16.ph,
          SizedBox(
            width: double.infinity,
            child: CustomGOEButton(
              onPressed: _nextStep,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText("Continue to Merchant", color: Colors.white, fontWeight: FontWeight.w600),
                  8.pw,
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (_currentStep == 1) {
      return Column(
        key: const ValueKey(1),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: widget.midController,
            title: 'Merchant ID (MID)',
          ),
          16.ph,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: CustomText("Back", color: isDark ? Colors.white70 : const Color(0xFF334155), fontWeight: FontWeight.w600),
                ),
              ),
              12.pw,
              Expanded(
                child: CustomGOEButton(
                  onPressed: _nextStep,
                  child: const CustomText("Continue", color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (_currentStep == 2) {
      return Column(
        key: const ValueKey(2),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: widget.orderIdController,
            title: 'Order ID',
          ),
          12.ph,
          CustomTextFormField(
            title: 'Txn Token',
            controller: widget.txnTokenController,
          ),
          16.ph,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: CustomText("Back", color: isDark ? Colors.white70 : const Color(0xFF334155), fontWeight: FontWeight.w600),
                ),
              ),
              12.pw,
              Expanded(
                child: CustomGOEButton(
                  onPressed: _nextStep,
                  child: const CustomText("Review Summary", color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        key: const ValueKey(3),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Transaction Summary",
            fontWeight: FontWeight.w600,
            size: 13,
          ),
          8.ph,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161A29) : const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildSummaryRow("Amount", "₹${widget.amountController.text}", isDark),
                const Divider(height: 16),
                _buildSummaryRow("Merchant ID", widget.midController.text, isDark),
                const Divider(height: 16),
                _buildSummaryRow("Order ID", widget.orderIdController.text, isDark),
                const Divider(height: 16),
                _buildSummaryRow(
                  "Txn Token", 
                  widget.txnTokenController.text.length > 12 
                      ? "${widget.txnTokenController.text.substring(0, 12)}..." 
                      : widget.txnTokenController.text, 
                  isDark
                ),
              ],
            ),
          ),
          16.ph,
          SizedBox(
            width: double.infinity,
            child: CustomGOEButton(
              onPressed: () async {
                CustomRoute.pushNamed(
                  name: RouteName.webViewPaymentGateway,
                  arguments: WebViewPaymentGatewayModel(
                    paymentLink:
                        'https://res.retailershakti.com/rs_live/msiteflutter/msite/static/paytm_view.html?amount=${widget.amountController.text}&mid=${widget.midController.text}&orderId=${widget.orderIdController.text}&txnToken=${widget.txnTokenController.text}',
                    redirectLink:
                        'https://www.retailershakti.com/retailCart/payment',
                    transactionId: widget.orderIdController.text,
                    title: "Paytm",
                  ),
                );
              },
              gradient: LinearGradient(
                colors: [ColorConst.baseHexColor, ColorConst.vibrateBlue],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomSvgAssetImageView(
                    path: AssetsConst.featherShield,
                    color: Colors.white,
                    height: 18,
                    width: 18,
                  ),
                  8.pw,
                  const CustomText(
                    "Pay with Paytm",
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
          4.ph,
          Center(
            child: TextButton(
              onPressed: () => setState(() => _currentStep = 0),
              child: const CustomText(
                "Change Details",
                color: ColorConst.baseHexColor,
                fontWeight: FontWeight.w600,
                size: 13,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label,
          size: 12,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          value,
          size: 12,
          color: isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildStep(BuildContext context, String number, String label, bool filled) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final accentColor = ColorConst.baseHexColor;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled
                  ? accentColor.withOpacity(isDark ? 0.15 : 0.08)
                  : (isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF1F5F9)),
              border: Border.all(
                color: filled ? accentColor : borderColor,
                width: 1.5,
              ),
            ),
            child: Center(
              child: CustomText(
                number,
                size: 10,
                fontWeight: FontWeight.w700,
                color: filled ? accentColor : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ),
          ),
          4.ph,
          CustomText(
            label,
            size: 9,
            color: filled
                ? (isDark ? const Color(0xFFF8FAFC) : ColorConst.primaryDark)
                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(BuildContext context, bool active) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = ColorConst.baseHexColor.withOpacity(0.5);
    final inactiveColor = isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFE2E8F0);

    return Container(
      width: 12,
      height: 1.5,
      color: active ? activeColor : inactiveColor,
    );
  }
}
