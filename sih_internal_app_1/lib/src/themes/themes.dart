import 'package:flutter/material.dart';

class AppThemes {
  // Sophisticated deep colors inspired by Indian heritage
  static const Color crimsonRed = Color(0xFFB71C1C); // Deep crimson
  static const Color burgundyRed = Color(0xFF8E0000); // Rich burgundy
  static const Color terracotta = Color(0xFFD84315); // Warm terracotta
  static const Color deepForest = Color(0xFF1B5E20); // Deep forest green
  static const Color emeraldDark = Color(0xFF00695C); // Dark emerald
  static const Color royalNavy = Color(0xFF0D47A1); // Deep royal blue
  static const Color richGold = Color(0xFFBF9000); // Sophisticated gold
  static const Color warmIvory = Color(0xFFFFFEF7); // Warm ivory
  static const Color charcoal = Color(0xFF212121); // Rich charcoal
  static const Color slate = Color(0xFF37474F); // Deep slate
  static const Color deepOrange = Color(0xFFE65100); // Deep Orange
  static const Color orangeAccent = Color(0xFFFF9800); // Bright Orange
  static const Color pureBlack = Color(0xFF000000); // Pure Black
  static const Color deepDarkGray = Color(0xFF121212); // Deep Dark Gray
  static const Color lightGray = Color(0xFFF5F5F5); // Light Gray

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: crimsonRed,
    primaryColorLight: terracotta,
    primaryColorDark: burgundyRed,
    scaffoldBackgroundColor: warmIvory,
    appBarTheme: const AppBarTheme(
      backgroundColor: crimsonRed,
      foregroundColor: warmIvory,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: const ColorScheme.light(
      primary: crimsonRed,
      primaryContainer: Color(0xFFFFEBEE),
      secondary: deepForest,
      secondaryContainer: Color(0xFFE8F5E8),
      tertiary: royalNavy,
      tertiaryContainer: Color(0xFFE3F2FD),
      surface: Color(0xFFFDFDFD),
      surfaceContainerHighest: Color(0xFFF5F5F5),
      error: Color(0xFFD32F2F),
      onPrimary: warmIvory,
      onPrimaryContainer: crimsonRed,
      onSecondary: warmIvory,
      onSecondaryContainer: deepForest,
      onTertiary: warmIvory,
      onTertiaryContainer: royalNavy,
      onSurface: charcoal,
      onSurfaceVariant: slate,
      onError: warmIvory,
      outline: Color(0xFF6F6F6F),
      shadow: Color(0x1A000000),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: charcoal,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: charcoal,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      titleLarge: TextStyle(
        color: charcoal,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: slate,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: charcoal,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: slate,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: charcoal,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: crimsonRed,
        foregroundColor: warmIvory,
        elevation: 3,
        shadowColor: crimsonRed.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: crimsonRed,
        side: const BorderSide(color: crimsonRed, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: deepForest,
        foregroundColor: warmIvory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: richGold,
      foregroundColor: charcoal,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFFFDFDFD),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFF5F5F5),
      selectedColor: crimsonRed.withValues(alpha: 0.12),
      labelStyle: const TextStyle(color: charcoal),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFDFDFD),
      indicatorColor: crimsonRed.withValues(alpha: 0.12),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
              color: crimsonRed, fontWeight: FontWeight.w600);
        }
        return const TextStyle(color: slate);
      }),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: deepOrange,
    primaryColorLight: orangeAccent,
    primaryColorDark: deepOrange,
    scaffoldBackgroundColor: const Color.fromARGB(255, 22, 21, 21),
    appBarTheme: const AppBarTheme(
      backgroundColor: pureBlack,
      foregroundColor: warmIvory,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    colorScheme: const ColorScheme.dark(
      primary: crimsonRed,
      primaryContainer: Color(0xFF262626),
      secondary: orangeAccent,
      secondaryContainer: deepOrange,
      tertiary: Color(0xFFBDBDBD),
      tertiaryContainer: Color(0xFF333333),
      surface: deepDarkGray,
      surfaceContainerHighest: Color(0xFF2A2A2A),
      error: Color(0xFFEF5350),
      onPrimary: Color.fromARGB(255, 214, 209, 209),
      onPrimaryContainer: lightGray,
      onSecondary: pureBlack,
      onSecondaryContainer: lightGray,
      onTertiary: pureBlack,
      onTertiaryContainer: lightGray,
      onSurface: lightGray,
      onSurfaceVariant: Color(0xFFBFBFBF),
      onError: pureBlack,
      outline: Color(0xFF737373),
      shadow: Color(0x33000000),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: warmIvory,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        color: warmIvory,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      titleLarge: TextStyle(
        color: warmIvory,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Color(0xFFBFBFBF),
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: warmIvory,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFBFBFBF),
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: warmIvory,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: deepOrange,
        foregroundColor: pureBlack,
        elevation: 3,
        shadowColor: deepOrange.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: deepOrange,
        side: const BorderSide(color: deepOrange, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: orangeAccent,
        foregroundColor: pureBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: orangeAccent,
      foregroundColor: pureBlack,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1C1C1C),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2A2A2A),
      selectedColor: deepOrange.withValues(alpha: 0.2),
      labelStyle: const TextStyle(color: warmIvory),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: pureBlack,
      indicatorColor: orangeAccent.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
              color: orangeAccent, fontWeight: FontWeight.w600);
        }
        return const TextStyle(color: Color(0xFFBFBFBF));
      }),
    ),
  );
}
