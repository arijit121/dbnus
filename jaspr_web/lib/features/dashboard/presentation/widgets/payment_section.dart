import 'package:universal_web/web.dart' as web;
import 'package:jaspr/dom.dart' hide BorderRadius, Padding;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_app/shared/constants/assects_const.dart';
import 'package:jaspr_app/shared/constants/theme.dart';
import 'package:jaspr_app/shared/ui/ui.dart';

// Lightweight TextEditingController mock to mimic Flutter's controller state.
class TextEditingController {
  String text;
  TextEditingController({this.text = ''});
  void dispose() {}
}

class CustomTextFormField extends StatelessComponent {
  final String title;
  final TextEditingController controller;

  const CustomTextFormField({
    required this.title,
    required this.controller,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      gap: 6,
      children: [
        CustomText(title, variant: TextVariant.bodySmall, fontWeight: FontWeight.w500, color: secondaryDark),
        CustomInput(
          placeholder: 'Enter $title',
          value: controller.text,
          onChanged: (val) {
            controller.text = val;
          },
        ),
      ],
    );
  }
}

class PaymentSection extends StatelessComponent {
  final TextEditingController amountController;
  final TextEditingController midController;
  final TextEditingController orderIdController;
  final TextEditingController txnTokenController;

  const PaymentSection({
    required this.amountController,
    required this.midController,
    required this.orderIdController,
    required this.txnTokenController,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg.value,
        borderRadius: BorderRadius.circular(18),
      ),
      style: Styles(raw: {
        'box-shadow': '0 4px 16px rgba(0, 0, 0, 0.06)',
        'border': '1px solid rgba(0, 0, 0, 0.04)',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: 18.0,
                topRight: 18.0,
              ),
            ),
            style: Styles(raw: {
              'background': 'linear-gradient(to right, ${violate.value}0D, ${sidebarSelected.value}08)',
            }),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  style: Styles(raw: {
                    'background': 'linear-gradient(135deg, ${violate.value}, ${sidebarSelected.value})',
                    'box-shadow': '0 3px 8px rgba(139, 92, 246, 0.3)',
                    'display': 'flex',
                    'justify-content': 'center',
                    'align-items': 'center',
                  }),
                  child: img(
                    src: AssetsConst.featherCreditCard,
                    styles: Styles(raw: {'width': '20px', 'height': '20px', 'filter': 'invert(1)'}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        "Paytm Gateway",
                        fontWeight: FontWeight.w700,
                        variant: TextVariant.body,
                        color: primaryDark,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        "Secure payment processing",
                        variant: TextVariant.bodySmall,
                        color: secondaryDark,
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  style: Styles(raw: {
                    'background-color': '${green.value}1A',
                    'display': 'flex',
                    'align-items': 'center',
                  }),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      div(
                        styles: Styles(raw: {
                          'width': '6px',
                          'height': '6px',
                          'border-radius': '50%',
                          'background-color': green.value,
                          'display': 'inline-block',
                        }),
                        [],
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        "Active",
                        variant: TextVariant.caption,
                        color: green,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          div(styles: Styles(raw: {'height': '1px', 'background-color': lineGrey.value}), []),

          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  controller: amountController,
                  title: 'Amount',
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  controller: midController,
                  title: 'MID',
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  controller: orderIdController,
                  title: 'Order ID',
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  title: 'Txn Token',
                  controller: txnTokenController,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pay button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              height: 44,
              events: {
                'click': (event) {
                  final paymentLink =
                      'https://res.retailershakti.com/rs_live/msiteflutter/msite/static/paytm_view.html?amount=${amountController.text}&mid=${midController.text}&orderId=${orderIdController.text}&txnToken=${txnTokenController.text}';
                  web.window.open(paymentLink, '_blank');
                }
              },
              style: Styles(raw: {
                'background': 'linear-gradient(135deg, ${violate.value}, ${sidebarSelected.value})',
                'border-radius': '12px',
                'display': 'flex',
                'justify-content': 'center',
                'align-items': 'center',
                'cursor': 'pointer',
                'box-shadow': '0 4px 12px rgba(139, 92, 246, 0.3)',
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  img(
                    src: AssetsConst.featherShield,
                    styles: Styles(raw: {'width': '18px', 'height': '18px', 'filter': 'invert(1)'}),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    "Pay with Paytm",
                    color: Colors.white,
                    variant: TextVariant.body,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Security badge
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  img(
                    src: AssetsConst.featherLock,
                    styles: Styles(raw: {'width': '12px', 'height': '12px', 'opacity': '0.6'}),
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    "Secured by 256-bit encryption",
                    variant: TextVariant.caption,
                    color: secondaryDark,
                    fontWeight: FontWeight.w500,
                    className: 'text-opacity-60',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Component _buildStep(String number, String label, bool filled) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
            ),
            style: Styles(raw: {
              'background-color': filled ? '${violate.value}1A' : lineGrey.value,
              'border': '1.5px solid ${filled ? violate.value : grey.value}',
              'display': 'flex',
              'justify-content': 'center',
              'align-items': 'center',
            }),
            child: CustomText(
              number,
              variant: TextVariant.caption,
              fontWeight: FontWeight.w700,
              color: filled ? violate : grey,
            ),
          ),
          const SizedBox(height: 4),
          span(
            styles: Styles(raw: {
              'font-size': '9px',
              'color': (filled ? primaryDark : grey).toString(),
              'font-weight': '500',
            }),
            [text(label)],
          ),
        ],
      ),
    );
  }

  Component _buildStepLine() {
    return Container(
      width: 12,
      height: 1.5,
      style: Styles(raw: {
        'background-color': '${violate.value}33', // 20% opacity
        'margin-bottom': '14px', // Align with circles
      }),
    );
  }
}
