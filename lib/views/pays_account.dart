import 'package:acounts_control/widgets/loading_dots.dart';
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

class _PaysAccountState extends State<PaysAccount> {
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
          pagos.clear();
          if (respuesta.isNotEmpty) {
            for (int i = 0; i < respuesta.length; i++) {
              pagos.add(Pagos(
                  idPayment: respuesta[i]['idAccount'],
                  idUser: respuesta[i]['name'],
                  idAccount: respuesta[i]['payment'],
                  paymentDate: respuesta[i]['password'],
                  status: respuesta[i]['bank'],
                  amount: respuesta[i]['password'],
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
    return Scaffold(
      backgroundColor: TColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            title1(),
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 650,
                              width: 600,
                              decoration: BoxDecoration(
                                color: TColor.green2Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Pago Total del Mes: ',
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '250.00',
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 538, right: 16, left: 16),
                                  child: Stack(children: [
                                    ListView.builder(
                                      itemCount: pagos.length,
                                      itemBuilder: (context, index) {
                                        final finance = pagos[index];
                                        var cant = finance.amount;
                                        int amount = int.parse(cant);
                                        NumberFormat formatoMoneda =
                                            NumberFormat.currency(symbol: '\$');
                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.asset(
                                                'assets/images/${finance.concept}.png',
                                                height: 40),
                                          ),
                                          title: Text(
                                            finance.concept,
                                            style: GoogleFonts.fredoka(
                                                fontSize: 17,
                                                color: Colors.black),
                                          ),
                                          subtitle: Text(
                                            '${finance.reason}',
                                            style: GoogleFonts.fredoka(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          trailing: Column(
                                            children: [
                                              Text(
                                                finance.type == 'Income'
                                                    ? formatoMoneda
                                                        .format(amount)
                                                    : '-' +
                                                        formatoMoneda
                                                            .format(amount),
                                                style: GoogleFonts.fredoka(
                                                  fontSize: 19,
                                                  color:
                                                      finance.type == 'Income'
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              ),
                                              Text(
                                                '${finance.date}',
                                                style: GoogleFonts.fredoka(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                                ),
                                Circles(),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            //title(),
            //tab navegador

            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
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
