import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUser {
  static final PreferenceUser _instance = PreferenceUser._internal();

  factory PreferenceUser() => _instance;

  PreferenceUser._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // GET y SET

  bool get secondaryColor => _prefs?.getBool('secondaryColor') ?? false;

  set secondaryColor(bool value) {
    _prefs?.setBool('secondaryColor', value);
  }

  int get sex => _prefs?.getInt('sex') ?? 1;

  set sex(int value) {
    _prefs?.setInt('sex', value);
  }

  String get name => _prefs?.getString('name') ?? '';

  set name(String value) {
    _prefs?.setString('name', value);
  }

  // Metodos

  cleanAllPrefs() {
    _prefs?.remove('secondaryColor');
    _prefs?.remove('sex');
    _prefs?.remove('name');
  }
}
