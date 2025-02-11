import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode currentTheme = ThemeMode.dark;
  static const String isLightModeKey = "theme";

  ThemeProvider(bool isLightTheme){
    // if(isLightTheme == null){
    //   currentTheme = ThemeMode.system;
    //   return;
    // }
    currentTheme = isLightTheme? ThemeMode.light : ThemeMode.dark;
  }

  void changeTheme(ThemeMode newTheme){
    currentTheme = newTheme;
    saveNewTheme(newTheme);
    notifyListeners();
  }

  void saveNewTheme(ThemeMode newTheme)async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(isLightModeKey,
        newTheme == ThemeMode.light);
  }
}