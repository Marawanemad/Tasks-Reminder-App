import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taskreminder/modeles/tasks.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../Screens/NotificationScreen.dart';

class NotifyHelper {
  // make object from this class
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  // init function to call it when start app
  initializeNotification() async {
    tz.initializeTimeZones();
    await _configureLocalTimeZone();
    //Sttings for IOS apps
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      // to make permisions for new IOS versions
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    //Sttings for android apps
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');

// make initialize for notifications
    const InitializationSettings initializationSettings =
        InitializationSettings(
      // send android notification sttings for android apps
      android: initializationSettingsAndroid,
      // send IOS notification sttings for IOS apps
      iOS: initializationSettingsDarwin,
    );
    // take initializationSettings and wait to make it
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

// to make display notification
  DisplatNotification({required String title, required String body}) async {
    print('doing test');
    // make how to show notification in android
    var androidNotificationDetails =
        const AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            // properties of android displaying the notification
            importance: Importance.max,
            priority: Priority.high);
    // properties of IOS displaying the notification
    var iosNotificationDetails = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      // to choose the sound of notification
      payload: 'Default_Sound',
    );
  }

  scheduledNotification(int hour, int minutes, Tasks task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, String repeat, String date) {
    // to make the now time on local area
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print("now date $now");
    var formattedDate = DateFormat.yMd().parse(date);
    // to make the time on local area
    final tz.TZDateTime FD = tz.TZDateTime.from(formattedDate, tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, FD.year, FD.month, FD.day, hour, minutes);
    print("Scheduled Date $scheduledDate");

    if (scheduledDate.isBefore(now)) {
      // to increase day 1 to show notification every day
      if (repeat == 'Daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formattedDate.day) + 1, hour, minutes);
      }
      // to increase weak 1 to show notification every week in the same day
      if (repeat == 'Weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formattedDate.day) + 7, hour, minutes);
      }
      // to increase month 1 to show notification every month in the same day
      if (repeat == 'Monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year,
            (formattedDate.month) + 1, formattedDate.day, hour, minutes);
      }
    }
    scheduledDate = afterRemind(remind, scheduledDate);
    print("Next ScheduledDate = $scheduledDate");

    return scheduledDate;
  }

  tz.TZDateTime afterRemind(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Get.to(() => NotificationScreen(notificationMSG: payload!));
  }

  // to end notification when delete task
  cancelNotification(Tasks task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
    print("Notification Canceled correctly");
  }

  cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print("ALL Notification Canceled ");
  }
}
