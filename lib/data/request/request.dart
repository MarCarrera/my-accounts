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

Future<dynamic> mostrarPagos(
    {required String date1, required String date2}) async {
  var data = {
    'opc': '10',
    'date1': date1,
    'date2': date2,
  };

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
  var data = {'opc': '11', 'idAccount': idAccount};

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

Future<dynamic> mostrarTotalPagoPorMesCuenta(
    {required String date1, required String date2}) async {
  var data = {
    'opc': '12',
    'date1': date1,
    'date2': date2,
  };

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('total pago cuenta: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}

Future<void> agregarPago({
  required String idUser,
  required String idAccount,
  required String paymentDate,
  required String amount,
}) async {
  var data = {
    'opc': '13',
    'idUser': idUser,
    'idAccount': idAccount,
    'paymentDate': paymentDate,
    'amount': amount
  };
  final response = await http.post(
    url,
    body: data,
  );
  if (response.statusCode == 200) {
    print('Pago enviado exitosamente');
  } else {
    print('Error al enviar el pago: ${response.reasonPhrase}');
  }
}

Future<void> eliminarPago({required String idPayment}) async {
  var data = {'opc': '14', 'idPayment': idPayment};
  final response = await http.post(
    url,
    body: data,
  );
  if (response.statusCode == 200) {
    print('Pago eliminado exitosamente');
  } else {
    print('Error al eliminar el pago: ${response.reasonPhrase}');
  }
}

Future<void> actualizarPin(
    {required String idUser, required String pin}) async {
  var data = {'opc': '15', 'idUser': idUser, 'pin': pin};
  final response = await http.post(
    url,
    body: data,
  );
  if (response.statusCode == 200) {
    print('Pin actualizado exitosamente');
  } else {
    print('Error al actualizar el pin: ${response.reasonPhrase}');
  }
}

Future<void> liberarPerfil({required String idUser}) async {
  var data = {
    'opc': '16',
    'idUser': idUser,
  };
  final response = await http.post(
    url,
    body: data,
  );
  if (response.statusCode == 200) {
    print('Perfil liberado exitosamente');
  } else {
    print('Error al liberar el perfil: ${response.reasonPhrase}');
  }
}

Future<void> agregarUsuario(
    {required String idUser,
    required String user,
    required String payment,
    required String amount,
    required String phone,
    required String genre}) async {
  var data = {
    'opc': '17',
    'idUser': idUser,
    'user': user,
    'payment': payment,
    'amount': amount,
    'phone': phone,
    'genre': genre
  };
  final response = await http.post(
    url,
    body: data,
  );
  if (response.statusCode == 200) {
    print('Usuario agregado exitosamente');
  } else {
    print('Error al agregar el usuario: ${response.reasonPhrase}');
  }
}
Future<dynamic> mostrarInfoUsuario(
    {required String idUser}) async {
  var data = {
    'opc': '18',
    'idUser': idUser,
  };

  try {
    final response = await http.post(
      url,
      body: data,
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      //print('total pago cuenta: ${jsonResponse}');
      return jsonResponse;
    }
  } catch (e) {
    return "err_internet_conex";
  }
}
