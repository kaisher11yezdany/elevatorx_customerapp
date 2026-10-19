import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/service_request_model.dart';
import '../../providers/service_request_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String requestId;
  const ServiceDetailScreen({Key? key, required this.requestId}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    Future.microtask(() => context.read<ServiceRequestProvider>().loadRequestDetail(widget.requestId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Request Details')),
      body: Consumer<ServiceRequestProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final request = provider.selectedRequest;
          if (request == null) {
            return const Center(child: Text('Request not found'));
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(request.ticketId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(request.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              request.status,
                              style: TextStyle(color: _getStatusColor(request.status), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Category', request.category),
                      _buildDetailRow('Priority', request.priority),
                      _buildDetailRow('Elevator', request.elevator),
                      _buildDetailRow('Site', request.site),
                      _buildDetailRow('Created', request.createdAt.toString().split(' ')[0]),
                      if (request.resolvedAt != null)
                        _buildDetailRow('Resolved', request.resolvedAt!.toString().split(' ')[0]),
                      if (request.assignedTechnician != null)
                        _buildDetailRow('Technician', request.assignedTechnician ?? 'Unassigned'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Description', style: AppTextStyles.body1),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(request.description, style: AppTextStyles.body2),
                ),
                const SizedBox(height: 24),
                if (request.resolution != null) ...[
                  const Text('Resolution', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Text(request.resolution ?? '', style: TextStyle(color: AppColors.success)),
                  ),
                  const SizedBox(height: 24),
                ],
                if (request.comments.isNotEmpty) ...[
                  const Text('Comments', style: AppTextStyles.body1),
                  const SizedBox(height: 12),
                  ...request.comments.map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(comment.author, style: AppTextStyles.caption),
                              Text(comment.timestamp, style: AppTextStyles.caption),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(comment.text, style: AppTextStyles.body2),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 24),
                ],
                if (request.isOpen) ...[
                  const Text('Add Comment', style: AppTextStyles.body1),
                  const SizedBox(height: 8),
                  AppTextField(
                    label: 'Comment',
                    hint: 'Add a comment...',
                    controller: _commentController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Post Comment',
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        provider.addComment(request.id, _commentController.text);
                        _commentController.clear();
                      }
                    },
                  ),
                ],
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
    if (status == 'Resolved' || status == 'Closed') return AppColors.success;
    if (status == 'In Progress' || status == 'Technician Assigned') return AppColors.info;
    return AppColors.warning;
  }
}
