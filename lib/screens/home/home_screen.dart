import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/project_provider.dart';
import '../../providers/elevator_provider.dart';
import '../../providers/service_request_provider.dart';
import '../../widgets/app_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final dashboardProvider = context.read<DashboardProvider>();
    final projectProvider = context.read<ProjectProvider>();
    final elevatorProvider = context.read<ElevatorProvider>();
    final serviceProvider = context.read<ServiceRequestProvider>();

    await Future.wait([
      dashboardProvider.loadDashboardData(),
      projectProvider.loadProjects(),
      elevatorProvider.loadElevators(),
      serviceProvider.loadServiceRequests(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('elevatorX'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications - Coming Soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushReplacementNamed(Routes.login);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: Consumer5<DashboardProvider, ProjectProvider, ElevatorProvider, ServiceRequestProvider, AuthProvider>(
          builder: (context, dashboardProvider, projectProvider, elevatorProvider, serviceProvider, authProvider, _) {
            if (dashboardProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (dashboardProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                    const SizedBox(height: 16),
                    Text(dashboardProvider.error ?? 'Error loading data'),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Retry',
                      width: 120,
                      isFullWidth: false,
                      onPressed: _loadDashboardData,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, Color(0xFF2C5AA0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${authProvider.user?.name?.split(' ').first}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Here\'s your elevator management summary',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // KPI Cards
                  const Text('Summary', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildKPICard(
                        'Projects',
                        projectProvider.projects.length.toString(),
                        Icons.folder,
                        AppColors.primary,
                      ),
                      _buildKPICard(
                        'Elevators',
                        elevatorProvider.elevators.length.toString(),
                        Icons.elevator,
                        AppColors.secondary,
                      ),
                      _buildKPICard(
                        'Open Tickets',
                        serviceProvider.openCount.toString(),
                        Icons.description,
                        AppColors.warning,
                      ),
                      _buildKPICard(
                        'Maintenance Due',
                        dashboardProvider.dashboardData?.upcomingMaintenance.toString() ?? '0',
                        Icons.event_note,
                        AppColors.info,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Alerts Section
                  if ((dashboardProvider.dashboardData?.expiryAlerts ?? []).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alerts', style: AppTextStyles.h4),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.danger.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.danger),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
                                  SizedBox(width: 8),
                                  Text('Warranty/AMC Expiring Soon', style: AppTextStyles.body2),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ...?dashboardProvider.dashboardData?.expiryAlerts.take(3).map(
                                (alert) => Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${alert.elevatorName}: ${alert.type} expires in ${alert.daysRemaining} days',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Quick Actions
                  const Text('Quick Actions', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'New Request',
                          onPressed: () => Navigator.of(context).pushNamed(Routes.raiseRequest),
                          backgroundColor: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: 'View Projects',
                          onPressed: () => Navigator.of(context).pushNamed(Routes.projects),
                          backgroundColor: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Projects'),
          BottomNavigationBarItem(icon: Icon(Icons.elevator), label: 'Elevators'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Service'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() => _selectedIndex = index);
          _navigateToSection(index);
        },
      ),
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _navigateToSection(int index) {
    switch (index) {
      case 1:
        Navigator.of(context).pushNamed(Routes.projects);
        break;
      case 2:
        Navigator.of(context).pushNamed(Routes.elevators);
        break;
      case 3:
        Navigator.of(context).pushNamed(Routes.service);
        break;
      case 4:
        Navigator.of(context).pushNamed(Routes.profile);
        break;
      default:
        break;
    }
  }
}
