import 'package:flutter/material.dart';

// Paleta generada a partir de un color semilla amarillo (#FFD700)

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  // --- Colores Primarios (para botones, appbars, elementos activos) ---
  primary: Color(0xFFFFD700), // Tu amarillo principal
  onPrimary: Color(0xFF000000), // Texto/iconos sobre el amarillo (Negro)
  primaryContainer: Color(0xFFFFF0B3), // Un contenedor de tono amarillo muy claro
  onPrimaryContainer: Color(0xFF261A00), // Texto/iconos sobre el contenedor amarillo claro

  // --- Colores Secundarios (para elementos menos prominentes, filtros, chips) ---
  secondary: Color(0xFF655F51),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFECE4D1),
  onSecondaryContainer: Color(0xFF201C11),

  // --- Colores Terciarios (para acentos decorativos) ---
  tertiary: Color(0xFF426650),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFC4ECD0),
  onTertiaryContainer: Color(0xFF002111),

  // --- Colores de Error ---
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),

  // --- Colores de Fondo y Superficies (el lienzo de la app) ---
  background: Color(0xFFFFFFFF), // Fondo principal (Blanco, como pediste)
  onBackground: Color(0xFF1E1C16), // Texto sobre el fondo (Negro)
  surface: Color(0xFFFFFFFF), // Fondo de tarjetas, diálogos, etc. (Blanco)
  onSurface: Color(0xFF1E1C16), // Texto sobre las tarjetas (Negro)
  surfaceVariant: Color(0xFFEBE2D1), // Superficies con una leve variación de color
  onSurfaceVariant: Color(0xFF4B4639), // Texto sobre esas superficies

  // --- Otros ---
  outline: Color(0xFF7C7767),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF33312A),
  onInverseSurface: Color(0xFFF7F0E7),
  inversePrimary: Color(0xFFE5C500),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  // --- Colores Primarios ---
  primary: Color(0xFFE5C500), // Amarillo vibrante para modo oscuro
  onPrimary: Color(0xFF3F2E00), // Texto oscuro sobre el amarillo
  primaryContainer: Color(0xFF5A4400),
  onPrimaryContainer: Color(0xFFFFE086),

  // --- Colores Secundarios ---
  secondary: Color(0xFFD0C8B5),
  onSecondary: Color(0xFF363125),
  secondaryContainer: Color(0xFF4D473A),
  onSecondaryContainer: Color(0xFFECE4D1),

  // --- Colores Terciarios ---
  tertiary: Color(0xFFA9D0B5),
  onTertiary: Color(0xFF143724),
  tertiaryContainer: Color(0xFF2B4E3A),
  onTertiaryContainer: Color(0xFFC4ECD0),

  // --- Colores de Error ---
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),

  // --- Colores de Fondo y Superficies ---
  background: Color(0xFF1E1C16), // Fondo principal oscuro
  onBackground: Color(0xFFE8E2D9), // Texto claro sobre el fondo oscuro
  surface: Color(0xFF1E1C16), // Fondo de tarjetas oscuro
  onSurface: Color(0xFFE8E2D9), // Texto claro sobre las tarjetas
  surfaceVariant: Color(0xFF4B4639),
  onSurfaceVariant: Color(0xFFCEC6B4),

  // --- Otros ---
  outline: Color(0xFF969080),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE8E2D9),
  onInverseSurface: Color(0xFF1E1C16),
  inversePrimary: Color(0xFF755B00),
);