/*
This file contains the definition of the NotificationService, its related logic 
and some particular methods to be used within the application. 

- Author: Iván Maldonado (Kikemaldonado11@gmail.com)
- Develop at: January 2025
*/


import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;


class NotificationService {

  // Main flutterNotificationPlugin instance
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void>  onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {}

  // Initialization
  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings  =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

  }


// Show instant notification

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
            "channel_Id",
            "channel_Name",
            importance: Importance.high,
            priority: Priority.high
        )
    );

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  //Show schedule notification

static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduleDate) async {
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
          "channel_Id",
          "channel_Name",
          importance: Importance.high,
          priority: Priority.high
      )
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(scheduleDate, tz.local),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
    androidScheduleMode: AndroidScheduleMode.inexact
  );

}

  // Cancel notification by its id

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

}