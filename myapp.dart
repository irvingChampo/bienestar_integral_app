import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/application/theme_provider.dart';
import 'package:bienestar_integral_app/core/router/app_router.dart';
import 'package:bienestar_integral_app/shared/theme/app_theme.dart';
 import 'package:device_preview/device_preview.dart'; // <--- COMENTAR O BORRAR
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.checkAuthStatus();

    final themeProvider = Provider.of<ThemeProvider>(context);

    final appRouter = AppRouter(appState: appState);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,

      // --- ESTAS LÍNEAS SE COMENTAN O BORRAN ---
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // -----------------------------------------

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
    );
  }
}