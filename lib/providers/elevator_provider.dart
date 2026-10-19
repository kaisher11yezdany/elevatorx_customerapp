import 'package:flutter/foundation.dart';
import '../models/elevator_model.dart';
import '../services/api_service.dart';

class ElevatorProvider extends ChangeNotifier {
  final ApiService _apiService;

  ElevatorProvider(this._apiService);

  List<Elevator> _elevators = [];
  Elevator? _selectedElevator;
  bool _isLoading = false;
  String? _error;

  List<Elevator> get elevators => _elevators;
  Elevator? get selectedElevator => _selectedElevator;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadElevators() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _elevators = await _apiService.getElevators();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadElevatorDetail(String elevatorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedElevator = await _apiService.getElevatorDetail(elevatorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  int get operationalCount => _elevators.where((e) => e.status == 'Operational').length;
  int get maintenanceCount => _elevators.where((e) => e.status == 'Maintenance').length;
  int get breakdownCount => _elevators.where((e) => e.status == 'Breakdown').length;
  int get warrantyExpiredCount => _elevators.where((e) => e.isWarrantyExpired).length;
  int get amcExpiredCount => _elevators.where((e) => e.isAmcExpired).length;

  List<Elevator> get elevatorsWithSoonExpiredWarranty {
    return _elevators
        .where((e) => !e.isWarrantyExpired && e.warrantyDaysRemaining > 0 && e.warrantyDaysRemaining <= 30)
        .toList();
  }

  List<Elevator> get elevatorsWithExpiredAMC {
    return _elevators.where((e) => e.isAmcExpired).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
