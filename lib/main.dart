import 'dart:math';

import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'app/app.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//

// final MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings();;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          onDidReceiveLocalNotification: ((int id, String? title, String? body,
              String? payload) async {}));

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: ((String? payload) async {
    if (payload != null) {
      debugPrint('Notifitcation Payloa' + payload);
    }
  }));
  runApp(MyApp());
}
