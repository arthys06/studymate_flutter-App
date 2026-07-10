import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

/// Wraps flutter_local_notifications so reminders actually pop up a
/// notification at the chosen time, even if the app is in the background.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);

    // Android 13+ requires runtime notification permission.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required DateTime dateTime,
  }) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'studymate_reminders',
      'StudyMate Reminders',
      channelDescription: 'Assignment, exam, water, and other reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    final scheduledTz = tz.TZDateTime.from(dateTime, tz.local);

    await _plugin.zonedSchedule(
      id,
      'StudyMate Reminder',
      title,
      scheduledTz,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }
}
