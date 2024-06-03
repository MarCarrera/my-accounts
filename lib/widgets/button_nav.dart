import 'package:acounts_control/views/home/home.dart';
import 'package:acounts_control/views/pays_account.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../utils/constans.dart';


class ButtonNav extends StatefulWidget {
  const ButtonNav({super.key, required this.indexColor});

  final int indexColor;

  @override
  State<ButtonNav> createState() => _ButtonNavState(indexColor: indexColor);
}

class _ButtonNavState extends State<ButtonNav> {
  late int indexColor;
  _ButtonNavState({required this.indexColor});

  List Screen = [
    const Home(),
    const PaysAccount(),
    const Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: TColor.backgroundColor,
      body: Screen[indexColor],
      bottomNavigationBar: BottomAppBar(
        color: TColor.backgroundColor,
        shape: CircularNotchedRectangle(),
        child: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: CustomNavigationBar(
              iconSize: 30,
              selectedColor: Color.fromARGB(255, 11, 57, 54),
              strokeColor: Colors.white,
              unSelectedColor: Color.fromARGB(255, 255, 255, 255),
              backgroundColor: TColor.greenColor,
              borderRadius: Radius.circular(24),
              blurEffect: true,
              opacity: 0.5,
              items: [
                CustomNavigationBarItem(icon: Icon(Icons.home)),
                CustomNavigationBarItem(icon: Icon(Icons.note_alt)),
              ],
              currentIndex: indexColor,
              onTap: (index) {
                setState(() {
                  indexColor = index;
                });
              },
              isFloating: true,
            )),
      ),
    );
  }
}
