import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class LanguagesHobbiesCard extends StatelessComponent {
  const LanguagesHobbiesCard({super.key});

  @override
  Component build(BuildContext context) {
    return GridView(
      maxCrossAxisExtent: 340,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      children: [
        // Languages Card
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              icon: AssetsConst.featherGlobe,
              title: "Languages",
              color: ColorConst.deepGreen,
            ),
            CardShell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSvgAssetImageView(
                    path: AssetsConst.featherMessageCircle,
                    width: 18,
                    height: 18,
                    color: ColorConst.deepGreen,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          "English",
                          variant: TextVariant.body,
                          fontWeight: FontWeight.w600,
                          color: ColorConst.primaryDark,
                        ),
                        SizedBox(height: 2),
                        CustomText(
                          "Highly proficient",
                          variant: TextVariant.caption,
                          color: ColorConst.secondaryDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Hobbies Card
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              icon: AssetsConst.featherHeart,
              title: "Hobbies",
              color: Color('#E67E22'),
            ),
            CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSvgAssetImageView(
                        path: AssetsConst.featherCompass,
                        width: 18,
                        height: 18,
                        color: Color('#E67E22'),
                      ),
                      SizedBox(width: 10),
                      CustomText(
                        "Cycling",
                        variant: TextVariant.body,
                        fontWeight: FontWeight.w500,
                        color: ColorConst.primaryDark,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomSvgAssetImageView(
                        path: AssetsConst.featherMusic,
                        width: 18,
                        height: 18,
                        color: ColorConst.violate,
                      ),
                      SizedBox(width: 10),
                      CustomText(
                        "Listening Music",
                        variant: TextVariant.body,
                        fontWeight: FontWeight.w500,
                        color: ColorConst.primaryDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
