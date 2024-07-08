import 'package:acounts_control/firebase_options.dart';
import 'package:acounts_control/widgets/button_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'src/push_providers/push_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Mensaje en Segundo Plano: ${message.messageId}');
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotifications.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp(
    indexColor: 0,
  ));
}
class MyApp extends StatefulWidget {
  final int indexColor;
  const MyApp({super.key, required this.indexColor});
  @override
  State<MyApp> createState() => _MyAppState(indexColor: indexColor);
}
class _MyAppState extends State<MyApp> {
  late int indexColor;
  _MyAppState({required this.indexColor});
  @override
  void initState() {
    super.initState();
    //obtener token
    /* FirebaseMessaging.instance.getToken().then((String? token) {
      assert(token != null);
      print("FCM Token: $token");
    });*/

    /* FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje en aplicacion abierta: ${message.messageId}');
      if (message.notification != null) {
        print(
            'Notification: ${message.notification!.title}, ${message.notification!.body}');
      }
    });*/

    /*FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensaje en aplicacion cerrada');
      if (message.notification != null) {
        print(
            'Notification: ${message.notification!.title}, ${message.notification!.body}');
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ButtonNav(
        indexColor: 0,
      ),
    );
  }
}
