import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

import 'card_shell.dart';
import 'section_title.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: FeatherIcons.user,
          title: "Profile",
          color: ColorConst.lightBlue,
        ),
        CardShell(
          child: const CustomText(
            'Skilled Flutter developer with 4+ years exp. Specialize in MVVM, BLOC, Provider, GetX. Proficient in Dart, UI/UX, Socket.IO, push notifications, deep linking, localization, location tracking, & payment integration (PhonePe, Paytm, etc.). Experienced with Agile methodology & CI/CD (Codemagic). Dedicated to excellence & innovation.',
            size: 14,
            color: ColorConst.secondaryDark,
          ),
        ),
      ],
    );
  }
}
