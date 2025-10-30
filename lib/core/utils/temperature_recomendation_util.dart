import 'package:sat_sen_app/features/forecast/domain/entities/forecast_day_entity.dart';

class TemperatureRecommendationUtil {
  static String generateRecommendations(
    List<ForecastDayEntity> forecast,
    String city,
  ) {
    final coldDays = <Map<String, dynamic>>[];
    final hotDays = <Map<String, dynamic>>[];
    final stormDays = <Map<String, dynamic>>[];

    double? parseTemp(String? t) {
      if (t == null || t.isEmpty) return null;
      final cleaned = t.replaceAll(RegExp(r'[^0-9.-]'), '');
      return double.tryParse(cleaned);
    }

    for (var day in forecast) {
      final min = parseTemp(day.minTemp);
      final max = parseTemp(day.maxTemp);
      final desc = day.description.toLowerCase();

      if (min != null && min < 8) {
        coldDays.add({'day': day.day, 'temp': min});
      }
      if (max != null && max > 35) {
        hotDays.add({'day': day.day, 'temp': max});
      }
      if (desc.contains('tormenta')) {
        stormDays.add({'day': day.day});
      }
    }

    final recommendations = StringBuffer();

    if (coldDays.isNotEmpty) {
      final daysStr = coldDays
          .map((e) => "- <b>${e['day']}</b>: ${e['temp']}°C")
          .join("<br>");
      recommendations.writeln("""
<b>¡Atención $city, ola de frío!</b><br>
Se esperan temperaturas mínimas muy bajas:<br>
$daysStr<br><br>
<b>Recomendaciones de la SEN:</b><br>
- Utilizar calzados cerrados. Mantén manos, cuello y cabeza protegidas.<br>
- Evitar exponerse a bajas temperaturas.<br>
- Evitar usar braceros en lugares cerrados.<br>
- Consumir bebidas calientes para mantener la temperatura corporal.<br>
- Evitar salir de tu casa a menos que sea absolutamente necesario.<br><br>
""");
    }

    if (hotDays.isNotEmpty) {
      final daysStr = hotDays
          .map((e) => "- <b>${e['day']}</b>: ${e['temp']}°C")
          .join("<br>");
      recommendations.writeln("""
<b>¡Atención $city, ola de calor!</b><br>
Se esperan temperaturas máximas muy altas:<br>
$daysStr<br><br>
<b>Recomendaciones de la SEN:</b><br>
- Tomar mucha agua.<br>
- Evitar el exceso de bebidas con cafeína, alcohol o azúcar.<br>
- Usar ropa ligera y que deje transpirar.<br>
- Evitar exponerse al sol entre las 10:00hr y las 17:00hr.<br>
- Consumir comidas ligeras y mucha fruta.<br><br>
""");
    }

    if (stormDays.isNotEmpty) {
      final daysStr = stormDays.map((e) => "- <b>${e['day']}</b>").join("<br>");
      recommendations.writeln("""
<b>¡Atención $city, posible tormenta!</b><br>
Se pronostican tormentas para los siguientes días:<br>
$daysStr<br><br>
<b>Recomendaciones de la SEN:</b><br>
- Suspender actividades al aire libre.<br>
- Conducir con cuidado en zonas de raudales.<br>
- Evitar refugiarse bajo árboles.<br>
- Mantenerse alejado de postes de tendido eléctricos, alambrados y cercas metálicas.<br>
- Salir solo en casos de urgencias.<br><br>
""");
    }

    if (recommendations.isEmpty) {
      return "Sin alertas por temperaturas extremas para $city en los próximos días.";
    }

    return recommendations.toString().trim();
  }
}
