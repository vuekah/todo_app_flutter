import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleSupport {
  static List<Locale> localeSupport = [const Locale('vi'), const Locale('en')];
}

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ??
        LocaleSupport.localeSupport.last.toString();
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocale = _locale;

    final newLocale = (currentLocale == LocaleSupport.localeSupport.first)
        ? LocaleSupport.localeSupport.last
        : LocaleSupport.localeSupport.first;

    await prefs.setString('language_code', newLocale.languageCode);

    _locale = Locale(newLocale.languageCode);
    notifyListeners();
  }
}
