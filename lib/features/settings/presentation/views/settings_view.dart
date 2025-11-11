import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sat_sen_app/core/constants/mysizes.dart';
import 'package:sat_sen_app/core/ui/sat_set_appbar.dart';
import 'package:sat_sen_app/core/constants/constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _phoneController = TextEditingController(
    text: '09',
  );
  String? _selectedDepartment;
  bool _isLoading = false;
  bool _isLoadingDepartment = false;

  final List<String> _departments = kDepartmentsList;

  @override
  void initState() {
    super.initState();
    _loadSavedData();

    // Keep the “09” prefix fixed like Android TextWatcher
    _phoneController.addListener(() {
      if (!_phoneController.text.startsWith('09')) {
        _phoneController.text = '09';
        _phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneController.text.length),
        );
      }
    });
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDepartment = prefs.getString(kDefaultDepartmentPref);
      _phoneController.text = prefs.getString('phone') ?? '09';
    });
  }

  Future<void> _registerUser() async {
    final phone = _phoneController.text.trim();
    final depSms = _selectedDepartment;

    if (!phone.startsWith('09') || phone.length != 10) {
      _showSnackBar('Ingrese un número de teléfono válido');
      return;
    }

    if (depSms == null || depSms.isEmpty) {
      _showSnackBar('Por favor, seleccione un departamento');
      return;
    }

    setState(() => _isLoading = true);
    //TODO: this should be done in the datasource layer!!!!!
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', phone);
      prefs.setString(kDefaultDepartmentPref, depSms);

      final uri = Uri.parse(
        'https://satsen.com.py/registrousuarioapp.php',
      ); // TODO: move to constants
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'telefono': phone, 'departamento': depSms},
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body == 'OK') {
          _showSnackBar('Datos guardados en servidor');
        } else if (body.contains('Usuario ya registrado')) {
          _showSnackBar('Ya estás registrado en ese departamento');
        } else if (body.contains('Datos incompletos')) {
          _showSnackBar('Faltan datos para el registro');
        } else {
          _showSnackBar('Error al guardar en servidor');
        }
      } else {
        _showSnackBar('Error de conexión al servidor');
      }
    } catch (e) {
      debugPrint('Error: $e');
      _showSnackBar('Error de conexión al servidor');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void registerOnlyDepartment() async {
    setState(() => _isLoadingDepartment = true);
    final depSms = _selectedDepartment;
    final prefs = await SharedPreferences.getInstance();
    if (depSms == null || depSms.isEmpty) {
      _showSnackBar('Por favor, seleccione un departamento');
      return;
    }

    prefs.setString(kDefaultDepartmentPref, depSms);
    setState(() => _isLoadingDepartment = false);
    _showSnackBar('Dato de departamento actualizado');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF9800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SatSenAppBar(title: "Configuraciones"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: MySizes.leftRightPadding,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registro para Alertas SMS',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Registrándose podrá recibir alertas SMS dependiendo del departamento en el cual registró.',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Phone input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                hintText: '09XXXXXXXX',
                counterText: '',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF9800)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Department selector
            const Text(
              'Seleccione su Departamento',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedDepartment,
              hint: const Text(
                'Seleccione',
                style: TextStyle(color: Colors.black87),
              ),
              items: _departments.map((String department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() => _selectedDepartment = value);
              },
            ),

            const SizedBox(height: 32),

            // Register button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'REGISTRAR',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoadingDepartment ? null : registerOnlyDepartment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 2,
                ),
                child: _isLoadingDepartment
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'REGISTRAR SOLO DEPARTAMENTO',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
            // Change department button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  /* Navigator.pushNamed(
                    context,
                    '/settings',
                  ); 
                  */
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'AJUSTES',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
