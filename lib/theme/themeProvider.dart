import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool currentTheme = false;

  ThemeData buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      backgroundColor: Colors.white,
        primaryTextTheme: const TextTheme(caption: TextStyle(color: Colors.black)),
        brightness: Brightness.light,
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black));
  }

  ThemeData buildDarkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      brightness: Brightness.dark,
              primaryTextTheme: const TextTheme(caption: TextStyle(color: Colors.white)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: Colors.amber[800], // Button color
          onPrimary: Colors.black, // Text color
        )),
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        scaffoldBackgroundColor: Colors.grey[900], //color ng scaffold
        iconTheme: const IconThemeData(color: Colors.white));
  }

  ThemeData get themeMode {
    if (!currentTheme) {
      return buildLightTheme();
    } else {
      return buildDarkTheme();
    }
  }

  initialize() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    currentTheme = _prefs.getBool('themeVal') ?? false;
    notifyListeners();
  }

  changeTheme(bool fromWidget) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool('themeVal', fromWidget);
    currentTheme = fromWidget;
    notifyListeners();
  }
}
