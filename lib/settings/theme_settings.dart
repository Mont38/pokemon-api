import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();
  ThemeData get currentTheme => _currentTheme;

  ThemeData temaClaro = ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(primary: Color.fromARGB(206, 251, 147, 27)));
  ThemeData temaOscuro = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(primary: Color.fromARGB(206, 46, 1, 171)));
  ThemeData temaPersonalizado = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(184, 200, 132, 221), secondary: Colors.red));

  ThemeProvider(bool isDark, bool isLight) {
    if (isDark) {
      _currentTheme = temaOscuro;
    } else {
      if (isLight) {
        _currentTheme = temaClaro;
      } else {
        _currentTheme = temaPersonalizado;
      }
    }
  }

  void cambiarTemaOscuro() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_currentTheme == temaClaro || _currentTheme == temaPersonalizado) {
      _currentTheme = temaOscuro;
      sharedPreferences.setBool('is_dark', true);
      sharedPreferences.setBool('is_light', false);
    }
    notifyListeners();
  }

  void cambiarTemaClaro() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_currentTheme == temaOscuro || _currentTheme == temaPersonalizado) {
      _currentTheme = temaClaro;
      sharedPreferences.setBool('is_dark', false);
      sharedPreferences.setBool('is_light', true);
    }
    notifyListeners();
  }

  void cambiarTemaPersonalizado() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_currentTheme == temaClaro || _currentTheme == temaOscuro) {
      _currentTheme = temaPersonalizado;
      sharedPreferences.setBool('is_dark', false);
      sharedPreferences.setBool('is_light', false);
    }
    notifyListeners();
  }
}
