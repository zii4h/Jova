import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldLog {
  // ---------------------------------------------------------------------------
  // Colors
  // ---------------------------------------------------------------------------

  static const bgPage = Color(0xFFF5F5F6);
  static const surfaceCard = Color(0xFFFAFAFB);
  static const surfaceMuted = Color(0xFFF0F0F2);

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

  // ---------------------------------------------------------------------------
  // Shape
  // ---------------------------------------------------------------------------

  static const radiusCard = 8.0;
  static const radiusControl = 6.0;
  static const radiusLarge = 8.0;

  // ---------------------------------------------------------------------------
  // Spacing
  // ---------------------------------------------------------------------------

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

  // ONLY for the JOVA logo/header
  static TextStyle brand({double size = 22, Color? color, FontWeight? weight}) {
    return GoogleFonts.saira(
      fontSize: size,
      height: 1.15,
      letterSpacing: 0.5,
      color: color ?? textPrimary,
      fontWeight: weight ?? FontWeight.w600,
    );
  }

  // Normal headings: Calendar, Analytics, etc.
  static TextStyle display({
    double size = 22,
    Color? color,
    FontWeight? weight,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.15,
      color: color ?? textPrimary,
      fontWeight: weight ?? FontWeight.w600,
    );
  }

  // Small labels / metadata
  static TextStyle mono({double size = 12, Color? color, FontWeight? weight}) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.35,
      color: color ?? textSecondary,
      fontWeight: weight ?? FontWeight.w500,
    );
  }

  // Normal body text
  static TextStyle body({double size = 14, Color? color, FontWeight? weight}) {
    return GoogleFonts.inter(
      fontSize: size,
      height: 1.35,
      color: color ?? textPrimary,
      fontWeight: weight ?? FontWeight.w400,
    );
  }

  // ---------------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------------

  static ThemeData themeData() {
    const background = bgPage;
    const surface = surfaceCard;
    const primaryText = textPrimary;
    const secondaryText = textSecondary;
    const themeBorder = border;

    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
      primary: accent,
      surface: surface,
      error: stageRejected,
    ).copyWith(onSurface: primaryText, outline: themeBorder);

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

  static ThemeData lightTheme() {
    return themeData();
  }

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

      // Cards
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(radiusCard)),
          side: BorderSide(color: themeBorder),
        ),
      ),

      // Bottom sheets
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        modalBarrierColor: Colors.black.withValues(alpha: 0.45),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusLarge),
          ),
        ),
        showDragHandle: true,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        hintStyle: GoogleFonts.inter(fontSize: 13, color: secondaryText),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: secondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(color: themeBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(color: themeBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: BorderSide(color: primaryText),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: const BorderSide(color: stageRejected),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusControl),
          borderSide: const BorderSide(color: stageRejected),
        ),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusControl),
          ),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusControl),
          ),
          side: BorderSide(color: themeBorder),
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusControl),
          ),
        ),
      ),

      // Icon buttons
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusControl),
          ),
        ),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: BorderSide(color: themeBorder),
        ),
      ),

      // Menus
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: BorderSide(color: themeBorder),
        ),
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryText,
        contentTextStyle: GoogleFonts.inter(fontSize: 13, color: background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusControl),
        ),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: themeBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
