import 'package:flutter/material.dart';
import '../models/view_model.dart';
import 'request.dart';
// Asegúrate de que la ruta es correcta

class HomeService {
  Future<List<Account>> cargarCuentas() async {
    List<Account> accounts = [];
    bool noData = false;
    //parametros = {"opcion": "1.1"};

    var respuesta = await mostrarCuentas();

    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        noData = true;
        print('no hay datos');
      } else {
        noData = false;
        //print('Cuentass en vista ::::: ${respuesta}');
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
        //print('Datos cuentas: ${accounts}');
      }
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
    return accounts;
  }

  Future<List<Profile>> cargarPerfiles() async {
    List<Profile> profiles = [];
    bool noData = false;

    var respuesta = await mostrarTodosUsuarios();

    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        noData = true;
        print('no hay datos');
      } else {
        noData = false;
        //print('Perfiles en vista ::::: ${respuesta}');
        profiles.clear();
        if (respuesta.isNotEmpty) {
          for (int i = 0; i < respuesta.length; i++) {
            profiles.add(Profile(
              idUser: respuesta[i]['idUser'],
              idAccount: respuesta[i]['idAccount'],
              letter: respuesta[i]['letter'],
              user: respuesta[i]['user'],
              payment: respuesta[i]['payment'],
              amount: respuesta[i]['amount'],
              phone: respuesta[i]['phone'],
              pin: respuesta[i]['pin'],
              status: respuesta[i]['status'],
              genre: respuesta[i]['genre'],
            ));
          }
        }
        //print('Datos perfiles: ${profiles}');
      }
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
    return profiles;
  }

  Future<List<ProxPagos>> cargarProxPagos() async {
    List<ProxPagos> proxPagos = [];
    bool noData = false;

    var respuesta = await mostrarFechasProximasPago();

    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        noData = true;
        print('no hay datos');
      } else {
        noData = false;
        proxPagos.clear();
        if (respuesta.isNotEmpty) {
          for (int i = 0; i < respuesta.length; i++) {
            String? paymentDateStr = respuesta[i]['payment'];
            String? idAccountStr = respuesta[i]['idAccount'];
            String? userStr = respuesta[i]['user'];

            if (paymentDateStr != null &&
                idAccountStr != null &&
                userStr != null) {
              DateTime paymentDate = DateTime.parse(paymentDateStr);
              DateTime currentDate = DateTime.now();

              // Calcular la diferencia en días
              int daysRemaining = paymentDate.difference(currentDate).inDays;
              print('Dias restantes: $daysRemaining');

              proxPagos.add(ProxPagos(
                idAccount: int.parse(idAccountStr),
                user: userStr,
                payment: paymentDateStr,
                diasRestantes: daysRemaining,
              ));
            }
          }
        }
      }
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
    return proxPagos;
  }

  Future<List<InfoUser>> obtenerInfoUser(String idUser) async {
    List<InfoUser> info = [];
    bool noData = false;

    var respuesta = await mostrarInfoUsuario(idUser: idUser);

    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        noData = true;
        print('no hay datos');
      } else {
        noData = false;
        print('Info en vista ::::: ${respuesta}');
        info.clear();
        if (respuesta.isNotEmpty) {
          for (int i = 0; i < respuesta.length; i++) {
            info.add(InfoUser(
              account: respuesta[i]['account'],
              password: respuesta[i]['pass'],
              letter: respuesta[i]['letter'],
              pin: respuesta[i]['pin'],
            ));
          }
        }
        //print('Datos perfiles: ${profiles}');
      }
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }

    return info;
  }
}
