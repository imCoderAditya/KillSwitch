import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';

class ThemeService {
  ThemeMode getThemeMode() {
    final isDark = StorageService.to.getIsDarkMode();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDarkMode() {
    return getThemeMode() == ThemeMode.dark;
  }

  void switchTheme() {
    final isDark = isDarkMode();
    final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;

    StorageService.to.saveIsDarkMode(!isDark);
    Get.changeThemeMode(newTheme);
  }
}
