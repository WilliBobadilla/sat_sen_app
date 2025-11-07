import 'package:sat_sen_app/core/scrappers/scrapper_utils.dart';
import 'package:sat_sen_app/features/wheater_warnings/data/models/alert_model.dart';

abstract class WheaterRemoteSource {
  Future<AlertModel> fetchWheaterAlert();
  Future<List<Map<String, String>>> fetchForecast(String city);
}

class WheaterRemoteSourceImpl implements WheaterRemoteSource {
  final WebScraperService webScraperService;

  WheaterRemoteSourceImpl({required this.webScraperService});

  @override
  Future<List<Map<String, String>>> fetchForecast(String city) async {
    return WebScraperService.fetchForecast(city);
  }

  @override
  Future<AlertModel> fetchWheaterAlert() async {
    return await WebScraperService.fetchAlert() ??
        AlertModel(fecha: '', horaDeEmision: '');
  }
}
