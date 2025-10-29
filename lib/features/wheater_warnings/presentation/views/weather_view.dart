import 'package:flutter/material.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/core/constants/myassets.dart';
import 'package:sat_sen_app/core/constants/mysizes.dart';
import 'package:sat_sen_app/core/utils/external_apps_opener_util.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String? _selectedCity;
  final List<String> _cities = [
    'Asunción',
    'Encarnación',
    'Ciudad del Este',
    'Villarrica',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Avisos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: MySizes.genericSeparationItems),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Selecciona una ciudad',
                      // border: OutlineInputBorder(),
                    ),
                    value: _selectedCity,
                    items: _cities.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCity = value);
                    },
                  ),
                  const SizedBox(height: MySizes.genericSeparationItems),

                  const Text(
                    'No hay alertas disponibles.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: MySizes.genericSeparationItems),

                  const Text(
                    'Recomendaciones',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: MySizes.genericSeparationItems / 2),

                  // Recommendation Card with image
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Stack(
                      children: [
                        /*decoration: BoxDecoration(
                          color: Colors.yellow.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),*/
                        // padding: const EdgeInsets.all(16),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Image.asset(
                            MyAssets.backgroundImageOne, // your asset path
                            width: MediaQuery.of(context).size.width / 1.2,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 20,
                          child: Text(
                            'Disfrute de su día.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Para más información:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ExternalAppsOpenerUtil.openWebBrowser(url: kwebUrl);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'VISITE NUESTRA WEB',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
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
