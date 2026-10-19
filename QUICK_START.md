# elevatorX Customer App - Quick Start Guide

Get the elevatorX Customer Flutter app up and running in 5 minutes!

## Prerequisites

Ensure you have Flutter installed on your system:

```bash
flutter --version  # Should be 3.0.0 or higher
dart --version     # Should be 3.0.0 or higher
```

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd elevatorx-customer-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will install all packages listed in `pubspec.yaml`.

### 3. Configure Backend Connection

Edit `lib/config/constants.dart` and update the API base URL:

**For Local Development:**
```dart
static const String apiBaseUrl = 'http://192.168.1.100:5000/api';
```

**For Staging:**
```dart
static const String apiBaseUrl = 'https://staging-api.elevatorx.com/api';
```

**For Production:**
```dart
static const String apiBaseUrl = 'https://api.elevatorx.com/api';
```

### 4. Run the App

#### On Android Emulator
```bash
flutter run
```

#### On Physical Device
```bash
flutter run -d <device_id>
# To list available devices:
flutter devices
```

#### On iOS Simulator
```bash
open -a Simulator
flutter run
```

## First Run

1. **Login Screen** should appear
2. **Test Credentials:**
   - Username: `admin`
   - Password: `Admin@123`
   
   OR create a new account using the Sign Up button

3. **Dashboard** displays after successful login

## File Structure Quick Reference

```
lib/
├── config/constants.dart           ← App colors, routes, messages
├── models/                         ← Data models
│   ├── user_model.dart
│   ├── project_model.dart
│   ├── elevator_model.dart
│   ├── service_request_model.dart
│   └── dashboard_model.dart
├── services/api_service.dart       ← Backend API calls
├── providers/                      ← State management
│   ├── auth_provider.dart
│   ├── project_provider.dart
│   ├── elevator_provider.dart
│   ├── service_request_provider.dart
│   └── dashboard_provider.dart
├── screens/                        ← App screens (in progress)
│   ├── auth/
│   │   ├── login_screen.dart       ✅ Ready
│   │   ├── signup_screen.dart      ⏳ To implement
│   │   ├── otp_screen.dart         ⏳ To implement
│   │   └── forgot_password_screen.dart ⏳ To implement
│   ├── home/                       ⏳ To implement
│   └── detail/                     ⏳ To implement
├── widgets/                        ← Reusable UI components
│   ├── app_button.dart             ✅ Ready
│   └── app_text_field.dart         ✅ Ready
├── main.dart                       ✅ Entry point
└── app.dart                        ✅ App configuration
```

## Common Tasks

### Add a New Screen

1. Create file: `lib/screens/home/my_screen.dart`
2. Create StatefulWidget extending Screen
3. Add route in `lib/app.dart`
4. Use Consumer<Provider> to access data

### Add a New API Endpoint

1. Add method to `ApiService` class in `lib/services/api_service.dart`
2. Create model if needed in `lib/models/`
3. Add provider method if needed in corresponding `provider.dart`
4. Call from widget using Consumer pattern

### Make a Provider Call

```dart
Consumer<ProjectProvider>(
  builder: (context, projectProvider, _) {
    if (projectProvider.isLoading) {
      return const LoadingWidget();
    }
    if (projectProvider.error != null) {
      return ErrorWidget(error: projectProvider.error);
    }
    return ListView.builder(
      itemCount: projectProvider.projects.length,
      itemBuilder: (context, index) {
        return ProjectCard(project: projectProvider.projects[index]);
      },
    );
  },
)
```

### Navigate Between Screens

```dart
// Push new screen
context.push('/projects');

// Pop current screen
context.pop();

// Replace current screen
context.go('/home');

// With parameters
context.push('/projects/${projectId}');
```

## Debugging Tips

### Enable Debug Logging

Add to `main.dart`:
```dart
import 'package:logger/logger.dart';

final logger = Logger();

// In API calls:
logger.d('Request: $url');
logger.d('Response: $data');
logger.e('Error: $error');
```

### Check API Calls

Enable logging in Dio interceptor to see all HTTP requests and responses.

### Device Connection Issues

```bash
# List connected devices
flutter devices

# Check device logs
flutter logs

# Kill running processes
lsof -ti:5000 | xargs kill -9  # On Mac/Linux
netstat -ano | findstr :5000   # On Windows
```

## Testing Credentials

Contact your backend administrator for test accounts.

**Demo Accounts:**
| Email | Password | Role |
|-------|----------|------|
| customer1@example.com | Password123 | Customer |
| customer2@example.com | Password123 | Customer Manager |

## Build for Production

### Android

```bash
# Generate release APK
flutter build apk --release

# Generate App Bundle (for Google Play)
flutter build appbundle --release

# APK location: build/app/release/app-release.apk
```

### iOS

```bash
# Generate release build
flutter build ios --release

# Generate IPA (for App Store)
flutter build ipa --release

# Archive location: build/ios/Release-iphoneos/
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Unsupported operation: Platform._operatingSystem" | Run on device or emulator, not in tests |
| "MissingPluginException" | Run `flutter pub get` and clean build |
| "Connection refused" | Check API URL, ensure backend is running |
| "401 Unauthorized" | Check login credentials and token |
| "Build failed" | Try `flutter clean` and `flutter pub get` |
| "iOS build error" | Update cocoapods: `cd ios && pod update` |

## Performance Tips

1. **Use const constructors** for widgets
2. **Lazy load images** with cached_network_image
3. **Paginate lists** instead of loading all at once
4. **Debounce search** with duration before API call
5. **Cache API responses** in SharedPreferences
6. **Use const Divider()** instead of Container

## Next Steps

1. **Review** the existing code structure
2. **Implement** remaining auth screens (see IMPLEMENTATION_GUIDE.md)
3. **Create** Dashboard screen
4. **Build** Projects and Elevators screens
5. **Add** Service Requests functionality
6. **Implement** Profile management
7. **Test** all features thoroughly
8. **Optimize** performance
9. **Prepare** for release

## Resources

- **Flutter Docs**: https://flutter.dev/docs
- **Provider Docs**: https://pub.dev/packages/provider
- **Dio Docs**: https://pub.dev/packages/dio
- **GoRouter Docs**: https://pub.dev/packages/go_router
- **Backend API**: See backend API documentation

## Getting Help

- Check existing screens for implementation examples
- Review IMPLEMENTATION_GUIDE.md for detailed instructions
- Check Flutter documentation: https://flutter.dev
- Review provider pattern examples in existing code

## Project Status

| Component | Status | Notes |
|-----------|--------|-------|
| Auth (Login) | ✅ Complete | Ready to use |
| Models | ✅ Complete | All data structures ready |
| API Service | ✅ Complete | All endpoints configured |
| Providers | ✅ Complete | All state management ready |
| Widgets | ⏳ In Progress | Button and TextField done |
| Screens | ⏳ In Progress | Login done, others to implement |
| Navigation | ✅ Complete | GoRouter configured |
| Testing | ⏳ Pending | After screens complete |

---

**Happy Coding! 🚀**

For issues or questions, refer to:
1. README.md (full documentation)
2. IMPLEMENTATION_GUIDE.md (step-by-step guide)
3. Existing code comments and structure
4. Flutter documentation

Last updated: October 2026
