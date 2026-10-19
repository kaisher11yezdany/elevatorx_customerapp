# elevatorX Customer Mobile App

A comprehensive Flutter-based customer mobile application for the elevatorX platform, enabling customers to track elevator projects, manage assets, request services, and view maintenance schedules.

## Project Status: Phase 1 Implementation

This is the **Phase 1 - Core App** implementation with the following features:
- ✅ User Authentication (Login, SignUp, Password Recovery)
- ✅ Customer Dashboard with KPIs and alerts
- ✅ Project Tracking with milestones
- ✅ My Elevators - Asset management
- ✅ Service Requests - Raise and track tickets
- ✅ Notifications system
- ✅ Profile Management
- 🔄 Phase 2 features (Maintenance calendar, Documents) - To be implemented
- 🔄 Phase 3 features (QR scanning, Payments) - To be implemented

## Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences + Hive
- **Push Notifications**: Firebase Cloud Messaging (Optional)
- **Navigation**: GoRouter (for named routes)
- **Authentication**: JWT Token-based

## Project Structure

```
elevatorx-customer-app/
├── lib/
│   ├── config/
│   │   └── constants.dart          # App configuration, colors, routes, messages
│   ├── models/
│   │   ├── user_model.dart         # User & Auth models
│   │   ├── project_model.dart      # Project & Milestone models
│   │   ├── elevator_model.dart     # Elevator & Asset models
│   │   ├── service_request_model.dart  # Service request & Comment models
│   │   └── dashboard_model.dart    # Dashboard data & Notifications
│   ├── services/
│   │   └── api_service.dart        # Dio-based HTTP client with JWT auth
│   ├── providers/
│   │   ├── auth_provider.dart      # Authentication state management
│   │   ├── project_provider.dart   # Projects state management
│   │   ├── elevator_provider.dart  # Elevators state management
│   │   ├── service_request_provider.dart  # Service requests state
│   │   └── dashboard_provider.dart # Dashboard state management
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   ├── otp_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart    # Dashboard
│   │   │   ├── projects_screen.dart
│   │   │   ├── elevators_screen.dart
│   │   │   ├── service_screen.dart
│   │   │   └── profile_screen.dart
│   │   └── detail/
│   │       ├── project_detail_screen.dart
│   │       ├── elevator_detail_screen.dart
│   │       ├── service_detail_screen.dart
│   │       └── raise_request_screen.dart
│   ├── widgets/
│   │   ├── app_button.dart         # Reusable button widget
│   │   ├── app_text_field.dart     # Reusable text field widget
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   ├── dashboard_card.dart
│   │   ├── project_card.dart
│   │   ├── elevator_card.dart
│   │   ├── request_card.dart
│   │   └── status_badge.dart
│   ├── main.dart                   # App entry point
│   └── app.dart                    # App configuration & routing
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── pubspec.yaml                    # Dependencies
└── README.md                        # This file
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd elevatorx-customer-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint** (lib/config/constants.dart)
   ```dart
   static const String apiBaseUrl = 'http://192.168.1.100:5000/api';
   // Change to production API when deploying
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## API Integration

The app connects to the elevatorX backend API. All API calls are handled through the `ApiService` class in `lib/services/api_service.dart`.

### Authentication Endpoints
- `POST /api/auth/login` - Login with credentials
- `POST /auth/signup` - Create new account
- `GET /api/auth/me` - Get current user profile
- `PUT /api/auth/profile` - Update user profile

### Projects API
- `GET /api/projects` - List all projects
- `GET /api/projects/:id` - Get project details

### Elevators API
- `GET /api/elevators` - List all elevators
- `GET /api/elevators/:id` - Get elevator details

### Service Requests API
- `GET /api/breakdowns` - List service requests
- `GET /api/breakdowns/:id` - Get request details
- `POST /api/breakdowns` - Create new service request
- `POST /api/breakdowns/:id/comment` - Add comment to request

### Dashboard API
- `GET /api/customers/dashboard` - Get dashboard data

### Maintenance API
- `GET /api/maintenance/schedule` - Get maintenance schedule

## State Management (Provider Pattern)

The app uses the Provider package for state management with the following providers:

### AuthProvider
Manages user authentication state, login, signup, and profile updates.
```dart
final authProvider = Provider.of<AuthProvider>(context);
authProvider.login(username, password);
authProvider.updateProfile(name, email, phone);
authProvider.logout();
```

### ProjectProvider
Manages project data, filtering, and sorting.
```dart
final projectProvider = Provider.of<ProjectProvider>(context);
await projectProvider.loadProjects();
projectProvider.completedProjects
projectProvider.inProgressProjects
```

### ElevatorProvider
Manages elevator asset data and status.
```dart
final elevatorProvider = Provider.of<ElevatorProvider>(context);
await elevatorProvider.loadElevators();
elevatorProvider.operationalCount
elevatorProvider.elevatorsWithExpiredAMC
```

