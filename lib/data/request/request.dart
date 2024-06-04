import 'dart:convert';
import 'package:http/http.dart' as http;

final url =
    Uri.parse('https://mariehcarey.000webhostapp.com/api-accounts/consults');
Future<dynamic> mostrarCuentas() async {
  var data = {'opc': '1'};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('Respuesta Api JSON: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> mostrarTodosUsuarios() async {
  var data = {'opc': '2'};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('USUARIUOS DE CUENTA: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<dynamic> mostrarUsuariosPorCuenta({required String idAccount}) async {
  var data = {'opc': '3', 'idAccount': idAccount};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('USUARIUOS DE CUENTA: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}
Future<dynamic> mostrarPagosPorCuenta({required String idAccount}) async {
  var data = {'opc': '10', 'idAccount': idAccount};

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('USUARIUOS DE CUENTA: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}
