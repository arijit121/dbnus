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

class _DashBoardPageState extends State<DashBoardPage> {
  ValueNotifier<int> counter = ValueNotifier(0);
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _midController = TextEditingController();
  final TextEditingController _orderIdController = TextEditingController();
  final TextEditingController _txnTokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SmoothScroll(
            primary: false,
            children: [
              // ── Welcome Header ──────────────────────────────────
              WelcomeHeader(counter: counter),
              24.ph,

              // ── Quick Actions ───────────────────────────────────
              const SectionTitle(
                  title: "Quick Actions", icon: FeatherIcons.zap),
              12.ph,
              const QuickActionsGrid(),
              24.ph,

              // ── Tools & Utilities ───────────────────────────────
              const SectionTitle(
                  title: "Tools & Utilities", icon: FeatherIcons.tool),
              12.ph,
              const ToolsSection(),
              24.ph,

              // ── Payment Gateway ─────────────────────────────────
              const SectionTitle(
                  title: "Payment Gateway", icon: FeatherIcons.creditCard),
              12.ph,
              PaymentSection(
                amountController: _amountController,
                midController: _midController,
                orderIdController: _orderIdController,
                txnTokenController: _txnTokenController,
              ),
              24.ph,

              // ── Media Gallery ───────────────────────────────────
              const SectionTitle(
                  title: "Media Gallery", icon: FeatherIcons.image),
              12.ph,
              const MediaSection(),
              24.ph,
            ],
          ),
        ),
      ],
    );
  }
}
