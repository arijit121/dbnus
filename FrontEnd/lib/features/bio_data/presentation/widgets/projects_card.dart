// ignore_color_warnings
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

import 'card_shell.dart';
import 'section_title.dart';

class ProjectsCard extends StatelessWidget {
  const ProjectsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: FeatherIcons.layers,
          title: "Projects",
          color: ColorConst.red,
        ),
        _projectCard(
          'Age and Gender Recognition',
          'Developed accurate age and gender recognition systems using advanced Python algorithms.',
          icon: FeatherIcons.eye,
          color: ColorConst.violate,
        ),
        _projectCard(
          'Food Frenzy',
          'Restaurant management app facilitating order food and streamlining order management.',
          icon: FeatherIcons.coffee,
          color: const Color(0xFFE67E22),
        ),
        _projectCard(
          'Caretaker',
          'Comprehensive home service app featuring home and car cleaning services.',
          icon: FeatherIcons.home,
          color: ColorConst.deepGreen,
        ),
        _projectCardWithLinks(
          'Imanage',
          'Self-care app of Tata for bill payment and manage inventory.',
          FeatherIcons.smartphone,
          ColorConst.lightBlue,
          const [
            _ProjectLink(
              'Android',
              'https://play.google.com/store/apps/details?id=com.tatatele.imanageappprod',
            ),
            _ProjectLink(
              'iOS',
              'https://apps.apple.com/in/app/tata-tele-imanage/id1613502566',
            ),
          ],
        ),
        _projectCardWithLinks(
          'Tata WFM',
          'Optimizing workforce management, scheduling, resource allocation, and employee engagement.',
          FeatherIcons.users,
          ColorConst.violate,
          const [
            _ProjectLink(
              'Android',
              'https://play.google.com/store/apps/details?id=com.ttsl.wfm',
            ),
          ],
        ),
        _projectCard(
          'Tata Combing',
          'Office maintenance app for monitoring schedules and occupancy levels.',
          icon: FeatherIcons.settings,
          color: ColorConst.deepBlue,
        ),
        _projectCard(
          'Gotrakk',
          'Vehicle tracking system enabling real-time tracking and fleet optimization.',
          icon: FeatherIcons.navigation,
          color: ColorConst.red,
        ),
        _projectCard(
          'Gemopai Connect',
          'Vehicle tracking system for real-time tracking and fleet optimization.',
          icon: FeatherIcons.truck,
          color: const Color(0xFFE67E22),
        ),
        _projectCardWithLinks(
          'Jivanjor Smart Connect',
          'JACPL dealer app for simplified order placement and product info access.',
          FeatherIcons.package,
          ColorConst.deepGreen,
          const [
            _ProjectLink(
              'Android',
              'https://play.google.com/store/apps/details?id=com.maxmobility.smart_connect',
            ),
            _ProjectLink(
              'iOS',
              'https://apps.apple.com/us/app/jivanjor-smart-connect/id1609917902',
            ),
          ],
        ),
        _projectCard(
          'MCSS Staffing Solutions',
          'Employee management app for scheduling shifts, tracking hours, and communication.',
          icon: FeatherIcons.clipboard,
          color: ColorConst.lightBlue,
        ),
        _projectCardWithLinks(
          'Retailer Shakti',
          'Retail management system for inventory, sales, and customer management.',
          FeatherIcons.shoppingBag,
          ColorConst.violate,
          const [
            _ProjectLink(
              'Android',
              'https://play.google.com/store/apps/details?id=com.retailershakti',
            ),
            _ProjectLink(
              'iOS',
              'https://apps.apple.com/in/app/retailershakti-wholesale-app/id6448796029',
            ),
            _ProjectLink('Web', 'https://www.retailershakti.com/'),
          ],
        ),
        _projectCardWithLinks(
          'Genu Path Labs',
          'Healthcare platform with video calls, lab management, patient tracking, and report generation.',
          FeatherIcons.activity,
          ColorConst.red,
          const [
            _ProjectLink(
              'Android',
              'https://play.google.com/store/apps/details?id=com.genupathlabs',
            ),
            _ProjectLink(
              'iOS',
              'https://apps.apple.com/us/app/genu-health/id6483367005',
            ),
            _ProjectLink('Web', 'https://www.genupathlabs.com/'),
          ],
        ),
        _projectCardWithLinks(
          'SastaSundar',
          'Medical e-commerce platform with mobile app, m-site, and video consultation.',
          FeatherIcons.heart,
          ColorConst.deepGreen,
          const [
            _ProjectLink(
              'Android',
              'https://play.google.com/store/apps/details?id=com.shtpl.sastasundar',
            ),
            _ProjectLink(
              'iOS',
              'https://apps.apple.com/in/app/sastasundar-online-pharmacy/id6738185605',
            ),
            _ProjectLink('Web', 'https://sastasundar.com/'),
          ],
        ),
      ],
    );
  }

  Widget _projectCard(
    String title,
    String description, {
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardShell(
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

  Widget _projectCardWithLinks(
    String title,
    String description,
    IconData icon,
    Color color,
    List<_ProjectLink> links,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardShell(
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
                  .map(
                    (link) => InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => OpenService.openUrl(
                        uri: Uri.parse(link.url),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withValues(alpha: 0.12),
                              color.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FeatherIcons.externalLink,
                              size: 12,
                              color: color,
                            ),
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
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectLink {
  final String label, url;
  const _ProjectLink(this.label, this.url);
}
