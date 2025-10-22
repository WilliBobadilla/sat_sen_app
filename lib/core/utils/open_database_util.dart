import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sat_sen_app/core/utils/file_downloader_util.dart';

Future<Database> openMyDatabase(String fileId) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, "mydatabase.db");

  if (!await File(path).exists()) {
    // If not downloaded yet, you can download here first
    await DatabaseDownloader.downloadDatabase(fileId);
  }

  return await openDatabase(path);
}
