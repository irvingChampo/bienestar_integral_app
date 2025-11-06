import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/auth/presentation/pages/login_screen.dart';
import 'package:bienestar_integral_app/features/events/presentation/pages/event_detail_screen.dart';
import 'package:bienestar_integral_app/features/events/presentation/pages/event_details_screen.dart';
import 'package:bienestar_integral_app/features/home/presentation/pages/home_screen.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/pages/my_events_screen.dart';
import 'package:bienestar_integral_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:bienestar_integral_app/features/register/presentation/pages/register_step1_screen.dart';
import 'package:bienestar_integral_app/features/register/presentation/pages/register_step2_screen.dart';
import 'package:bienestar_integral_app/features/register/presentation/pages/register_step3_screen.dart';
import 'package:bienestar_integral_app/features/settings/presentation/pages/settings_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AppState appState;
  AppRouter({required this.appState});

  late final GoRouter router = GoRouter(
    // CAMBIO: La ruta inicial ahora es el login.
    initialLocation: AppRoutes.loginPath,
    refreshListenable: appState,
    routes: [
      // CAMBIO: Se eliminó la GoRoute para el splash.
      GoRoute(path: AppRoutes.loginPath, name: AppRoutes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(path: AppRoutes.registerStep1Path, name: AppRoutes.registerStep1, builder: (c, s) => const RegisterStep1Screen()),
      GoRoute(path: AppRoutes.registerStep2Path, name: AppRoutes.registerStep2, builder: (c, s) => const RegisterStep2Screen()),
      GoRoute(path: AppRoutes.registerStep3Path, name: AppRoutes.registerStep3, builder: (c, s) => const RegisterStep3Screen()),

      // Rutas protegidas que requieren autenticación
      GoRoute(path: AppRoutes.homePath, name: AppRoutes.home, builder: (c, s) => const HomeScreen()),
      GoRoute(path: AppRoutes.eventDetailsPath, name: AppRoutes.eventDetails, builder: (c, s) => const EventDetailsScreen()),
      GoRoute(path: AppRoutes.eventDetailPath, name: AppRoutes.eventDetail, builder: (c, s) => const EventDetailScreen()),
      GoRoute(path: AppRoutes.editProfilePath, name: AppRoutes.editProfile, builder: (c, s) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.myEventsPath, name: AppRoutes.myEvents, builder: (c, s) => const MyEventsScreen()),
      GoRoute(path: AppRoutes.settingsPath, name: AppRoutes.settings, builder: (c, s) => const SettingsScreen()),
    ],
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final location = state.matchedLocation;

      final isAuthRoute = location == AppRoutes.loginPath || location.startsWith('/register');

      // CAMBIO: Se elimina el caso para AuthStatus.unknown.
      switch (authStatus) {
        case AuthStatus.unauthenticated:
        // Si no está autenticado, solo puede acceder a las rutas de login/registro.
          return isAuthRoute ? null : AppRoutes.loginPath;

        case AuthStatus.authenticated:
        // Si está autenticado, no puede volver a las rutas de login/registro.
        // Si intenta ir, es redirigido a home.
          return isAuthRoute ? AppRoutes.homePath : null;

        default:
          return AppRoutes.loginPath;
      }
    },
  );
}