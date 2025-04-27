import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Text theme configuration for the app
class AppTextTheme {
  AppTextTheme._();

  // Light text colors
  static const Color _lightTextColor = Color(0xFF2D3142);

  // Dark text colors
  static const Color _darkTextColor = Color(0xFFF5F5F5);

  static TextTheme getLightTextTheme() => TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: _lightTextColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: _lightTextColor,
    ),
    displayMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: _lightTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: _lightTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: _lightTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: _lightTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w300,
      color: _lightTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.w500,
      color: _lightTextColor,
    ),
  );

  static TextTheme getDarkTextTheme() => TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w900,
      color: _darkTextColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: _darkTextColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: _darkTextColor,
    ),
    displayMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: _darkTextColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: _darkTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: _darkTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: _darkTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w300,
      color: _darkTextColor,
    ),
    labelSmall: TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.w500,
      color: _darkTextColor,
    ),
  );
}
