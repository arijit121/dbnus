import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import '../../../../core/services/open_service.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';

class HeroHeader extends StatelessComponent {
  const HeroHeader({super.key});

  @override
  Component build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: 24,
          bottomRight: 24,
        ),
      ),
      style: Styles(raw: {
        'background': 'linear-gradient(135deg, ${ColorConst.sidebarBg.value}, #2D3250)',
        'box-shadow': '0 4px 15px rgba(0, 0, 0, 0.15)',
        'border-bottom': '1px solid #334155',
        'box-sizing': 'border-box',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomIconButton(
                icon: const CustomSvgAssetImageView(
                  path: AssetsConst.featherArrowLeft,
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                color: Colors.white,
                iconSize: 20,
                onPressed: () {
                  try {
                    Router.of(context).push('/');
                  } catch (_) {}
                },
              ),
              CustomIconButton(
                icon: CustomSvgAssetImageView(
                  path: AssetsConst.featherShare2,
                  width: 20,
                  height: 20,
                  color: Colors.white.withOpacity(0.85),
                ),
                color: Colors.white,
                iconSize: 20,
                onPressed: () {
                  OpenService.share(
                    title: "Arijit Sarkar - Flutter Developer",
                    text: "Arijit Sarkar - Flutter Developer Bio Data",
                    url: "https://dbnus-df986.web.app/bio-data",
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(40),
            ),
            style: Styles(raw: {
              'background': 'linear-gradient(135deg, ${ColorConst.sidebarSelected.value}, ${ColorConst.violate.value})',
              'box-shadow': '0 4px 15px rgba(99, 102, 241, 0.4)',
              'display': 'flex',
              'justify-content': 'center',
              'align-items': 'center',
            }),
            child: const CustomText(
              "AS",
              color: Colors.white,
              variant: TextVariant.h1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),

          // Name
          const CustomText(
            "Arijit Sarkar",
            color: Colors.white,
            variant: TextVariant.h2,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 8),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(20),
            ),
            style: Styles(raw: {
              'background-color': 'rgba(255, 255, 255, 0.12)',
              'display': 'inline-flex',
              'align-items': 'center',
              'gap': '8px',
            }),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSvgAssetImageView(
                  path: AssetsConst.featherCode,
                  width: 14,
                  height: 14,
                  color: Colors.white.withOpacity(0.85),
                ),
                const SizedBox(width: 8),
                CustomText(
                  "Flutter Developer  •  4+ Years",
                  color: Colors.white.withOpacity(0.9),
                  variant: TextVariant.bodySmall,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
