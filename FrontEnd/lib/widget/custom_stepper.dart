import 'package:flutter/material.dart';

import '../const/color_const.dart';
import '../extension/spacing.dart';

class CustomVerticalStepper extends StatelessWidget {
  final List<CustomStepperContent>? customStepperContent;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Color activeLineColor;
  final Color inActiveLineColor;

  const CustomVerticalStepper({
    super.key,
    this.customStepperContent,
    this.physics,
    this.shrinkWrap = false,
    this.activeLineColor = ColorConst.green,
    this.inActiveLineColor = ColorConst.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: physics,
        shrinkWrap: shrinkWrap,
        itemBuilder: (context, index) {
          CustomStepperContent? content =
              customStepperContent?.elementAt(index);
          return ListTile(
            title: content?.content,
            leading: Column(
              children: [
                Expanded(
                  child: Container(
                      width: 2,
                      color: index == 0
                          ? Colors.transparent
                          : customStepperContent
                                      ?.elementAt(index - 1)
                                      .isActive ==
                                  true
                              ? activeLineColor
                              : inActiveLineColor),
                ),
                if (content?.leading != null) content!.leading,
                Expanded(
                  child: Container(
                      width: 2,
                      color: (index + 1) == customStepperContent?.length
                          ? Colors.transparent
                          : content?.isActive == true
                              ? activeLineColor
                              : inActiveLineColor),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return 0.ph;
        },
        itemCount: customStepperContent?.length ?? 0);
  }
}

class CustomHorizontalStepper extends StatelessWidget {
  final List<CustomStepperContent>? customStepperContent;
  final double? lineHeight, lineWidth;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Color activeLineColor;
  final Color inActiveLineColor;

  const CustomHorizontalStepper({
    super.key,
    this.customStepperContent,
    this.physics,
    this.lineHeight,
    this.lineWidth = 30,
    this.shrinkWrap = false,
    this.activeLineColor = ColorConst.green,
    this.inActiveLineColor = ColorConst.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: physics,
        shrinkWrap: shrinkWrap,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          CustomStepperContent? content =
              customStepperContent?.elementAt(index);
          return Column(
            children: [
              Row(
                children: [
                  Container(
                      width: (lineWidth ?? 0.1) / 2,
                      height: lineHeight ?? 2,
                      color: index == 0
                          ? Colors.transparent
                          : content?.isActive == true
                              ? activeLineColor
                              : inActiveLineColor),
                  if (content?.leading != null) content!.leading,
                  Container(
                      width: (lineWidth ?? 0.1) / 2,
                      height: lineHeight ?? 2,
                      color: (index + 1) == customStepperContent?.length
                          ? Colors.transparent
                          : content?.isActive == true
                              ? activeLineColor
                              : inActiveLineColor)
                ],
              ),
              if (content?.content != null)
                SizedBox(
                    width: (lineWidth ?? 0),
                    child: Center(child: content!.content)),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return 0.pw;
        },
        itemCount: customStepperContent?.length ?? 0);
  }
}

class CustomStepperContent {
  CustomStepperContent(
      {required this.isActive, required this.content, required this.leading});

  bool isActive;
  Widget content;
  Widget leading;
}
