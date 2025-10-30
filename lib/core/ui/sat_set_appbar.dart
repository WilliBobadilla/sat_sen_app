import 'package:flutter/material.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:sat_sen_app/core/utils/external_apps_opener_util.dart';

class SatSenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  //final bool showLogo;

  const SatSenAppBar({super.key, this.title = 'SAT_SEN'});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFF9800), // orange tone
      elevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            ExternalAppsOpenerUtil.openWebBrowser(url: kwebUrl);
            // Example: open website
            // launchUrl(Uri.parse('https://www.sen.gov.py'));
          },
          icon: const Icon(Icons.public, color: Colors.white),
          tooltip: 'Sitio web SEN',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
