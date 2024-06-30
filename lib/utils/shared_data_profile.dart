import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/info_card.dart';
import 'events.dart';


/*class SharedDataProfile{
  Future<void> sharedDataProfile(
    BuildContext context,
    ScreenshotController ctlScreen,
    String idUser
  )async{
    final imageDataCard = await ctlScreen.captureFromWidget(

      InfoCardUser(idUser: idUser,)); 
      print("shared data profile");

      return await Events().saveAndShare(imageDataCard);     
  }
}*/

class SharedDataProfile {
  Future<void> sharedDataProfile(
    BuildContext context,
    ScreenshotController ctlScreen,
    String idUser,
  ) async {
    final imageDataCard = await ctlScreen.captureFromWidget(
      MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              body: Center(
                child: ScaffoldMessenger(
                  child: InfoCardUser(idUser: idUser),
                ),
              ),
            ),
          ),
        ),
      ),
      delay: Duration(milliseconds: 100), // Opcional: puede ayudar a esperar que el widget se renderice completamente
    );
    print("shared data profile");

    return await Events().saveAndShare(imageDataCard);
  }
}




