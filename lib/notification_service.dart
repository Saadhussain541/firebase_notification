import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService
{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async
  {
    NotificationSettings settings=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized)
      {
        print('user granted persmission');
      }
    else if(settings.authorizationStatus==AuthorizationStatus.provisional)
      {
        print('user granted provisional permission');

      }
    else
      {
        print('user denied permission');

      }
  }


  void initLocalNotification(BuildContext context,RemoteMessage message) async
  {
    var androidInitializationSettings=const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings=const DarwinInitializationSettings();

    var initializationSetting=InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload)
        {

        }
    );
  }

  // void firebaseInit()
  // {
  //   FirebaseMessaging.onMessage.listen((message){
  //     if (kDebugMode) {
  //       print(message.notification!.title.toString());
  //       print(message.notification!.body.toString());
  //     }
  //
  //     showNotification(message);
  //   });
  // }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {

      if (Platform.isAndroid) {
        print(message.data['id']);
        initLocalNotification(context, message);
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async
  {
    AndroidNotificationChannel channel=AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(),
        'Hign Importance Notification',
      importance: Importance.max
    );
    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
       channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );

    const DarwinNotificationDetails darwinNotificationDetails=DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );

    NotificationDetails notificationDetails=NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show( 0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void isTokenRefresh() async
  {
    messaging.onTokenRefresh.listen((event){
      event.toString();
      print('refresh');
    });
  }

  Future<String> getDeviceToken() async
  {
    String? token=await messaging.getToken();
    return token!;
  }


  void handleMessage(BuildContext context,RemoteMessage message)
  {

  }

}