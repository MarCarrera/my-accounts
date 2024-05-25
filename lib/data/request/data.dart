// //-------------------------------------------------------------------
// import 'request.dart';
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/widgets.dart';



//   bool noData = false;
//   bool reload = false;

// Future<void> cargarCuentas() async {
//     //parametros = {"opcion": "1.1"};
//     reload = true;
//     var respuesta = await mostrarCuentas();
//     reload = false;
//     if (respuesta != "err_internet_conex") {
//       setState(() {
//         if (respuesta == 'empty') {
//           noData = true;
//           print('no hay datos');
//         } else {
//           noData = false;
//           //print('Respuesta en vista ::::: ${respuesta}');
//           finances.clear();
//           if (respuesta.isNotEmpty) {
//             for (int i = 0; i < respuesta.length; i++) {
//               finances.add(Finance(
//                   idFinance: respuesta[i]['idFinance'],
//                   concept: respuesta[i]['concept'],
//                   reason: respuesta[i]['reason'],
//                   amount: respuesta[i]['amount'],
//                   type: respuesta[i]['type'],
//                   date: respuesta[i]['date']));
//             }
//             //print('Arreglo idFinance:');
//             // Itera sobre la lista finances y accede al idFinance de cada objeto Finance
//             for (var finance in finances) {
//               //print(finance.idFinance);
//             }
//           }
//         }
//       });
//     } else {
//       noData = true;
//       print('Verifique su conexion a internet');
//     }
//   }
//   //-------------------------------------------------------------------------