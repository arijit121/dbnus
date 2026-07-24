import 'package:dbnus/shared/constants/assects_const.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/images/custom_image.dart';

import 'card_shell.dart';
import 'section_title.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: AssetsConst.featherBookOpen,
          title: "Education",
          color: ColorConst.violate,
        ),
        CardShell(
          child: Column(
            children: [
              _educationTile(
                '2017-2021',
                'B. Tech (E.C.E)',
                'UEM, Jaipur',
                AssetsConst.featherAward,
                ColorConst.violate,
              ),
              _divider(),
              _educationTile(
                '2017',
                'Higher Secondary',
                'Panchgram High School',
                AssetsConst.featherBook,
                ColorConst.lightBlue,
              ),
              _divider(),
              _educationTile(
                '2015',
                'Secondary',
                'Panchgram High School',
                AssetsConst.featherBookOpen,
                ColorConst.deepGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _educationTile(
    String period,
    String degree,
    String school,
    String icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: CustomSvgAssetImageView(path: icon, height: 18, width: 18, color: color),
          ),
          14.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  degree,
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: ColorConst.primaryDark,
                ),
                2.ph,
                CustomText(
                  school,
                  size: 12,
                  color: ColorConst.secondaryDark,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomText(
              period,
              size: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 0, color: ColorConst.lineGrey);
}
