
// lib/services/currency_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CurrencyService extends ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _currencyKey = 'selectedCurrency';

  CurrencyService(this._prefs);

  static const Map<String, String> supportedCurrencies = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    // Add more currencies as needed
  };

  String get currentCurrencyCode => _prefs.getString(_currencyKey) ?? 'USD';

  String get currentCurrencySymbol => supportedCurrencies[currentCurrencyCode] ?? '\$';

  Future<void> setCurrency(String currencyCode) async {
    if (supportedCurrencies.containsKey(currencyCode)) {
      await _prefs.setString(_currencyKey, currencyCode);
      notifyListeners();
    }
  }
}