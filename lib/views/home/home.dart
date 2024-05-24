import 'package:flutter/material.dart';

import '../../utils/constans.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.orangeColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 200, horizontal: 40),
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: 600,
                  decoration: BoxDecoration(
                      color: TColor.orangeColor,
                      borderRadius: BorderRadius.circular(20)),
                )
              ],
            ),
          ),
        ));
  }
}
