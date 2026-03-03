import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:dbnus/shared/extensions/spacing.dart';

import '../widgets/order_header.dart';
import '../widgets/notifications_section.dart';
import '../widgets/js_navigation_section.dart';
import '../widgets/pin_code_section.dart';
import '../widgets/forms_section.dart';
import '../widgets/maps_section.dart';
import '../widgets/section_title.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final TextEditingController _pinController = TextEditingController();
  final ValueNotifier<bool> boolNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> clearPin = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Header ──────────────────────────────────────────
        const OrderHeader(),
        24.ph,

        // ── Notifications & Downloads ───────────────────────
        const SectionTitle(
            title: "Notifications & Downloads", icon: FeatherIcons.bell),
        12.ph,
        const NotificationsSection(),
        24.ph,

        // ── JS & Navigation ─────────────────────────────────
        const SectionTitle(title: "JS & Navigation", icon: FeatherIcons.code),
        12.ph,
        const JsNavigationSection(),
        24.ph,

        // ── Pin Code ────────────────────────────────────────
        const SectionTitle(title: "Pin Code", icon: FeatherIcons.lock),
        12.ph,
        PinCodeSection(
          pinController: _pinController,
          boolNotifier: boolNotifier,
          clearPin: clearPin,
        ),
        24.ph,

        // ── Forms & Inputs ──────────────────────────────────
        const SectionTitle(title: "Forms & Inputs", icon: FeatherIcons.edit3),
        12.ph,
        const FormsSection(),
        24.ph,

        // ── Maps & Location ─────────────────────────────────
        const SectionTitle(title: "Maps & Location", icon: FeatherIcons.mapPin),
        12.ph,
        const MapsSection(),
        24.ph,
      ],
    );
  }
}
