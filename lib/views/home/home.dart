import 'package:acounts_control/widgets/loading_dots.dart';
import 'package:flutter/material.dart';

import '../../data/request/request.dart';
import '../../data/models/view_model.dart';
import '../../utils/constans.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //INSTANCIAS DE MODELOS DE CLASES
  List<Account> accounts = [];
  List<Profile> profiles = [];

  bool noData = false;
  bool reload = false;

  Future<void> cargarCuentas() async {
    //parametros = {"opcion": "1.1"};
    reload = true;
    var respuesta = await mostrarCuentas();
    reload = false;
    if (respuesta != "err_internet_conex") {
      setState(() {
        if (respuesta == 'empty') {
          noData = true;
          print('no hay datos');
        } else {
          noData = false;
          //print('Respuesta en vista ::::: ${respuesta}');
          accounts.clear();
          if (respuesta.isNotEmpty) {
            for (int i = 0; i < respuesta.length; i++) {
              accounts.add(Account(
                  idAccount: respuesta[i]['idAccount'],
                  name: respuesta[i]['name'],
                  payment: respuesta[i]['payment'],
                  password: respuesta[i]['password'],
                  bank: respuesta[i]['bank']));
            }
          }
        }
      });
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
  }

  @override
  void initState() {
    super.initState();
    cargarCuentas();
    mostrarUsuariosPorCuenta(idAccount: '2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: TColor.backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Cuentas',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  card(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Usuarios',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            CardUser(),
            CardUser(),
            CardUser(),
            CardUser(),
            CardUser()
          ],
        ),
      ),
    );
  }

  Padding CardUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Stack(
        children: [
          //Contenedor para mantener la sobra de card
          Container(
            height: 150,
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                shadow(),
              ],
            ),
          ),
          //Contenedor para mantener la sobra de card
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 150,
              width: 500,
              decoration: BoxDecoration(
                color: TColor.purpleColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  shadow(),
                ],
              ),
              child: Stack(children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Usuario A',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Nombre:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Teléfono:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 80),
                                child: Text(
                                  'Pin:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                'Pago:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
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
                        child: Image.asset('assets/icons/woman.png'),
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
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ]);
  }

  Padding card() {
    if (noData == false && accounts.isEmpty || reload) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Center(
          child: FutureBuilder<void>(
              future: Future.delayed(Duration(seconds: 4)),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingDots();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: Stack(
                      children: [
                        Container(
                          height: 200,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
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
                              boxShadow: [
                                shadow(),
                              ],
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
                                          'Cuenta',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Contraseña:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'Mensualidad:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          'Banco:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
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
                      ],
                    ),
                  );
                }
              }),
        ),
      );
    } else {
      if (noData) {
        return Padding(padding: EdgeInsets.all(8));
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Ajusta la altura según tus necesidades
                width: 400, // Asegura que el ancho esté bien definido
                child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return Stack(children: [
                      Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
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
                            boxShadow: [
                              shadow(),
                            ],
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
                                        account.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        account.password,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        account.payment,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        account.bank,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
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
    }
  }

  BoxShadow shadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.255),
      spreadRadius: 3,
      blurRadius: 10,
      offset: Offset(0, 6),
    );
  }
}
