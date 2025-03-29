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
    'dbnus_fcm', // name
    description: 'dbnus app fcm notification', // description
    importance: Importance.high,
    ledColor: Colors.white);
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
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

  Future<void> showFlutterNotification(
      CustomNotificationModel fcmNotificationModel) async {
    if (Platform.isAndroid && fcmNotificationModel.title != null) {
      _showNotificationAndroid(fcmNotificationModel);
    } else if (Platform.isIOS && fcmNotificationModel.title != null) {
      _showNotificationIos(fcmNotificationModel);
    }
  }

  Future<void> _showNotificationIos(
      CustomNotificationModel fcmNotificationModel) async {
    final String? bigPicturePath =
        ValueHandler().isTextNotEmptyOrNull(fcmNotificationModel.imageUrl)
            ? await _downloadAndSaveFile(
                fcmNotificationModel.imageUrl!, 'bigPicture.jpg')
            : null;

    final DarwinNotificationDetails darwinNotificationDetailsImage =
        DarwinNotificationDetails(
            subtitle: ValueHandler()
                    .isTextNotEmptyOrNull(fcmNotificationModel.bigText)
                ? ValueHandler()
                    .parseHtmlToText(fcmNotificationModel.message ?? "")
                : null,
            attachments: bigPicturePath != null
                ? <DarwinNotificationAttachment>[
                    DarwinNotificationAttachment(bigPicturePath,
                        hideThumbnail: false)
                  ]
                : null,
            sound:
                ValueHandler().isTextNotEmptyOrNull(fcmNotificationModel.sound)
                    ? "${fcmNotificationModel.sound ?? ""}.aiff"
                    : null,
            presentSound: ValueHandler()
                .isTextNotEmptyOrNull(fcmNotificationModel.sound));
    final NotificationDetails notificationDetailsImage = NotificationDetails(
      iOS: darwinNotificationDetailsImage,
    );

    await flutterLocalNotificationsPlugin.show(
        getId(),
        fcmNotificationModel.title ?? "",
        ValueHandler().parseHtmlToText(
            fcmNotificationModel.bigText ?? fcmNotificationModel.message ?? ""),
        notificationDetailsImage,
        payload: fcmNotificationModel.actionURL);
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
    int max = 5000;
    int min = 1000;
    Random rnd = Random();
    int r = min + rnd.nextInt(max - min);
    return r;
  }

  Future<void> _showNotificationAndroid(
      CustomNotificationModel fcmNotificationModel) async {
    ByteArrayAndroidBitmap? bigPicture;
    if (ValueHandler().isTextNotEmptyOrNull(fcmNotificationModel.imageUrl)) {
      Uint8List? byte =
          await _getByteArrayFromUrl(fcmNotificationModel.imageUrl!);
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
            contentTitle: fcmNotificationModel.title,
            summaryText: ValueHandler()
                    .isTextNotEmptyOrNull(fcmNotificationModel.bigText)
                ? fcmNotificationModel.bigText
                : fcmNotificationModel.message,
            htmlFormatContentTitle: true,
            htmlFormatSummaryText: true,
            htmlFormatContent: true,
            htmlFormatTitle: true)
        : ValueHandler().isTextNotEmptyOrNull(fcmNotificationModel.bigText)
            ? BigTextStyleInformation(fcmNotificationModel.bigText ?? "",
                contentTitle: fcmNotificationModel.title,
                summaryText: fcmNotificationModel.message,
                htmlFormatTitle: true,
                htmlFormatBigText: true,
                htmlFormatContent: true,
                htmlFormatContentTitle: true,
                htmlFormatSummaryText: true)
            : null;

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            styleInformation: styleInformation,
            playSound:
                ValueHandler().isTextNotEmptyOrNull(fcmNotificationModel.sound),
            sound:
                ValueHandler().isTextNotEmptyOrNull(fcmNotificationModel.sound)
                    ? RawResourceAndroidNotificationSound(
                        fcmNotificationModel.sound!)
                    : null);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        getId(),
        fcmNotificationModel.title ?? "",
        fcmNotificationModel.message ?? "",
        notificationDetails,
        payload: fcmNotificationModel.actionURL);
  }

  Future<void> showProgressNotification(
      {required int progress,
      required int progressId,
      required String imagePath}) async {
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('progress channel', 'progress channel',
              channelDescription: 'progress channel description',
              channelShowBadge: false,
              importance: Importance.max,
              priority: Priority.high,
              onlyAlertOnce: true,
              showProgress: true,
              maxProgress: 100,
              progress: progress);

      final DarwinNotificationDetails darwinNotificationDetails =
          DarwinNotificationDetails(attachments: <DarwinNotificationAttachment>[
        DarwinNotificationAttachment(imagePath, hideThumbnail: false)
      ]);
      final NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails, iOS: darwinNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          progressId, 'Downloading .... ', '', notificationDetails,
          payload: 'item x');
    });
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
}
