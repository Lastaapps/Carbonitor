
import 'package:carbonitor/src/notifiaction/channels.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    _init();
  }

  Future<void> warn() async {
    await _init();

    _showNotification("Warning!", "High concentration of CO2", "/",
        NotificationChannels.cO2warning);
  }

  Future<void> _init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    //TODO Handle notification tapped logic here
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> _showNotification(String title, String message, String route, AndroidNotificationDetails channel) async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: channel);
    await flutterLocalNotificationsPlugin.show(
        0, title, message, platformChannelSpecifics,
        payload: route);
  }
}
