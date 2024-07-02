//e7KCYiRqQgW1h2Cf7LAsyT:APA91bG2S6HgbjUhXBJ7xvqD0MADI715hFoX1rg7a3-IzfmPWzbQif8982F0-E6lfwPpQ_iU6A7ewSjKHyQ9stxqptCribArZC9O0NOZ7p5dv8kyF1QcJnJwao3QDlbr_zlNsHJtmCIT

import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PushNotifications {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = StreamController.broadcast();
//get estatico que retorna el messageStream
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    // print('Background Handler ${message.messageId}');

    //cuando se recibe una notificacion se añade al stream, en este caso el titulo
    print('Data recibida: ${message.data}');
    //_messageStream.add(message.notification?.body ?? 'Sin titulo');

    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['idUser'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage Handler ${message.messageId}');
    print('Data recibida: ${message.data}');
    //_messageStream.add(message.notification?.body ?? 'Sin titulo');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['idUser'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp Handler ${message.messageId}');
    print('Data recibida: ${message.data}');
    //_messageStream.add(message.notification?.body ?? 'Sin titulo');
    String argumento = 'no-data';
    if (Platform.isAndroid) {
      argumento = message.data['idUser'] ?? 'no-data';
    }
    _messageStream.add(argumento);
  }

  static Future initializeApp() async {
    //inicializar firebase
    await Firebase.initializeApp();
    // Pedir permisos para notificaciones
    await _requestPermissions();

    try {
        token = await FirebaseMessaging.instance.getToken();
        print('Token: $token');

        // Guardar el token en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('UserToken', token ?? '');
    } catch (e) {
        print('Error obteniendo el token: $e');
    }

//Handlers
//cuando la aplicacion esta en segundo plano pero no se ha destruido o cerrado
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    //cuando la aplicacion esta abierta
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    //cuando la app esta cerrada y se debe abrir
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permiso de notificaciones concedido');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Permiso de notificaciones provisional concedido');
    } else {
      print('Permiso de notificaciones denegado');
    }
  }

  static closeStreams() {
    _messageStream.close();
  }
}
