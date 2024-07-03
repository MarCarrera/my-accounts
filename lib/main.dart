import 'package:acounts_control/firebase_options.dart';
import 'package:acounts_control/widgets/button_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/push_providers/push_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotifications.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
