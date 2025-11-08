import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/add_product/presentation/pages/add_product_screen.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/pages/admin_home_screen.dart';
import 'package:bienestar_integral_app/features/launch_event/presentation/pages/launch_event_screen.dart';
import 'package:bienestar_integral_app/features/manage_volunteers/presentation/pages/manage_volunteers_screen.dart';
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
    initialLocation: AppRoutes.loginPath,
    refreshListenable: appState,
    routes: [
      GoRoute(path: AppRoutes.loginPath, name: AppRoutes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(path: AppRoutes.registerStep1Path, name: AppRoutes.registerStep1, builder: (c, s) => const RegisterStep1Screen()),
      GoRoute(path: AppRoutes.registerStep2Path, name: AppRoutes.registerStep2, builder: (c, s) => const RegisterStep2Screen()),
      GoRoute(path: AppRoutes.registerStep3Path, name: AppRoutes.registerStep3, builder: (c, s) => const RegisterStep3Screen()),

      // Rutas protegidas de Voluntario
      GoRoute(path: AppRoutes.homePath, name: AppRoutes.home, builder: (c, s) => const HomeScreen()),
      GoRoute(path: AppRoutes.eventDetailsPath, name: AppRoutes.eventDetails, builder: (c, s) => const EventDetailsScreen()),
      GoRoute(path: AppRoutes.eventDetailPath, name: AppRoutes.eventDetail, builder: (c, s) => const EventDetailScreen()),
      GoRoute(path: AppRoutes.editProfilePath, name: AppRoutes.editProfile, builder: (c, s) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.myEventsPath, name: AppRoutes.myEvents, builder: (c, s) => const MyEventsScreen()),
      GoRoute(path: AppRoutes.settingsPath, name: AppRoutes.settings, builder: (c, s) => const SettingsScreen()),

      // Rutas protegidas de Administrador
      GoRoute(path: AppRoutes.adminHomePath, name: AppRoutes.adminHome, builder: (c, s) => const AdminHomeScreen()),
      GoRoute(path: AppRoutes.manageVolunteersPath, name: AppRoutes.manageVolunteers, builder: (c, s) => const ManageVolunteersScreen()),
      GoRoute(path: AppRoutes.launchEventPath, name: AppRoutes.launchEvent, builder: (c, s) => const LaunchEventScreen()),
      GoRoute(path: AppRoutes.addProductPath, name: AppRoutes.addProduct, builder: (c, s) => const AddProductScreen()),
    ],
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final userRole = appState.userRole;
      final location = state.matchedLocation;

      final isAuthRoute = location == AppRoutes.loginPath || location.startsWith('/register');
      final isAdminRoute = location == AppRoutes.adminHomePath ||
          location == AppRoutes.manageVolunteersPath ||
          location == AppRoutes.launchEventPath ||
          location == AppRoutes.addProductPath;

      switch (authStatus) {
        case AuthStatus.unauthenticated:
          return isAuthRoute ? null : AppRoutes.loginPath;

        case AuthStatus.authenticated:
        // Si el usuario está autenticado y trata de ir al login/registro, redirigirlo a su home.
          if (isAuthRoute) {
            return userRole == UserRole.admin ? AppRoutes.adminHomePath : AppRoutes.homePath;
          }
          // Si un voluntario intenta acceder a una ruta de admin, redirigirlo a su home.
          if (isAdminRoute && userRole != UserRole.admin) {
            return AppRoutes.homePath;
          }
          // En cualquier otro caso, permitir el acceso.
          return null;

        default:
          return AppRoutes.loginPath;
      }
    },
  );
}
