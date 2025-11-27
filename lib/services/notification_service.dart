import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationService {
static final _local = FlutterLocalNotificationsPlugin();


static Future<void> init() async {
const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
await _local.initialize(initializationSettings);


// Foreground messages (FCM)
FirebaseMessaging.onMessage.listen((message) {
final title = message.notification?.title ?? 'Order Update';
final body = message.notification?.body ?? '';
showNotification(title, body);
});
}


static Future<void> showNotification(String title, String body) async {
const android = AndroidNotificationDetails('default', 'Default', importance: Importance.max, priority: Priority.high);
const platform = NotificationDetails(android: android);
await _local.show(DateTime.now().microsecond, title, body, platform);
}
}