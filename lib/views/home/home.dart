import 'dart:io';

import 'package:acounts_control/utils/dialogs_pack.dart';
import 'package:acounts_control/utils/prueba.dart';
import 'package:acounts_control/widgets/add_payment.dart';
import 'package:acounts_control/widgets/loading_dots.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:expandable_menu/expandable_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/view_model.dart';
import '../../data/request/request.dart';
import '../../data/request/service.dart';
import '../../src/push_providers/push_notifications.dart';
import '../../utils/add_user.dart';
import '../../utils/constans.dart';
import '../../utils/buttom_nav.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ffi';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/edit_pin.dart';
import '../../utils/events.dart';
import '../../utils/shared_data_profile.dart';
import '../../utils/showConfirm.dart';
import '../../widgets/info_card.dart';
import 'package:flutter/material.dart'; // Importa para utilizar TimeOfDay

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalAuthentication auth = LocalAuthentication();

  //local notifications
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;
  final List<String> _notifications =
      []; // Lista para almacenar las notificaciones

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //canal de notificaciones
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null &&
        android != null &&
        (Platform.isAndroid || Platform.isIOS)) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO Personalizar para no utilizar el por defecto
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  //----------------

  int calcularDiasRestantes(String fecha) {
    // Convertir la cadena de fecha a un objeto DateTime
    DateTime fechaPago = DateTime.parse(fecha);
    // Fecha actual
    DateTime fechaActual = DateTime.now();

    // Calcular la diferencia en días
    Duration diferencia = fechaPago.difference(fechaActual);
    int restantes = diferencia.inDays;
    int diasRestantes = restantes;

    return diasRestantes;
  }

