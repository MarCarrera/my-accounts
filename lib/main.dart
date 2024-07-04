import 'package:acounts_control/firebase_options.dart';
import 'package:acounts_control/widgets/button_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'src/push_providers/push_notifications.dart';

//Backfround message
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await PushNotifications.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Suscrips
  await FirebaseMessaging.instance.subscribeToTopic('bitala');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Nuevo mensaje recibido');
    print('Contenido: ${message.data}');

    if (message.notification != null) {
      print('Mensaje contiene notificacion: ${message.notification?.title}');
      print('Mensaje contiene notificacion: ${message.notification?.body}');
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ButtonNav(
        indexColor: 0,
      ),
    );
  }
}
