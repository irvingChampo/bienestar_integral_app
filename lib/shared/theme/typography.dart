import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextTheme appTextTheme = GoogleFonts.latoTextTheme().copyWith(
  displayLarge: GoogleFonts.lato(fontSize: 57, fontWeight: FontWeight.bold),
  displayMedium: GoogleFonts.lato(fontSize: 45, fontWeight: FontWeight.bold),
  displaySmall: GoogleFonts.lato(fontSize: 36, fontWeight: FontWeight.bold),

  headlineLarge: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.bold),
  headlineMedium: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold),
  headlineSmall: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),

  titleLarge: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w600),
  titleMedium: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
  titleSmall: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),

  bodyLarge: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  bodySmall: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),

  labelLarge: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
  labelMedium: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  labelSmall: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
);