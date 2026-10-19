import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/elevator_provider.dart';

class ElevatorDetailScreen extends StatefulWidget {
  final String elevatorId;
  const ElevatorDetailScreen({Key? key, required this.elevatorId}) : super(key: key);

  @override
  State<ElevatorDetailScreen> createState() => _ElevatorDetailScreenState();
}

class _ElevatorDetailScreenState extends State<ElevatorDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ElevatorProvider>().loadElevatorDetail(widget.elevatorId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elevator Details')),
      body: Consumer<ElevatorProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final elevator = provider.selectedElevator;
          if (elevator == null) {
            return const Center(child: Text('Elevator not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(elevator.elevatorId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(elevator.location, style: AppTextStyles.caption),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(elevator.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              elevator.status,
                              style: TextStyle(color: _getStatusColor(elevator.status), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Specifications', style: AppTextStyles.body1),
                const SizedBox(height: 12),
                _buildDetailRow('Model', elevator.model),
                _buildDetailRow('Type', elevator.type),
                _buildDetailRow('Serial Number', elevator.serialNumber),
                _buildDetailRow('Manufacturer', elevator.manufacturer),
                _buildDetailRow('Building', elevator.building),
                const SizedBox(height: 24),
                const Text('Technical Details', style: AppTextStyles.body1),
                const SizedBox(height: 12),
                _buildDetailRow('Capacity', '${elevator.capacity} kg'),
                _buildDetailRow('Speed', '${elevator.speed} m/s'),
                _buildDetailRow('Floor Count', '${elevator.floorCount}'),
                const SizedBox(height: 24),
                const Text('Important Dates', style: AppTextStyles.body1),
                const SizedBox(height: 12),
                _buildDetailRow('Installation', elevator.installationDate.toString().split(' ')[0]),
                _buildDetailRow('Commissioning', elevator.commissioningDate.toString().split(' ')[0]),
                const SizedBox(height: 24),
                const Text('Warranty & AMC', style: AppTextStyles.body1),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getWarrantyAlertColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getWarrantyAlertColor()),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Warranty Expiry', style: AppTextStyles.caption),
                          Text(
                            elevator.warrantyExpiryDate?.toString().split(' ')[0] ?? 'N/A',
                            style: TextStyle(
                              color: _getWarrantyAlertColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (elevator.isWarrantyExpired)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '⚠ Warranty has expired',
                            style: TextStyle(color: _getWarrantyAlertColor(), fontSize: 12),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Expires in ${elevator.warrantyDaysRemaining} days',
                            style: TextStyle(color: _getWarrantyAlertColor(), fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getAmcAlertColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getAmcAlertColor()),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('AMC Expiry', style: AppTextStyles.caption),
                          Text(
                            elevator.amcExpiryDate?.toString().split(' ')[0] ?? 'N/A',
                            style: TextStyle(
                              color: _getAmcAlertColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (elevator.isAmcExpired)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '⚠ AMC has expired',
                            style: TextStyle(color: _getAmcAlertColor(), fontSize: 12),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Expires in ${elevator.amcDaysRemaining} days',
                            style: TextStyle(color: _getAmcAlertColor(), fontSize: 12),
                          ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Expanded(child: Text(value, style: AppTextStyles.body2, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'operational':
        return AppColors.success;
      case 'maintenance':
        return AppColors.warning;
      case 'breakdown':
        return AppColors.danger;
      default:
        return AppColors.info;
    }
  }

  Color _getWarrantyAlertColor() {
    final elevator = context.read<ElevatorProvider>().selectedElevator;
    if (elevator?.isWarrantyExpired ?? false) return AppColors.danger;
    if ((elevator?.warrantyDaysRemaining ?? 999) <= 30) return AppColors.warning;
    return AppColors.success;
  }

  Color _getAmcAlertColor() {
    final elevator = context.read<ElevatorProvider>().selectedElevator;
    if (elevator?.isAmcExpired ?? false) return AppColors.danger;
    if ((elevator?.amcDaysRemaining ?? 999) <= 30) return AppColors.warning;
    return AppColors.success;
  }
}
