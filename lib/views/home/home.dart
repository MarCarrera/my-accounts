import 'package:flutter/material.dart';

import '../../utils/constans.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Cuentas',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Card(),
                  Card(),
                  Card(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Usuarios',
                    style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            CardUser(),
            CardUser(),
            CardUser(),
            CardUser(),
            CardUser()
          ],
        ),
      ),
    );
  }

  Padding CardUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        children: [
          Container(
            height: 140,
            width: 500,
            decoration: BoxDecoration(
                color: TColor.purpleColor,
                borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }

  Padding Card() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 300,
            width: 500,
            decoration: BoxDecoration(
                color: TColor.orangeColor,
                borderRadius: BorderRadius.circular(20)),
          )
        ],
      ),
    );
  }
}
