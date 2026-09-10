import 'dart:math';
import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:jaspr_app/shared/constants/assects_const.dart';
import 'package:jaspr_app/shared/constants/theme.dart';
import 'package:jaspr_app/shared/ui/ui.dart';
import 'package:jaspr_app/core/localization/utils/localization_utils.dart';
import 'package:jaspr_app/core/models/custom_file.dart';
import 'package:jaspr_app/core/services/file_picker.dart';
import 'package:jaspr_app/shared/extensions/logger_extension.dart';
import 'package:jaspr_app/core/config/app_config.dart';
import 'package:jaspr_app/shared/utils/pop_up_items.dart';
import 'package:jaspr_app/navigation/route_names.dart';

class QuickActionsGrid extends StatelessComponent {
  const QuickActionsGrid({super.key});

  @override
  Component build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: AssetsConst.featherGlobe,
        label: "Change Language",
        subtitle: "Random locale",
        gradient: const [violate, sidebarSelected],
        onTap: () {
          LocalizationUtils.changeLanguage(
              context: context,
              locale: LocalizationUtils.supportedLocales[
                  Random().nextInt(LocalizationUtils.supportedLocales.length)]);
        },
      ),
      _QuickAction(
        icon: AssetsConst.featherFileText,
        label: "Order Details",
        subtitle: "View order #56",
        gradient: const [lightBlue, deepBlue],
        onTap: () {
          Router.of(context).push('/order/details');
        },
      ),
      _QuickAction(
        icon: AssetsConst.featherBarChart2,
        label: "Leaderboard",
        subtitle: "Rankings",
        gradient: const [deepGreen, Color('#1B7A4D')],
        onTap: () {
          Router.of(context).push(RouteName.leaderBoard);
        },
      ),
      _QuickAction(
        icon: AssetsConst.featherUploadCloud,
        label: "File Pick",
        subtitle: "Upload files",
        gradient: const [Color('#E67E22'), Color('#D35400')],
        onTap: () async {
          CustomFile? customFile = await CustomFilePicker.customFilePicker();
          AppLog.i(customFile?.name, tag: "CustomFile");
        },
      ),
      _QuickAction(
        icon: AssetsConst.featherSmartphone,
        label: "Device ID",
        subtitle: "Copy identifier",
        gradient: const [Color('#8E44AD'), Color('#6C3483')],
        onTap: () async {
          String? deviceId = await AppConfig().getDeviceId();
          AppLog.i(deviceId);
          PopUpItems.toastMessage(deviceId ?? "", green);
        },
      ),
      _QuickAction(
        icon: AssetsConst.featherDollarSign,
        label: "Razorpay",
        subtitle: "Payment",
        gradient: const [lightBlue, violate],
        onTap: () async {
          PopUpItems.toastMessage("Razorpay is not supported in the web build.", red);
        },
      ),
    ];

    return GridView(
      maxCrossAxisExtent: 200,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      children: List.generate(actions.length, (index) {
        final action = actions[index];
        return _QuickActionCard(action: action);
      }),
    );
  }
}

class _QuickActionCard extends StatelessComponent {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Component build(BuildContext context) {
    return div(
      events: {
        'click': (event) => action.onTap(),
      },
      classes: 'quick-action-card',
      styles: Styles(raw: {
        'background': 'linear-gradient(135deg, ${action.gradient.first.value}, ${action.gradient.last.value})',
        'border-radius': '18px',
        'padding': '16px',
        'display': 'flex',
        'flex-direction': 'column',
        'justify-content': 'space-between',
        'position': 'relative',
        'overflow': 'hidden',
        'cursor': 'pointer',
        'box-shadow': '0 6px 14px ${action.gradient.first.value}59', // 35% opacity hex
        'aspect-ratio': '1.25',
        'transition': 'transform 0.15s ease, box-shadow 0.15s ease',
      }),
      [
        // Decorative circles
        div(
          styles: Styles(raw: {
            'position': 'absolute',
            'right': '-15px',
            'top': '-15px',
            'width': '60px',
            'height': '60px',
            'border-radius': '50%',
            'background-color': 'rgba(255, 255, 255, 0.08)',
            'pointer-events': 'none',
          }),
          [],
        ),
        div(
          styles: Styles(raw: {
            'position': 'absolute',
            'right': '20px',
            'bottom': '-10px',
            'width': '35px',
            'height': '35px',
            'border-radius': '50%',
            'background-color': 'rgba(255, 255, 255, 0.06)',
            'pointer-events': 'none',
          }),
          [],
        ),

        // Icon with glow
        Row(
          children: [
            div(
              styles: Styles(raw: {
                'padding': '10px',
                'background-color': 'rgba(255, 255, 255, 0.2)',
                'border-radius': '12px',
                'display': 'flex',
                'justify-content': 'center',
                'align-items': 'center',
                'box-shadow': '0 4px 8px rgba(255, 255, 255, 0.1)',
              }),
              [
                img(
                  src: action.icon,
                  styles: Styles(raw: {'width': '20px', 'height': '20px', 'filter': 'invert(1)'}),
                ),
              ],
            ),
          ],
        ),

        // Label + Subtitle + Chevron Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    action.label,
                    color: Colors.white,
                    variant: TextVariant.body,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    action.subtitle,
                    color: Colors.white,
                    variant: TextVariant.caption,
                    fontWeight: FontWeight.w400,
                    className: 'text-opacity-70',
                  ),
                ],
              ),
            ),
            img(
              src: AssetsConst.featherArrowRight,
              styles: Styles(raw: {'width': '14px', 'height': '14px', 'filter': 'invert(1) opacity(0.5)'}),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction {
  final String icon;
  final String label;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });
}
