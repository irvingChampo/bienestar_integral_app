import 'package:bienestar_integral_app/core/application/app_state.dart';
import 'package:bienestar_integral_app/core/router/routes.dart';
import 'package:bienestar_integral_app/features/account_status/presentation/pages/account_status_screen.dart';
import 'package:bienestar_integral_app/features/add_product/presentation/pages/add_product_screen.dart';
import 'package:bienestar_integral_app/features/admin_home/presentation/pages/admin_home_screen.dart';
import 'package:bienestar_integral_app/features/auth/presentation/pages/login_screen.dart';
import 'package:bienestar_integral_app/features/chef_ia/presentation/pages/chef_ia_screen.dart';
import 'package:bienestar_integral_app/features/events/domain/entities/event.dart'; // <-- IMPORTANTE: Importar Entidad Evento
import 'package:bienestar_integral_app/features/events/presentation/pages/edit_event_screen.dart'; // <-- IMPORTANTE: Importar Pantalla Edición
import 'package:bienestar_integral_app/features/events/presentation/pages/event_detail_screen.dart';
import 'package:bienestar_integral_app/features/events/presentation/pages/event_details_screen.dart';
import 'package:bienestar_integral_app/features/home/presentation/pages/home_screen.dart';
import 'package:bienestar_integral_app/features/inventory/presentation/pages/inventory_screen.dart';
import 'package:bienestar_integral_app/features/kitchen_schedule/presentation/pages/kitchen_schedule_screen.dart';
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
      // Rutas Públicas (Auth)
      GoRoute(path: AppRoutes.loginPath, name: AppRoutes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(path: AppRoutes.registerStep1Path, name: AppRoutes.registerStep1, builder: (c, s) => const RegisterStep1Screen()),
      GoRoute(path: AppRoutes.registerStep3Path, name: AppRoutes.registerStep3, builder: (c, s) => const RegisterStep3Screen()),

      // Rutas de Voluntario (User)
      GoRoute(path: AppRoutes.homePath, name: AppRoutes.home, builder: (c, s) => const HomeScreen()),
      GoRoute(
        path: '${AppRoutes.eventDetailsPath}/:kitchenId',
        name: AppRoutes.eventDetails,
        builder: (context, state) {
          final kitchenId = int.tryParse(state.pathParameters['kitchenId'] ?? '0');
          final initialData = state.extra as Map<String, String>?;
          return EventDetailsScreen(kitchenId: kitchenId!, initialData: initialData);
        },
      ),
      GoRoute(
        path: '${AppRoutes.kitchenSchedulePath}/:kitchenId',
        name: AppRoutes.kitchenSchedule,
        builder: (context, state) {
          final kitchenId = int.tryParse(state.pathParameters['kitchenId'] ?? '0') ?? 0;
          return KitchenScheduleScreen(kitchenId: kitchenId);
        },
      ),
      GoRoute(path: AppRoutes.eventDetailPath, name: AppRoutes.eventDetail, builder: (c, s) => const EventDetailScreen()),
      GoRoute(path: AppRoutes.editProfilePath, name: AppRoutes.editProfile, builder: (c, s) => const EditProfileScreen()),
      GoRoute(path: AppRoutes.myEventsPath, name: AppRoutes.myEvents, builder: (c, s) => const MyEventsScreen()),
      GoRoute(path: AppRoutes.settingsPath, name: AppRoutes.settings, builder: (c, s) => const SettingsScreen()),

      // Rutas de Administrador
      GoRoute(path: AppRoutes.adminHomePath, name: AppRoutes.adminHome, builder: (c, s) => const AdminHomeScreen()),

      // Manage Volunteers (Recibe un objeto Event en 'extra')
      GoRoute(
        path: AppRoutes.manageVolunteersPath,
        name: AppRoutes.manageVolunteers,
        builder: (c, s) => const ManageVolunteersScreen(),
      ),

      GoRoute(path: AppRoutes.launchEventPath, name: AppRoutes.launchEvent, builder: (c, s) => const LaunchEventScreen()),
      GoRoute(path: AppRoutes.addProductPath, name: AppRoutes.addProduct, builder: (c, s) => const AddProductScreen()),
      GoRoute(path: AppRoutes.inventoryPath, name: AppRoutes.inventory, builder: (c, s) => const InventoryScreen()),
      GoRoute(path: AppRoutes.registerPurchasePath, name: AppRoutes.registerPurchase, builder: (c, s) => const RegisterPurchaseScreen()),
      GoRoute(path: AppRoutes.registerDonationPath, name: AppRoutes.registerDonation, builder: (c, s) => const RegisterDonationScreen()),
      GoRoute(path: AppRoutes.accountStatusPath, name: AppRoutes.accountStatus, builder: (c, s) => const AccountStatusScreen()),
      GoRoute(path: AppRoutes.chefIaPath, name: AppRoutes.chefIa, builder: (c, s) => const ChefIaScreen()),

      // --- NUEVA RUTA: EDITAR EVENTO ---
      GoRoute(
        path: AppRoutes.editEventPath,
        name: AppRoutes.editEvent,
        builder: (context, state) {
          // Extraemos el evento pasado como argumento extra
          final event = state.extra as Event;
          return EditEventScreen(event: event);
        },
      ),
    ],

    // --- LÓGICA DE REDIRECCIÓN ---
    redirect: (context, state) {
      final authStatus = appState.authStatus;
      final userRole = appState.userRole;
      final location = state.matchedLocation;

      // 1. Identificar tipos de rutas
      final isAuthRoute = location == AppRoutes.loginPath || location.startsWith('/register');

      // Lista de rutas exclusivas de admin
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
            AppRoutes.editEventPath, // Agregamos la nueva ruta a la protección
          ].contains(location);

      // 2. Manejo de estado: No Autenticado
      if (authStatus == AuthStatus.unauthenticated) {
        // Si no está autenticado y quiere ir a una ruta privada, mandar al login
        return isAuthRoute ? null : AppRoutes.loginPath;
      }

      // 3. Manejo de estado: Autenticado
      if (authStatus == AuthStatus.authenticated) {
        // Si está en Login o Registro, redirigir a su Home correspondiente
        if (isAuthRoute) {
          return userRole == UserRole.admin ? AppRoutes.adminHomePath : AppRoutes.homePath;
        }

        // Protección de rutas: Si es voluntario e intenta entrar a rutas de admin
        if (isAdminRoute && userRole != UserRole.admin) {
          return AppRoutes.homePath;
        }
      }

      return null; // No redirigir
    },
  );
}