import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';

class OrderPage extends StatelessComponent {
  const OrderPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'order-page', [
      // Header
      div(classes: 'order-header', [
        h2([text('🛒 Orders')]),
        button(classes: 'order-new-btn', [text('+ New Order')]),
      ]),
      // Filters
      div(classes: 'order-filters', [
        _filterChip('All', true),
        _filterChip('Pending', false),
        _filterChip('Processing', false),
        _filterChip('Completed', false),
        _filterChip('Cancelled', false),
      ]),
      // Orders list
      div(classes: 'orders-list', [
        _orderCard('#ORD-1234', 'John Doe', '\$350.00', 'Completed', '2024-01-15', '🟢'),
        _orderCard('#ORD-1235', 'Jane Smith', '\$120.50', 'Processing', '2024-01-15', '🔵'),
        _orderCard('#ORD-1236', 'Bob Wilson', '\$89.99', 'Pending', '2024-01-14', '🟡'),
        _orderCard('#ORD-1237', 'Alice Chen', '\$245.00', 'Completed', '2024-01-14', '🟢'),
        _orderCard('#ORD-1238', 'Charlie Brown', '\$567.80', 'Cancelled', '2024-01-13', '🔴'),
        _orderCard('#ORD-1239', 'Diana Lee', '\$178.25', 'Processing', '2024-01-13', '🔵'),
        _orderCard('#ORD-1240', 'Frank Miller', '\$92.00', 'Pending', '2024-01-12', '🟡'),
        _orderCard('#ORD-1241', 'Grace Wang', '\$430.50', 'Completed', '2024-01-12', '🟢'),
      ]),
    ]);
  }

  Component _filterChip(String label, bool active) {
    return button(classes: 'filter-chip ${active ? "active" : ""}', [text(label)]);
  }

  Component _orderCard(String id, String customer, String amount, String status, String date, String dot) {
    return div(classes: 'order-card', [
      div(classes: 'oc-top', [
        div(classes: 'oc-id-row', [
          span(classes: 'oc-id', [text(id)]),
          span(classes: 'oc-status', [text('$dot $status')]),
        ]),
        span(classes: 'oc-amount', [text(amount)]),
      ]),
      div(classes: 'oc-bottom', [
        span(classes: 'oc-customer', [text(customer)]),
        span(classes: 'oc-date', [text(date)]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.order-page').styles(display: .flex, flexDirection: .column, gap: Gap.all(20.px), raw: {'animation': 'fadeIn 0.4s ease'}),
    css('.order-header').styles(display: .flex, justifyContent: .spaceBetween, alignItems: .center),
    css('.order-new-btn').styles(
      padding: .symmetric(horizontal: 20.px, vertical: 10.px),
      radius: .all(.circular(10.px)),
      backgroundColor: baseHexColor, color: Colors.white,
      fontSize: 14.px, fontWeight: .w600, cursor: .pointer, border: .none,
      raw: {'transition': 'all 0.2s ease'},
    ),
    css('.order-new-btn:hover').styles(raw: {'transform': 'translateY(-1px)', 'box-shadow': '0 4px 12px rgba(108,99,255,0.4)'}),
    // Filters
    css('.order-filters').styles(display: .flex, gap: Gap.all(8.px), flexWrap: .wrap),
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
    // Orders list
    css('.orders-list').styles(display: .flex, flexDirection: .column, gap: Gap.all(12.px)),
    css('.order-card', [
      css('&').styles(
        backgroundColor: Colors.white, radius: .all(.circular(14.px)),
        padding: .all(18.px),
        raw: {'box-shadow': '0 1px 3px rgba(0,0,0,0.04)', 'transition': 'transform 0.2s ease, box-shadow 0.2s ease'},
      ),
      css('&:hover').styles(raw: {'transform': 'translateX(4px)', 'box-shadow': '0 4px 12px rgba(0,0,0,0.06)'}),
      css('.oc-top').styles(display: .flex, justifyContent: .spaceBetween, alignItems: .center, raw: {'margin-bottom': '10px'}),
      css('.oc-id-row').styles(display: .flex, alignItems: .center, gap: Gap.all(12.px)),
      css('.oc-id').styles(fontSize: 15.px, fontWeight: .w600, color: primaryDark),
      css('.oc-status').styles(fontSize: 12.px, fontWeight: .w500, color: secondaryDark),
      css('.oc-amount').styles(fontSize: 18.px, fontWeight: .w700, color: primaryDark),
      css('.oc-bottom').styles(display: .flex, justifyContent: .spaceBetween),
      css('.oc-customer').styles(fontSize: 13.px, color: secondaryDark),
      css('.oc-date').styles(fontSize: 12.px, color: grey),
    ]),
  ];
}
