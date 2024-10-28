import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prestige_vender/view/drawers/notificationScreen.dart';



class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // request permission notification .........
  void requestPermissionNotification(context) async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
        announcement: true,
        carPlay: true,
        alert: true,
        badge: true,
        sound: true,
        criticalAlert: true,
        provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("user granted the Notification permission");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("user granted the Notification provisional permission");
      }
    } else {
      AppSettings.openAppSettings();
      if (kDebugMode) {
        print("denied the Notification permission");
      }
    }
  }

  // initialized local notification
  void initializeLocalNotificationApp(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings =InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        if (kDebugMode) {
          print("navigate");
        }
    const NotificationScreen().launch(context);

        // handleMessage(context, message);
      },
    );
  }

  // init firebase for displaying notification
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("title ${message.notification!.title.toString()}");
        print("body ${message.notification!.body.toString()}");       
      }
      if (Platform.isAndroid) {
        // initializeLocalNotificationApp(context, message);
        // showNotification(message);
      }
      showNotification(message);
    });
  }

  // show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "high importance notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      icon: "@mipmap/ic_launcher",
      channelDescription: "my description",
      priority: Priority.high,
      importance: Importance.high,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  // for getting devoice token
  Future<String> getToken(context) async {
    String? token = await firebaseMessaging.getToken();
    return token!;
  }

  // for refreshing the token
  void isTokenRefresh() async {
    firebaseMessaging.onTokenRefresh.listen((event) {
      if (kDebugMode) {
        print(event.toString());
      }
    });
  }

  // when application is in background or  terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is in terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
    const NotificationScreen().launch(context);
      handleMessage(context, event);
      
    });
  }

 // for handling the message
  handleMessage(BuildContext context, RemoteMessage message) async {
    // if (message.data['type'] == 'msg') {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => ),
    //   );
    // }
  }
}


