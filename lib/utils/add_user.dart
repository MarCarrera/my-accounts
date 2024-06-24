import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:lottie/lottie.dart';
import '../data/request/request.dart';

class AddDialog extends StatefulWidget {
  final String title;
  final String idUser;
  final TextEditingController userC;
  final TextEditingController amountC;
  final TextEditingController phoneC;
  final TextEditingController paymentC;
  final TextEditingController genreC;
  final bool obscureText;

  const AddDialog({
    super.key,
    this.obscureText = false,
    required this.idUser,
    required this.userC,
    required this.amountC,
    required this.phoneC,
    required this.paymentC,
    required this.genreC,
    required this.title,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddDialogState createState() => _AddDialogState(idUser);
}

class _AddDialogState extends State<AddDialog> {
  late TextEditingController _userC;
  late TextEditingController _amountC;
  late TextEditingController _phoneC;
  late TextEditingController _paymentC;
  late TextEditingController _genreC;

  _AddDialogState(this.idUser);
  final String idUser;

  @override
  void initState() {
    super.initState();
    _userC = TextEditingController(text: widget.userC.text);
    _amountC = TextEditingController(text: widget.amountC.text);
    _phoneC = TextEditingController(text: widget.phoneC.text);
    _paymentC = TextEditingController(text: widget.paymentC.text);
    _genreC = TextEditingController(text: widget.genreC.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Container(
        height: 300,
        child: Column(children: [
          TextFormField(
            controller: _userC,
            keyboardType: TextInputType.text,
            obscureText: widget.obscureText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _amountC,
            keyboardType: TextInputType.number,
            obscureText: widget.obscureText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mónto',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _phoneC,
            keyboardType: TextInputType.number,
            obscureText: widget.obscureText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Teléfono',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _paymentC,
            keyboardType: TextInputType.number,
            obscureText: widget.obscureText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mensualidad',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _genreC,
            keyboardType: TextInputType.text,
            obscureText: widget.obscureText,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Género',
            ),
          ),
        ]),
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
            widget.userC.text = _userC.text;
            widget.amountC.text = _amountC.text;
            widget.phoneC.text = _phoneC.text;
            widget.paymentC.text = _paymentC.text;
            widget.genreC.text = _genreC.text;

            await agregarUsuario(
                idUser: idUser,
                user: widget.userC.text,
                amount: widget.amountC.text,
                phone: widget.phoneC.text,
                payment: widget.paymentC.text,
                genre: widget.genreC.text);

            Navigator.of(context).pop();
            Dialogs.bottomMaterialDialog(
              msg: 'El usuario ha sido agregado exitosamente.',
              title: '¡Agregado!',
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

void showAddDialog({
  required BuildContext context,
  required String title,
  required String idUser,
  required final TextEditingController userC,
  required final TextEditingController amountC,
  required final TextEditingController phoneC,
  required final TextEditingController paymentC,
  required final TextEditingController genreC,
  bool obscureText = false,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddDialog(
          title: title,
          idUser: idUser,
          userC: userC,
          amountC: amountC,
          phoneC: phoneC,
          paymentC: paymentC,
          genreC: genreC);
    },
  );
}
