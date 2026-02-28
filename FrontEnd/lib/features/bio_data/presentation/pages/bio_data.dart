import 'package:dbnus/navigation/custom_router/custom_route.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';
import 'package:dbnus/shared/ui/atoms/buttons/custom_button.dart';

class BioData extends StatelessWidget {
  const BioData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ─────────────────────────────────────
          SliverToBoxAdapter(child: _buildHeroHeader(context)),

          // ── Content ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                16.ph,
                _buildProfileCard(),
                20.ph,
                _buildContactCard(),
                20.ph,
                _buildEmploymentCard(),
                20.ph,
                _buildEducationCard(),
                20.ph,
                _buildSkillsCard(),
                20.ph,
                _buildLanguagesHobbiesCard(),
                20.ph,
                _buildCoursesCard(),
                20.ph,
                _buildProjectsCard(),
                40.ph,
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Hero Header ───────────────────────────────────────────────
  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConst.sidebarBg,
            Color(0xFF2D3250),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConst.sidebarBg.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top bar
          Row(
            children: [
              CustomIconButton(
                icon: const Icon(FeatherIcons.arrowLeft),
                color: Colors.white,
                iconSize: 20,
                onPressed: () => CustomRoute.back(),
              ),
              const Spacer(),
              CustomIconButton(
                icon: const Icon(FeatherIcons.share2),
                color: Colors.white70,
                iconSize: 20,
                onPressed: () {},
              ),
            ],
          ),
          16.ph,

          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorConst.sidebarSelected,
                  ColorConst.violate,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.sidebarSelected.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: CustomText(
                "AS",
                color: Colors.white,
                size: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          12.ph,

          // Name
          const CustomText(
            "Arijit Sarkar",
            color: Colors.white,
            size: 24,
            fontWeight: FontWeight.w800,
          ),
          6.ph,

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FeatherIcons.code, size: 14, color: Colors.white70),
                8.pw,
                const CustomText(
                  "Flutter Developer  •  3+ Years",
                  color: Colors.white70,
                  size: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section Title ─────────────────────────────────────────────
  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          12.pw,
          Flexible(
            child: CustomText(
              title,
              fontWeight: FontWeight.w700,
              size: 17,
              color: ColorConst.primaryDark,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Card Shell ────────────────────────────────────────────────
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      child: child,
    );
  }

  // ─── Profile ───────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(FeatherIcons.user, "Profile", ColorConst.lightBlue),
        _buildCard(
          child: const CustomText(
            'Skilled Flutter developer with 3+ years exp. Specialize in BLOC, Provider, GetX. Proficient in Dart, UI/UX, location tracking, & payment integration (PhonePe, Paytm, etc.). Dedicated to excellence & innovation.',
            size: 14,
            color: ColorConst.secondaryDark,
          ),
        ),
      ],
    );
  }

  // ─── Contact ───────────────────────────────────────────────────
  Widget _buildContactCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(FeatherIcons.phone, "Contact", ColorConst.deepGreen),
        _buildCard(
          child: Column(
            children: [
              _contactTile(FeatherIcons.mapPin, 'Kolkata, India',
                  ColorConst.violate, null),
              _divider(),
              _contactTile(
                  FeatherIcons.phone, '+91 89189 51655', ColorConst.deepGreen,
                  () {
                OpenService.openUrl(uri: Uri.parse('tel:+918918951655'));
              }),
              _divider(),
              _contactTile(
                  FeatherIcons.mail, 'ruarijitsarkar@gmail.com', ColorConst.red,
                  () {
                OpenService.openUrl(
                    uri: Uri.parse('mailto:ruarijitsarkar@gmail.com'));
              }),
              _divider(),
              _contactTile(
                  FeatherIcons.linkedin,
                  'linkedin.com/in/arijit-sarkar-...',
                  ColorConst.lightBlue, () {
                OpenService.openUrl(
                    uri: Uri.parse(
                        'https://www.linkedin.com/in/arijit-sarkar-53b822184/'));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactTile(
      IconData icon, String text, Color color, VoidCallback? onTap) {
    final tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          12.pw,
          Expanded(
            child: CustomText(
              text,
              size: 13,
              color: ColorConst.primaryDark,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onTap != null)
            Icon(FeatherIcons.chevronRight, size: 16, color: ColorConst.grey),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
          borderRadius: BorderRadius.circular(8), onTap: onTap, child: tile);
    }
    return tile;
  }

  // ─── Employment ────────────────────────────────────────────────
  Widget _buildEmploymentCard() {
    final jobs = [
      _Job(
          'Mar 2023 - Present',
          'App Developer',
          'SastaSundar, Kolkata',
          'App & Web Developer (Flutter), specializing in crafting seamless cross-platform solutions.',
          [Color(0xFFE67E22), Color(0xFFD35400)],
          true),
      _Job(
          'May 2022 - Mar 2023',
          'Software Engineer',
          'Max Mobility, Kolkata',
          'Skilled in Dart, crafting cross-platform apps. Proficient in BLoC & GetX state management.',
          [ColorConst.lightBlue, ColorConst.deepBlue],
          false),
      _Job(
          'Oct 2021 - Apr 2022',
          'Flutter Developer',
          'SOFTWEBIAN',
          'Specialize in crafting cross-platform apps with Dart. Proficient in UI/UX & API integration.',
          [ColorConst.violate, ColorConst.sidebarSelected],
          false),
      _Job(
          'Nov 2020 - May 2021',
          'Trainee Developer',
          'MOBILOITTE, New Delhi',
          'Mastering Java, Kotlin, Dart & Flutter for cross-platform apps.',
          [ColorConst.deepGreen, Color(0xFF1B7A4D)],
          false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            FeatherIcons.briefcase, "Employment History", Color(0xFFE67E22)),
        ...jobs.map((job) => Padding(
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
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: job.gradient,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                              job.isCurrent
                                  ? FeatherIcons.zap
                                  : FeatherIcons.clock,
                              size: 16,
                              color: Colors.white),
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
                                  horizontal: 8, vertical: 2),
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
            )),
      ],
    );
  }

  // ─── Education ─────────────────────────────────────────────────
  Widget _buildEducationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            FeatherIcons.bookOpen, "Education", ColorConst.violate),
        _buildCard(
          child: Column(
            children: [
              _educationTile(
                '2017-2021',
                'B. Tech (E.C.E)',
                'UEM, Jaipur',
                FeatherIcons.award,
                ColorConst.violate,
              ),
              _divider(),
              _educationTile(
                '2017',
                'Higher Secondary',
                'Panchgram High School',
                FeatherIcons.book,
                ColorConst.lightBlue,
              ),
              _divider(),
              _educationTile(
                '2015',
                'Secondary',
                'Panchgram High School',
                FeatherIcons.bookOpen,
                ColorConst.deepGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _educationTile(
      String period, String degree, String school, IconData icon, Color color) {
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
            child: Icon(icon, size: 18, color: color),
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

  // ─── Skills ────────────────────────────────────────────────────
  Widget _buildSkillsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(FeatherIcons.cpu, "Skills", Color(0xFFE67E22)),
        _buildCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _skillChip('Flutter', 'Expert', ColorConst.lightBlue),
              _skillChip('Node.js', 'Expert', ColorConst.deepGreen),
              _skillChip('Git', 'Expert', ColorConst.red),
              _skillChip('MS Office', 'Expert', Color(0xFFE67E22)),
              _skillChip('JavaScript', 'Skillful', ColorConst.violate),
              _skillChip('Java', 'Skillful', ColorConst.primaryDark),
              _skillChip('MySQL', 'Skillful', Color(0xFF16A085)),
              _skillChip('SQL', 'Skillful', Color(0xFF8E44AD)),
              _skillChip('Python', 'Experienced', ColorConst.deepBlue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _skillChip(String name, String level, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          6.pw,
          CustomText(name, size: 12, fontWeight: FontWeight.w600, color: color),
          4.pw,
          CustomText(
            '• $level',
            size: 10,
            color: color.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  // ─── Languages & Hobbies ───────────────────────────────────────
  Widget _buildLanguagesHobbiesCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                  FeatherIcons.globe, "Languages", ColorConst.deepGreen),
              _buildCard(
                child: Row(
                  children: [
                    Icon(FeatherIcons.messageCircle,
                        size: 16, color: ColorConst.deepGreen),
                    10.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText("English",
                              size: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorConst.primaryDark),
                          CustomText("Highly proficient",
                              size: 11, color: ColorConst.secondaryDark),
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
              _buildSectionTitle(
                  FeatherIcons.heart, "Hobbies", Color(0xFFE67E22)),
              _buildCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(FeatherIcons.compass,
                            size: 16, color: Color(0xFFE67E22)),
                        8.pw,
                        CustomText("Cycling",
                            size: 13,
                            fontWeight: FontWeight.w500,
                            color: ColorConst.primaryDark),
                      ],
                    ),
                    8.ph,
                    Row(
                      children: [
                        Icon(FeatherIcons.music,
                            size: 16, color: ColorConst.violate),
                        8.pw,
                        Flexible(
                          child: CustomText("Listening Music",
                              size: 13,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              color: ColorConst.primaryDark),
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

  // ─── Courses ───────────────────────────────────────────────────
  Widget _buildCoursesCard() {
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
      Color(0xFFE67E22),
      ColorConst.red,
      ColorConst.deepBlue,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            FeatherIcons.award, "Courses & Certifications", ColorConst.violate),
        _buildCard(
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
                  if (i < courses.length - 1) _divider(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ─── Projects ──────────────────────────────────────────────────
  Widget _buildProjectsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(FeatherIcons.layers, "Projects", ColorConst.red),
        _projectCard('Age and Gender Recognition',
            'Developed accurate age and gender recognition systems using advanced Python algorithms.',
            icon: FeatherIcons.eye, color: ColorConst.violate),
        _projectCard('Food Frenzy',
            'Restaurant management app facilitating order food and streamlining order management.',
            icon: FeatherIcons.coffee, color: Color(0xFFE67E22)),
        _projectCard('Caretaker',
            'Comprehensive home service app featuring home and car cleaning services.',
            icon: FeatherIcons.home, color: ColorConst.deepGreen),
        _projectCardWithLinks(
          'Imanage',
          'Self-care app of Tata for bill payment and manage inventory.',
          FeatherIcons.smartphone,
          ColorConst.lightBlue,
          [
            _ProjectLink('Android',
                'https://play.google.com/store/apps/details?id=com.tatatele.imanageappprod'),
            _ProjectLink('iOS',
                'https://apps.apple.com/in/app/tata-tele-imanage/id1613502566'),
          ],
        ),
        _projectCardWithLinks(
          'Tata WFM',
          'Optimizing workforce management, scheduling, resource allocation, and employee engagement.',
          FeatherIcons.users,
          ColorConst.violate,
          [
            _ProjectLink('Android',
                'https://play.google.com/store/apps/details?id=com.ttsl.wfm'),
          ],
        ),
        _projectCard('Tata Combing',
            'Office maintenance app for monitoring schedules and occupancy levels.',
            icon: FeatherIcons.settings, color: ColorConst.deepBlue),
        _projectCard('Gotrakk',
            'Vehicle tracking system enabling real-time tracking and fleet optimization.',
            icon: FeatherIcons.navigation, color: ColorConst.red),
        _projectCard('Gemopai Connect',
            'Vehicle tracking system for real-time tracking and fleet optimization.',
            icon: FeatherIcons.truck, color: Color(0xFFE67E22)),
        _projectCardWithLinks(
          'Jivanjor Smart Connect',
          'JACPL dealer app for simplified order placement and product info access.',
          FeatherIcons.package,
          ColorConst.deepGreen,
          [
            _ProjectLink('Android',
                'https://play.google.com/store/apps/details?id=com.maxmobility.smart_connect'),
            _ProjectLink('iOS',
                'https://apps.apple.com/us/app/jivanjor-smart-connect/id1609917902'),
          ],
        ),
        _projectCard('MCSS Staffing Solutions',
            'Employee management app for scheduling shifts, tracking hours, and communication.',
            icon: FeatherIcons.clipboard, color: ColorConst.lightBlue),
        _projectCardWithLinks(
          'Retailer Shakti',
          'Retail management system for inventory, sales, and customer management.',
          FeatherIcons.shoppingBag,
          ColorConst.violate,
          [
            _ProjectLink('Android',
                'https://play.google.com/store/apps/details?id=com.retailershakti'),
            _ProjectLink('iOS',
                'https://apps.apple.com/in/app/retailershakti-wholesale-app/id6448796029'),
            _ProjectLink('Web', 'https://www.retailershakti.com/'),
          ],
        ),
        _projectCardWithLinks(
          'Genu Path Labs',
          'Healthcare platform with video calls, lab management, patient tracking, and report generation.',
          FeatherIcons.activity,
          ColorConst.red,
          [
            _ProjectLink('Android',
                'https://play.google.com/store/apps/details?id=com.genupathlabs'),
            _ProjectLink('iOS',
                'https://apps.apple.com/us/app/genu-health/id6483367005'),
            _ProjectLink('Web', 'https://www.genupathlabs.com/'),
          ],
        ),
        _projectCardWithLinks(
          'SastaSundar',
          'Medical e-commerce platform with mobile app, m-site, and video consultation.',
          FeatherIcons.heart,
          ColorConst.deepGreen,
          [
            _ProjectLink('Android',
                'https://play.google.com/store/apps/details?id=com.shtpl.sastasundar'),
            _ProjectLink('iOS',
                'https://apps.apple.com/in/app/sastasundar-online-pharmacy/id6738185605'),
            _ProjectLink('Web', 'https://sastasundar.com/'),
          ],
        ),
      ],
    );
  }

  Widget _projectCard(String title, String description,
      {required IconData icon, required Color color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            14.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontWeight: FontWeight.w700,
                    size: 14,
                    color: ColorConst.primaryDark,
                  ),
                  6.ph,
                  CustomText(
                    description,
                    size: 12,
                    color: ColorConst.secondaryDark,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectCardWithLinks(String title, String description, IconData icon,
      Color color, List<_ProjectLink> links) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                14.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title,
                        fontWeight: FontWeight.w700,
                        size: 14,
                        color: ColorConst.primaryDark,
                      ),
                      6.ph,
                      CustomText(
                        description,
                        size: 12,
                        color: ColorConst.secondaryDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.ph,
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: links
                  .map((link) => InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () =>
                            OpenService.openUrl(uri: Uri.parse(link.url)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withValues(alpha: 0.12),
                                color.withValues(alpha: 0.04),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: color.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FeatherIcons.externalLink,
                                  size: 12, color: color),
                              6.pw,
                              CustomText(
                                link.label,
                                size: 11,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared ────────────────────────────────────────────────────
  Widget _divider() =>
      Divider(height: 1, indent: 0, color: ColorConst.lineGrey);
}

// ─── Data Classes ────────────────────────────────────────────────
class _Job {
  final String period, title, company, description;
  final List<Color> gradient;
  final bool isCurrent;
  const _Job(this.period, this.title, this.company, this.description,
      this.gradient, this.isCurrent);
}

class _Course {
  final String title, provider;
  final IconData icon;
  const _Course(this.title, this.provider, this.icon);
}

class _ProjectLink {
  final String label, url;
  const _ProjectLink(this.label, this.url);
}
