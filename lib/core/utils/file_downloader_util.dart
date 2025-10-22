import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DatabaseDownloader {
  static Future<File> downloadDatabase(String fileId) async {
    // Direct download link
    final url = "https://drive.google.com/uc?export=download&id=$fileId";

    // Get application documents directory
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = "${dir.path}/mydatabase.db";

    // Download
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final file = File(dbPath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception("Failed to download DB file: ${response.statusCode}");
    }
  }
}
