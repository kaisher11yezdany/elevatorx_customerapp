import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/home/projects_screen.dart';
import 'screens/home/elevators_screen.dart';
import 'screens/home/service_screen.dart';
import 'screens/home/profile_screen.dart';
import 'screens/home/raise_request_screen.dart';
import 'screens/home/edit_profile_screen.dart';
import 'screens/details/project_detail_screen.dart';
import 'screens/details/elevator_detail_screen.dart';
import 'screens/details/service_detail_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      redirect: _handleRedirect,
      routes: _buildRoutes(),
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authProvider = context.watch<AuthProvider>();
    final isLoggingIn = state.matchedLocation == Routes.login;

    if (!authProvider.isAuthenticated) {
      return isLoggingIn ? null : Routes.login;
    }

    if (isLoggingIn) {
      return Routes.home;
    }

    return null;
  }

  List<RouteBase> _buildRoutes() {
    return [
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.signup,
        name: 'signup',
        builder: (context, state) {
          // ignore: avoid_relative_lib_imports
          return const SignupScreen();
        },
      ),
      GoRoute(
        path: Routes.otp,
        name: 'otp',
        builder: (context, state) {
          return OtpScreen(email: state.extra as String? ?? '');
        },
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: Routes.home,
        name: 'home',
        builder: (context, state) {
          return const HomeScreen();
        },
        routes: [
          GoRoute(
            path: 'projects',
            name: 'projects',
            builder: (context, state) => const ProjectsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'project-detail',
                builder: (context, state) => ProjectDetailScreen(projectId: state.pathParameters['id'] ?? ''),
              ),
            ],
          ),
          GoRoute(
            path: 'elevators',
            name: 'elevators',
            builder: (context, state) => const ElevatorsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'elevator-detail',
                builder: (context, state) => ElevatorDetailScreen(elevatorId: state.pathParameters['id'] ?? ''),
              ),
            ],
          ),
          GoRoute(
            path: 'service',
            name: 'service',
            builder: (context, state) => const ServiceScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'service-detail',
                builder: (context, state) => ServiceDetailScreen(requestId: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'raise-request',
                name: 'raise-request',
                builder: (context, state) => const RaiseRequestScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'edit-profile',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'elevatorX Customer',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Segoe UI',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 1,
          centerTitle: false,
          titleTextStyle: AppTextStyles.h4,
        ),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
