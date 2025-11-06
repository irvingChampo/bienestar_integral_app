import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:bienestar_integral_app/myapp.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appState),
          ChangeNotifierProvider(create: (_) => AuthProvider(appState)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}