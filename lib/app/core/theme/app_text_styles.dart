import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static bool _isDark() {
    try {
      if (Get.context == null) return false;
      return Theme.of(Get.context!).brightness == Brightness.dark;
    } catch (_) {
      return false;
    }
  }

  // Base generator helpers
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? (_isDark() ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    letterSpacing: letterSpacing,
    height: height,
  );

  static TextStyle openSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.openSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? (_isDark() ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    letterSpacing: letterSpacing,
    height: height,
  );

  static TextStyle roboto({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.roboto(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color ?? (_isDark() ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    letterSpacing: letterSpacing,
    height: height,
  );

  // Core Theme Styles
  static TextStyle headlineLarge() => poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headlineMedium() => poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subtitle() => openSans(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body() => poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle caption() => openSans(
    fontSize: 14.sp,
  );

  static TextStyle small() => openSans(
    fontSize: 10.sp,
  );

  static TextStyle button() => poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle brandLogo() => GoogleFonts.playfairDisplay(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    letterSpacing: 1.2,
  );
}
