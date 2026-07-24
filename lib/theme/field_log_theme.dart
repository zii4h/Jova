import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Field Log" design tokens for Jecord.
/// Values mirror the Part 3 Design System doc — keep the two in sync
/// if you tweak anything here.
class FieldLog {
  // Color tokens
  static const bgPage = Color(0xFFF3EEE1);
  static const surfaceCard = Color(0xFFFBF8F0);
  static const border = Color(0xFFDAD2BC);
  static const textPrimary = Color(0xFF2C2820);
  static const textSecondary = Color(0xFF6F6756);

  static const stageApplied = Color(0xFF854F0B);
  static const stageScreening = Color(0xFF993C1D);
  static const stageInterview = Color(0xFF0F6E56);
  static const stageOffer = Color(0xFF3B6D11);
  static const stageRejected = Color(0xFFA32D2D);

  // Shape tokens
  static const radiusCard = 2.0;
  static const radiusControl = 6.0;

  // Spacing tokens
  static const space4 = 4.0;
  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space24 = 24.0;

  // Typography tokens
  static TextStyle display({double size = 22, Color? color}) =>
      GoogleFonts.specialElite(fontSize: size, color: color ?? textPrimary);

  static TextStyle mono({double size = 12, Color? color, FontWeight? weight}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: color ?? textSecondary, fontWeight: weight);

  static TextStyle body({double size = 14, Color? color, FontWeight? weight}) =>
      GoogleFonts.inter(fontSize: size, color: color ?? textPrimary, fontWeight: weight);

  static ThemeData themeData() {
    return ThemeData(
      scaffoldBackgroundColor: bgPage,
      colorScheme: ColorScheme.fromSeed(seedColor: stageInterview),
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,
    );
  }
}
