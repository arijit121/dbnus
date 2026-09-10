import 'package:jaspr/dom.dart';

// Primary brand colors
const baseHexColor = Color('#6C63FF');
const vibrateBlue = Color('#4F46E5');
const violate = Color('#8B5CF6');

// Neutral / text colors
const primaryDark = Color('#1E293B');
const secondaryDark = Color('#64748B');
const grey = Color('#94A3B8');
const lightGrey = Color('#E2E8F0');
const lineGrey = Color('#F1F5F9');

// Status colors
const red = Color('#EF4444');
const green = Color('#22C55E');
const deepGreen = Color('#15803D');
const lightGreen = Color('#DCFCE7');
const lightBlue = Color('#3B82F6');
const deepBlue = Color('#1D4ED8');

// Background colors
const scaffoldBg = Color('#F8FAFC');
const sidebarBg = Color('#0F172A');
const cardBg = Color('#FFFFFF');

// Navigation
const sidebarSelected = Color('#6366F1');

// Legacy alias
const primaryColor = baseHexColor;

// Defines the global CSS styles for this project.
@css
List<StyleRule> get styles => [
  css.import(
      'https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap'),
  css('*, *::before, *::after').styles(boxSizing: .borderBox),
  css('html, body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    padding: .zero,
    margin: .zero,
    fontFamily: const .list([FontFamily('Inter'), FontFamilies.sansSerif]),
    backgroundColor: scaffoldBg,
    color: primaryDark,
  ),
  css('h1, h2, h3, h4, h5, h6').styles(margin: .zero, fontWeight: .w600),
  css('a').styles(textDecoration: TextDecoration(line: .none), color: .inherit),
  css('button').styles(
    cursor: .pointer,
    border: .none,
    raw: {'background-color': 'transparent'},
  ),
  // Global animation keyframe
  css.keyframes('fadeIn', {
    'from': Styles(raw: {'opacity': '0', 'transform': 'translateY(8px)'}),
    'to': Styles(raw: {'opacity': '1', 'transform': 'translateY(0)'}),
  }),
];
