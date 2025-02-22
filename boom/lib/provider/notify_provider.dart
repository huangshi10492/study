import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notify_provider.g.dart';

@Riverpod(keepAlive: true)
class Notify extends _$Notify {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var _i = 0;
  @override
  void build() async {
    const androidInitializationSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSetting = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
        android: androidInitializationSetting, iOS: iosInitializationSetting);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
    showRun(
      '正在运行',
      '应用正在运行中...',
    );
    return;
  }

  void showRun(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails(
      '123456',
      '运行通知',
      category: AndroidNotificationCategory.service,
      ongoing: true,
    );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    _flutterLocalNotificationsPlugin.show(
        0, title, '$body\n次数:$_i', notificationDetails);
  }

  void updateRun() {
    _i++;
    showRun(
      '正在运行',
      '应用正在运行中...',
    );
  }
}
