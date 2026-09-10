import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class CoursesCard extends StatelessComponent {
  const CoursesCard({super.key});

  @override
  Component build(BuildContext context) {
    const courses = [
      _Course('Back-end Development (REST API)', 'Udemy', AssetsConst.featherServer),
      _Course('Java Vocational Training', 'MSME', AssetsConst.featherCoffee),
      _Course('VLSI Vocational Training', 'MSME', AssetsConst.featherCpu),
      _Course('BSNL Telecom Training', 'BSNL', AssetsConst.featherRadio),
      _Course('Machine Learning with Python', 'MYWBUT', AssetsConst.featherTrendingUp),
      _Course('Python Programming', 'MYWBUT', AssetsConst.featherTerminal),
    ];

    const colors = [
      ColorConst.lightBlue,
      ColorConst.deepGreen,
      ColorConst.violate,
      Color('#E67E22'),
      ColorConst.red,
      ColorConst.deepBlue,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          icon: AssetsConst.featherAward,
          title: "Courses & Certifications",
          color: ColorConst.violate,
        ),
        CardShell(
          child: Column(
            children: List.generate(courses.length, (index) {
              final course = courses[index];
              final color = colors[index];
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(8),
                          ),
                          style: Styles(raw: {
                            'background-color': '${color.value}1A',
                            'display': 'flex',
                            'align-items': 'center',
                            'justify-content': 'center',
                          }),
                          child: CustomSvgAssetImageView(path: course.icon, width: 16, height: 16, color: color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                course.title,
                                variant: TextVariant.body,
                                fontWeight: FontWeight.w600,
                                color: ColorConst.primaryDark,
                              ),
                              const SizedBox(height: 2),
                              CustomText(
                                course.provider,
                                variant: TextVariant.caption,
                                color: ColorConst.secondaryDark,
                                className: 'italic-text',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < courses.length - 1) const CustomDivider(),
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
  final String title;
  final String provider;
  final String icon;
  const _Course(this.title, this.provider, this.icon);
}
