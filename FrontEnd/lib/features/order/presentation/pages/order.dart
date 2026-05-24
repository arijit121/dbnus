import 'package:flutter/material.dart';
import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';

import '../widgets/order_header.dart';
import '../widgets/notifications_section.dart';
import '../widgets/js_navigation_section.dart';
import '../widgets/pin_code_section.dart';
import '../widgets/forms_section.dart';
import '../widgets/maps_section.dart';
import '../widgets/printing_section.dart';
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
            title: "Notifications & Downloads", icon: AssetsConst.featherBell),
        12.ph,
        const NotificationsSection(),
        24.ph,

        // ── Printing & Documents ────────────────────────────
        const SectionTitle(
            title: "Printing Options", icon: AssetsConst.featherPrinter),
        12.ph,
        const PrintingSection(),
        24.ph,

        // ── JS & Navigation ─────────────────────────────────
        const SectionTitle(title: "JS & Navigation", icon: AssetsConst.featherCode),
        12.ph,
        const JsNavigationSection(),
        24.ph,

        // ── Pin Code ────────────────────────────────────────
        const SectionTitle(title: "Pin Code", icon: AssetsConst.featherLock),
        12.ph,
        PinCodeSection(
          pinController: _pinController,
          boolNotifier: boolNotifier,
          clearPin: clearPin,
        ),
        24.ph,

        // ── Forms & Inputs ──────────────────────────────────
        const SectionTitle(title: "Forms & Inputs", icon: AssetsConst.featherEdit3),
        12.ph,
        const FormsSection(),
        24.ph,

        // ── Maps & Location ─────────────────────────────────
        const SectionTitle(title: "Maps & Location", icon: AssetsConst.featherMapPin),
        12.ph,
        const MapsSection(),
        24.ph,
      ],
    );
  }
}
