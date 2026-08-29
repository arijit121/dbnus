import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';
import '../../shared/ui/ui.dart';

class OrderPage extends StatelessComponent {
  const OrderPage({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      className: 'order-page',
      gap: 20,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText('🛒 Orders', variant: TextVariant.h2),
            CustomGOEButton(
              child: text('+ New Order'),
              className: 'order-new-btn',
              backGroundColor: baseHexColor,
              onPressed: () {},
            ),
          ],
        ),
        // Filters
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _filterChip('All', true),
            _filterChip('Pending', false),
            _filterChip('Processing', false),
            _filterChip('Completed', false),
            _filterChip('Cancelled', false),
          ],
        ),
        // Orders list
        Column(
          gap: 12,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _orderCard('#ORD-1234', 'John Doe', '\$350.00', 'Completed', '2024-01-15', '🟢'),
            _orderCard('#ORD-1235', 'Jane Smith', '\$120.50', 'Processing', '2024-01-15', '🔵'),
            _orderCard('#ORD-1236', 'Bob Wilson', '\$89.99', 'Pending', '2024-01-14', '🟡'),
            _orderCard('#ORD-1237', 'Alice Chen', '\$245.00', 'Completed', '2024-01-14', '🟢'),
            _orderCard('#ORD-1238', 'Charlie Brown', '\$567.80', 'Cancelled', '2024-01-13', '🔴'),
            _orderCard('#ORD-1239', 'Diana Lee', '\$178.25', 'Processing', '2024-01-13', '🔵'),
            _orderCard('#ORD-1240', 'Frank Miller', '\$92.00', 'Pending', '2024-01-12', '🟡'),
            _orderCard('#ORD-1241', 'Grace Wang', '\$430.50', 'Completed', '2024-01-12', '🟢'),
          ],
        ),
      ],
    );
  }

  Component _filterChip(String label, bool active) {
    return CustomGOEButton(
      child: text(label),
      className: 'filter-chip ${active ? "active" : ""}',
      backGroundColor: active ? baseHexColor : null,
      borderColor: active ? null : baseHexColor,
      onPressed: () {},
    );
  }

  Component _orderCard(String id, String customer, String amount, String status, String date, String dot) {
    return Card(
      className: 'order-card',
      padding: const EdgeInsets.all(18.0),
      borderRadius: const BorderRadius.all(14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                gap: 12,
                children: [
                  CustomText(id, className: 'oc-id', fontWeight: FontWeight.w600),
                  CustomText('$dot $status', className: 'oc-status', variant: TextVariant.bodySmall),
                ],
              ),
              CustomText(amount, className: 'oc-amount', fontWeight: FontWeight.w700),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(customer, className: 'oc-customer', variant: TextVariant.bodySmall),
              CustomText(date, className: 'oc-date', variant: TextVariant.caption),
            ],
          ),
        ],
      ),
    );
  }
}
