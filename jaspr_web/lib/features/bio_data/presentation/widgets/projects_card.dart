import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../core/services/open_service.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class ProjectsCard extends StatelessComponent {
  const ProjectsCard({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          icon: AssetsConst.featherLayers,
          title: "Projects",
          color: ColorConst.red,
        ),
        GridView(
          maxCrossAxisExtent: 340,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          children: [
            _projectCardWithLinks(
              'Age and Gender Recognition',
              'Developed accurate age and gender recognition systems using advanced Python algorithms.',
              AssetsConst.featherEye,
              ColorConst.violate,
              const [],
            ),
            _projectCardWithLinks(
              'Food Frenzy',
              'Restaurant management app facilitating order food and streamlining order management.',
              AssetsConst.featherCoffee,
              const Color('#E67E22'),
              const [],
            ),
            _projectCardWithLinks(
              'Caretaker',
              'Comprehensive home service app featuring home and car cleaning services.',
              AssetsConst.featherHome,
              ColorConst.deepGreen,
              const [],
            ),
            _projectCardWithLinks(
              'Imanage',
              'Self-care app of Tata for bill payment and manage inventory.',
              AssetsConst.featherSmartphone,
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
              AssetsConst.featherUsers,
              ColorConst.violate,
              const [
                _ProjectLink(
                  'Android',
                  'https://play.google.com/store/apps/details?id=com.ttsl.wfm',
                ),
              ],
            ),
            _projectCardWithLinks(
              'Tata Combing',
              'Office maintenance app for monitoring schedules and occupancy levels.',
              AssetsConst.featherSettings,
              ColorConst.deepBlue,
              const [],
            ),
            _projectCardWithLinks(
              'Gotrakk',
              'Vehicle tracking system enabling real-time tracking and fleet optimization.',
              AssetsConst.featherNavigation,
              ColorConst.red,
              const [],
            ),
            _projectCardWithLinks(
              'Gemopai Connect',
              'Vehicle tracking system for real-time tracking and fleet optimization.',
              AssetsConst.featherTruck,
              const Color('#E67E22'),
              const [],
            ),
            _projectCardWithLinks(
              'Jivanjor Smart Connect',
              'JACPL dealer app for simplified order placement and product info access.',
              AssetsConst.featherPackage,
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
            _projectCardWithLinks(
              'MCSS Staffing Solutions',
              'Employee management app for scheduling shifts, tracking hours, and communication.',
              AssetsConst.featherClipboard,
              ColorConst.lightBlue,
              const [],
            ),
            _projectCardWithLinks(
              'Retailer Shakti',
              'Retail management system for inventory, sales, and customer management.',
              AssetsConst.featherShoppingBag,
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
              AssetsConst.featherActivity,
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
              AssetsConst.featherHeart,
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
        ),
      ],
    );
  }

  Component _projectCardWithLinks(
    String title,
    String description,
    String icon,
    Color color,
    List<_ProjectLink> links,
  ) {
    return CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(10),
                ),
                style: Styles(raw: {
                  'background-color': '${color.value}1A',
                  'display': 'flex',
                  'align-items': 'center',
                  'justify-content': 'center',
                }),
                child: CustomSvgAssetImageView(path: icon, width: 18, height: 18, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      title,
                      fontWeight: FontWeight.w700,
                      variant: TextVariant.body,
                      color: ColorConst.primaryDark,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      description,
                      variant: TextVariant.caption,
                      color: ColorConst.secondaryDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (links.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: links
                  .map(
                    (item) => div(
                      events: {
                        'click': (e) => OpenService.openUrl(
                              uri: Uri.parse(item.url),
                            ),
                      },
                      styles: Styles(raw: {
                        'background': 'linear-gradient(135deg, ${color.value}1F, ${color.value}0A)',
                        'border': '1px solid ${color.value}33',
                        'border-radius': '8px',
                        'padding': '6px 10px',
                        'cursor': 'pointer',
                        'display': 'inline-flex',
                        'align-items': 'center',
                        'gap': '6px',
                        'transition': 'opacity 0.2s ease',
                      }),
                      [
                        CustomSvgAssetImageView(
                          path: AssetsConst.featherExternalLink,
                          width: 12,
                          height: 12,
                          color: color,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          item.label,
                          variant: TextVariant.caption,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProjectLink {
  final String label;
  final String url;
  const _ProjectLink(this.label, this.url);
}
