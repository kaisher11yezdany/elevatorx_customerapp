import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/elevator_model.dart';
import '../models/service_request_model.dart';
import '../models/dashboard_model.dart';

class ApiService {
  late Dio _dio;
  late SharedPreferences _prefs;
  String? _token;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token expired, trigger logout
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('auth_token');
  }

  // ═══════════════════════════════════════════
  // AUTH ENDPOINTS
  // ═══════════════════════════════════════════

  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      final authResponse = AuthResponse.fromJson(response.data);
      _token = authResponse.token;
      await _prefs.setString('auth_token', authResponse.token);
      await _prefs.setString('user', response.data.toString());
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signup(String name, String email, String phone, String password) async {
    try {
      final response = await _dio.post('/auth/signup', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    await _prefs.remove('auth_token');
    await _prefs.remove('user');
  }

  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateProfile(String name, String email, String? phone) async {
    try {
      final response = await _dio.put('/auth/profile', data: {
        'name': name,
        'email': email,
        if (phone != null) 'phone': phone,
      });
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  // DASHBOARD ENDPOINTS
  // ═══════════════════════════════════════════

  Future<DashboardData> getDashboardData() async {
    try {
      final response = await _dio.get('/customers/dashboard');
      return DashboardData.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  // PROJECT ENDPOINTS
  // ═══════════════════════════════════════════

  Future<List<Project>> getProjects() async {
    try {
      final response = await _dio.get('/projects');
      final data = response.data as List<dynamic>;
      return data.map((p) => Project.fromJson(p)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Project> getProjectDetail(String projectId) async {
    try {
      final response = await _dio.get('/projects/$projectId');
      return Project.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  // ELEVATOR ENDPOINTS
  // ═══════════════════════════════════════════

  Future<List<Elevator>> getElevators() async {
    try {
      final response = await _dio.get('/elevators');
      final data = response.data as List<dynamic>;
      return data.map((e) => Elevator.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Elevator> getElevatorDetail(String elevatorId) async {
    try {
      final response = await _dio.get('/elevators/$elevatorId');
      return Elevator.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  // SERVICE REQUEST ENDPOINTS
  // ═══════════════════════════════════════════

  Future<List<ServiceRequest>> getServiceRequests() async {
    try {
      final response = await _dio.get('/breakdowns');
      final data = response.data as List<dynamic>;
      return data.map((s) => ServiceRequest.fromJson(s)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceRequest> getServiceRequestDetail(String requestId) async {
    try {
      final response = await _dio.get('/breakdowns/$requestId');
      return ServiceRequest.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ServiceRequest> createServiceRequest(CreateServiceRequestRequest request) async {
    try {
      final response = await _dio.post('/breakdowns', data: request.toJson());
      return ServiceRequest.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addCommentToRequest(String requestId, String comment) async {
    try {
      await _dio.post('/breakdowns/$requestId/comment', data: {
        'text': comment,
      });
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  // MAINTENANCE ENDPOINTS
  // ═══════════════════════════════════════════

  Future<List<MaintenanceVisit>> getMaintenanceSchedule() async {
    try {
      final response = await _dio.get('/maintenance/schedule');
      final data = response.data as List<dynamic>;
      return data.map((m) => MaintenanceVisit.fromJson(m)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // ═══════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════

  bool get isLoggedIn => _token != null;
  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }
}
