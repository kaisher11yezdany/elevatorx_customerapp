import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, Color(0xFF2C5AA0)],
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            '${user?.name?.split(' ').first.characters.first ?? 'U'}${user?.name?.split(' ').last.characters.first ?? 'S'}',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(user?.name ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(user?.role ?? 'Customer', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoCard('Email', user?.email ?? 'N/A', Icons.email_outlined),
                      const SizedBox(height: 12),
                      _buildInfoCard('Phone', user?.phone ?? 'N/A', Icons.phone_outlined),
                      const SizedBox(height: 12),
                      _buildInfoCard('Role', user?.role ?? 'N/A', Icons.badge_outlined),
                      const SizedBox(height: 12),
                      _buildInfoCard('Status', user?.status ?? 'Active', Icons.check_circle_outline),
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Edit Profile',
                        onPressed: () => Navigator.of(context).pushNamed(Routes.editProfile),
                        backgroundColor: AppColors.info,
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Logout',
                        onPressed: () {
                          authProvider.logout();
                          Navigator.of(context).pushReplacementNamed(Routes.login);
                        },
                        backgroundColor: AppColors.danger,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
