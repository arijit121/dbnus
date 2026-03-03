import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/constants/api_url_const.dart';
import 'package:dbnus/core/models/custom_notification_model.dart';
import 'package:dbnus/core/services/download_handler.dart';
import 'package:dbnus/core/services/notification_handler.dart';

import 'order_tool_tile.dart';

class NotificationsSection extends StatefulWidget {
  const NotificationsSection({super.key});

  @override
  State<NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<NotificationsSection> {
  int? notificationId;

  Widget _buildDivider() =>
      const Divider(height: 1, indent: 56, color: ColorConst.lineGrey);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          OrderToolTile(
            icon: FeatherIcons.download,
            title: "Download PDF",
            subtitle: "Download sample 1MB PDF file",
            color: ColorConst.lightBlue,
            onTap: () {
              DownloadHandler.download(
                  downloadUrl:
                      "https://file-examples.com/storage/fe6146b54768752f9a08cf7/2017/10/file-example_PDF_1MB.pdf");
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.bell,
            title: "Show Notification",
            subtitle: "Display a sample push notification",
            color: ColorConst.violate,
            onTap: () async {
              int? newId =
                  await NotificationHandler.showUpdateFlutterNotification(
                CustomNotificationModel(
                  title: "Silent Notification4",
                  message: "test",
                  bigText:
                      "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
                  imageUrl: ApiUrlConst.testImgUrl(),
                  sound: "slow_spring_board",
                ),
              );
              if (mounted) {
                setState(() {
                  notificationId = newId;
                });
              }
            },
          ),
          _buildDivider(),
          OrderToolTile(
            icon: FeatherIcons.refreshCw,
            title: "Update Notification",
            subtitle: "Update the last shown notification",
            color: const Color(0xFFE67E22),
            onTap: () {
              NotificationHandler.showUpdateFlutterNotification(
                CustomNotificationModel(
                  title: "Silent Notification update",
                  message: "test $notificationId",
                  bigText:
                      "<p>This is<sub> subscript</sub> and <sup>superscript</sup></p>",
                  imageUrl: ApiUrlConst.testImgUrl(),
                  sound: "slow_spring_board",
                ),
                notificationId: notificationId,
              );
            },
          ),
        ],
      ),
    );
  }
}
