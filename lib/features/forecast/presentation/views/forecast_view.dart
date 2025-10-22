import 'package:flutter/material.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final forecastList = [
      {
        "day": "Lunes 20 Octubre 2025",
        "description":
            "Fresco a cálido, cielo escasamente nublado, vientos del sureste, luego rotando al noreste.",
        "min": "13°C",
        "max": "28°C",
      },
      {
        "day": "Martes 21 Octubre 2025",
        "description":
            "Fresco a cálido, cielo parcialmente nublado, vientos variables, luego del noreste.",
        "min": "16°C",
        "max": "28°C",
      },
      {
        "day": "Miércoles 22 Octubre 2025",
        "description":
            "Cálido a caluroso, cielo parcialmente nublado, vientos del noreste.",
        "min": "19°C",
        "max": "31°C",
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.orange,
                child: const Text(
                  'SAT_SEN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Pronóstico',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Asunción',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              // Forecast list
              ...forecastList.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Día: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: item["day"]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Descripción: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: item["description"]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mínima ${item["min"]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Máxima ${item["max"]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Yellow card for alerts
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(24),
                child: const Text(
                  'Sin alertas por temperaturas extremas para Asunción en los próximos días.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
