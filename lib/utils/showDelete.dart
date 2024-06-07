// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ShowDelete {
  Future<void> showDeleteDialog(BuildContext context) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      autoCloseDuration: const Duration(seconds: 2),
      showConfirmBtn: false,
      title: 'Movimiento Eliminado!',
      titleColor: Colors.purple.shade300,
    );

    // Esperar 2 segundos antes de cerrar el diálogo
    await Future.delayed(Duration(seconds: 2));
  }
}
