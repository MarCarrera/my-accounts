import 'package:acounts_control/data/request/service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import '../data/models/view_model.dart';
import '../utils/shared_data_profile.dart';
import 'loading_dots.dart';

class InfoCardUser extends StatefulWidget {
  const InfoCardUser({super.key, required this.idUser});
  final String idUser;

  @override
  State<InfoCardUser> createState() => _InfoCardUserState();
}

class _InfoCardUserState extends State<InfoCardUser> {
  final HomeService homeService = HomeService();
  late Future<List<InfoUser>> info;

  @override
  void initState() {
    super.initState();
    info = homeService.obtenerInfoUser(widget.idUser);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/cinema.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(164, 217, 235, 252),
              ),
              child: FutureBuilder<List<InfoUser>>(
                future: info,
                builder: (BuildContext context,
                    AsyncSnapshot<List<InfoUser>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingDots();
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Stack(
                        children: [
                          Text('Sin datos'),
                        ],
                      ),
                    );
                  } else {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No hay datos que mostrar.');
                    } else {
                      final infoCard = snapshot.data!.toList();
                      return ListView.builder(
                          itemCount: infoCard.length,
                          itemBuilder: (context, index) {
                            final infoCardUser = infoCard[index];
                            return Column(
                              children: [
                                Text('Cuenta: ${infoCardUser.account}',
                                    style: GoogleFonts.fredoka(
                                        fontSize: 22, color: Colors.black87)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Contraseña: ${infoCardUser.password}',
                                    style: GoogleFonts.fredoka(
                                        fontSize: 22, color: Colors.black87)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Usuario: ${infoCardUser.letter.toUpperCase()}',
                                    style: GoogleFonts.fredoka(
                                        fontSize: 22, color: Colors.black87)),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Pin: ${infoCardUser.pin}',
                                    style: GoogleFonts.fredoka(
                                        fontSize: 22, color: Colors.black87)),
                              ],
                            );
                          });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
