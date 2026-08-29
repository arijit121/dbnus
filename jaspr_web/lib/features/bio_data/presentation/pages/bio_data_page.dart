import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../widgets/contact_card.dart';
import '../widgets/courses_card.dart';
import '../widgets/education_card.dart';
import '../widgets/employment_card.dart';
import '../widgets/hero_header.dart';
import '../widgets/languages_hobbies_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/projects_card.dart';
import '../widgets/skills_card.dart';

class BioDataPage extends StatelessComponent {
  const BioDataPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bio-data-page',
      styles: Styles(raw: {
        'display': 'flex',
        'flex-direction': 'column',
        'width': '100%',
        'min-height': '100%',
        'box-sizing': 'border-box',
      }),
      [
        // Hero Header
        const HeroHeader(),

        // Content body
        div(
          classes: 'bio-data-content',
          styles: Styles(raw: {
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '20px',
            'padding': '20px 16px 40px 16px',
            'max-width': '1100px',
            'width': '100%',
            'margin': '0 auto',
            'box-sizing': 'border-box',
          }),
          [
            const ProfileCard(),
            const ContactCard(),
            const EmploymentCard(),
            const EducationCard(),
            const SkillsCard(),
            const LanguagesHobbiesCard(),
            const CoursesCard(),
            const ProjectsCard(),
          ],
        ),
      ],
    );
  }
}
