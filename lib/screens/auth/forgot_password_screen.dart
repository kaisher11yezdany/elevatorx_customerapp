import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text('Reset Password', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              const Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: AppTextStyles.body2,
              ),
              const SizedBox(height: 40),
              if (!_isSubmitted)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Email Address',
                        hint: 'Enter your email',
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Email is required';
                          if (!RegExp(AppConstants.emailPattern).hasMatch(value!)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Send Reset Link',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() => _isSubmitted = true);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Login'),
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(Icons.check_circle, color: AppColors.success, size: 40),
                      ),
                      const SizedBox(height: 24),
                      const Text('Check Your Email', style: AppTextStyles.h3),
                      const SizedBox(height: 12),
                      Text(
                        'We\'ve sent a password reset link to\n${_emailController.text}',
                        style: AppTextStyles.body2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        label: 'Back to Login',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
