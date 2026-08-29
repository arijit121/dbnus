import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import 'package:intl/intl.dart';
import 'package:jaspr_app/flavors.dart';
import 'package:jaspr_app/shared/constants/assects_const.dart';
import 'package:jaspr_app/shared/constants/theme.dart';
import 'package:jaspr_app/shared/ui/ui.dart';
import 'package:jaspr_app/core/localization/extension/localization_ext.dart';

class WelcomeHeader extends StatefulComponent {
  final ValueNotifier<int> counter;

  const WelcomeHeader({
    required this.counter,
    super.key,
  });

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader> {
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  String _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AssetsConst.featherSunrise;
    if (hour < 17) return AssetsConst.featherSun;
    return AssetsConst.featherMoon;
  }

  @override
  Component build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMM d, yyyy').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      style: Styles(raw: {
        'background': 'linear-gradient(135deg, #1A1D2E, #2D3250, #424769)',
        'box-shadow': '0 8px 20px rgba(26, 29, 46, 0.4), 0 4px 30px rgba(139, 92, 246, 0.15)',
        'position': 'relative',
        'overflow': 'hidden',
      }),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: div(
              styles: Styles(raw: {
                'width': '100px',
                'height': '100px',
                'border-radius': '50%',
                'background-color': 'rgba(255, 255, 255, 0.04)',
              }),
              [],
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: div(
              styles: Styles(raw: {
                'width': '60px',
                'height': '60px',
                'border-radius': '50%',
                'background-color': 'rgba(255, 255, 255, 0.03)',
              }),
              [],
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with initials
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    style: Styles(raw: {
                      'background': 'linear-gradient(135deg, ${violate.value}, ${sidebarSelected.value})',
                      'box-shadow': '0 4px 12px rgba(139, 92, 246, 0.4)',
                      'display': 'flex',
                      'justify-content': 'center',
                      'align-items': 'center',
                    }),
                    child: CustomText(
                      F.title.isNotEmpty ? F.title[0].toUpperCase() : "D",
                      color: Colors.white,
                      variant: TextVariant.h3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            img(
                              src: _getGreetingIcon(),
                              styles: Styles(raw: {
                                'width': '16px',
                                'height': '16px',
                                'filter': 'invert(84%) sepia(85%) saturate(410%) hue-rotate(357deg) brightness(102%) contrast(105%)' // yellow
                              }),
                            ),
                            const SizedBox(width: 6),
                            CustomText(
                              _getGreeting(),
                              color: Colors.white,
                              variant: TextVariant.bodySmall,
                              fontWeight: FontWeight.w500,
                              className: 'text-opacity-70',
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          context.l10n.hello_world,
                          color: Colors.white,
                          variant: TextVariant.h2,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),

                  // Counter button
                  ValueListenableBuilder<int>(
                    listenable: component.counter,
                    builder: (BuildContext context, int value) {
                      return div(
                        events: {
                          'click': (event) {
                            component.counter.value = component.counter.value + 1;
                          }
                        },
                        classes: 'counter-button',
                        styles: Styles(raw: {
                          'padding': '10px 16px',
                          'background': 'linear-gradient(to bottom, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0.08))',
                          'border-radius': '12px',
                          'border': '1px solid rgba(255, 255, 255, 0.1)',
                          'display': 'flex',
                          'align-items': 'center',
                          'cursor': 'pointer',
                          'transition': 'transform 0.1s ease',
                        }),
                        [
                          img(
                            src: AssetsConst.featherActivity,
                            styles: Styles(raw: {'width': '16px', 'height': '16px', 'filter': 'invert(1)'}),
                          ),
                          const SizedBox(width: 8),
                          CustomText(
                            "$value",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            variant: TextVariant.body,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Date and flavor info row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                style: Styles(raw: {
                  'background-color': 'rgba(255, 255, 255, 0.08)',
                  'margin-top': '16px',
                }),
                child: Wrap(
                  children: [
                    img(
                      src: AssetsConst.featherCalendar,
                      styles: Styles(raw: {'width': '14px', 'height': '14px', 'filter': 'invert(1) opacity(0.5)'}),
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      dateStr,
                      color: Colors.white,
                      variant: TextVariant.bodySmall,
                      fontWeight: FontWeight.w500,
                      className: 'text-opacity-60',
                    ),
                    const SizedBox(width: 16),
                    div(
                      styles: Styles(raw: {
                        'width': '4px',
                        'height': '4px',
                        'border-radius': '50%',
                        'background-color': 'rgba(255, 255, 255, 0.3)',
                        'display': 'inline-block',
                      }),
                      [],
                    ),
                    const SizedBox(width: 16),
                    CustomText(
                      "${F.title} • ${F.name}",
                      color: Colors.white,
                      variant: TextVariant.bodySmall,
                      className: 'text-opacity-50',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
