# elevatorX Customer App - Implementation Guide

This document provides a step-by-step guide to complete the Phase 1 Flutter customer app implementation.

## Project Setup Status

✅ **Completed:**
- Project structure and architecture
- pubspec.yaml with all dependencies
- Constants and configuration (colors, routes, text styles, messages)
- All data models (User, Project, Elevator, ServiceRequest, Dashboard)
- API Service layer with all endpoints
- State management providers (5 providers using Provider package)
- Reusable widgets (Button, TextField)
- Login screen with full UI and authentication
- Main app setup with routing and theming
- Documentation

⏳ **To Complete:**
- SignUp screen
- Password recovery screens (Forgot Password, OTP)
- Home/Dashboard screen with widgets
- Projects screen and detail page
- Elevators screen and detail page
- Service requests screen and detail page
- Raise service request screen
- Profile screen and edit profile
- Maintenance calendar (Phase 2)
- Documents section (Phase 2)

## Step-by-Step Implementation Guide

### 1. Create Remaining Auth Screens

#### 1.1 SignUp Screen (lib/screens/auth/signup_screen.dart)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup(BuildContext context, AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(ErrorMessages.passwordMismatch)),
        );
        return;
      }

      final success = await authProvider.signup(
        _nameController.text,
        _emailController.text,
        _phoneController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account', style: AppTextStyles.h2),
              const SizedBox(height: 8),
              const Text(
                'Join elevatorX to manage your elevator projects and assets',
                style: AppTextStyles.body2,
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Email Address',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!Patterns.emailRegex.hasMatch(value)) {
                          return ErrorMessages.invalidEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!Patterns.phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
                          return ErrorMessages.invalidPhone;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      hint: 'Create a password',
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return ErrorMessages.weakPassword;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      controller: _confirmPasswordController,
                      obscureText: !_showPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() => _agreeToTerms = value ?? false);
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'I agree to the Terms of Service and Privacy Policy',
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        if (authProvider.error != null) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.danger.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              authProvider.error ?? 'Error occurred',
                              style: const TextStyle(color: AppColors.danger),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return AppButton(
                          label: 'Create Account',
                          isLoading: authProvider.isLoading,
                          onPressed: _agreeToTerms
                              ? () => _handleSignup(context, authProvider)
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Sign In'),
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
```

#### 1.2 Forgot Password Screen

Create `lib/screens/auth/forgot_password_screen.dart` with:
- Email input field
- Submit button to request password reset
- Display success message
- Link to OTP verification screen

#### 1.3 OTP Verification Screen

Create `lib/screens/auth/otp_screen.dart` with:
- 6-digit OTP input fields
- Resend OTP button with countdown timer
- Verify button
- Error handling

### 2. Create Home/Dashboard Screen

Create `lib/screens/home/home_screen.dart`:

```dart
// This should display:
// 1. Top summary cards (Total Projects, Active Requests, Elevators, Maintenance)
// 2. Recent notifications list
// 3. Warranty/AMC expiry alerts
// 4. Quick action buttons to navigate to Projects, Elevators, Service
// 5. Bottom navigation bar with 5 tabs
```

**Key Components:**
- Dashboard summary widgets showing KPIs
- Alert cards for expiring warranties/AMC
- Recent notifications section
- Quick action buttons

### 3. Create Projects Screen

Create `lib/screens/home/projects_screen.dart`:

**Features:**
- List of all customer projects
- Project status badges (Completed, In Progress, Delayed)
- Progress bar showing completion percentage
- Tap to view project details
- Pull-to-refresh functionality

Create `lib/screens/detail/project_detail_screen.dart`:

**Features:**
- Project header with ID, customer, status
- Milestones list with completion status
- Timeline view of milestones
- Project statistics (budget, cost, timeline)
- Elevator list for this project

### 4. Create Elevators Screen

Create `lib/screens/home/elevators_screen.dart`:

**Features:**
- List of installed elevators
- Elevator status indicators
- Warranty/AMC status
- Filter by status
- Search functionality

Create `lib/screens/detail/elevator_detail_screen.dart`:

**Features:**
- Elevator specifications
- Warranty details with countdown
- AMC information
- Maintenance history
- Service history
- Documents section

### 5. Create Service Requests Screen

Create `lib/screens/home/service_screen.dart`:

**Features:**
- List of all service requests
- Status filter (All, Open, Resolved)
- Priority color coding
- Tap to view details
- FAB to create new request

Create `lib/screens/detail/service_detail_screen.dart`:

**Features:**
- Ticket number and details
- Timeline of status changes
- Assigned technician info
- Comments section
- Attached documents
- Service report (if resolved)

Create `lib/screens/detail/raise_request_screen.dart`:

**Features:**
- Select building/site
- Select elevator
- Choose complaint category
- Describe problem
- Upload photos (optional)
- Set priority
- Submit button

### 6. Create Profile Screen

Create `lib/screens/home/profile_screen.dart`:

**Features:**
- Display user information
- Associated organizations
- Edit button
- Change password option
- Logout button

Create `lib/screens/home/edit_profile_screen.dart`:

**Features:**
- Edit name, email, phone
- Change password form
- Save button
- Success/error messages

### 7. Create Additional Widgets

#### 7.1 Dashboard Card Widget
```dart
// lib/widgets/dashboard_card.dart
// Shows KPI with icon, label, value, and subtitle
```

#### 7.2 Project Card Widget
```dart
// lib/widgets/project_card.dart
// Shows project summary with progress bar
```

#### 7.3 Elevator Card Widget
```dart
// lib/widgets/elevator_card.dart
// Shows elevator summary with status
```

#### 7.4 Request Card Widget
```dart
// lib/widgets/request_card.dart
// Shows service request with status and priority
```

#### 7.5 Status Badge Widget
```dart
// lib/widgets/status_badge.dart
// Shows status with appropriate color
```

#### 7.6 Loading Widget
```dart
// lib/widgets/loading_widget.dart
// Centered loading spinner
```

#### 7.7 Error Widget
```dart
// lib/widgets/error_widget.dart
// Error message with retry button
```

## Next Steps After Phase 1

### Phase 2 - Operations
- [ ] Maintenance calendar with scheduling
- [ ] Warranty management and AMC renewals
- [ ] Document management (view/download PDFs)
- [ ] Service completion feedback and ratings
- [ ] Offline data caching with Hive

### Phase 3 - Advanced
- [ ] QR code scanning (flutter_barcode_scanner package)
- [ ] Payment integration (Razorpay/PayPal)
- [ ] Electronic signatures (SignaturePad)
- [ ] IoT elevator monitoring
- [ ] Multi-language support (intl package)
- [ ] In-app chat support (Firebase)

## Testing Checklist

Before production release:

- [ ] Login/Signup workflows
- [ ] Password recovery flow
- [ ] Data loading and caching
- [ ] Error handling and fallbacks
- [ ] Offline behavior
- [ ] Push notifications
- [ ] Token refresh mechanism
- [ ] Logout and session cleanup
- [ ] Form validations
- [ ] Image upload (future)
- [ ] API request timeouts
- [ ] Network error recovery

## Performance Optimization

1. **Lazy Loading**: Implement pagination for lists
2. **Image Caching**: Use cached_network_image package
3. **State Preservation**: Maintain scroll position
4. **Debouncing**: Debounce search queries
5. **Data Caching**: Cache API responses locally
6. **Code Splitting**: Use code generation for models

## Deployment Checklist

- [ ] Update API base URL to production
- [ ] Configure Firebase for production
- [ ] Enable HTTPS/SSL pinning
- [ ] Remove debug prints and logs
- [ ] Test all features on real devices
- [ ] Version bump in pubspec.yaml
- [ ] Create signed APK/IPA
- [ ] Upload to Play Store/App Store
- [ ] Create release notes

## Common Flutter Commands

```bash
# Run app in debug mode
flutter run

# Run with specific device
flutter run -d <device_id>

# Build APK
flutter build apk --release

# Build iOS app
flutter build ios --release

# Run tests
flutter test

# Clean build
flutter clean
flutter pub get
flutter run

# Analyze code
flutter analyze

# Format code
dart format .

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade
```

## Package Recommendations for Future Phases

| Feature | Package | Purpose |
|---------|---------|---------|
| QR Scanning | qr_code_scanner | Scan elevator QR codes |
| PDF Viewing | pdf | View PDF documents |
| Image Picking | image_picker | Select photos |
| File Picker | file_picker | Browse files |
| Payments | razorpay_flutter | Payment processing |
| Chat | firebase_database | Real-time messaging |
| Signatures | signature | Digital signatures |
| Offline Sync | hive | Local database |
| Analytics | firebase_analytics | Usage tracking |
| Crash Reporting | firebase_crashlytics | Error monitoring |

## Troubleshooting Common Issues

### Issue: Widgets not updating after API call
**Solution**: Ensure `notifyListeners()` is called in providers

### Issue: Navigation not working
**Solution**: Check route names in GoRouter configuration

### Issue: API requests failing
**Solution**: Verify token is being sent in Authorization header

### Issue: Auth token not persisting
**Solution**: Check SharedPreferences save/load in ApiService

### Issue: Build errors on iOS
**Solution**: Run `pod update` and check iOS deployment target version

## Support & Resources

- [Flutter Documentation](https://flutter.dev)
- [Provider Documentation](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Firebase Documentation](https://firebase.flutter.dev)

---

**Last Updated**: October 2026
**Status**: Phase 1 - Implementation Guide
