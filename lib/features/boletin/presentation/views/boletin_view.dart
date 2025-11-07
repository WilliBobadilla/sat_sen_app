import 'package:flutter/material.dart';
import 'package:sat_sen_app/core/scrappers/boletin_scrapper.dart';
import 'package:sat_sen_app/core/ui/sat_set_appbar.dart';

class BoletinView extends StatefulWidget {
  const BoletinView({super.key});

  @override
  State<BoletinView> createState() => _BoletinViewState();
}

class _BoletinViewState extends State<BoletinView> {
  late Future<Map<String, String>> boletinFuture;

  @override
  void initState() {
    super.initState();
    boletinFuture = BoletinScraper.fetchBoletin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SatSenAppBar(title: "Boletín"),
      body: FutureBuilder<Map<String, String>>(
        future: boletinFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9800)),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'No se pudo cargar el boletín.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Boletín Especial',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Evento previsto: ${data["evento"]}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                /*Text(
                  'Fecha: ${data["fecha"]}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),*/
                const SizedBox(height: 16),
                Text(
                  data["descripcion"] ?? 'Sin descripción',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Se recomienda seguir las indicaciones de la SEN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
