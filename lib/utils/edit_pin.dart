import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:lottie/lottie.dart';
import '../data/request/request.dart';

class EditDialog extends StatefulWidget {
  final String title;
  final String idUser;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const EditDialog({
    super.key,
    required this.title,
    required this.controller,
    required this.keyboardType,
    this.obscureText = false,
    required this.idUser,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditDialogState createState() => _EditDialogState(idUser);
}

class _EditDialogState extends State<EditDialog> {
  late TextEditingController _controller;

  _EditDialogState(this.idUser);
  final String idUser;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Guardar'),
          onPressed: () async {
            widget.controller.text = _controller.text;

            await actualizarPin(idUser: idUser, pin: widget.controller.text);
            Navigator.of(context).pop();
            Dialogs.bottomMaterialDialog(
                                        msg:
                                            'El pin ha sido actualizado exitosamente.',
                                        title: '¡Actualizado!',
                                        color: Colors.white,
                                        lottieBuilder: Lottie.asset(
                                          'assets/js/cong_example.json',
                                          fit: BoxFit.contain,
                                        ),
                                        context: context,
                                      );
                                      
          },
        ),
      ],
    );
  }
}

void showEditDialog({
  required BuildContext context,
  required String title,
  required String idUser,
  required TextEditingController controller,
  required TextInputType keyboardType,
  bool obscureText = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditDialog(
        title: title,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText, idUser: idUser,
      );
    },
  );
}
