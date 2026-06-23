import 'package:jaspr/dom.dart' hide BorderRadius, Alignment;
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';
import '../../shared/ui/ui.dart';

class BioDataPage extends StatelessComponent {
  const BioDataPage({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      className: 'bio-page',
      gap: 24,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile header
        Card(
          className: 'bio-profile',
          padding: const EdgeInsets.all(28.0),
          borderRadius: const BorderRadius.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: 20,
            children: [
              Container(
                className: 'bio-avatar',
                width: 80,
                height: 80,
                alignment: Alignment.center,
                child: const CustomText('AJ', variant: TextVariant.h2, color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText('Alex Johnson', variant: TextVariant.h2),
                  CustomText('Full Stack Developer', className: 'bio-role', variant: TextVariant.bodySmall),
                  Row(
                    className: 'bio-badges',
                    gap: 8,
                    children: [
                      CustomText('Pro', className: 'badge badge-purple', variant: TextVariant.caption),
                      CustomText('Verified', className: 'badge badge-green', variant: TextVariant.caption),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Info cards grid
        GridView(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          shrinkWrap: true,
          children: [
            _infoSection('📋 Personal Information', [
              _infoRow('Full Name', 'Alex Johnson'),
              _infoRow('Email', 'alex.johnson@email.com'),
              _infoRow('Phone', '+1 (555) 123-4567'),
              _infoRow('Location', 'San Francisco, CA'),
              _infoRow('Date of Birth', 'January 15, 1995'),
            ]),
            _infoSection('💼 Professional', [
              _infoRow('Company', 'TechCorp Inc.'),
              _infoRow('Role', 'Senior Developer'),
              _infoRow('Experience', '8 years'),
              _infoRow('Skills', 'Dart, Flutter, Jaspr, React'),
              _infoRow('LinkedIn', 'linkedin.com/in/alexj'),
            ]),
            _infoSection('📊 Statistics', [
              _infoRow('Projects', '42'),
              _infoRow('Contributions', '1,234'),
              _infoRow('Reputation', '9,850 pts'),
              _infoRow('Rank', '#4 Global'),
              _infoRow('Member Since', 'March 2020'),
            ]),
            _infoSection('🎯 Achievements', [
              _infoRow('🏆 Top Contributor', '2024 Q1 Award'),
              _infoRow('⭐ 5-Star Rating', 'Client satisfaction'),
              _infoRow('🔥 100-Day Streak', 'Daily commits'),
              _infoRow('🎓 Certified', 'Dart Professional'),
              _infoRow('🌟 Open Source', '50+ repositories'),
            ]),
          ],
        ),
      ],
    );
  }

  Component _infoSection(String title, List<Component> rows) {
    return Card(
      className: 'bio-card',
      padding: const EdgeInsets.all(24.0),
      borderRadius: const BorderRadius.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(title, variant: TextVariant.h3, className: 'bio-card-title'),
          Column(
            className: 'bio-card-body',
            gap: 2,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: rows,
          ),
        ],
      ),
    );
  }

  Component _infoRow(String label, String value) {
    return Row(
      className: 'bio-row',
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(label, className: 'bio-label', variant: TextVariant.bodySmall),
        CustomText(value, className: 'bio-value', variant: TextVariant.body, fontWeight: FontWeight.w600),
      ],
    );
  }
}
