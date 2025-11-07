import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class BoletinScraper {
  static const String url = "https://www.meteorologia.gov.py/boletin-especial";

  static Future<Map<String, String>> fetchBoletin() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
          "Error al obtener el boletín (status ${response.statusCode})",
        );
      }

      final document = parser.parse(response.body);

      // Extract values with similar logic to Kotlin version
      final evento =
          document
              .querySelectorAll(".entry-content h2 span")
              .lastOrNull
              ?.text
              ?.trim() ??
          "No disponible";

      final fecha =
          document
              .querySelectorAll(".entry-content h3 span")
              .firstOrNull
              ?.text
              ?.trim() ??
          "No disponible";

      var descripcion =
          document
              .querySelector(".entry-content div[align=justify]")
              ?.text
              ?.trim() ??
          "No disponible";

      // Clean description
      descripcion = descripcion
          .replaceAll(RegExp(r'BE_\w+_\d+'), '')
          .replaceAll(RegExp(r'Puede mantenerse.*', caseSensitive: false), '')
          .trim();

      return {"evento": evento, "fecha": fecha, "descripcion": descripcion};
    } catch (e) {
      print(" Error fetching boletín: $e");
      return {
        "evento": "Error",
        "fecha": "Error",
        "descripcion": "No se pudo cargar el boletín.",
      };
    }
  }
}

// Helper to safely get the first or last element of a list
extension IterableSafeAccess<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
  E? get lastOrNull => isEmpty ? null : last;
}
