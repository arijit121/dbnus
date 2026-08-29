import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../../core/models/custom_file.dart';
import '../../constants/assects_const.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class FileView extends StatelessComponent {
  final CustomFile file;
  final double? height;
  final double? width;
  final void Function()? onDelete;
  final String? className;

  const FileView({
    required this.file,
    this.height = 80,
    this.width = 80,
    this.onDelete,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final isPdf = file.name?.toLowerCase().contains('.pdf') == true;

    return Container(
      className: className,
      width: width,
      height: height,
      style: Styles(raw: {
        'border': '1px solid ${ColorConst.lightGrey.value}',
        'border-radius': '8px',
        'position': 'relative',
        'overflow': 'hidden',
        'display': 'flex',
        'flex-direction': 'column',
        'align-items': 'center',
        'justify-content': 'center',
        'background-color': '#FFFFFF',
        'box-sizing': 'border-box',
      }),
      child: Stack(
        children: [
          if (isPdf)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomSvgAssetImageView(
                  path: AssetsConst.featherFileText,
                  width: 32,
                  height: 32,
                  color: ColorConst.red,
                ),
                const SizedBox(height: 4),
                CustomText(
                  file.name ?? 'PDF Document',
                  variant: TextVariant.caption,
                  color: ColorConst.primaryDark,
                ),
              ],
            )
          else if (file.path != null)
            CustomNetWorkImageView(
              url: file.path!,
              width: width,
              height: height,
              fit: BoxFit.cover,
            )
          else
            const CustomSvgAssetImageView(
              path: AssetsConst.featherFile,
              width: 32,
              height: 32,
              color: ColorConst.grey,
            ),
          if (onDelete != null)
            Positioned(
              right: 4,
              top: 4,
              child: CustomIconButton(
                icon: const CustomSvgAssetImageView(
                  path: AssetsConst.featherTrash2,
                  width: 14,
                  height: 14,
                  color: ColorConst.red,
                ),
                iconSize: 14,
                onPressed: onDelete,
              ),
            ),
        ],
      ),
    );
  }
}
