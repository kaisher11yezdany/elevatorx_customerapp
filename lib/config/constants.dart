import 'package:flutter/material.dart';

// API Configuration
class AppConfig {
  static const String apiBaseUrl = 'http://192.168.1.100:5000/api';
  // For production, use: https://api.elevatorx.com/api

  static const String apiTimeout = '30';
}

// App Colors
class AppColors {
  static const primary = Color(0xFF1E3A5F);
  static const secondary = Color(0xFFFF6B35);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const danger = Color(0xFFE53935);
  static const info = Color(0xFF2196F3);

  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE0E0E0);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF999999);
  static const textHint = Color(0xFFCCCCCC);

  static const shadowColor = Color(0x1A000000);
}

// Text Styles
class AppTextStyles {
  static const h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const h2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const h3 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const h4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary);
  static const body2 = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary);
  static const button = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white);
}

// Route Names
class Routes {
  static const String splash = '/';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String otp = 'otp';
  static const String forgotPassword = 'forgot-password';
  static const String home = 'home';
  static const String projects = 'projects';
  static const String projectDetail = 'project-detail';
  static const String elevators = 'elevators';
  static const String elevatorDetail = 'elevator-detail';
  static const String service = 'service';
  static const String serviceDetail = 'service-detail';
  static const String raiseRequest = 'raise-request';
  static const String profile = 'profile';
  static const String editProfile = 'edit-profile';
}

// Error Messages
class ErrorMessages {
  static const String networkError = 'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPhone = 'Please enter a valid phone number.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String weakPassword = 'Password must be at least 6 characters long.';
  static const String invalidOtp = 'Invalid OTP. Please try again.';
  static const String sessionExpired = 'Session expired. Please login again.';
  static const String unauthorized = 'You are not authorized to perform this action.';
  static const String notFound = 'Resource not found.';
}

// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'Login successful!';
  static const String signupSuccess = 'Account created successfully!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String requestSubmitted = 'Service request submitted successfully!';
  static const String logoutSuccess = 'Logged out successfully!';
}

// Regex Patterns
class Patterns {
  static final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final phoneRegex = RegExp(r'^\d{10}$');
  static final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z0-9@$!%*?&]{6,}$');
}

// App Constants
class AppConstants {
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
}

// Status Types
class StatusTypes {
  static const String pending = 'Pending';
  static const String inProgress = 'In Progress';
  static const String completed = 'Completed';
  static const String delayed = 'Delayed';
  static const String onHold = 'On Hold';
  static const String cancelled = 'Cancelled';

  static const String acknowledged = 'Acknowledged';
  static const String technicianAssigned = 'Technician Assigned';
  static const String waitingForParts = 'Waiting for Parts';
  static const String resolved = 'Resolved';
  static const String closed = 'Closed';
}

// Request Priority
class RequestPriority {
  static const String low = 'Low';
  static const String medium = 'Medium';
  static const String high = 'High';
  static const String critical = 'Critical';
}

// Maintenance Status
class MaintenanceStatus {
  static const String scheduled = 'Scheduled';
  static const String completed = 'Completed';
  static const String postponed = 'Postponed';
  static const String missed = 'Missed';
}
