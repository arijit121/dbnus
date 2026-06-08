import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../constants/theme.dart';
import '../ui.dart';

class AppTopBar extends StatelessComponent {
  final void Function()? onMenuTap;
  final String title;

  const AppTopBar({this.onMenuTap, this.title = 'Dbnus', super.key});

  @override
  Component build(BuildContext context) {
    return Container(
      className: 'app-top-bar',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
            label: '',
            icon: '☰',
            className: 'topbar-btn',
            onPressed: onMenuTap,
            isOutlined: true,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: 8,
            className: 'topbar-brand',
            children: [
              Container(
                className: 'topbar-logo',
                width: 30,
                height: 30,
                alignment: Alignment.center,
                child: const CustomText('D', fontWeight: FontWeight.w700, color: Colors.white),
              ),
              CustomText(title, className: 'topbar-title', fontWeight: FontWeight.w700, variant: TextVariant.h3),
            ],
          ),
          const CustomButton(
            label: '',
            icon: '🔔',
            className: 'topbar-btn',
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.app-top-bar', [
      css('&').styles(
        display: .none,
        alignItems: .center,
        justifyContent: .spaceBetween,
        padding: .symmetric(horizontal: 16.px, vertical: 12.px),
        backgroundColor: scaffoldBg,
        raw: {'position': 'sticky', 'top': '0', 'z-index': '50'},
      ),
      css('.topbar-btn').styles(
        width: 40.px,
        height: 40.px,
        display: .flex,
        alignItems: .center,
        justifyContent: .center,
        radius: .all(.circular(12.px)),
        backgroundColor: Colors.white,
        fontSize: 18.px,
        cursor: .pointer,
        border: .none,
        raw: {'box-shadow': '0 2px 8px rgba(0,0,0,0.06)'},
      ),
      css('.topbar-brand').styles(
        display: .flex,
        alignItems: .center,
        gap: Gap.all(8.px),
      ),
      css('.topbar-logo').styles(
        width: 30.px,
        height: 30.px,
        radius: .all(.circular(8.px)),
        display: .flex,
        alignItems: .center,
        justifyContent: .center,
        color: Colors.white,
        fontWeight: .w700,
        fontSize: 14.px,
        raw: {'background': 'linear-gradient(135deg, #6366F1, #8B5CF6)'},
      ),
      css('.topbar-title').styles(
        fontWeight: .w700,
        fontSize: 20.px,
        color: primaryDark,
      ),
    ]),
    // Show top bar on mobile only
    css.media(MediaQuery.screen(maxWidth: 768.px), [
      css('.app-top-bar').styles(display: .flex),
    ]),
  ];
}
