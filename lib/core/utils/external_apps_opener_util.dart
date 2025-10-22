import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart' as UrlLauncher;

class ExternalAppsOpenerUtil {
  static void openCallApp({required String phoneNumber}) async {
    UrlLauncher.launchUrlString("tel://$phoneNumber");
  }

  static void openWhatsappApp({
    required String phoneNumber,
    required String message,
  }) async {
    var androidUrl = "whatsapp://send?phone=$phoneNumber&text=$message";
    var iosUrl = "https://wa.me/$phoneNumber?text=${Uri.parse(message)}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      throw Exception('WhatsApp is not installed.');
      // EasyLoading.showError('WhatsApp is not installed.');
    }
  }

  static void openMapsApp({
    required String latitude,
    required String longitude,
  }) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw Exception('Could not open the map.');
    }
  }

  static void openEmailApp({required String email}) async {
    final Uri params = Uri(scheme: 'mailto', path: email);
    String url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Could not open the email app.');
    }
  }

  static void openWebBrowser({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open the web browser.');
    }
  }
}
