import 'package:flutter/material.dart';
import 'package:sat_sen_app/features/boletin/presentation/pages/boletin_page.dart';
import 'package:sat_sen_app/features/forecast/presentation/pages/forecast_page.dart';
import 'package:sat_sen_app/features/settings/presentation/pages/settings_page.dart';
import 'package:sat_sen_app/features/wheater_warnings/presentation/pages/weather_page.dart';

class MainActivityPage extends StatefulWidget {
  const MainActivityPage({super.key});

  @override
  State<MainActivityPage> createState() => _MainActivityPageState();
}

class _MainActivityPageState extends State<MainActivityPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    WeatherPage(),
    ForecastPage(),
    BoletinPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        iconSize: 18,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_outlined),
            label: 'Avisos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_outlined),
            label: 'Pronóstico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Boletín',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
