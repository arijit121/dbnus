import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../shared/constants/theme.dart';

class BioDataPage extends StatelessComponent {
  const BioDataPage({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'bio-page', [
      // Profile header
      div(classes: 'bio-profile', [
        div(classes: 'bio-avatar', [text('AJ')]),
        div(classes: 'bio-name-section', [
          h2([text('Alex Johnson')]),
          p(classes: 'bio-role', [text('Full Stack Developer')]),
          div(classes: 'bio-badges', [
            span(classes: 'badge badge-purple', [text('Pro')]),
            span(classes: 'badge badge-green', [text('Verified')]),
          ]),
        ]),
      ]),
      // Info cards
      div(classes: 'bio-grid', [
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
      ]),
    ]);
  }

  Component _infoSection(String title, List<Component> rows) {
    return div(classes: 'bio-card', [
      h3(classes: 'bio-card-title', [text(title)]),
      div(classes: 'bio-card-body', rows),
    ]);
  }

  Component _infoRow(String label, String value) {
    return div(classes: 'bio-row', [
      span(classes: 'bio-label', [text(label)]),
      span(classes: 'bio-value', [text(value)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.bio-page').styles(display: .flex, flexDirection: .column, gap: Gap.all(24.px), raw: {'animation': 'fadeIn 0.4s ease'}),
    css('.bio-profile', [
      css('&').styles(
        display: .flex, alignItems: .center, gap: Gap.all(20.px),
        backgroundColor: Colors.white, radius: .all(.circular(20.px)),
        padding: .all(28.px),
        raw: {'box-shadow': '0 2px 8px rgba(0,0,0,0.04)'},
      ),
      css('.bio-avatar').styles(
        width: 80.px, height: 80.px,
        radius: .all(.circular(20.px)),
        display: .flex, alignItems: .center, justifyContent: .center,
        color: Colors.white, fontSize: 28.px, fontWeight: .w700,
        raw: {'background': 'linear-gradient(135deg, #6366F1, #8B5CF6)', 'flex-shrink': '0'},
      ),
      css('.bio-role').styles(color: secondaryDark, fontSize: 14.px, margin: .zero, raw: {'margin-top': '4px'}),
      css('.bio-badges').styles(display: .flex, gap: Gap.all(8.px), raw: {'margin-top': '8px'}),
      css('.badge').styles(
        padding: .symmetric(horizontal: 10.px, vertical: 4.px),
        radius: .all(.circular(6.px)), fontSize: 11.px, fontWeight: .w600,
      ),
      css('.badge-purple').styles(backgroundColor: const Color('#EDE9FE'), color: violate),
      css('.badge-green').styles(backgroundColor: lightGreen, color: deepGreen),
    ]),
    css('.bio-grid').styles(
      display: .grid, gap: Gap.all(20.px),
      raw: {'grid-template-columns': 'repeat(auto-fit, minmax(300px, 1fr))'},
    ),
    css('.bio-card', [
      css('&').styles(
        backgroundColor: Colors.white, radius: .all(.circular(16.px)),
        padding: .all(24.px),
        raw: {'box-shadow': '0 1px 3px rgba(0,0,0,0.04)'},
      ),
      css('.bio-card-title').styles(fontSize: 16.px, raw: {'margin-bottom': '16px'}),
      css('.bio-card-body').styles(display: .flex, flexDirection: .column, gap: Gap.all(2.px)),
    ]),
    css('.bio-row', [
      css('&').styles(
        display: .flex, justifyContent: .spaceBetween, alignItems: .center,
        padding: .symmetric(horizontal: 8.px, vertical: 12.px),
        radius: .all(.circular(8.px)),
        raw: {'transition': 'background 0.15s ease'},
      ),
      css('&:hover').styles(backgroundColor: scaffoldBg),
      css('.bio-label').styles(fontSize: 13.px, color: secondaryDark, fontWeight: .w500),
      css('.bio-value').styles(fontSize: 14.px, color: primaryDark, fontWeight: .w600),
    ]),
  ];
}
