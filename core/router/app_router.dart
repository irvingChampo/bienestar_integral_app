// core/router/app_router.dart (CÓDIGO COMPLETO Y ACTUALIZADO)

import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/account_status/presentation/pages/account_status_screen.dart';
import 'package:bienestar_integral_app/features/add_product/presentation/pages/add_product_screen.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/pages/admin_home_screen.dart';
import 'package:bienestar_integral_app/features/auth/presentation/pages/login_screen.dart';
import 'package:bienestar_integral_app/features/chef_ia/presentation/pages/chef_ia_screen.dart';
import 'package:bienestar_integral_app/features/events/presentation/pages/event_detail_screen.dart';
import 'package:bienestar_integral_app/features/events/presentation/pages/event_details_screen.dart';
import 'package:bienestar_integral_app/features/home/presentation/pages/home_screen.dart';
import 'package:bienestar_integral_app/features/inventory/presentation/pages/inventory_screen.dart';
import 'package:bienestar_integral_app/features/launch_event/presentation/pages/launch_event_screen.dart';
import 'package:bienestar_integral_app/features/manage_volunteers/presentation/pages/manage_volunteers_screen.dart';
import 'package:bienestar_integral_app/features/my_events/presentation/pages/my_events_screen.dart';
import 'package:bienestar_integral_app/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:bienestar_integral_app/features/register/presentation/pages/register_step1_screen.dart';
import 'package:bienestar_integral_app/features/register/presentation/pages/register_step3_screen.dart';
import 'package:bienestar_integral_app/features/register_donation/presentation/pages/register_donation_screen.dart';
import 'package:bienestar_integral_app/features/register_purchase/presentation/pages/register_purchase_screen.dart';
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
      GoRoute(path: AppRoutes.registerStep3Path, name: AppRoutes.registerStep3, builder: (c, s) => const RegisterStep3Screen()),

      GoRoute(path: AppRoutes.homePath, name: AppRoutes.home, builder: (c, s) => const HomeScreen()),

      // --- CAMBIO AQUÍ: La ruta ahora acepta un ID de cocina como parámetro ---
      GoRoute(
        path: '${AppRoutes.eventDetailsPath}/:kitchenId',
        name: AppRoutes.eventDetails,
        builder: (context, state) {
          final kitchenId = int.tryParse(state.pathParameters['kitchenId'] ?? '0');
          final initialData = state.extra as Map<String, String>?;

          return EventDetailsScreen(
            kitchenId: kitchenId!,
            initialData: initialData,
          );
        },
      ),

      GoRoute(path: AppRoutes.eventDetailPath, name: AppRoutes.eventDetail, builder: (c, s) => const EventDetailScreen()),
      GoRoute(path: AppRoutes.editProfilePath, name: AppRoutes.editProfile, builder: (c, s) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.myEventsPath, name: AppRoutes.myEvents, builder: (c, s) => const MyEventsScreen()),
      GoRoute(path: AppRoutes.settingsPath, name: AppRoutes.settings, builder: (c, s) => const SettingsScreen()),

      GoRoute(path: AppRoutes.adminHomePath, name: AppRoutes.adminHome, builder: (c, s) => const AdminHomeScreen()),
      GoRoute(path: AppRoutes.manageVolunteersPath, name: AppRoutes.manageVolunteers, builder: (c, s) => const ManageVolunteersScreen()),
      GoRoute(path: AppRoutes.launchEventPath, name: AppRoutes.launchEvent, builder: (c, s) => const LaunchEventScreen()),
      GoRoute(path: AppRoutes.addProductPath, name: AppRoutes.addProduct, builder: (c, s) => const AddProductScreen()),
      GoRoute(path: AppRoutes.inventoryPath, name: AppRoutes.inventory, builder: (c, s) => const InventoryScreen()),
      GoRoute(path: AppRoutes.registerPurchasePath, name: AppRoutes.registerPurchase, builder: (c, s) => const RegisterPurchaseScreen()),
      GoRoute(path: AppRoutes.registerDonationPath, name: AppRoutes.registerDonation, builder: (c, s) => const RegisterDonationScreen()),
      GoRoute(path: AppRoutes.accountStatusPath, name: AppRoutes.accountStatus, builder: (c, s) => const AccountStatusScreen()),
      GoRoute(path: AppRoutes.chefIaPath, name: AppRoutes.chefIa, builder: (c, s) => const ChefIaScreen()),
    ],
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final userRole = appState.userRole;
      final location = state.matchedLocation;

      final isAuthRoute = location == AppRoutes.loginPath || location.startsWith('/register');
      final isAdminRoute = location.startsWith('/admin') ||
          [
            AppRoutes.manageVolunteersPath,
            AppRoutes.launchEventPath,
            AppRoutes.addProductPath,
            AppRoutes.inventoryPath,
            AppRoutes.registerPurchasePath,
            AppRoutes.registerDonationPath,
            AppRoutes.accountStatusPath,
            AppRoutes.chefIaPath,
          ].contains(location);

      switch (authStatus) {
        case AuthStatus.unauthenticated:
          return isAuthRoute ? null : AppRoutes.loginPath;

        case AuthStatus.authenticated:
          if (isAuthRoute) {
            return userRole == UserRole.admin ? AppRoutes.adminHomePath : AppRoutes.homePath;
          }
          if (isAdminRoute && userRole != UserRole.admin) {
            return AppRoutes.homePath;
          }
          return null;

        default:
          return AppRoutes.loginPath;
      }
    },
  );
}