import 'package:acounts_control/widgets/loading_dots.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/request/request.dart';
import '../../data/models/view_model.dart';
import '../../utils/constans.dart';
import '../../utils/prueba.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class PaysAccount extends StatefulWidget {
  const PaysAccount({super.key});

  @override
  State<PaysAccount> createState() => _PaysAccountState();
}

class _PaysAccountState extends State<PaysAccount>
    with TickerProviderStateMixin {
  //INSTANCIAS DE MODELOS DE CLASES

  List<Pagos> pagos = [];

  bool noData = false;
  bool noDataUser = false;
  bool reload = false;
  int indexAct = 1;

  int index = 0;

  Future<void> cargarPagos() async {
    //parametros = {"opcion": "1.1"};
    reload = true;
    var respuesta = await mostrarPagosPorCuenta(idAccount: '1');
    reload = false;
    if (respuesta != "err_internet_conex") {
      setState(() {
        if (respuesta == 'empty') {
          noData = true;
          print('no hay datos');
        } else {
          noData = false;
          print('Respuesta en vista ::::: ${respuesta}');
          pagos.clear();
          if (respuesta.isNotEmpty) {
            for (int i = 0; i < respuesta.length; i++) {
              pagos.add(Pagos(
                idPayment: respuesta[i]['idPayment'],
                idUser: respuesta[i]['idUser'],
                idAccount: respuesta[i]['idAccount'],
                paymentDate: respuesta[i]['paymentDate'],
                status: respuesta[i]['status'],
                amount: respuesta[i]['amount'],
              ));
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
    cargarPagos();
    // mostrarUsuariosPorCuenta(idAccount: '2');
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      backgroundColor: TColor.backgroundColor,
      body: Stack(
        children: [
          title1(),
          Padding(
            padding: const EdgeInsets.only(top: 150, left: 0),
            child: Stack(children: [
              Container(
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Tab 1'),
                    Tab(text: 'Tab 2'),
                    Tab(text: 'Tab 3'),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                height: double.infinity,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Stack(children: [
                      statics(),
                      data(),
                    ]),
                    Stack(children: [
                      statics(),
                      data(),
                    ]),
                    Stack(children: [
                      statics(),
                      data(),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
          //statics(),
        ],
      ),
    );
  }

  Padding statics() {
    if (noData == false && pagos.isEmpty || reload) {
      return Padding(
        padding: const EdgeInsets.only(top: 378),
        child: Center(
          child: FutureBuilder<void>(
            future: Future.delayed(Duration(seconds: 4)),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Si estamos esperando, mostramos el CircularProgressIndicator
                return CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 46),
                  child: Center(
                    child: FadeInUp(
                      duration: Duration(milliseconds: 2100),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                            'Sin datos o problemas de red. \nVerifica tu conexión a internet.',
                            style: GoogleFonts.fredoka(
                                fontSize: 25, color: Colors.black),
                          ),
                          Image.asset('assets/gifs/noData.gif'),
                        ],
                      ),
                    ),
                  ), // Cambia 'assets/error.gif' al path de tu GIF
                ); // Aquí debes reemplazar YourRegularContentWidget con tu widget habitual
              }
            },
          ),
        ),
      );
    } else
    //SI NO EXISTE DATA
    if (noData) {
      return Padding(
        padding: const EdgeInsets.only(top: 420),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Sin datos para mostrar.',
                style: GoogleFonts.fredoka(fontSize: 25, color: Colors.black),
              ),
              Image.asset('assets/gifs/noData.gif'),
            ],
          ),
        ), // Cambia 'assets/error.gif' al path de tu GIF
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(top: 60, right: 26, left: 26),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: TColor.accentColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: GoogleFonts.fredoka(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '680.00',
                            style: GoogleFonts.fredoka(
                                fontSize: 76,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Monto total acumulado del mes de Noviembre',
                            style: GoogleFonts.fredoka(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.monetization_on_rounded,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Mensualidad',
                                          style: GoogleFonts.fredoka(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '299.00',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.monetization_on_rounded,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Ganancia',
                                          style: GoogleFonts.fredoka(
                                              fontSize: 24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '299.00',
                                      style: GoogleFonts.fredoka(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
    }
  }

  Padding data() {
    if (noData == false && pagos.isEmpty || reload) {
      return Padding(
        padding: const EdgeInsets.only(top: 378),
        child: Center(
          child: FutureBuilder<void>(
            future: Future.delayed(Duration(seconds: 4)),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Si estamos esperando, mostramos el CircularProgressIndicator
                return CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 46),
                  child: Center(
                    child: FadeInUp(
                      duration: Duration(milliseconds: 2100),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                            'Sin datos o problemas de red. \nVerifica tu conexión a internet.',
                            style: GoogleFonts.fredoka(
                                fontSize: 25, color: Colors.black),
                          ),
                          Image.asset('assets/gifs/noData.gif'),
                        ],
                      ),
                    ),
                  ), // Cambia 'assets/error.gif' al path de tu GIF
                ); // Aquí debes reemplazar YourRegularContentWidget con tu widget habitual
              }
            },
          ),
        ),
      );
    } else
    //SI NO EXISTE DATA
    if (noData) {
      return Padding(
        padding: const EdgeInsets.only(top: 420),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Sin datos para mostrar.',
                style: GoogleFonts.fredoka(fontSize: 25, color: Colors.black),
              ),
              Image.asset('assets/gifs/noData.gif'),
            ],
          ),
        ), // Cambia 'assets/error.gif' al path de tu GIF
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(top: 380, right: 26, left: 26),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: TColor.accentColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Historial de Pagos',
                            style: GoogleFonts.fredoka(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Mónto',
                            style: GoogleFonts.fredoka(
                                fontSize: 23,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      itemCount: pagos.length,
                      itemBuilder: (context, index) {
                        final pago = pagos[index];
                        var cant = pago.amount;
                        int amount = int.parse(cant);
                        NumberFormat formatoMoneda =
                            NumberFormat.currency(symbol: '\$');
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/icons/efectivo.png',
                                height: 40),
                          ),
                          title: Text(
                            pago.idUser.toString(),
                            style: GoogleFonts.fredoka(
                                fontSize: 22, color: Colors.white),
                          ),
                          subtitle: Text(
                            pago.status,
                            style: GoogleFonts.fredoka(
                                fontSize: 20, color: Colors.white),
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                formatoMoneda.format(amount),
                                style: GoogleFonts.fredoka(
                                    fontSize: 23, color: Colors.white),
                              ),
                              Text(
                                pago.paymentDate,
                                style: GoogleFonts.fredoka(
                                    fontSize: 19, color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ));
    }
  }

  Padding title1() {
    return Padding(
      padding: const EdgeInsets.only(top: 70, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Pagos de Cuenta A',
            style: TextStyle(
                fontSize: 34, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Stack Circles() {
    return Stack(children: [
      Positioned(
        top: -60,
        left: 220,
        child: Container(
          width: 500,
          height:
              500, // Asegúrate de que el contenedor sea cuadrado para que sea un círculo
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        bottom: -50,
        right: 255,
        child: Container(
          width: 380,
          height:
              380, // Asegúrate de que el contenedor sea cuadrado para que sea un círculo
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ]);
  }
}
