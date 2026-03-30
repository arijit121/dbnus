import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/organisms/scrolls/smooth_scroll.dart';

import '../widgets/welcome_header.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/tools_section.dart';
import '../widgets/payment_section.dart';
import '../widgets/media_section.dart';
import '../widgets/section_title.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage>
    with SingleTickerProviderStateMixin {
  ValueNotifier<int> counter = ValueNotifier(0);
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _midController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _txnTokenController = TextEditingController();

  late AnimationController _staggerController;

  // 8 items to animate: header, section+grid, section+tools, section+payment, section+media
  static const int _itemCount = 8;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _amountController.dispose();
    _midController.dispose();
    _orderIdController.dispose();
    _txnTokenController.dispose();
    super.dispose();
  }

  Animation<double> _fadeAnimation(int index) {
    final start = (index / _itemCount) * 0.6;
    final end = start + 0.4;
    return CurvedAnimation(
      parent: _staggerController,
      curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
          curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slideAnimation(int index) {
    final start = (index / _itemCount) * 0.6;
    final end = start + 0.4;
    return Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0),
          curve: Curves.easeOut),
    ));
  }

  Widget _staggeredItem(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimation(index),
      child: SlideTransition(
        position: _slideAnimation(index),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SmoothScroll(
            primary: false,
            children: [
              // Consistent horizontal padding for all sections
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    // ── Welcome Header ──────────────────────────────
                    _staggeredItem(0, WelcomeHeader(counter: counter)),
                    28.ph,

                    // ── Quick Actions ───────────────────────────────
                    _staggeredItem(
                      1,
                      const SectionTitle(
                          title: "Quick Actions", icon: FeatherIcons.zap),
                    ),
                    14.ph,
                    _staggeredItem(2, const QuickActionsGrid()),
                    28.ph,

                    // ── Tools & Utilities ───────────────────────────
                    _staggeredItem(
                      3,
                      const SectionTitle(
                          title: "Tools & Utilities", icon: FeatherIcons.tool),
                    ),
                    14.ph,
                    _staggeredItem(4, const ToolsSection()),
                    28.ph,

                    // ── Payment Gateway ─────────────────────────────
                    _staggeredItem(
                      5,
                      const SectionTitle(
                          title: "Payment Gateway",
                          icon: FeatherIcons.creditCard),
                    ),
                    14.ph,
                    _staggeredItem(
                      6,
                      PaymentSection(
                        amountController: _amountController,
                        midController: _midController,
                        orderIdController: _orderIdController,
                        txnTokenController: _txnTokenController,
                      ),
                    ),
                    28.ph,

                    // ── Media Gallery ───────────────────────────────
                    _staggeredItem(
                      7,
                      const SectionTitle(
                          title: "Media Gallery", icon: FeatherIcons.image),
                    ),
                    14.ph,
                    // Media is typically long, no stagger needed
                    const MediaSection(),
                    28.ph,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
