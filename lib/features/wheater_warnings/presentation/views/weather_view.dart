import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/core/constants/myassets.dart';
import 'package:sat_sen_app/core/constants/mysizes.dart';
import 'package:sat_sen_app/core/ui/sat_set_appbar.dart';
import 'package:sat_sen_app/core/utils/external_apps_opener_util.dart';
import 'package:sat_sen_app/features/wheater_warnings/domain/entities/alert_entity.dart';
import 'package:sat_sen_app/features/wheater_warnings/presentation/cubit/weather_alert_cubit.dart';
import 'package:sat_sen_app/features/wheater_warnings/presentation/cubit/wheater_alert_form_cubit.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String? _selectedCity;
  final List<String> _departments = kDepartmentsList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SatSenAppBar(title: "Avisos"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  BlocBuilder<WheaterAlertFormCubit, WheaterAlertFormState>(
                    builder: (context, state) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Selecciona una ciudad',
                          // border: OutlineInputBorder(),
                        ),
                        value: state.departmentName ?? _departments[0],
                        items: _departments.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (value) {
                          context
                              .read<WheaterAlertFormCubit>()
                              .setDepartmentName(value!);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: MySizes.genericSeparationItems),
                  BlocBuilder<WeatherAlertCubit, WeatherAlertState>(
                    builder: (context, state) {
                      if (state is WeatherAlertLoaded) {
                        return _BodyWidget(alert: state.alert);
                      }
                      return const Text(
                        'No hay alertas disponibles.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      );
                    },
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

class _BodyWidget extends StatelessWidget {
  final AlertEntity alert;

  const _BodyWidget({Key? key, required this.alert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.alert.descripcion ?? 'No hay alertas disponibles.....',
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
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
