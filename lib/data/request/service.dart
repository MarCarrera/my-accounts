import 'package:flutter/material.dart';

import '../models/view_model.dart';
import 'request.dart';
// Asegúrate de que la ruta es correcta

class HomeService {
  Future<void> cargarCuentas() async {
    bool noData = false;
    //parametros = {"opcion": "1.1"};

    var respuesta = await mostrarCuentas();

    if (respuesta != "err_internet_conex") {
 
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
  
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }
  }

  Future<List<Profile>> cargarPerfiles(String indexA) async {
    List<Profile> profiles = [];
    bool noData = false;

    var respuesta = await mostrarUsuariosPorCuenta(idAccount: indexA);

    if (respuesta != "err_internet_conex") {
      if (respuesta == 'empty') {
        noData = true;
        print('no hay datos');
      } else {
        noData = false;
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
      }
    } else {
      noData = true;
      print('Verifique su conexion a internet');
    }

    return profiles;
  }
}
