import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';
import '../../shared/ui/organisms/row.dart';
import '../../shared/ui/organisms/column.dart';
import '../../shared/ui/organisms/container.dart';
import '../../shared/ui/organisms/wrap.dart';
import '../../shared/ui/organisms/card.dart';
import '../../shared/ui/organisms/sized_box.dart';

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
            h2([text('🛒 Orders')]),
            button(classes: 'order-new-btn', [text('+ New Order')]),
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
    return button(classes: 'filter-chip ${active ? "active" : ""}', [text(label)]);
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
                  span(classes: 'oc-id', [text(id)]),
                  span(classes: 'oc-status', [text('$dot $status')]),
                ],
              ),
              span(classes: 'oc-amount', [text(amount)]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              span(classes: 'oc-customer', [text(customer)]),
              span(classes: 'oc-date', [text(date)]),
            ],
          ),
        ],
      ),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.order-new-btn').styles(
      padding: .symmetric(horizontal: 20.px, vertical: 10.px),
      radius: .all(.circular(10.px)),
      backgroundColor: baseHexColor, color: Colors.white,
      fontSize: 14.px, fontWeight: .w600, cursor: .pointer, border: .none,
      raw: {'transition': 'all 0.2s ease'},
    ),
    css('.order-new-btn:hover').styles(raw: {'transform': 'translateY(-1px)', 'box-shadow': '0 4px 12px rgba(108,99,255,0.4)'}),
    // Filters
    css('.filter-chip', [
      css('&').styles(
        padding: .symmetric(horizontal: 16.px, vertical: 8.px),
        radius: .all(.circular(20.px)), fontSize: 13.px, fontWeight: .w500,
        cursor: .pointer, border: .none,
        backgroundColor: Colors.white, color: secondaryDark,
        raw: {'transition': 'all 0.2s ease', 'border': '1px solid #E2E8F0'},
      ),
      css('&:hover').styles(raw: {'border-color': '#94A3B8'}),
      css('&.active').styles(backgroundColor: baseHexColor, color: Colors.white, raw: {'border-color': 'transparent'}),
    ]),
    // Orders list / cards
    css('.order-card', [
      css('&').styles(
        backgroundColor: Colors.white,
        raw: {'box-shadow': '0 1px 3px rgba(0,0,0,0.04)', 'transition': 'transform 0.2s ease, box-shadow 0.2s ease'},
      ),
      css('&:hover').styles(raw: {'transform': 'translateX(4px)', 'box-shadow': '0 4px 12px rgba(0,0,0,0.06)'}),
      css('.oc-id').styles(fontSize: 15.px, fontWeight: .w600, color: primaryDark),
      css('.oc-status').styles(fontSize: 12.px, fontWeight: .w500, color: secondaryDark),
      css('.oc-amount').styles(fontSize: 18.px, fontWeight: .w700, color: primaryDark),
      css('.oc-customer').styles(fontSize: 13.px, color: secondaryDark),
      css('.oc-date').styles(fontSize: 12.px, color: grey),
    ]),
  ];
}
