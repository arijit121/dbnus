import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dbnus/extension/logger_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../data/model/custom_notification_model.dart';
import 'redirect_engine.dart';
import 'value_handler.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'dbnus_app', // id
    'dbnus_local_notification', // name
    description: 'dbnus app local notification', // description
    importance: Importance.high,
    ledColor: Colors.transparent);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
bool isFlutterLocalNotificationsInitialized = false;

String navigationActionId = 'id_3';
String darwinNotificationCategoryPlain = 'plainCategory';
String darwinNotificationCategoryText = 'textCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  AppLog.i(notificationResponse.payload, tag: "Payload");
}

class NotificationHandler {
  Future<void> initiateNotification() async {
    await setupFlutterNotifications();
    // await requestPermissions();
    _configureSelectNotificationSubject();
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_monochrome');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        selectNotificationStream.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      if (payload != null && payload.isNotEmpty) {
        RedirectEngine()
            .redirectRoutes(redirectUrl: Uri.parse(payload), delayedSeconds: 3);
      }
    });

    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      var payload = value?.notificationResponse?.payload;

      if (payload != null && payload.isNotEmpty) {
        RedirectEngine()
            .redirectRoutes(redirectUrl: Uri.parse(payload), delayedSeconds: 4);
      }
    });
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      } else if (Platform.isMacOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
    }
  }

  /// Return notification Id
  Future<int?> showUpdateFlutterNotification(
      CustomNotificationModel notificationModel,
      {int? notificationId}) async {
    if (Platform.isAndroid && notificationModel.title != null) {
      return await _showUpdateNotificationAndroid(notificationModel,
          notificationId: notificationId);
    } else if (Platform.isIOS && notificationModel.title != null) {
      return await _showUpdateNotificationIos(notificationModel,
          notificationId: notificationId);
    }
    return null;
  }

  /// Return notification Id
  Future<int> _showUpdateNotificationIos(
      CustomNotificationModel notificationModel,
      {int? notificationId}) async {
    int tempNotificationId = notificationId ?? getId();
    bool isNotificationActive = (notificationId != null) &&
        (await _isNotificationActive(notificationId));
    final String? bigPicturePath =
        ValueHandler().isTextNotEmptyOrNull(notificationModel.imageUrl)
            ? await _downloadAndSaveFile(
                notificationModel.imageUrl!, 'bigPicture.jpg')
            : null;

    final DarwinNotificationDetails darwinNotificationDetailsImage =
        DarwinNotificationDetails(
            subtitle:
                ValueHandler().isTextNotEmptyOrNull(notificationModel.bigText)
                    ? ValueHandler()
                        .parseHtmlToText(notificationModel.message ?? "")
                    : null,
            attachments: bigPicturePath != null
                ? <DarwinNotificationAttachment>[
                    DarwinNotificationAttachment(bigPicturePath,
                        hideThumbnail: false)
                  ]
                : null,
            sound: ValueHandler().isTextNotEmptyOrNull(notificationModel.sound)
                ? "${notificationModel.sound ?? ""}.aiff"
                : null,
            presentSound: !ValueHandler()
                    .isTextNotEmptyOrNull(notificationId) &&
                ValueHandler().isTextNotEmptyOrNull(notificationModel.sound),
            presentAlert: !isNotificationActive,
            presentBadge: !isNotificationActive);
    final NotificationDetails notificationDetailsImage = NotificationDetails(
      iOS: darwinNotificationDetailsImage,
    );

    await flutterLocalNotificationsPlugin.show(
        tempNotificationId,
        notificationModel.title ?? "",
        ValueHandler().parseHtmlToText(
            notificationModel.bigText ?? notificationModel.message ?? ""),
        notificationDetailsImage,
        payload: notificationModel.actionURL);
    return tempNotificationId;
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response =
        await http.get(Uri.parse(url)).timeout(const Duration(minutes: 5));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  int getId() {
    int max = 2147483647;
    int min = 1000;
    Random rnd = Random();
    int r = min + rnd.nextInt(max - min);
    return r;
  }

  /// Return notification Id
  Future<int> _showUpdateNotificationAndroid(
      CustomNotificationModel notificationModel,
      {int? notificationId}) async {
    int tempNotificationId = notificationId ?? getId();
    bool isNotificationActive = (notificationId != null) &&
        (await _isNotificationActive(notificationId));
    ByteArrayAndroidBitmap? bigPicture;
    if (ValueHandler().isTextNotEmptyOrNull(notificationModel.imageUrl)) {
      Uint8List? byte = await _getByteArrayFromUrl(notificationModel.imageUrl!);
      if (byte != null) {
        bigPicture = ByteArrayAndroidBitmap(byte);
      } else {
        bigPicture = null;
      }
    } else {
      bigPicture = null;
    }

    StyleInformation? styleInformation = bigPicture != null
        ? BigPictureStyleInformation(bigPicture,
            // largeIcon: largeIcon,
            contentTitle: notificationModel.title,
            summaryText:
                ValueHandler().isTextNotEmptyOrNull(notificationModel.bigText)
                    ? notificationModel.bigText
                    : notificationModel.message,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true,
            htmlFormatContent: true,
            htmlFormatTitle: true)
        : ValueHandler().isTextNotEmptyOrNull(notificationModel.bigText)
            ? BigTextStyleInformation(notificationModel.bigText ?? "",
                contentTitle: notificationModel.title,
                summaryText: notificationModel.message,
                htmlFormatTitle: true,
                htmlFormatBigText: true,
                htmlFormatContent: true,
                htmlFormatContentTitle: true,
                htmlFormatSummaryText: true)
            : null;

    AndroidNotificationChannel tempChannel = channel;
    if (ValueHandler().isTextNotEmptyOrNull(notificationModel.sound)) {
      AndroidNotificationChannel dynamicChannel = AndroidNotificationChannel(
        "${channel.id}_${notificationModel.sound}", // id
        channel.name, // name
        description: "${channel.description}_sound_${notificationModel.sound}",
        // description
        importance: Importance.high,
        ledColor: Colors.transparent,
        sound: RawResourceAndroidNotificationSound(notificationModel.sound!),
        playSound: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(dynamicChannel);
      tempChannel = dynamicChannel;
    }

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(tempChannel.id, tempChannel.name,
            channelDescription: tempChannel.description,
            styleInformation: styleInformation,
            playSound: !isNotificationActive &&
                ValueHandler().isTextNotEmptyOrNull(notificationModel.sound),
            sound: ValueHandler().isTextNotEmptyOrNull(notificationModel.sound)
                ? RawResourceAndroidNotificationSound(notificationModel.sound!)
                : null,
            importance: isNotificationActive ? Importance.low : Importance.high,
            priority: isNotificationActive ? Priority.low : Priority.high,
            silent: isNotificationActive);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        tempNotificationId,
        notificationModel.title ?? "",
        notificationModel.message ?? "",
        notificationDetails,
        payload: notificationModel.actionURL);
    return tempNotificationId;
  }

  Future<Uint8List?> _getByteArrayFromUrl(String url) async {
    try {
      final http.Response response =
          await http.get(Uri.parse(url)).timeout(const Duration(minutes: 5));
      return response.bodyBytes;
    } catch (e, stacktrace) {
      AppLog.e(e.toString(), error: e, stackTrace: stacktrace);
    }
    return null;
  }

  Future<bool> _isNotificationActive(int notificationId) async {
    final List<ActiveNotification> activeNotifications =
        await flutterLocalNotificationsPlugin.getActiveNotifications();

    return activeNotifications.any((n) => n.id == notificationId);
  }

  Future<bool> _isNotificationPending(int notificationId) async {
    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return pendingNotifications.any((n) => n.id == notificationId);
  }
}
