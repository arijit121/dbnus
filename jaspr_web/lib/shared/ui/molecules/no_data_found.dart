import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/assects_const.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class NoDataFound extends StatelessComponent {
  final double width;
  final double height;
  final Color? backgroundColor;
  final String? msg;
  final String? className;

  const NoDataFound({
    this.height = 300,
    this.width = 300,
    this.backgroundColor,
    this.msg,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      className: className,
      width: width,
      height: height,
      style: Styles(raw: {
        if (backgroundColor != null) 'background-color': backgroundColor!.value,
        'display': 'flex',
        'flex-direction': 'column',
        'align-items': 'center',
        'justify-content': 'center',
        'text-align': 'center',
        'padding': '20px',
        'box-sizing': 'border-box',
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAssetImageView(
            path: AssetsConst.noRecordFound,
            width: width * 0.7,
            height: height * 0.5,
          ),
          const SizedBox(height: 16),
          const CustomText(
            "No record found",
            color: ColorConst.lightBlue,
            variant: TextVariant.h2,
            fontWeight: FontWeight.w600,
          ),
          if (msg != null && msg!.isNotEmpty) ...[
            const SizedBox(height: 8),
            CustomText(
              msg!,
              color: ColorConst.secondaryDark,
              variant: TextVariant.body,
            ),
          ],
        ],
      ),
    );
  }
}
