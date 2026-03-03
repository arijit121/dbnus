import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import 'package:dbnus/core/services/open_service.dart';
import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/ui/atoms/text/custom_text.dart';

import 'card_shell.dart';
import 'section_title.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: FeatherIcons.phone,
          title: "Contact",
          color: ColorConst.deepGreen,
        ),
        CardShell(
          child: Column(
            children: [
              _contactTile(
                FeatherIcons.mapPin,
                'Kolkata, India',
                ColorConst.violate,
                null,
              ),
              _divider(),
              _contactTile(
                FeatherIcons.phone,
                '+91 89189 51655',
                ColorConst.deepGreen,
                () {
                  OpenService.openUrl(uri: Uri.parse('tel:+918918951655'));
                },
              ),
              _divider(),
              _contactTile(
                FeatherIcons.mail,
                'ruarijitsarkar@gmail.com',
                ColorConst.red,
                () {
                  OpenService.openUrl(
                    uri: Uri.parse('mailto:ruarijitsarkar@gmail.com'),
                  );
                },
              ),
              _divider(),
              _contactTile(
                FeatherIcons.linkedin,
                'linkedin.com/in/arijit-sarkar-...',
                ColorConst.lightBlue,
                () {
                  OpenService.openUrl(
                    uri: Uri.parse(
                      'https://www.linkedin.com/in/arijit-sarkar-53b822184/',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _contactTile(
    IconData icon,
    String text,
    Color color,
    VoidCallback? onTap,
  ) {
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
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: tile,
      );
    }
    return tile;
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 0, color: ColorConst.lineGrey);
}
