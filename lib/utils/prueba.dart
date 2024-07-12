import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/view_model.dart';
import '../data/request/service.dart';
import '../widgets/loading_dots.dart';
import 'constans.dart';

class ProxPagosList extends StatefulWidget {
  const ProxPagosList({super.key});

  @override
  State<ProxPagosList> createState() => _ProxPagosListState();
}

class _ProxPagosListState extends State<ProxPagosList> {
  final HomeService homeService = HomeService();
  late Future<List<ProxPagos>> proxPagos;
  
  @override
  void initState() {
    super.initState();
    proxPagos = homeService.cargarProxPagos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProxPagos>>(
      future: proxPagos,
      builder: (BuildContext context, AsyncSnapshot<List<ProxPagos>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingDots();
        } else if (snapshot.hasError) {
          return _buildErrorWidget('Error al cargar datos');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildErrorWidget('No hay datos \npara mostrar');
        } else {
          final proxPagos = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView.builder(
              itemCount: proxPagos.length,
              itemBuilder: (context, index) {
                final pago = proxPagos[index];
                return ListTile(
                  title: Text('${pago.user}'),
                  subtitle: Text('Fecha de pago: ${pago.payment}\nDías restantes: ${pago.diasRestantes}'),
                  trailing: Text('${pago.idAccount}'),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                color: TColor.orangeLightColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message,
                              style: GoogleFonts.fredoka(
                                fontSize: 26,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 30,
                    left: 200,
                    child: Container(
                      width: 160,
                      child: Image.asset('assets/icons/info.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
