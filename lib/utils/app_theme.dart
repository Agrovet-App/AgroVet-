import 'package:flutter/material.dart';

class AppColors {
  // Green tones for agriculture
  static const Color primary = Color.fromRGBO(34, 139, 34, 1); // Forest Green
  static const Color primaryLight = Color.fromRGBO(102, 187, 106, 1); // Soft Green
  static const Color primaryDark = Color.fromRGBO(27, 94, 32, 1); // Dark Green
  static const Color primaryVariant = Color.fromRGBO(102, 187, 106, 1);
  static const Color accent = Color.fromRGBO(141, 199, 95, 1); // Lime Green
  static const Color secondary = accent;
  static const Color success = Color.fromRGBO(76, 175, 80, 1);
  static const Color warning = Color.fromRGBO(255, 179, 0, 1);
  static const Color danger = Color.fromRGBO(229, 57, 53, 1);
  static const Color background = Color(0xFFF2F7F0);
  static const Color darkGray = Color(0xFF5B6A5F);
  static const Color surface = Color(0xFFF7FBF5);
  static const Color gray = Color.fromRGBO(98, 110, 100, 1);
  static const Color gray50 = Color.fromRGBO(98, 110, 100, 0.3);
  static const Color black = Color.fromRGBO(25, 33, 27, 1);
}

class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.black,
      background: AppColors.background,
      onBackground: AppColors.black,
      error: AppColors.danger,
      onError: Colors.white,
    );

    final baseTextTheme = Typography.material2021().black.apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
      fontFamily: 'Trebuchet MS',
      fontFamilyFallback: const ['Helvetica'],
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Trebuchet MS',
      textTheme: baseTextTheme.copyWith(
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: AppColors.gray),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.gray),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(color: AppColors.gray),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        shadowColor: Colors.black.withOpacity(0.08),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: AppColors.gray),
        hintStyle: const TextStyle(color: AppColors.gray50),
        prefixIconColor: AppColors.gray,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.gray50.withOpacity(0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.gray50.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.gray50.withOpacity(0.7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Trebuchet MS',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray.withOpacity(0.7),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        elevation: 10,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
