import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/service_request_model.dart';
import '../../providers/service_request_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RaiseRequestScreen extends StatefulWidget {
  const RaiseRequestScreen({Key? key}) : super(key: key);

  @override
  State<RaiseRequestScreen> createState() => _RaiseRequestScreenState();
}

class _RaiseRequestScreenState extends State<RaiseRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _elevatorController;
  late TextEditingController _descriptionController;
  String _selectedCategory = 'Breakdown';
  String _selectedPriority = 'Medium';

  @override
  void initState() {
    super.initState();
    _elevatorController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _elevatorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raise Service Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Elevator', style: AppTextStyles.body1),
              const SizedBox(height: 8),
              AppTextField(
                label: 'Elevator',
                hint: 'Select elevator',
                controller: _elevatorController,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 24),
              const Text('Category', style: AppTextStyles.body1),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'Breakdown', child: Text('Breakdown')),
                  DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                  DropdownMenuItem(value: 'Inspection', child: Text('Inspection')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _selectedCategory = value ?? 'Breakdown'),
                decoration: InputDecoration(
                  hintText: 'Select category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Priority', style: AppTextStyles.body1),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                  DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Critical', child: Text('Critical')),
                ],
                onChanged: (value) => setState(() => _selectedPriority = value ?? 'Medium'),
                decoration: InputDecoration(
                  hintText: 'Select priority',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Description', style: AppTextStyles.body1),
              const SizedBox(height: 8),
              AppTextField(
                label: 'Description',
                hint: 'Describe the issue',
                controller: _descriptionController,
                maxLines: 5,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              Consumer<ServiceRequestProvider>(
                builder: (context, provider, _) {
                  return AppButton(
                    label: 'Submit Request',
                    isLoading: provider.isLoading,
                    onPressed: (_formKey.currentState?.validate() ?? false)
                        ? () {
                            final request = CreateServiceRequestRequest(
                              site: '',
                              elevator: _elevatorController.text,
                              category: _selectedCategory,
                              description: _descriptionController.text,
                              priority: _selectedPriority,
                            );
                            provider.createServiceRequest(request);
                            Navigator.pop(context);
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
