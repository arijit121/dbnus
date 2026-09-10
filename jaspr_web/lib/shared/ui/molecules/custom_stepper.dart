import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import '../../constants/color_const.dart';
import '../ui.dart';

class CustomStepperContent {
  final bool isActive;
  final Component content;
  final Component leading;

  const CustomStepperContent({
    required this.isActive,
    required this.content,
    required this.leading,
  });
}

class CustomVerticalStepper extends StatelessComponent {
  final List<CustomStepperContent> customStepperContent;
  final Color activeLineColor;
  final Color inActiveLineColor;
  final String? className;

  const CustomVerticalStepper({
    required this.customStepperContent,
    this.activeLineColor = ColorConst.green,
    this.inActiveLineColor = ColorConst.grey,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Column(
      className: className,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(customStepperContent.length, (index) {
        final content = customStepperContent[index];
        final isLast = index == customStepperContent.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                content.leading,
                if (!isLast)
                  Container(
                    width: 2,
                    height: 36,
                    style: Styles(raw: {
                      'background-color': content.isActive
                          ? activeLineColor.value
                          : inActiveLineColor.value,
                    }),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(child: content.content),
          ],
        );
      }),
    );
  }
}

class CustomHorizontalStepper extends StatelessComponent {
  final List<CustomStepperContent> customStepperContent;
  final double lineWidth;
  final Color activeLineColor;
  final Color inActiveLineColor;
  final String? className;

  const CustomHorizontalStepper({
    required this.customStepperContent,
    this.lineWidth = 40,
    this.activeLineColor = ColorConst.green,
    this.inActiveLineColor = ColorConst.grey,
    this.className,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return Row(
      className: className,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(customStepperContent.length, (index) {
        final content = customStepperContent[index];
        final isLast = index == customStepperContent.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                content.leading,
                const SizedBox(height: 4),
                content.content,
              ],
            ),
            if (!isLast)
              Container(
                width: lineWidth,
                height: 2,
                style: Styles(raw: {
                  'background-color': content.isActive
                      ? activeLineColor.value
                      : inActiveLineColor.value,
                }),
              ),
          ],
        );
      }),
    );
  }
}
