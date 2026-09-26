import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldLog {
  // ---------------------------------------------------------------------------
  // Existing tokens
  //
  // Kept for compatibility with widgets that still directly reference
  // FieldLog.bgPage, surfaceCard, textPrimary, etc.
  // ---------------------------------------------------------------------------

  static const bgPage = Color(0xFFF7F7F8);
  static const surfaceCard = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F2F4);

  static const border = Color(0xFFE4E5E9);
  static const borderStrong = Color(0xFFD5D7DC);

  static const textPrimary = Color(0xFF18191C);
  static const textSecondary = Color(0xFF6F727A);
  static const textTertiary = Color(0xFF9A9DA5);

  static const accent = Color(0xFF4F5DFF);
  static const accentSoft = Color(0xFFEEF0FF);

  // Status colors
  static const stageApplied = Color(0xFF64748B);
  static const stageScreening = Color(0xFFB7791F);
  static const stageInterview = Color(0xFF4F5DFF);
  static const stageOffer = Color(0xFF16845B);
  static const stageRejected = Color(0xFFC94A4A);

  // Shape
  static const radiusCard = 14.0;
  static const radiusControl = 10.0;
  static const radiusLarge = 18.0;

  // Spacing
  static const space4 = 4.0;
  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space20 = 20.0;
  static const space24 = 24.0;
  static const space32 = 32.0;

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  static TextStyle display({
    double size = 22,
    Color? color,
    FontWeight? weight,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.2,
      letterSpacing: -0.35,
      color: color ?? textPrimary,
      fontWeight: weight ?? FontWeight.w600,
    );
  }

  static TextStyle mono({
    double size = 12,
    Color? color,
    FontWeight? weight,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.35,
      color: color ?? textSecondary,
      fontWeight: weight ?? FontWeight.w500,
    );
  }

  static TextStyle body({
    double size = 14,
    Color? color,
    FontWeight? weight,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.45,
      color: color ?? textPrimary,
      fontWeight: weight ?? FontWeight.w400,
    );
  }

  // ---------------------------------------------------------------------------
  // Light theme
  // ---------------------------------------------------------------------------

  static ThemeData lightTheme() {
    const background = Color(0xFFF7F7F8);
    const surface = Color(0xFFFFFFFF);
    const primaryText = Color(0xFF18191C);
    const secondaryText = Color(0xFF6F727A);
    const themeBorder = Color(0xFFE4E5E9);

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
      primary: accent,
      surface: surface,
      error: stageRejected,
    ).copyWith(
      onSurface: primaryText,
      outline: themeBorder,
    );

    return _buildTheme(
      scheme: scheme,
      background: background,
      surface: surface,
      primaryText: primaryText,
      secondaryText: secondaryText,
      themeBorder: themeBorder,
      inputFill: surface,
    );
  }

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------

  static ThemeData darkTheme() {
    const background = Color(0xFF111214);
    const surface = Color(0xFF191A1E);
    const primaryText = Color(0xFFF3F3F5);
    const secondaryText = Color(0xFFA5A7AE);
    const themeBorder = Color(0xFF2B2D32);
    const inputFill = Color(0xFF1D1E22);

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      primary: const Color(0xFF8B93FF),
      surface: surface,
      error: const Color(0xFFFF7474),
    ).copyWith(
      onSurface: primaryText,
      outline: themeBorder,
    );

    return _buildTheme(
      scheme: scheme,
      background: background,
      surface: surface,
      primaryText: primaryText,
      secondaryText: secondaryText,
      themeBorder: themeBorder,
      inputFill: inputFill,
    );
  }

  // ---------------------------------------------------------------------------
  // Shared theme
  // ---------------------------------------------------------------------------

  static ThemeData _buildTheme({
    required ColorScheme scheme,
    required Color background,
    required Color surface,
    required Color primaryText,
    required Color secondaryText,
    required Color themeBorder,
    required Color inputFill,
  }) {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: primaryText,
      displayColor: primaryText,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: background,
      colorScheme: scheme,
      textTheme: textTheme,
      dividerColor: themeBorder,

      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(radiusCard),
          ),
          side: BorderSide(
            color: themeBorder,
          ),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        modalBarrierColor: Colors.black.withValues(alpha: 0.45),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: themeBorder,
        dragHandleSize: const Size(36, 4),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiusLarge),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          color: secondaryText,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: secondaryText,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 13,
          color: secondaryText,
        ),
        prefixIconColor: secondaryText,
        suffixIconColor: secondaryText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(
            color: themeBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(
            color: themeBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(
            color: scheme.primary,
            width: 1.4,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(
            color: scheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(
            color: scheme.error,
            width: 1.4,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(
            scheme.primary,
          ),
          foregroundColor: WidgetStatePropertyAll(
            scheme.onPrimary,
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusControl),
            ),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            primaryText,
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: themeBorder,
            ),
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusControl),
            ),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            primaryText,
          ),
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 3,
        focusElevation: 3,
        hoverElevation: 5,
        highlightElevation: 3,
        shape: const CircleBorder(),
      ),

      iconTheme: IconThemeData(
        color: primaryText,
        size: 20,
      ),

      dividerTheme: DividerThemeData(
        color: themeBorder,
        thickness: 1,
        space: 1,
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: surface,
        headerForegroundColor: primaryText,
        dividerColor: themeBorder,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radiusLarge),
          ),
        ),
      ),
    );
  }

  // Keep this so any old code that still calls themeData() doesn't break.
  static ThemeData themeData() => lightTheme();
}