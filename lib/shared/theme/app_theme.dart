import 'package:bienestar_integral_app/shared/theme/color_schemes.dart';
import 'package:bienestar_integral_app/shared/theme/typography.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: appTextTheme,
    scaffoldBackgroundColor: lightColorScheme.background, // Fondo blanco

    // CAMBIO: Asegura que el AppBar use el amarillo primario.
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary, // Amarillo
      foregroundColor: lightColorScheme.onPrimary, // Negro
      elevation: 0,
      centerTitle: true,
      titleTextStyle: appTextTheme.titleLarge?.copyWith(
        color: lightColorScheme.onPrimary, // Texto negro en AppBar
      ),
      iconTheme: IconThemeData(
        color: lightColorScheme.onPrimary, // Iconos negros en AppBar
      ),
    ),

    // CAMBIO: Asegura que los botones elevados usen el amarillo primario.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary, // Amarillo
        foregroundColor: lightColorScheme.onPrimary, // Texto negro en botones
        textStyle: appTextTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 0,
      ),
    ),

    // Estilos para otros componentes
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100, // Un gris muy claro para los campos de texto
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 1.5),
      ),
      prefixIconColor: lightColorScheme.primary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: appTextTheme,
    scaffoldBackgroundColor: darkColorScheme.background,

    // Configuración para modo oscuro
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        textStyle: appTextTheme.labelLarge,
      ),
    ),
  );
}