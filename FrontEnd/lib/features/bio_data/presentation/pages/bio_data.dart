import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';

import '../widgets/contact_card.dart';
import '../widgets/courses_card.dart';
import '../widgets/education_card.dart';
import '../widgets/employment_card.dart';
import '../widgets/hero_header.dart';
import '../widgets/languages_hobbies_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/projects_card.dart';
import '../widgets/skills_card.dart';

class BioData extends StatelessWidget {
  const BioData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ─────────────────────────────────────
          const SliverToBoxAdapter(child: HeroHeader()),

          // ── Content ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                16.ph,
                const ProfileCard(),
                20.ph,
                const ContactCard(),
                20.ph,
                const EmploymentCard(),
                20.ph,
                const EducationCard(),
                20.ph,
                const SkillsCard(),
                20.ph,
                const LanguagesHobbiesCard(),
                20.ph,
                const CoursesCard(),
                20.ph,
                const ProjectsCard(),
                40.ph,
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
