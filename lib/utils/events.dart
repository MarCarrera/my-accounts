import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Events {
  ///final String? idAccount;

  /*Events(this.idAccount);
  final String idAccount;*/

  Future<void> saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);

    await Share.shareFiles([image.path]);
  }

  Future<void> shareMessageUser(String phone) async {
    //final directory = await getApplicationDocumentsDirectory();
    //final image = File('${directory.path}/acceso.png');
    //final phoneNumber = '+52$phone';
    const phoneNumber = '+522361082838';
    //image.writeAsBytesSync(bytes);

    // Mensaje que contiene la imagen
    String message =
        '¡Hola! Éste es un recordatorio del pago de la mensualidad de Netflix, porfavor...';

    // Combinar el mensaje y la imagen
    //String combinedMessage = '$message ${image.path}';
    // URL de WhatsApp con el número de teléfono y mensaje
    String whatsappUrl =
        'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    // Abrir el enlace en WhatsApp
    await launch(whatsappUrl);

    //await Share.shareFiles([image.path]);
  }
}
