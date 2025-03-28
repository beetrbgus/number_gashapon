import 'package:flutter/material.dart';
import 'package:number_gashapon/core/design_system/styles/app_color.dart';

class AppTextTheme {
  static const double _baseFontSize = 16;

  static final TextStyle headline1 = TextStyle(
    fontSize: _baseFontSize * 2.5,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
    height: 1.2,
  );

  static final TextStyle headline2 = TextStyle(
    fontSize: _baseFontSize * 2.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static final TextStyle headline3 = TextStyle(
    fontSize: _baseFontSize * 1.75,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontSize: _baseFontSize * 1.25,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
    height: 1.4,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontSize: _baseFontSize,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
    height: 1.5,
  );

  static final TextStyle bodySmall = TextStyle(
    fontSize: _baseFontSize * 0.875,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.2,
    height: 1.6,
  );

  static final TextStyle caption = TextStyle(
    fontSize: _baseFontSize * 0.75,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 1.5,
    color: AppColors.black900,
  );

  static final TextStyle subtitle = TextStyle(
    fontSize: _baseFontSize * 1.125,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static final TextStyle button = TextStyle(
    fontSize: _baseFontSize,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    height: 1.2,
    color: AppColors.white,
  );
}
