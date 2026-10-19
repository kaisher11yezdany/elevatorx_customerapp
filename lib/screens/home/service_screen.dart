import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/service_request_model.dart';
import '../../providers/service_request_provider.dart';
import '../../widgets/app_button.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ServiceRequestProvider>().loadServiceRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Requests')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(Routes.raiseRequest),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Consumer<ServiceRequestProvider>(
        builder: (context, serviceProvider, _) {
          if (serviceProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredRequests = _filterRequests(serviceProvider.requests);

          return RefreshIndicator(
            onRefresh: () => serviceProvider.loadServiceRequests(),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Open'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Resolved'),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredRequests.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.description_outlined, size: 48, color: AppColors.textSecondary),
                              const SizedBox(height: 16),
                              const Text('No service requests', style: AppTextStyles.body2),
                              const SizedBox(height: 24),
                              AppButton(
                                label: 'Create New Request',
                                width: 180,
                                isFullWidth: false,
                                onPressed: () => Navigator.of(context).pushNamed(Routes.raiseRequest),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) {
                            return _buildRequestCard(context, filteredRequests[index]);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedFilter = label),
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withOpacity(0.2),
      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, ServiceRequest request) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(Routes.serviceDetail, arguments: request.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(request.ticketId, style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(request.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    request.priority,
                    style: TextStyle(color: _getPriorityColor(request.priority), fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(request.category, style: AppTextStyles.caption),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(request.description, style: AppTextStyles.body2, maxLines: 2, overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(color: _getStatusColor(request.status), fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<ServiceRequest> _filterRequests(List<ServiceRequest> requests) {
    if (_selectedFilter == 'All') return requests;
    if (_selectedFilter == 'Open') return requests.where((r) => r.isOpen).toList();
    return requests.where((r) => r.isResolved).toList();
  }

  Color _getStatusColor(String status) {
    if (status == 'Resolved' || status == 'Closed') return AppColors.success;
    if (status == 'In Progress' || status == 'Technician Assigned') return AppColors.info;
    return AppColors.warning;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'CRITICAL':
        return AppColors.danger;
      case 'HIGH':
        return AppColors.warning;
      case 'MEDIUM':
        return AppColors.info;
      default:
        return AppColors.success;
    }
  }
}
