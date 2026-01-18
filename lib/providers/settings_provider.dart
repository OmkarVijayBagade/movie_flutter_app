import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _showAdultContent = false;
  bool _enableHighQualityImages = true;
  bool _autoLoadMoreMovies = false;
  int _selectedColorIndex = 0;

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  ThemeMode get themeMode => _themeMode;
  bool get showAdultContent => _showAdultContent;
  bool get enableHighQualityImages => _enableHighQualityImages;
  bool get autoLoadMoreMovies => _autoLoadMoreMovies;
  int get selectedColorIndex => _selectedColorIndex;
  Color get selectedColor => colors[_selectedColorIndex];

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
    _showAdultContent = prefs.getBool('show_adult_content') ?? false;
    _enableHighQualityImages = prefs.getBool('high_quality_images') ?? true;
    _autoLoadMoreMovies = prefs.getBool('auto_load_more') ?? false;
    _selectedColorIndex = prefs.getInt('selected_color_index') ?? 0;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setShowAdultContent(bool value) async {
    _showAdultContent = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_adult_content', value);
    notifyListeners();
  }

  Future<void> setEnableHighQualityImages(bool value) async {
    _enableHighQualityImages = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('high_quality_images', value);
    notifyListeners();
  }

  Future<void> setAutoLoadMoreMovies(bool value) async {
    _autoLoadMoreMovies = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_load_more', value);
    notifyListeners();
  }

  Future<void> setSelectedColorIndex(int index) async {
    _selectedColorIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_color_index', index);
    notifyListeners();
  }
}