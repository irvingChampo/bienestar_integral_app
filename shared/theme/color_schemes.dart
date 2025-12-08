import 'package:flutter/material.dart';

// Paleta Clara
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFFFD700), // Amarillo
  onPrimary: Color(0xFF000000), // Texto negro sobre amarillo
  primaryContainer: Color(0xFFFFF0B3),
  onPrimaryContainer: Color(0xFF261A00),
  secondary: Color(0xFF655F51),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFECE4D1),
  onSecondaryContainer: Color(0xFF201C11),
  tertiary: Color(0xFF426650),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC4ECD0),
  onTertiaryContainer: Color(0xFF002111),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF1E1C16), // Texto casi negro
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1E1C16),
  surfaceVariant: Color(0xFFEBE2D1),
  onSurfaceVariant: Color(0xFF4B4639),
  outline: Color(0xFF7C7767),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF33312A),
  onInverseSurface: Color(0xFFF7F0E7),
  inversePrimary: Color(0xFFE5C500),
);

// Paleta Oscura (CORREGIDA)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFD700), // Mantenemos tu Amarillo semilla
  onPrimary: Color(0xFF3F2E00), // Texto oscuro sobre el amarillo
  primaryContainer: Color(0xFF5A4400),
  onPrimaryContainer: Color(0xFFFFE086),
  secondary: Color(0xFFD0C8B5),
  onSecondary: Color(0xFF363125),
  secondaryContainer: Color(0xFF4D473A),
  onSecondaryContainer: Color(0xFFECE4D1),
  tertiary: Color(0xFFA9D0B5),
  onTertiary: Color(0xFF143724),
  tertiaryContainer: Color(0xFF2B4E3A),
  onTertiaryContainer: Color(0xFFC4ECD0),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1E1C16),
  onBackground: Color(0xFFE8E2D9), // Texto CLARO sobre fondo oscuro
  surface: Color(0xFF1E1C16),
  onSurface: Color(0xFFE8E2D9), // Texto CLARO sobre tarjetas oscuras
  surfaceVariant: Color(0xFF4B4639),
  onSurfaceVariant: Color(0xFFCEC6B4),
  outline: Color(0xFF969080),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE8E2D9),
  onInverseSurface: Color(0xFF1E1C16),
  inversePrimary: Color(0xFF755B00),
);