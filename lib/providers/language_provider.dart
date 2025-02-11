import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LanguageProvider extends ChangeNotifier{
  late String currentLocale ;
  static const String localeKey = "locale";
  static const String fallBackLocale = "en";

  LanguageProvider(String? defaultLocale){
    if(defaultLocale==null){
      var currentSysLocale = Platform.localeName;
      if(AppLocalizations.supportedLocales.contains(currentSysLocale)){
        currentLocale = currentSysLocale;
        return;
      }
    }
    currentLocale = defaultLocale ?? fallBackLocale;


  }

  void changeLocale(String newLocale){
    currentLocale = newLocale;
    saveNewLocaleToSharePreferences(newLocale);
    notifyListeners();
  }
}

void saveNewLocaleToSharePreferences(String newLocale) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString(LanguageProvider.localeKey, newLocale);
}