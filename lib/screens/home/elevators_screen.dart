import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/elevator_model.dart';
import '../../providers/elevator_provider.dart';

class ElevatorsScreen extends StatefulWidget {
  const ElevatorsScreen({Key? key}) : super(key: key);

  @override
  State<ElevatorsScreen> createState() => _ElevatorsScreenState();
}

class _ElevatorsScreenState extends State<ElevatorsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ElevatorProvider>().loadElevators());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Elevators')),
      body: Consumer<ElevatorProvider>(
        builder: (context, elevatorProvider, _) {
          if (elevatorProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (elevatorProvider.elevators.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.elevator_outlined, size: 48, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('No elevators found'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => elevatorProvider.loadElevators(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: elevatorProvider.elevators.length,
              itemBuilder: (context, index) {
                final elevator = elevatorProvider.elevators[index];
                return _buildElevatorCard(context, elevator);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildElevatorCard(BuildContext context, Elevator elevator) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(Routes.elevatorDetail, arguments: elevator.id),
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(elevator.elevatorId, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(elevator.location, style: AppTextStyles.caption),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(elevator.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(elevator.status, style: TextStyle(color: _getStatusColor(elevator.status), fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetail('Capacity', '${elevator.capacity} kg'),
                _buildDetail('Speed', '${elevator.speed} m/s'),
                _buildDetail('Floors', '${elevator.floorCount}'),
              ],
            ),
            const SizedBox(height: 12),
            if (elevator.isWarrantyExpired)
              _buildAlert('⚠ Warranty Expired', AppColors.danger)
            else if (elevator.warrantyDaysRemaining <= 30)
              _buildAlert('Warranty expires in ${elevator.warrantyDaysRemaining} days', AppColors.warning),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(children: [
      Text(label, style: AppTextStyles.caption),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    ]);
  }

  Widget _buildAlert(String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
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
}
