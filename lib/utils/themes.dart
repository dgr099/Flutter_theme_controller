import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  late bool _isDark; //booleano para saber si es oscuro o no
  late Color _mainColor; //color de enfasis
  late MyThemePreferences
      _preferences; //theme preferences del usuario para mantener las preferencias
  late ThemeData themeData;
  bool get isDark => _isDark;
  var mapTheme = {
    Color(0xFF643B7D): {"Dark": 0.25, "Light": 0.15}
  };

  ThemeManager() {
    _isDark = true;
    // ignore: prefer_const_constructors
    _mainColor = Color(0xFF643B7D);
    _preferences = MyThemePreferences();
    themeData = ThemeData.dark();
    getTypePreferences();
    getColorPreferences();
    themeData = constructTheme(_mainColor, _isDark);
    notifyListeners();
  }
  ThemeData constructTheme(Color color, bool type) {
    return type
        ? ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor:
                darken(color, mapTheme[color]?["Dark"] ?? 0.35),
            primaryColor: const Color.fromARGB(255, 255, 255, 255),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(color),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))))),
          )
        : ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor:
                lighten(color, mapTheme[color]?["Light"] ?? 0.20),
            primaryColor: Color.fromARGB(145, 0, 0, 0),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 0, 0)),
                    backgroundColor: MaterialStateProperty.all<Color>(color),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))))),
          );
  }

  void changeColor(int value) {
    _mainColor = Color(value);
    _preferences.setThemeColor(_mainColor);
    themeData = constructTheme(_mainColor, _isDark);
    notifyListeners();
  }

  void changeType() {
    _isDark = !_isDark;
    _preferences.setThemeType(_isDark);
    themeData = constructTheme(_mainColor, _isDark);
    notifyListeners();
  }

  getTypePreferences() async {
    _isDark = await _preferences.getThemeType();
  }

  getColorPreferences() async {
    _mainColor = await _preferences.getThemeColor();
  }
}

//clase para el control de temas dentro del shared preferences
class MyThemePreferences {
  // ignore: constant_identifier_names
  static const THEME_TYPE_KEY = "theme_type_key";
  // ignore: constant_identifier_names
  static const THEME_MAIN_COLOR = "theme_main_color";

  setThemeType(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(THEME_TYPE_KEY, value);
  }

  getThemeType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(THEME_TYPE_KEY) ?? false;
  }

  getThemeColor() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // ignore: prefer_const_constructors
    return sharedPreferences.getBool(THEME_MAIN_COLOR) ?? Color(0xFF643B7D);
  }

  setThemeColor(Color color) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(THEME_MAIN_COLOR, color.value);
  }
}

ThemeData themeAppDark = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darken(const Color(0xFF643B7D), 0.35),
  primaryColor: const Color.fromARGB(255, 255, 255, 255),
);

/*función para hacer un color más oscuro*/
Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

/*función para hacer un color más claro*/
Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}
