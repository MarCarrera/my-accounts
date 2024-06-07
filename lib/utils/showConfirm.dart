// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ShowConfirm {
  Future<void> showConfirmDialog(BuildContext context) async {
    return await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        //text: 'Se ha eliminado un movimiento.',
        //textColor: Colors.purple.shade300,
        autoCloseDuration: const Duration(seconds: 2),
        showConfirmBtn: false,
        title: 'Movimiento Agregado!',
        titleColor: Colors.purple.shade300);
  }
  Future<void> showConfirmDialog2(BuildContext context) async {
    return await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        //text: 'Se ha eliminado un movimiento.',
        //textColor: Colors.purple.shade300,
        autoCloseDuration: const Duration(seconds: 2),
        showConfirmBtn: false,
        title: 'Abono Agregado!',
        titleColor: Colors.purple.shade300);
  }
}
