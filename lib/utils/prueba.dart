import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int month = 6, year = 2024;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Month Picker Demo'),
      ),
      body: 
      
      
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  showMonthPicker(context, onSelected: (month, year) {
                    if (kDebugMode) {
                      print('Selected month: $month, year: $year');
                    }
                    setState(() {
                      this.month = month;
                      this.year = year;
                    });
                  },
                      initialSelectedMonth: month,
                      initialSelectedYear: year,
                      firstEnabledMonth: 3,
                      lastEnabledMonth: 10,
                      firstYear: 2000,
                      //size: const Size(520, 250),
                      lastYear: 2035,
                      selectButtonText: 'OK',
                      cancelButtonText: 'Cancel',
                      highlightColor: Colors.purple,
                      textColor: Colors.black,
                      contentBackgroundColor: Colors.white,
                      dialogBackgroundColor: Colors.grey[200]);
                },
                child: const Text('Ver pagos por mes')),
            Text('Mes seleccionado: $month, año: $year')
          ],
        ),
      ),
    );
  }
}
