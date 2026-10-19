import 'package:flutter/foundation.dart';
import '../models/service_request_model.dart';
import '../services/api_service.dart';

class ServiceRequestProvider extends ChangeNotifier {
  final ApiService _apiService;

  ServiceRequestProvider(this._apiService);

  List<ServiceRequest> _requests = [];
  ServiceRequest? _selectedRequest;
  bool _isLoading = false;
  String? _error;

  List<ServiceRequest> get requests => _requests;
  ServiceRequest? get selectedRequest => _selectedRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadServiceRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _requests = await _apiService.getServiceRequests();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRequestDetail(String requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedRequest = await _apiService.getServiceRequestDetail(requestId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createServiceRequest(CreateServiceRequestRequest request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newRequest = await _apiService.createServiceRequest(request);
      _requests.insert(0, newRequest);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addComment(String requestId, String comment) async {
    try {
      await _apiService.addCommentToRequest(requestId, comment);
      await loadRequestDetail(requestId);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  int get openCount => _requests.where((r) => r.isOpen).length;
  int get resolvedCount => _requests.where((r) => r.isResolved).length;
  int get criticalCount => _requests.where((r) => r.priority == 'Critical' && r.isOpen).length;

  List<ServiceRequest> get openRequests => _requests.where((r) => r.isOpen).toList();
  List<ServiceRequest> get recentRequests {
    final sorted = [..._requests];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
