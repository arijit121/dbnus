import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

import 'card_shell.dart';
import 'section_title.dart';

class LanguagesHobbiesCard extends StatelessWidget {
  const LanguagesHobbiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                icon: FeatherIcons.globe,
                title: "Languages",
                color: ColorConst.deepGreen,
              ),
              CardShell(
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.messageCircle,
                      size: 16,
                      color: ColorConst.deepGreen,
                    ),
                    10.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            "English",
                            size: 13,
                            fontWeight: FontWeight.w600,
                            color: ColorConst.primaryDark,
                          ),
                          CustomText(
                            "Highly proficient",
                            size: 11,
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
        ),
        12.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                icon: FeatherIcons.heart,
                title: "Hobbies",
                color: const Color(0xFFE67E22),
              ),
              CardShell(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FeatherIcons.compass,
                          size: 16,
                          color: Color(0xFFE67E22),
                        ),
                        8.pw,
                        CustomText(
                          "Cycling",
                          size: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorConst.primaryDark,
                        ),
                      ],
                    ),
                    8.ph,
                    Row(
                      children: [
                        Icon(
                          FeatherIcons.music,
                          size: 16,
                          color: ColorConst.violate,
                        ),
                        8.pw,
                        Flexible(
                          child: CustomText(
                            "Listening Music",
                            size: 13,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: ColorConst.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
