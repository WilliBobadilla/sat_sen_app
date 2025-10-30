import 'dart:developer' as developer;

import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:sat_sen_app/features/wheater_warnings/data/models/alert_model.dart';

class WebScraperService {
  static const String _alertsUrl = "https://www.meteorologia.gov.py/avisos/";
  static const String _forecastUrl =
      "https://www.meteorologia.gov.py/pronostico/";

  /// Fetch the active alert from the official page.
  static Future<AlertModel?> fetchAlert() async {
    try {
      final response = await http.get(Uri.parse(_alertsUrl));

      if (response.statusCode != 200) return null;

      final doc = html_parser.parse(response.body);
      final alertContainer = doc.querySelector("div.entry-content");
      if (alertContainer == null) return null;
      developer.log("✅ Alert data fetched successfully.");
      developer.log(alertContainer.outerHtml);
      // Helper function to find <p> elements by contained text
      String extractParagraphText(String contains, {String? replace}) {
        final paragraphs = alertContainer.querySelectorAll("p");
        for (final p in paragraphs) {
          if (p.text.contains(contains)) {
            var text = p.text;
            if (replace != null) text = text.replaceFirst(replace, "");
            return text.trim();
          }
        }
        return "";
      }

      final fecha = extractParagraphText("Fecha:", replace: "Fecha:").isNotEmpty
          ? extractParagraphText("Fecha:", replace: "Fecha:")
          : "Fecha desconocida";

      final horaDeEmision =
          extractParagraphText(
            "Hora de emisión:",
            replace: "Hora de emisión:",
          ).isNotEmpty
          ? extractParagraphText(
              "Hora de emisión:",
              replace: "Hora de emisión:",
            )
          : "Hora desconocida";

      final descripcion =
          alertContainer
              .querySelector("h3")
              ?.text
              .replaceFirst("Fenómeno esperado:", "")
              .trim() ??
          "Descripción no disponible";

      final descripcionAdicional =
          alertContainer.querySelector("div.col-md-6 p")?.text.trim() ??
          "Sin descripción adicional";

      final zonaCobertura =
          extractParagraphText(
            "Zona de cobertura:",
            replace: "Zona de cobertura:",
          ).isNotEmpty
          ? extractParagraphText(
              "Zona de cobertura:",
              replace: "Zona de cobertura:",
            )
          : "Zona no especificada";

      final departamentosRaw = extractParagraphText(
        "Departamentos afectados:",
        replace: "Departamentos afectados:",
      );
      final departamentosAfectados = departamentosRaw.isNotEmpty
          ? departamentosRaw
                .split(",")
                .map((e) => e.trim().toLowerCase())
                .toList()
          : <String>[];

      return AlertModel(
        fecha: fecha,
        horaDeEmision: horaDeEmision,
        descripcion: descripcion,
        descripcionAdicional: descripcionAdicional,
        zonaCobertura: zonaCobertura,
        departamentosAfectados: departamentosAfectados,
      );
    } catch (e) {
      print("❌ Error fetching alert: $e");
      return null;
    }
  }

  /// Fetch forecast data for a specific city
  static Future<List<Map<String, String>>> fetchForecast(
    String cityName,
  ) async {
    try {
      final cityId = cityName
          .toLowerCase()
          .replaceAll(" ", "_")
          .replaceAll("á", "a")
          .replaceAll("é", "e")
          .replaceAll("í", "i")
          .replaceAll("ó", "o")
          .replaceAll("ú", "u")
          .replaceAll("ñ", "n");

      final response = await http.get(Uri.parse(_forecastUrl));
      if (response.statusCode != 200) {
        return [
          {"error": "No se pudo conectar con el servidor."},
        ];
      }

      final doc = html_parser.parse(response.body);
      final cityDiv = doc.querySelector("div#$cityId");
      print("City Div: ${cityDiv?.outerHtml}");
      if (cityDiv == null) {
        return [
          {"error": "No se encontró información para $cityName."},
        ];
      }

      final days = cityDiv.querySelectorAll("h5");
      final descriptions = cityDiv.querySelectorAll("div.pronostico--content");
      final temps = cityDiv.querySelectorAll("div.col-sm-3.col-xs-4");

      final List<Map<String, String>> forecast = [];

      for (var i = 0; i < days.length; i++) {
        final day = days[i].text.trim();
        final description = i < descriptions.length
            ? descriptions[i].text.trim()
            : "Sin descripción";
        final minTemp = i * 2 < temps.length ? temps[i * 2].text.trim() : "N/A";
        final maxTemp = i * 2 + 1 < temps.length
            ? temps[i * 2 + 1].text.trim()
            : "N/A";

        forecast.add({
          "day": day,
          "description": description,
          "min": minTemp,
          "max": maxTemp,
        });
      }

      return forecast;
    } catch (e) {
      print("❌ Error fetching forecast: $e");
      return [
        {"error": "Error al obtener el pronóstico: $e"},
      ];
    }
  }
}
