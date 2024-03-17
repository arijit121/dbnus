import 'package:flutter/material.dart';
import '../extension/spacing.dart';

Widget customStepper(
        {List<CustomStepperContent>? customStepperContent,
        ScrollPhysics? physics,
        bool shrinkWrap = false,
        Color activeLineColor = Colors.green,
        Color inActiveLineColor = Colors.grey}) =>
    ListView.separated(
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

class CustomStepperContent {
  CustomStepperContent(
      {required this.isActive, required this.content, required this.leading});

  bool isActive;
  Widget content;
  Widget leading;
}