// Función para programar el envío de notificación a una hora específica
  void programarEnvioNotificacion() {
    // Hora específica para enviar la notificación (ejemplo: 8:00 AM)
    TimeOfDay notificacionTime = TimeOfDay(hour: 21, minute: 20);

    // Calcular la diferencia en segundos hasta la hora específica
    DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(now.year, now.month, now.day,
        notificacionTime.hour, notificacionTime.minute);
    if (scheduledDate.isBefore(now) || scheduledDate.isAtSameMomentAs(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    int secondsUntilNotification = scheduledDate.difference(now).inSeconds;

    // Programar la notificación utilizando un temporizador
    Timer(Duration(seconds: secondsUntilNotification), () {
      // Aquí puedes colocar la lógica para enviar la notificación
      enviarNotificacion(
        topic: 'tema1',
        title: '¡Próxima Mensualidad!',
        body: 'Se espera un nuevo pago hoy...',
        fecha: 'Fecha de pago',
      );
    });
  }

  //--------------------------------------------------------------------

  final textController = BoardDateTimeTextController();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  String _authorized = 'No autenticado';
  bool showData = false;
  //INSTANCIAS DE MODELOS DE CLASES

  //importacion de perfiles cargados
  TextEditingController pagoC = TextEditingController();
  TextEditingController pinC = TextEditingController();
  TextEditingController userC = TextEditingController();
  TextEditingController amoutnC = TextEditingController();
  TextEditingController paymentC = TextEditingController();
  TextEditingController genreC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  final ctlScreen = ScreenshotController();

  final HomeService homeService = HomeService();
  late Future<List<Profile>> futureProfiles;
  late Future<List<Account>> futureAccounts;
  late Future<List<ProxPagos>> proxPagos;

  bool noData = false;
  bool noDataUser = false;
  bool reload = false;
  int indexAct = 1;
  int index = 0;

  String formattedDate = '';
  String formattedDate2 = '';

  String obtenerSaludo() {
    DateTime ahora = DateTime.now();
    int hora = ahora.hour;

    if (hora >= 5 && hora < 12) {
      return 'Buenos días';
    } else if (hora >= 12 && hora < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  static Future<String?> getTokenFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserToken');
  }

  Future<void> _reloadData() async {
    setState(() {
      futureAccounts = homeService.cargarCuentas();
      futureProfiles = homeService
          .cargarPerfiles(); // Reemplaza 'indexA' con el valor adecuado
    });
  }

  //------DIALOGOS------------------------------------------------------
  Future<void> _editPin(String idUser) async {
    showEditDialog(
      context: context,
      title: 'Editar Pin',
      controller: pinC,
      keyboardType: TextInputType.number,
      idUser: idUser,
    );
  }

  Future<void> _addUser(String idUser) async {
    showAddDialog(
      context: context,
      title: 'Agregar usuario',
      idUser: idUser,
      userC: userC,
      amountC: amoutnC,
      phoneC: phoneC,
      paymentC: paymentC,
      genreC: genreC,
    );
  }

  Future<void> shareMessageUser(String phone) async {
    //final directory = await getApplicationDocumentsDirectory();
    //final image = File('${directory.path}/acceso.png');
    //final phoneNumber = '+52$phone';
    //const phoneNumber = '+522361082838';
    //image.writeAsBytesSync(bytes);

    // Mensaje que contiene la imagen
    String message =
        '${obtenerSaludo()}, sólo para recordarle del pago de la mensualidad de Netflix, porfavor :) ...';

    // Combinar el mensaje y la imagen
    //String combinedMessage = '$message ${image.path}';
    // URL de WhatsApp con el número de teléfono y mensaje
    String whatsappUrl = 'https://wa.me/$phone?text=${Uri.encodeFull(message)}';

    // Abrir el enlace en WhatsApp
    await launch(whatsappUrl);

    //await Share.shareFiles([image.path]);
  }
  //--------------------------------------------------------------------

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Escanee su huella dactilar o patrón para autenticarse.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        print('Error: ${e.toString()}');
      });
      return;
    }
    if (!mounted) return;
    setState(() {
      _authorized = authenticated ? 'Autenticado' : 'No Autenticado';
    });
    if (_authorized == 'Autenticado') {
      print('Se ha pulsado autenticar');
      showData = true;
    }
  }

  @override
  void initState() {
    super.initState();
    futureAccounts = homeService.cargarCuentas();
    futureProfiles = homeService.cargarPerfiles();
    proxPagos = homeService.cargarProxPagos();
    //notifications
    setupFlutterNotifications().then((value) {
      FirebaseMessaging.onMessage.listen(showFlutterNotification);
    });
    PushNotifications.messagesStream.listen((data) {
      setState(() {
        _notifications.add(data); // Agregar la notificación a la lista
      });
      //navigatorKey.currentState?.pushNamed('addPay', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            title1(),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: card()),
            title('Próximos Pagos'),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: cardProxPagos()),
            title('Usuarios'),
            //tab navegador
            buttomNav(),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
                scrollDirection: Axis.vertical, child: cardUser()),
          ],
        ),
      ),
    );
  }

  Widget buttomNav() {
    return ButtomNav(
      initialIndex: 0,
      containerHeight: 50,
      containerWight: 420,
      containerColor: TColor.blueColor,
      onSelect: (index) {
        indexAct = index + 1;
        homeService.cargarPerfiles();
        //print('index calculado: $indexAct');
        setState(() {
          LoadingDots();
        });
        Timer(Duration(seconds: 1), () {
          homeService.cargarPerfiles();
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.3),
          child: Text(
            'Cuenta A',
            style: GoogleFonts.fredoka(fontSize: 19, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.3),
          child: Text(
            'Cuenta B',
            style: GoogleFonts.fredoka(fontSize: 19, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.3),
          child: Text(
            'Cuenta C',
            style: GoogleFonts.fredoka(fontSize: 19, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Padding title1() {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 15, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cuentas',
            style: GoogleFonts.fredoka(
                fontSize: 34, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_authorized != 'Autenticado') {
                    _authenticate();
                  } else {
                    setState(() {
                      _authorized = 'No autenticado';
                    });
                  }
                },
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  size: 32,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _reloadData();
                    homeService.cargarCuentas();
                    homeService.cargarPerfiles();
                  });
                },
                child: const Icon(
                  Icons.change_circle_outlined,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Padding title(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.fredoka(
                fontSize: 34, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Padding cardUser() {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: Center(
        child: FutureBuilder<List<Profile>>(
          future: futureProfiles,
          builder:
              (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingDots();
            } else if (snapshot.hasError) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Stack(
                  children: [
                    //Contenedor para mantener la sobra de card
                    Container(
                      height: 170,
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    //Contenedor para mantener la sobra de card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 170,
                        width: 500,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(
                            color: Colors.black, // Color del borde
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Error al cargar datos',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 26, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Circles(),
                          Positioned(
                            bottom: 24,
                            left: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  child: Image.asset('assets/icons/info.png'),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Stack(
                  children: [
                    //Contenedor para mantener la sobra de card
                    Container(
                      height: 170,
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    //Contenedor para mantener la sobra de card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 170,
                        width: 500,
                        decoration: BoxDecoration(
                          color: TColor.purpleColor,
                          border: Border.all(
                            color: Colors.black, // Color del borde
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No hay datos \npara mostrar',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 26, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Circles(),
                          Positioned(
                            bottom: 24,
                            left: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 140,
                                  child: Image.asset('assets/icons/info.png'),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              );
            } else {
              //final profiles = snapshot.data!;

              final profiles = snapshot.data!
                  .where((profile) => profile.idAccount == indexAct)
                  .toList();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    //Contenedor para mantener la sobra de card
                    Container(
                      height: 500, // Ajusta la altura según tus necesidades
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: profiles.length,
                        itemBuilder: (context, index) {
                          final profile = profiles[index];
                          // Llamar a la función y obtener los días restantes
                          //int diasRestantes =(profile.payment);print('${profile.user}: $diasRestantes');

                          /* if (diasRestantes <= 2) {
                            // Llama a la función para programar el envío de notificación
                            programarEnvioNotificacion();
                          }*/

                          //print('${profile.payment}: ');

                          return Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: Container(
                                  height: 200, //150,
                                  width: 500, //500,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 200, //150,
                                  width: 500, //500,
                                  decoration: BoxDecoration(
                                    color: TColor.purpleColor,
                                    border: Border.all(
                                      color: Colors.black, // Color del borde
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Usuario ${profile.letter.toUpperCase()}',
                                                    style: GoogleFonts.fredoka(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(width: 130),
                                                  Text(
                                                    '${profile.status.toUpperCase()}',
                                                    style: GoogleFonts.fredoka(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Nombre: ${profile.user.toUpperCase()}',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                _authorized == 'Autenticado'
                                                    ? 'Teléfono: ${profile.phone}'
                                                    : 'Teléfono: ***-***-****',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 80),
                                                    child: Text(
                                                      _authorized ==
                                                              'Autenticado'
                                                          ? 'Pin: ${profile.pin}'
                                                          : 'Pin: ****',
                                                      style:
                                                          GoogleFonts.fredoka(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  Text(
                                                    _authorized == 'Autenticado'
                                                        ? 'Pago: ${profile.payment}'
                                                        : 'Pago: ***',
                                                    style: GoogleFonts.fredoka(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Circles(),
                                    Positioned(
                                      bottom: 8,
                                      left: 340,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: profile.genre == 'f' &&
                                                    (profile.letter == 'a' ||
                                                        profile.letter == 'c' ||
                                                        profile.letter == 'e')
                                                ? Image.asset(
                                                    'assets/icons/woman.png')
                                                : profile.genre == 'f' &&
                                                        (profile.letter == 'b' ||
                                                            profile.letter ==
                                                                'd')
                                                    ? Image.asset(
                                                        'assets/icons/woman2.png')
                                                    : profile.genre == 'm' &&
                                                            (profile.letter == 'a' ||
                                                                profile.letter ==
                                                                    'c')
                                                        ? Image.asset(
                                                            'assets/icons/man1.png')
                                                        : profile.genre == 'm' &&
                                                                (profile.letter ==
                                                                        'b' ||
                                                                    profile.letter ==
                                                                        'd')
                                                            ? Image.asset(
                                                                'assets/icons/man2.png')
                                                            : profile.genre ==
                                                                        'm' &&
                                                                    (profile.letter ==
                                                                        'e')
                                                                ? Image.asset(
                                                                    'assets/icons/man3.png')
                                                                : Image.asset('assets/icons/icon6.png'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: ExpandableMenu(
                                          width: 45.0,
                                          height: 45.0,
                                          backgroundColor: Colors
                                              .yellow.shade800
                                              .withOpacity(0.5),
                                          iconColor: Colors.white,
                                          itemContainerColor: Colors.white,
                                          items: [
                                            GestureDetector(
                                              onTap: () async {
                                                await shareMessageUser(
                                                    profile.phone);
                                              },
                                              child: Icon(
                                                Icons.email,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print(
                                                    'Id usuario de imagen: ${profile.idUser}');
                                                SharedDataProfile()
                                                    .sharedDataProfile(
                                                        context,
                                                        ctlScreen,
                                                        profile.idUser
                                                            .toString());
                                              },
                                              child: Icon(
                                                Icons.share_outlined,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await _addUser(
                                                    profile.idUser.toString());
                                              },
                                              child: Icon(
                                                Icons.person_add_alt_1_rounded,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                Dialogs.bottomMaterialDialog(
                                                    msg:
                                                        'Liberar perfil? ya no podrás revertir esta acción.',
                                                    title: 'Liberar',
                                                    context: context,
                                                    actions: [
                                                      IconsOutlineButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        text: 'Cancelar',
                                                        iconData: Icons
                                                            .cancel_outlined,
                                                        textStyle: TextStyle(
                                                            color: Colors.grey),
                                                        iconColor: Colors.grey,
                                                      ),
                                                      IconsButton(
                                                        onPressed: () async {
                                                          await liberarPerfil(
                                                              idUser: profile
                                                                  .idUser
                                                                  .toString());
                                                          Navigator.of(context)
                                                              .pop();
                                                          Dialogs
                                                              .bottomMaterialDialog(
                                                            msg:
                                                                'El perfil ha sido liberado exitosamente.',
                                                            title: '¡Liberado!',
                                                            color: Colors.white,
                                                            lottieBuilder:
                                                                Lottie.asset(
                                                              'assets/js/cong_example.json',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                            context: context,
                                                            actions: [
                                                              IconsButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  setState(() {
                                                                    _reloadData();
                                                                  });
                                                                },
                                                                text: 'Cerrar',
                                                                iconData:
                                                                    Icons.done,
                                                                color:
                                                                    Colors.blue,
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                iconColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                        text: 'Eliminar',
                                                        iconData: Icons.delete,
                                                        color: Colors.red,
                                                        textStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        iconColor: Colors.white,
                                                      ),
                                                    ]);
                                              },
                                              child: Icon(
                                                Icons.cleaning_services_rounded,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await _editPin(
                                                    profile.idUser.toString());
                                                //recargar datos
                                                //_reloadData();
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                String? token =
                                                    await getTokenFromPreferences();
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AddPayment(
                                                      token: token.toString(),
                                                      idUser: profile.idUser
                                                          .toString(),
                                                      idAccount: profile
                                                          .idAccount
                                                          .toString(),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ]),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    //Contenedor para mantener la sobra de card
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Stack Circles() {
    return Stack(children: [
      Positioned(
        top: 60,
        left: 200,
        child: Container(
          width: 300,
          height:
              300, // Asegúrate de que el contenedor sea cuadrado para que sea un círculo
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Color del borde
              //width: 3, // Ancho del borde
            ),
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        bottom: 40,
        left: 355,
        child: Container(
          width: 180,
          height:
              180, // Asegúrate de que el contenedor sea cuadrado para que sea un círculo
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Color del borde
              //width: 3, // Ancho del borde
            ),
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ]);
  }

  Padding card() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Center(
        child: FutureBuilder<List<Account>>(
            future: futureAccounts,
            builder:
                (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingDots();
              } else if (snapshot.hasError) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Color del borde
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            color: TColor.orangeLightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Error al cargar datos',
                                        style: GoogleFonts.fredoka(
                                            fontSize: 26, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Circles(),
                            Positioned(
                              top: 30,
                              left: 200,
                              child: Container(
                                width: 160,
                                child: Image.asset('assets/icons/info.png'),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Color del borde
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            color: TColor.orangeLightColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No hay datos \npara mostrar',
                                        style: GoogleFonts.fredoka(
                                            fontSize: 26, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Circles(),
                            Positioned(
                              top: 30,
                              left: 200,
                              child: Container(
                                width: 160,
                                child: Image.asset('assets/icons/info.png'),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                final accounts = snapshot.data!.toList();
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.2, // Ajusta la altura según tus necesidades
                        width: MediaQuery.of(context)
                            .size
                            .width, // Asegura que el ancho esté bien definido
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: accounts.length,
                          itemBuilder: (context, index) {
                            final account = accounts[index];
                            return Stack(children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 25),
                                child: Container(
                                  height: 200,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 200,
                                  width: 400,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black, // Color del borde
                                      //width: 3, // Ancho del borde
                                    ),
                                    color: TColor.orangeLightColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _authorized == 'Autenticado'
                                                    ? account.name
                                                    : 'Cuenta: **********@gmail.com',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                _authorized == 'Autenticado'
                                                    ? account.password
                                                    : 'Contraseña: *******',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                _authorized == 'Autenticado'
                                                    ? account.payment
                                                    : 'Mensulaidad: ***',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                _authorized == 'Autenticado'
                                                    ? account.bank
                                                    : 'Banco: *******',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Circles(),
                                    Positioned(
                                        top: 60,
                                        left: 200,
                                        child: Container(
                                            width: 260,
                                            child: Image.asset(
                                              'assets/icons/icon${account.idAccount.toString()}.png',
                                              fit: BoxFit.contain,
                                            ))),
                                  ]),
                                ),
                              ),
                            ]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Padding cardProxPagos() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Center(
        child: FutureBuilder<List<ProxPagos>>(
            future: proxPagos,
            builder: (BuildContext context,
                AsyncSnapshot<List<ProxPagos>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingDots();
              } else if (snapshot.hasError) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(53, 183, 23, 246),
                        /*gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(95, 183, 23, 246),
                                        Color.fromARGB(255, 255, 255, 255),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),*/
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9, left: 3),
                            child: Container(
                              height: 90,
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sin datos',
                                  style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(53, 183, 23, 246),
                        /*gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(95, 183, 23, 246),
                                        Color.fromARGB(255, 255, 255, 255),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),*/
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9, left: 3),
                            child: Container(
                              height: 90,
                              width: 3,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sin datos',
                                  style: GoogleFonts.fredoka(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                final proxPagos = snapshot.data!;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.13, // Ajusta la altura según tus necesidades
                        width: MediaQuery.of(context).size.width +
                            0, // Asegura que el ancho esté bien definido
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: proxPagos.length,
                          itemBuilder: (context, index) {
                            final pago = proxPagos[index];
                            final restantes =
                                calcularDiasRestantes(pago.payment);
                            DateTime fechaPago = DateTime.parse(pago.payment);
                            // Fecha actual
                            DateTime fechaActual = DateTime.now();
                            if (restantes >= 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(53, 183, 23, 246),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 9, left: 3),
                                          child: Container(
                                            height: 90,
                                            width: 3,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('${pago.user}',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                            Text(
                                                pago.idAccount == 1
                                                    ? 'Cuenta A'
                                                    : pago.idAccount == 2
                                                        ? 'Cuenta B'
                                                        : 'Cuenta C',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                            Text(
                                                fechaPago == fechaActual
                                                    ? 'Día de pago: Hoy'
                                                    : restantes == 0
                                                        ? 'Día de pago: Mañana'
                                                        : 'Días restantes: ${restantes}',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container(); // Retorna un Container vacío si restantes es menor a -1
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  BoxShadow shadow(color) {
    return BoxShadow(
      color: color,
      spreadRadius: 3,
      blurRadius: 20,
      offset: Offset(0, -2),
    );
  }

  void _showModalSheetBono() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(
            'Agregar Pago',
            style: GoogleFonts.fredoka(
                fontSize: 26, color: const Color(0xff368983)),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Cerrar', style: GoogleFonts.fredoka(fontSize: 16)),
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
            )
          ],
          message: Container(
            height: MediaQuery.of(context).size.height * 0.26,
            child: Material(
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    //SELECCIONAR FECHA ------------------------------------------------------

                    //------------------------------------------------------------------------
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: pagoC,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 11, 57, 54),
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(47, 125, 121, 0.9),
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            prefixIcon: Icon(
                              Icons.monetization_on_rounded,
                              color: Color.fromRGBO(47, 125, 121, 0.9),
                            ),
                            hintText: '00.0',
                            filled: true,
                            fillColor: Colors.transparent),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        //await abonarGasto( bono: abonoC.text,idFinance: idFinance.toString());
                        await ShowConfirm().showConfirmDialog2(context);
                        // Llamar a setState para reconstruir la vista y mostrar los nuevos datos
                        setState(() {});
                        // Navegar de regreso a la vista de inicio y reemplazar la vista actual
                        // Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff368983),
                        ),
                        width: 120,
                        height: 50,
                        child: Text('Guardar',
                            style: GoogleFonts.fredoka(
                                fontSize: 17, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
