import 'dart:ffi';
import 'package:acounts_control/data/request/request.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPayment extends StatefulWidget {
  const AddPayment(
      {super.key,
      required this.idUser,
      required this.idAccount,
      required this.token});
  final String token;
  final String idUser;
  final String idAccount;

  @override
  State<AddPayment> createState() => _PruebaState(idUser, idAccount, token);
}

class _PruebaState extends State<AddPayment> {
  _PruebaState(this.idUser, this.idAccount, this.token);
  final String token;
  final String idUser;
  final String idAccount;

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      idUser: idUser,
      idAccount: idAccount,
      token: token,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.idUser,
      required this.idAccount,
      required this.token});
  final String token;
  final String idUser;
  final String idAccount;
  @override
  State<MyHomePage> createState() => _MyHomePageState(idUser, idAccount, token);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.idUser, this.idAccount, this.token);
  final String token;
  final String idUser;
  final String idAccount;

  final controller = BoardDateTimeController();
  TextEditingController pagoC = TextEditingController();
  DateTimePickerType? opened;
  final List<GlobalKey<_ItemWidgetState>> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  final textController = BoardDateTimeTextController();

  DateTime? selectedDate; // Variable para almacenar la fecha seleccionada

  @override
  Widget build(BuildContext context) {
    return BoardDateTimeBuilder<BoardDateTimeCommonResult>(
      controller: controller,
      resizeBottom: true,
      options: const BoardDateTimeOptions(
        boardTitle: 'Fecha de Pago',
        languages: BoardPickerLanguages.en(),
      ),
      builder: (context) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 250),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 370,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 4, 104, 98),
                    ),
                    child: ItemWidget(
                      key: keys[1],
                      type: DateTimePickerType.date,
                      controller: controller,
                      onOpen: (type) => opened = type,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 370,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: pagoC,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          prefixIcon: Icon(
                            Icons.monetization_on_rounded,
                            color: Color.fromRGBO(47, 125, 121, 0.9),
                          ),
                          hintText: '00.0',
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      var fechaPagoApi;
                      if (selectedDate != null) {
                        fechaPagoApi =
                            BoardDateFormat('yyyy-MM-dd').format(selectedDate!);
                      } else {
                        var currentDate = DateTime.now();
                        fechaPagoApi =
                            BoardDateFormat('yyyy-MM-dd').format(currentDate!);
                      }
                      await agregarPago(
                          idUser: idUser,
                          idAccount: idAccount,
                          paymentDate: fechaPagoApi,
                          amount: pagoC.text);
                      await enviarNotificacion(
                        topic: 'tema1',
                        title: '¡Pago Agregado!',
                        body: 'Se ha agregado un nuevo pago de mensualidad.',
                        fecha: 'Fecha de pago',
                      );
                      if (mounted) {
                        Navigator.of(context).pop();
                        Dialogs.bottomMaterialDialog(
                          msg: 'Pago agregado exitosamente.',
                          title: '¡Agregado!',
                          color: Colors.white,
                          lottieBuilder: Lottie.asset(
                            'assets/js/cong_example.json',
                            fit: BoxFit.contain,
                          ),
                          context: context,
                        );
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
      onResult: (val) {},
      onChange: (val) {
        int index = -1;
        if (opened == DateTimePickerType.datetime) {
          index = 0;
        } else if (opened == DateTimePickerType.date) {
          index = 1;
        } else if (opened == DateTimePickerType.time) {
          index = 2;
        }
        if (index >= 0) keys[index].currentState?.update(val);
      },
    );
  }
}

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    super.key,
    required this.type,
    required this.controller,
    required this.onOpen,
    required this.onDateSelected, // Nuevo parámetro
  });

  final DateTimePickerType type;
  final BoardDateTimeController controller;
  final void Function(DateTimePickerType type) onOpen;
  final void Function(DateTime date) onDateSelected; // Nuevo parámetro

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  DateTime d = DateTime.now();

  void update(DateTime date) {
    //print('Fecha Seleccionada: $date');
    setState(() {
      d = date;
    });
    widget.onDateSelected(date); // Llamada al nuevo callback
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          widget.onOpen(widget.type);
          widget.controller.open(widget.type, d);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Material(
                color: color,
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 36,
                  width: 36,
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  BoardDateFormat(format).format(d),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get title {
    switch (widget.type) {
      case DateTimePickerType.date:
        return 'Fecha';
      case DateTimePickerType.datetime:
        return 'DateTime';
      case DateTimePickerType.time:
        return 'Time';
    }
  }

  IconData get icon {
    switch (widget.type) {
      case DateTimePickerType.date:
        return Icons.date_range_rounded;
      case DateTimePickerType.datetime:
        return Icons.date_range_rounded;
      case DateTimePickerType.time:
        return Icons.schedule_rounded;
    }
  }

  Color get color {
    switch (widget.type) {
      case DateTimePickerType.date:
        return Color.fromRGBO(47, 125, 121, 0.9);
      case DateTimePickerType.datetime:
        return Colors.orange;
      case DateTimePickerType.time:
        return Colors.pink;
    }
  }

  String get format {
    switch (widget.type) {
      case DateTimePickerType.date:
        return 'yyyy/MM/dd';
      case DateTimePickerType.datetime:
        return 'yyyy/MM/dd HH:mm';
      case DateTimePickerType.time:
        return 'HH:mm';
    }
  }
}

class ModalItem extends StatefulWidget {
  const ModalItem({super.key});

  @override
  State<ModalItem> createState() => _ModalItemState();
}

class _ModalItemState extends State<ModalItem> {
  DateTime d = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final result = await showBoardDateTimePicker(
            context: context,
            pickerType: DateTimePickerType.datetime,
            options: const BoardDateTimeOptions(
              languages: BoardPickerLanguages.en(),
              startDayOfWeek: DateTime.sunday,
              pickerFormat: PickerFormat.ymd,
              boardTitle: 'Board Picker',
              pickerSubTitles: BoardDateTimeItemTitles(year: 'year'),
            ),
            onResult: (val) {},
          );
          if (result != null) {
            setState(() {
              d = result;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                child: const SizedBox(
                  height: 36,
                  width: 36,
                  child: Center(
                    child: Icon(
                      Icons.open_in_browser_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  BoardDateFormat('yyyy/MM/dd HH:mm').format(d),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                'Show Dialog',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
