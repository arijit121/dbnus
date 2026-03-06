import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

import 'section_title.dart';

class EmploymentCard extends StatelessWidget {
  const EmploymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = [
      _Job(
        'Mar 2023 - Present',
        'App Developer',
        'SastaSundar, Kolkata',
        'App & Web Developer (Flutter), specializing in crafting seamless cross-platform solutions.',
        const [Color(0xFFE67E22), Color(0xFFD35400)],
        true,
      ),
      _Job(
        'May 2022 - Mar 2023',
        'Software Engineer',
        'Max Mobility, Kolkata',
        'Skilled in Dart, crafting cross-platform apps. Proficient in BLoC & GetX state management.',
        const [ColorConst.lightBlue, ColorConst.deepBlue],
        false,
      ),
      _Job(
        'Oct 2021 - Apr 2022',
        'Flutter Developer',
        'SOFTWEBIAN',
        'Specialize in crafting cross-platform apps with Dart. Proficient in UI/UX & API integration.',
        const [ColorConst.violate, ColorConst.sidebarSelected],
        false,
      ),
      _Job(
        'Nov 2020 - May 2021',
        'Trainee Developer',
        'MOBILOITTE, New Delhi',
        'Mastering Java, Kotlin, Dart & Flutter for cross-platform apps.',
        const [ColorConst.deepGreen, Color(0xFF1B7A4D)],
        false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: FeatherIcons.briefcase,
          title: "Employment History",
          color: const Color(0xFFE67E22),
        ),
        ...jobs.map(
          (job) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                color: ColorConst.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient top bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: job.gradient),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          job.isCurrent ? FeatherIcons.zap : FeatherIcons.clock,
                          size: 16,
                          color: Colors.white,
                        ),
                        8.pw,
                        CustomText(
                          job.period,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          size: 12,
                        ),
                        if (job.isCurrent) ...[
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const CustomText(
                              "Current",
                              color: Colors.white,
                              size: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          job.title,
                          fontWeight: FontWeight.w700,
                          size: 15,
                          color: ColorConst.primaryDark,
                        ),
                        4.ph,
                        CustomText(
                          job.company,
                          size: 13,
                          color: ColorConst.secondaryDark,
                          fontStyle: FontStyle.italic,
                        ),
                        10.ph,
                        CustomText(
                          job.description,
                          size: 13,
                          color: ColorConst.secondaryDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Job {
  final String period, title, company, description;
  final List<Color> gradient;
  final bool isCurrent;
  const _Job(
    this.period,
    this.title,
    this.company,
    this.description,
    this.gradient,
    this.isCurrent,
  );
}
