
// lib/services/language_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _languageKey = 'selectedLanguage';

  LanguageService(this._prefs);

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    // Add more languages as needed
  };

  String get currentLanguageCode => _prefs.getString(_languageKey) ?? 'en';

  String get currentLanguageName => supportedLanguages[currentLanguageCode] ?? 'English';

  Future<void> setLanguage(String languageCode) async {
    if (supportedLanguages.containsKey(languageCode)) {
      await _prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }
}