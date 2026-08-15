import 'package:material_ui/material_ui.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomSvgAssetImageView(path: icon, height: 20, width: 20, color: ColorConst.primaryDark),
        10.pw,
        CustomText(
          title,
          fontWeight: FontWeight.w600,
          size: 18,
          color: ColorConst.primaryDark,
        ),
      ],
    );
  }
}
