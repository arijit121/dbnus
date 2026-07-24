import 'package:flutter/material.dart';

import '../../../../shared/ui/atoms/text/custom_text.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CustomText(
      "Need To Implement",
      color: Colors.black,
    )));
  }
}