### ServiceRequestProvider
Manages service requests and ticket tracking.
```dart
final serviceProvider = Provider.of<ServiceRequestProvider>(context);
await serviceProvider.loadServiceRequests();
await serviceProvider.createServiceRequest(request);
await serviceProvider.addComment(requestId, comment);
```

### DashboardProvider
Manages dashboard summary data.
```dart
final dashboardProvider = Provider.of<DashboardProvider>(context);
await dashboardProvider.loadDashboardData();
dashboardProvider.dashboardData?.totalProjects
```

## Navigation Structure

The app uses named routes for navigation:

```
/                    → Login Screen
/signup              → SignUp Screen
/otp                 → OTP Verification
/forgot-password     → Password Recovery
/home                → Dashboard (Main)
/projects            → Projects List
/projects/:id        → Project Details
/elevators           → Elevators List
/elevators/:id       → Elevator Details
/service             → Service Requests List
/service/:id         → Service Request Details
/raise-request       → Create New Request
/profile             → Profile Screen
/edit-profile        → Edit Profile
```

## Key Features Implementation

### 1. Authentication Flow
- Login with username/email and password
- Form validation
- Error handling and user feedback
- JWT token storage
- Automatic logout on token expiry

### 2. Dashboard
- Summary of projects, elevators, and service requests
- Expiry alerts for warranty and AMC
- Recent notifications
- Quick action buttons

### 3. Project Tracking
- List all projects with status and progress
- View project details with milestones
- Track installation progress
- View project documents

### 4. Elevator Management
- View all installed elevators
- Check warranty status
- View AMC details
- Track maintenance history

### 5. Service Requests
- Create new service requests
- Select priority and category
- Track ticket status in real-time
- Add comments to tickets
- View service reports

### 6. Notifications
- Real-time push notifications (Firebase)
- In-app notification center
- Notification history
- Mark as read functionality

### 7. Profile Management
- View and edit personal information
- Change password
- View associated organizations
- Logout

## Error Handling

The app includes comprehensive error handling:
- Network error detection
- API error responses
- Form validation
- User-friendly error messages
- Automatic retry for failed requests

## Local Storage

The app uses SharedPreferences for:
- Authentication token storage
- User preferences
- Last sync timestamp
- Offline data cache

Hive can be used for more complex data storage in Phase 2.

## Push Notifications (Optional Firebase Integration)

To enable push notifications:

1. Set up Firebase project
2. Configure Android and iOS projects
3. Add Firebase credentials
4. Initialize Firebase in main.dart
5. Listen to incoming messages
6. Handle notification taps

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release  # For Google Play
```

### iOS
```bash
flutter build ios --release
flutter build ipa --release  # For App Store
```

## Phase 2 Features (Upcoming)

- [ ] Maintenance calendar view
- [ ] Preventive maintenance scheduling
- [ ] Warranty and AMC management with renewal requests
- [ ] Document management (PDFs, certificates)
- [ ] Service reports and completion feedback
- [ ] Offline data sync
- [ ] Local notifications for reminders

## Phase 3 Features (Advanced)

- [ ] QR code scanning for elevator identification
- [ ] Online payment integration
- [ ] Digital signatures for documents
- [ ] IoT elevator monitoring (if devices available)
- [ ] Multi-language support
- [ ] In-app chat with support team
- [ ] Offline mode with data sync

## Security Best Practices

1. ✅ JWT token-based authentication
2. ✅ Token stored in SharedPreferences (can upgrade to Keystore/Keychain)
3. ✅ Automatic token expiry handling
4. ✅ HTTPS for API calls
5. ✅ Input validation and sanitization
6. ✅ No sensitive data in logs
7. ⏳ Implement certificate pinning (Phase 2)
8. ⏳ Biometric authentication (Phase 2)

## Dependencies

See `pubspec.yaml` for complete list. Key dependencies:

- **provider** (v6.0.0+) - State management
- **dio** (v5.3.0+) - HTTP client
- **go_router** (v11.0.0+) - Navigation
- **shared_preferences** (v2.2.0+) - Local storage
- **firebase_core** & **firebase_messaging** - Push notifications
- **intl** (v0.18.0+) - Internationalization

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Create a pull request

## Deployment

### Dev Environment
- API: http://192.168.1.100:5000/api
- Firebase: Dev project

### Staging Environment
- API: https://staging-api.elevatorx.com/api
- Firebase: Staging project

### Production Environment
- API: https://api.elevatorx.com/api
- Firebase: Production project

## Troubleshooting

### Common Issues

1. **App won't connect to API**
   - Check API base URL in constants.dart
   - Ensure backend server is running
   - Check network connectivity

2. **Authentication failing**
   - Verify credentials
   - Check if user account exists
   - Clear app cache and try again

3. **Notifications not working**
   - Verify Firebase configuration
   - Check notification permissions
   - Ensure Firebase services are initialized

## Support & Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- Backend API Documentation: See backend README

## License

[Your License Here]

## Contact

For support, contact: support@elevatorx.com

---

**Last Updated**: October 2026
**Version**: 1.0.0 (Phase 1)
**Maintainer**: elevatorX Development Team
