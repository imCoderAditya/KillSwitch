import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme_controller.dart';

class AppColors {
  // Brand Colors
  static const Color primaryColor = Color(0xFFFF4081); // Pink Accent
  static const Color accentColor = Color(0xFF7C4DFF); // Deep Purple Accent
  
  // Specific branding & specific pages
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color dhanColor = Color(0xFF0F766E);
  
  // Base Slate colors
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Status Colors (Success, Error, Warning, Info)
  // Green (Success)
  static const Color green50 = Color(0xFFECFDF5);
  static const Color green100 = Color(0xFFD1FAE5);
  static const Color green200 = Color(0xFFA7F3D0);
  static const Color green300 = Color(0xFF6EE7B7);
  static const Color green500 = Color(0xFF10B981);
  static const Color green600 = Color(0xFF059669);
  static const Color green700 = Color(0xFF047857);
  static const Color green800 = Color(0xFF065F46);
  static const Color green700Variant = Color(0xFF16803D);

  // Red (Error/Danger)
  static const Color red50 = Color(0xFFFEF2F2);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red200 = Color(0xFFFECACA);
  static const Color red300 = Color(0xFFFCA5A5);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);
  static const Color red800 = Color(0xFF991B1B);
  static const Color red50Variant = Color(0xFFFFF5F5);

  // Purple
  static const Color purple100 = Color(0xFFF3E8FF);
  static const Color purple200 = Color(0xFFE9D5FF);
  static const Color purple800 = Color(0xFF6B21A8);

  // Rose
  static const Color rose100 = Color(0xFFFFE4E6);
  static const Color rose200 = Color(0xFFFECDD3);
  static const Color rose600 = Color(0xFFE11D48);

  // Amber / Orange (Warning)
  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber200 = Color(0xFFFDE68A);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber800 = Color(0xFF92400E);
  static const Color orange600 = Color(0xFFEA580C);

  // Blue (Info/Interactive)
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue200 = Color(0xFFBFDBFE);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue800 = Color(0xFF1E40AF);

  // Google Colors
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleRed = Color(0xFFEA4335);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleGreen = Color(0xFF34A853);

  // Basic Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color grey = Colors.grey;

  // UI Theme Palettes
  // Light Theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F8F8);
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightDivider = Color(0xFFE0E0E0);

  // Dark Theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkDivider = Color(0xFF2C2C2C);
  
  static const Color secondaryPrimary = Color(0xFFDEA604);
  static const Color sucessPrimary = Color(0xFF038B50);

  static bool get isDarkMode {
    try {
      if (Get.isRegistered<ThemeController>()) {
        return Get.find<ThemeController>().isDarkMode.value;
      }
      if (Get.context == null) return false;
      return Theme.of(Get.context!).brightness == Brightness.dark;
    } catch (_) {
      return false;
    }
  }

  static Color get background => isDarkMode ? darkBackground : lightBackground;
  static Color get surface => isDarkMode ? darkSurface : lightSurface;
  static Color get textPrimary => isDarkMode ? darkTextPrimary : slate800;
  static Color get textSecondary => isDarkMode ? darkTextSecondary : slate500;
  static Color get cardBackground => isDarkMode ? darkSurface : white;
  static Color get scaffoldBackground => isDarkMode ? darkBackground : slate100;
  static Color get divider => isDarkMode ? darkDivider : slate200;
  static Color get inputBackground => isDarkMode ? const Color(0xFF1E293B) : slate50;

  static Color hexToColor(String? hex) {
    if (hex == null || hex.trim().isEmpty) {
      return Colors.transparent;
    }

    hex = hex.trim().replaceAll("#", "").toUpperCase();

    // if only RGB -> add alpha
    if (hex.length == 6) {
      hex = "FF$hex";
    }

    // invalid hex length
    if (hex.length != 8) {
      return Colors.transparent;
    }

    try {
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return Colors.transparent;
    }
  }
}
