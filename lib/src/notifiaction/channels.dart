
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  static const cO2warning = AndroidNotificationDetails(
      'Warning', 'Warning CO2', 'Warns when CO2 limits are exceeded.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false
  );
}
