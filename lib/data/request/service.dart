import 'package:flutter/material.dart';

import '../models/view_model.dart';
import 'request.dart';
// Asegúrate de que la ruta es correcta

class ProfileService {
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
