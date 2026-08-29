import 'package:jaspr/dom.dart' hide BorderRadius;
import 'package:jaspr/jaspr.dart';
import '../../../../core/services/open_service.dart';
import '../../../../shared/constants/assects_const.dart';
import '../../../../shared/constants/color_const.dart';
import '../../../../shared/ui/ui.dart';
import 'card_shell.dart';
import 'section_title.dart';

class ContactCard extends StatelessComponent {
  const ContactCard({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          icon: AssetsConst.featherPhone,
          title: "Contact",
          color: ColorConst.deepGreen,
        ),
        CardShell(
          child: Column(
            children: [
              _contactTile(
                AssetsConst.featherMapPin,
                'Kolkata, India',
                ColorConst.violate,
                null,
              ),
              const CustomDivider(),
              _contactTile(
                AssetsConst.featherPhone,
                '+91 89189 51655',
                ColorConst.deepGreen,
                () => OpenService.callNumber(contactNo: '+918918951655'),
              ),
              const CustomDivider(),
              _contactTile(
                AssetsConst.featherMail,
                'ruarijitsarkar@gmail.com',
                ColorConst.red,
                () => OpenService.sendEmail(toEmail: 'ruarijitsarkar@gmail.com'),
              ),
              const CustomDivider(),
              _contactTile(
                AssetsConst.featherLinkedin,
                'linkedin.com/in/arijit-sarkar-53b822184',
                ColorConst.lightBlue,
                () => OpenService.openUrl(
                  uri: Uri.parse(
                    'https://www.linkedin.com/in/arijit-sarkar-53b822184/',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Component _contactTile(
    String icon,
    String text,
    Color color,
    VoidCallback? onTap,
  ) {
    return div(
      events: onTap != null ? {'click': (e) => onTap()} : {},
      styles: Styles(raw: {
        'padding': '10px 0',
        'display': 'flex',
        'align-items': 'center',
        'width': '100%',
        'box-sizing': 'border-box',
        if (onTap != null) 'cursor': 'pointer',
      }),
      [
        Row(
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
              child: CustomSvgAssetImageView(path: icon, width: 16, height: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                text,
                variant: TextVariant.body,
                fontWeight: FontWeight.w500,
                color: ColorConst.primaryDark,
              ),
            ),
            if (onTap != null)
              const CustomSvgAssetImageView(
                path: AssetsConst.featherChevronRight,
                width: 16,
                height: 16,
                color: ColorConst.grey,
              ),
          ],
        ),
      ],
    );
  }
}
