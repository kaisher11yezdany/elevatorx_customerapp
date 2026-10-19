import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/project_provider.dart';
import 'providers/elevator_provider.dart';
import 'providers/service_request_provider.dart';
import 'providers/dashboard_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API service
  final apiService = ApiService();
  await apiService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ProxyProvider<ApiService, AuthProvider>(
          create: (_) => AuthProvider(apiService),
          update: (_, api, previous) => previous ?? AuthProvider(api),
        ),
        ProxyProvider<ApiService, ProjectProvider>(
          create: (_) => ProjectProvider(apiService),
          update: (_, api, previous) => previous ?? ProjectProvider(api),
        ),
        ProxyProvider<ApiService, ElevatorProvider>(
          create: (_) => ElevatorProvider(apiService),
          update: (_, api, previous) => previous ?? ElevatorProvider(api),
        ),
        ProxyProvider<ApiService, ServiceRequestProvider>(
          create: (_) => ServiceRequestProvider(apiService),
          update: (_, api, previous) => previous ?? ServiceRequestProvider(api),
        ),
        ProxyProvider<ApiService, DashboardProvider>(
          create: (_) => DashboardProvider(apiService),
          update: (_, api, previous) => previous ?? DashboardProvider(api),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
