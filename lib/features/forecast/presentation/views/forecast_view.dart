import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/core/constants/mysizes.dart';
import 'package:sat_sen_app/core/ui/sat_set_appbar.dart';
import 'package:sat_sen_app/features/forecast/presentation/cubit/forecast_form_cubit.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SatSenAppBar(title: "Pronóstico"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: MySizes.leftRightPadding,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Pronóstico',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BlocBuilder<ForecastFormCubit, ForecastFormState>(
                builder: (context, state) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Selecciona una ciudad',
                      // border: OutlineInputBorder(),
                    ),
                    value: state.cityName ?? kDefaultCity,
                    items: kMainCities.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (value) {
                      context.read<ForecastFormCubit>().changeCityName(value!);
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              BlocBuilder<ForecastFormCubit, ForecastFormState>(
                builder: (context, state) {
                  if (state.forecastData != null) {
                    final forecastData = state.forecastData!.forecastData;
                    return Column(
                      children: forecastData.map<Widget>((item) {
                        return _ForecastCard(
                          day: item["day"] ?? "",
                          description: item["description"] ?? "",
                          min: item["min"] ?? "",
                          max: item["max"] ?? "",
                        );
                      }).toList(),
                    );
                  }
                  return Container();
                },
              ),

              // Forecast lis
              const SizedBox(height: 16),
              BlocBuilder<ForecastFormCubit, ForecastFormState>(
                builder: (context, state) {
                  if (state.recommendation != null) {
                    return _RecommendationCard(
                      day: '',
                      description:
                          state.recommendation ?? kSinRecomendacioensMessage,
                    );
                  }
                  return _RecommendationCard(
                    day: '',
                    description:
                        state.recommendation ?? kSinRecomendacioensMessage,
                  );
                },
              ),

              // Yellow card for alerts
            ],
          ),
        ),
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final String day;
  final String description;
  final String min;
  final String max;

  const _ForecastCard({
    super.key,
    required this.day,
    required this.description,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                TextSpan(text: day), //item["day"]),
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
                TextSpan(text: description), //item["description"]),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            min.trim().replaceAll('\n', ''), //item["min"] ,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(
            max.trim().replaceAll('\n', ''), //item["max"] ,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String day;
  final String description;

  const _RecommendationCard({
    super.key,
    required this.day,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow.shade700,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Html(data: description),
    );
  }
}
