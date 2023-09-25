import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  // to store changes
  final _box = GetStorage();
  final _key = 'isThemeMode';
  // to change thememode inside box
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  //  to get thememode from box
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  //  to save thememode in box
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  //  to switch thememode and edit on value in box
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
