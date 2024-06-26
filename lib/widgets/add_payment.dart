import 'package:flutter/material.dart';

class AddPayment extends StatelessWidget {
  const AddPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: 520,
        width: 400,
        decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  height: 296,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(164, 217, 235, 252),
                  )),
              SizedBox(
                height: 6,
              ),
              Container(
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(179, 184, 211, 237),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
