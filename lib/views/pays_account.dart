import 'package:acounts_control/widgets/loading_dots.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import '../../data/request/request.dart';
import '../../data/models/view_model.dart';
import '../../utils/constans.dart';
import '../utils/buttom_nav.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class PaysAccount extends StatefulWidget {
  const PaysAccount({super.key});

  @override
  State<PaysAccount> createState() => _PaysAccountState();
}

class _PaysAccountState extends State<PaysAccount>
    with TickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  String _authorized = 'No autenticado';

  //INSTANCIAS DE MODELOS DE CLASES
  NumberFormat formatoMoneda = NumberFormat.currency(symbol: '\$');
  List<Pagos> pagos = [];
  List<TotalPago> totalPago = [];

  bool noData = false;
  bool noDataStatcs = false;
  bool reload = false;
  bool isButtonEnabled = true;
  int indexAct = 1;
  bool showData = false;
  int index = 0;
  int month = 6, year = 2024;

  Map<String, String> monthTranslations = {
    "January": "Enero",
    "February": "Febrero",
    "March": "Marzo",
    "April": "Abril",
    "May": "Mayo",
    "June": "Junio",
    "July": "Julio",
    "August": "Agosto",
    "September": "Septiembre",
    "October": "Octubre",
    "November": "Noviembre",
    "December": "Diciembre",
  };
  Map<int, String> monthNumber = {
    1: "Enero",
    2: "Febrero",
    3: "Marzo",
    4: "Abril",
    5: "Mayo",
    6: "Junio",
    7: "Julio",
    8: "Agosto",
    9: "Septiembre",
    10: "Octubre",
    11: "Noviembre",
    12: "Diciembre",
  };

  Future<void> cargarPagos() async {
    //parametros = {"opcion": "1.1"};
    reload = true;
    var respuesta =
        await mostrarPagos(date1: '2024-06-01', date2: '2024-06-06');
    reload = false;
    if (respuesta != "err_internet_conex") {
      setState(() {
        if (respuesta == 'empty') {
          noData = true;
          print('no hay datos');
        } else {
          noData = false;
          //print('Respuesta en vista ::::: ${respuesta}');
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
                userName: respuesta[i]['userName'],
              ));
            }
          }
        }
      });
    } else {
      noData = true;
      isButtonEnabled = false;
      print('Verifique su conexion a internet');
    }
  }

  Future<void> cargarTotalPago() async {
    //parametros = {"opcion": "1.1"};
    reload = true;
    var respuesta = await mostrarTotalPagoPorMesCuenta(
        date1: '2024-06-01', date2: '2024-06-06');
    reload = false;
    if (respuesta != "err_internet_conex") {
      setState(() {
        if (respuesta == 'empty') {
          noDataStatcs = true;
          print('no hay datos');
        } else {
          noData = false;
          print('Respuesta totalPago ::::: ${respuesta}');
          totalPago.clear();
          if (respuesta.isNotEmpty) {
            for (int i = 0; i < respuesta.length; i++) {
              totalPago.add(TotalPago(
                  idAccount: respuesta[i]['idAccount'],
                  totalPagado: respuesta[i]['totalPagado'],
                  month1: respuesta[i]['month1'],
                  month2: respuesta[i]['month2'],
                  mensualidad: respuesta[i]['mensualidad'],
                  ganancia: respuesta[i]['ganancia']));
            }
          }
        }
      });
    } else {
      noDataStatcs = true;
      print('Verifique su conexion a internet');
    }
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
    cargarPagos();
    cargarTotalPago();
    //_checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: TColor.backgroundColor,
      body: Stack(
        children: [
          title1(),
          //calendar(context),
          Padding(
            padding: const EdgeInsets.only(top: 230, left: 0),
            child: Stack(children: [
              Container(
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Cuenta A'),
                    Tab(text: 'Cuenta B'),
                    Tab(text: 'Cuenta C'),
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
                      statics(1),
                      data(1),
                    ]),
                    Stack(children: [
                      statics(2),
                      data(2),
                    ]),
                    Stack(children: [
                      statics(3),
                      data(3),
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

  Padding calendar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Pagos del mes de: ${monthNumber[month]}',
            style: GoogleFonts.fredoka(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      showMonthPicker(context, onSelected: (month, year) {
                        if (kDebugMode) {
                          print('Selected month: $month, year: $year');
                        }
                        setState(() {
                          this.month = month;
                          this.year = year;
                        });
                      },
                          initialSelectedMonth: month,
                          initialSelectedYear: year,
                          firstEnabledMonth: 3,
                          lastEnabledMonth: 10,
                          firstYear: 2000,
                          //size: const Size(520, 250),
                          lastYear: 2035,
                          selectButtonText: 'OK',
                          cancelButtonText: 'Cancel',
                          //highlightColor: Colors.purple,
                          textColor: Colors.black,
                          contentBackgroundColor: Colors.white,
                          dialogBackgroundColor: Colors.grey[200]);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                backgroundColor: TColor.accentColor, // Color del texto
                //shadowColor: Colors.grey, // Color de la sombra
                elevation: 5, // Elevación
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Borde redondeado
                  side: BorderSide(color: Colors.black), // Borde del botón
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // Padding interno
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.black,
              )),
          ElevatedButton(
            onPressed: () {
              setState(() {
                totalPago.clear();
                pagos.clear();
                cargarPagos();
                cargarTotalPago();
              });
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor: TColor.accentColor, // Color del texto
              //shadowColor: Colors.grey, // Color de la sombra
              elevation: 5, // Elevación
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Borde redondeado
                side: BorderSide(color: Colors.black), // Borde del botón
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 30, vertical: 15), // Padding interno
            ),
            child: const Icon(
              Icons.change_circle_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Padding statics(int idAccount) {
    if (noDataStatcs == false && totalPago.isEmpty || reload) {
      return Padding(
        padding: const EdgeInsets.only(top: 28),
        child: Center(
          child: FutureBuilder<void>(
            future: Future.delayed(Duration(seconds: 4)),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Si estamos esperando, mostramos el CircularProgressIndicator
                return CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 36),
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
    } else {
      final filteredTotales =
          totalPago.where((pago) => pago.idAccount == idAccount).toList();
      final total = filteredTotales[index];
      return Padding(
          padding: const EdgeInsets.only(top: 60, right: 26, left: 26),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: TColor.accentColor,
                    border: Border.all(
                      color: Colors.black, // Color del borde
                      //width: 3, // Ancho del borde
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Balance',
                                style: GoogleFonts.fredoka(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
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
                                  Icons.remove_red_eye,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Text(
                            _authorized == 'Autenticado'
                                ? formatoMoneda.format(total.totalPagado)
                                : '***',
                            style: GoogleFonts.fredoka(
                                fontSize: 76,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            'Monto total acumulado del mes de ${monthTranslations[total.month1]}',
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
                                      _authorized == 'Autenticado' ?
                                      formatoMoneda
                                      .format(total.mensualidad) : '***',
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
                                    Text(_authorized == 'Autenticado' ?
                                      formatoMoneda.format(total.ganancia): '***',
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

  Padding data(int idAccount) {
    if (noData == false && pagos.isEmpty || reload) {
      return Padding(
        padding: const EdgeInsets.only(top: 78),
        child: Center(
          child: FutureBuilder<void>(
            future: Future.delayed(Duration(seconds: 4)),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Si estamos esperando, mostramos el CircularProgressIndicator
                return CircularProgressIndicator();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child:
                      Text(''), // Cambia 'assets/error.gif' al path de tu GIF
                ); // Aquí debes reemplazar YourRegularContentWidget con tu widget habitual
              }
            },
          ),
        ),
      );
    } else {
      // Filtrar los pagos por idAccount
      final filteredPagos =
          pagos.where((pago) => pago.idAccount == idAccount).toList();
      return Padding(
          padding: const EdgeInsets.only(top: 380, right: 26, left: 26),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: TColor.accentColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black, // Color del borde
                    //width: 3, // Ancho del borde
                  ),
                ),
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
                      itemCount: filteredPagos.length,
                      itemBuilder: (context, index) {
                        final pago = filteredPagos[index];
                        var cant = pago.amount;
                        int amount = int.parse(cant);

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/icons/efectivo.png',
                                height: 40),
                          ),
                          title: Text(
                            pago.userName.toUpperCase(),
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
                              Text(_authorized == 'Autenticado' ?
                                formatoMoneda.format(amount) : '***',
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Gestión de Pagos',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ],
          ),
          calendar(context),
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
