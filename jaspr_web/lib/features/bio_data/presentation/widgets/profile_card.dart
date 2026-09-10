import 'package:jaspr/jaspr.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class ProfileCard extends StatelessComponent {
  const ProfileCard({super.key});

  @override
  Component build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: AssetsConst.featherUser,
          title: "Profile",
          color: ColorConst.lightBlue,
        ),
        CardShell(
          child: CustomText(
            'Skilled Flutter developer with 4+ years exp. Specialize in MVVM, BLOC, Provider, GetX. Proficient in Dart, UI/UX, Socket.IO, push notifications, deep linking, localization, location tracking, & payment integration (PhonePe, Paytm, etc.). Experienced with Agile methodology & CI/CD (Codemagic). Dedicated to excellence & innovation.',
            variant: TextVariant.body,
            color: ColorConst.secondaryDark,
          ),
        ),
      ],
    );
  }
}
