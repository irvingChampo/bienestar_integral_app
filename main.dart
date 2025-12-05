import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:bienestar_integral_app/features/events/presentation/providers/event_details_provider.dart';
import 'package:bienestar_integral_app/features/home/presentation/providers/home_provider.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/provider/my_events_provider.dart'; // <-- 1. IMPORTAR
import 'package:bienestar_integral_app/features/payments/presentation/providers/payment_provider.dart';
import 'package:bienestar_integral_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:bienestar_integral_app/features/register/presentation/providers/register_provider.dart';
import 'package:bienestar_integral_app/myapp.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final appState = AppState();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => appState),
          ChangeNotifierProvider(create: (_) => AuthProvider(appState)),
          ChangeNotifierProvider(create: (_) => RegisterProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => EventDetailsProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => MyEventsProvider()), // <-- 2. REGISTRAR
        ],
        child: const MyApp(),
      ),
    ),
  );
}