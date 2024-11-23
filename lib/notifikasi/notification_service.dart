// lib/notifikasi/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      debugPrint('Initializing notifications service...');

      // Request permissions first
      final bool? permissionGranted = await _requestPermissions();
      debugPrint('Permission granted: $permissionGranted');

      if (permissionGranted != true) {
        debugPrint('Notification permissions not granted');
        return;
      }

      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      debugPrint('Timezone initialized');

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          debugPrint('Notification tapped: ${response.payload}');
        },
      );
      debugPrint('Notifications plugin initialized');

      // Schedule notifications
      await scheduleMultipleNotifications();

      // Show immediate test notification
      await showInstantNotification(
          'Notifikasi Aktif', 'Pengingat Al-Quran telah diatur');
    } catch (e, stackTrace) {
      debugPrint('Error initializing notifications: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<bool?> _requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            notificationsPlugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation == null) {
          debugPrint('Failed to get Android implementation');
          return false;
        }

        final bool? granted =
            await androidImplementation.requestNotificationsPermission();
        debugPrint('Android notification permission granted: $granted');
        return granted;
      } else if (Platform.isIOS) {
        final bool? result = await notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
        debugPrint('iOS notification permission granted: $result');
        return result;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  Future<void> scheduleMultipleNotifications() async {
    try {
      debugPrint('Cancelling existing notifications...');
      await notificationsPlugin.cancelAll();

      final List<Map<String, dynamic>> notificationSchedules = [
        {
          'hour': 5,
          'minute': 0,
          'title': 'Waktu Subuh',
          'message': 'Saatnya membaca Al-Quran di waktu yang berkah'
        },
        {
          'hour': 12,
          'minute': 0,
          'title': 'Waktu Dzuhur',
          'message': 'Luangkan waktu untuk membaca Al-Quran'
        },
        {
          'hour': 15,
          'minute': 0,
          'title': 'Waktu Ashar',
          'message': 'Jangan lupa membaca Al-Quran hari ini'
        },
        {
          'hour': 18,
          'minute': 0,
          'title': 'Waktu Maghrib',
          'message': 'Mari membaca Al-Quran setelah sholat Maghrib'
        },
        {
          'hour': 19,
          'minute': 0,
          'title': 'Waktu Isya',
          'message': 'Sempurnakan hari ini dengan membaca Al-Quran'
        }
      ];

      debugPrint('Scheduling ${notificationSchedules.length} notifications...');

      int id = 0;
      for (var schedule in notificationSchedules) {
        await scheduleNotification(
          id++,
          schedule['hour'],
          schedule['minute'],
          schedule['title'],
          schedule['message'],
        );
      }

      // Check pending notifications
      final List<PendingNotificationRequest> pendingNotifications =
          await notificationsPlugin.pendingNotificationRequests();
      debugPrint('Pending notifications: ${pendingNotifications.length}');
      for (var notification in pendingNotifications) {
        debugPrint(
            'Scheduled: ID ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      debugPrint('Error scheduling multiple notifications: $e');
    }
  }

  Future<void> scheduleNotification(
    int id,
    int hour,
    int minute,
    String title,
    String message,
  ) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'quran_app_channel_$id',
        'Quran App Notifications',
        channelDescription: 'Daily Quran reading reminders',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        styleInformation: BigTextStyleInformation(message),
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      debugPrint('Scheduling notification ID $id for: $scheduledDate');

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        message,
        scheduledDate,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Successfully scheduled notification ID $id');
    } catch (e) {
      debugPrint('Error scheduling notification ID $id: $e');
    }
  }

  Future<void> showInstantNotification(String title, String message) async {
    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Notifications for immediate display',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(message),
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await notificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        message,
        platformDetails,
      );

      debugPrint('Instant notification sent successfully');
    } catch (e) {
      debugPrint('Error showing instant notification: $e');
    }
  }
}
