import 'package:flutter/foundation.dart';
import '../models/project_model.dart';
import '../services/api_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ApiService _apiService;

  ProjectProvider(this._apiService);

  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;
  String? _error;

  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProjects() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _projects = await _apiService.getProjects();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProjectDetail(String projectId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProject = await _apiService.getProjectDetail(projectId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  int get completedProjects => _projects.where((p) => p.status == 'Completed').length;
  int get inProgressProjects => _projects.where((p) => p.status == 'In Progress').length;
  int get delayedProjects => _projects.where((p) => p.status == 'Delayed').length;

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
