import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'card_shell.dart';
import 'section_title.dart';

class CoursesCard extends StatelessWidget {
  const CoursesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      _Course('Back-end Development (REST API)', 'Udemy', FeatherIcons.server),
      _Course('Java Vocational Training', 'MSME', FeatherIcons.coffee),
      _Course('VLSI Vocational Training', 'MSME', FeatherIcons.cpu),
      _Course('BSNL Telecom Training', 'BSNL', FeatherIcons.radio),
      _Course(
          'Machine Learning with Python', 'MYWBUT', FeatherIcons.trendingUp),
      _Course('Python Programming', 'MYWBUT', FeatherIcons.terminal),
    ];

    final colors = [
      ColorConst.lightBlue,
      ColorConst.deepGreen,
      ColorConst.violate,
      const Color(0xFFE67E22),
      ColorConst.red,
      ColorConst.deepBlue,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: FeatherIcons.award,
          title: "Courses & Certifications",
          color: ColorConst.violate,
        ),
        CardShell(
          child: Column(
            children: List.generate(courses.length, (i) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors[i].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              Icon(courses[i].icon, size: 16, color: colors[i]),
                        ),
                        12.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                courses[i].title,
                                size: 13,
                                fontWeight: FontWeight.w600,
                                color: ColorConst.primaryDark,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              2.ph,
                              CustomText(
                                courses[i].provider,
                                size: 11,
                                color: ColorConst.secondaryDark,
                                fontStyle: FontStyle.italic,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < courses.length - 1)
                    const Divider(
                      height: 1,
                      indent: 0,
                      color: ColorConst.lineGrey,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _Course {
  final String title, provider;
  final IconData icon;
  const _Course(this.title, this.provider, this.icon);
}
