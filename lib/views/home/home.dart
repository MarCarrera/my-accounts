import 'package:acounts_control/widgets/loading_dots.dart';
import 'package:expandable_menu/expandable_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/request/request.dart';
import '../../data/models/view_model.dart';
import '../../data/request/service.dart';
import '../../utils/constans.dart';
import '../../utils/buttom_nav.dart';
import 'dart:async';

import '../../utils/showConfirm.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  String _authorized = 'No autenticado';
  bool showData = false;
  //INSTANCIAS DE MODELOS DE CLASES

  //importacion de perfiles cargados
  TextEditingController pagoC = TextEditingController();
  final HomeService homeService = HomeService();
  late Future<List<Profile>> futureProfiles;
  late Future<List<Account>> futureAccounts;

  bool noData = false;
  bool noDataUser = false;
  bool reload = false;
  int indexAct = 1;

  int index = 0;

  Future<void> _reloadData() async {
    setState(() {
      futureAccounts = homeService.cargarCuentas();
      futureProfiles = homeService
          .cargarPerfiles(); // Reemplaza 'indexA' con el valor adecuado
    });
  }

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
    futureProfiles = homeService
        .cargarPerfiles(); // Reemplaza 'indexA' con el valor adecuado
    //ProfileService().cargarPerfiles(indexAct.toString());
    // mostrarUsuariosPorCuenta(idAccount: '2');
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
            title(),
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

  Padding title() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Usuarios',
            style: GoogleFonts.fredoka(
                fontSize: 34, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ],
      ),
    );
  }

  /*Padding cardUser() {
    if (noDataUser == false && profiles.isEmpty || reload) {
      return Padding(
          padding: EdgeInsets.only(top: 0),
          child: Center(
            child: FutureBuilder<void>(
              future: Future.delayed(Duration(seconds: 3)),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingDots();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
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
                                              fontSize: 26,
                                              color: Colors.white),
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
                                  alignment: Alignment
                                      .center, // Alinea el contenido en el centro del Stack
                                  children: [
                                    Container(
                                      width: 140,
                                      child:
                                          Image.asset('assets/icons/info.png'),
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
                }
              },
            ),
          ));
    } else {
      if (noDataUser) {
        return Padding(padding: EdgeInsets.all(8));
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              //Contenedor para mantener la sobra de card
              Container(
                height: 550, // Ajusta la altura según tus necesidades
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: profiles.length,

                    /*profiles
                        .where((profile) => profile.idAccount == 1)
                        .length,*/
                    itemBuilder: (context, index) {
                      final filteredProfile = profiles
                          .where((profile) => profile.idAccount == 1)
                          .toList();
                      final profile = profiles[index];
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
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
                                  //width: 3, // Ancho del borde
                                ),
                                borderRadius: BorderRadius.circular(20),
                                // boxShadow: [
                                //   shadow(TColor.purpleColor),
                                // ],
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
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 130,
                                              ),
                                              Text(
                                                '${profile.status.toUpperCase()}',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w400,
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
                                                padding: const EdgeInsets.only(
                                                    right: 80),
                                                child: Text(
                                                  _authorized == 'Autenticado'
                                                      ? 'Pin: ${profile.pin}'
                                                      : 'Pin: ****',
                                                  style: GoogleFonts.fredoka(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                _authorized == 'Autenticado'
                                                    ? 'Pago: ${profile.payment}'
                                                    : 'Pago: ***',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
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
                                  left: 360,
                                  child: Stack(
                                    alignment: Alignment
                                        .center, // Alinea el contenido en el centro del Stack
                                    children: [
                                      Container(
                                        width: 100,
                                        child: Image.asset(
                                            'assets/icons/woman.png'),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          )
                        ],
                      );
                    }),
              ),

              //Contenedor para mantener la sobra de card
            ],
          ),
        );
      }
    }
  }*/

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
                                            Icon(
                                              Icons.person_add_alt_1_rounded,
                                              color: Colors.amber.shade700,
                                            ),
                                            Icon(
                                              Icons.cleaning_services_rounded,
                                              color: Colors.amber.shade700,
                                            ),
                                            Icon(
                                              Icons.share_outlined,
                                              color: Colors.amber.shade700,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showModalSheetBono();
                                              },
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.amber.shade700,
                                              ),
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                      bottom: 8,
                                      left: 360,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Image.asset(
                                                'assets/icons/woman.png'),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                              'assets/icons/icon3.png',
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
                    Text('Fecha: 05 de Julio, 2024',
                        style: GoogleFonts.fredoka(
                            fontSize: 24,
                            color: Color.fromRGBO(47, 125, 121, 0.9))),
                    SizedBox(
                      height: 15,
                    ),
                    /*Text('0.00',
                        style: GoogleFonts.fredoka(
                            fontSize: 80,
                            color: Color.fromRGBO(47, 125, 121, 0.9))),*/
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
