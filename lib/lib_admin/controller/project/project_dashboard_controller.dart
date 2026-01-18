import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../core/class/statusrequest.dart';
import '../../core/services/auth_service.dart';
import '../../data/Models/project_model.dart';
import '../../data/repository/projects_repository.dart';

abstract class ProjectDashboardController extends GetxController {
  List<ProjectModel> get allProjects;
  ProjectModel? get selectedProject;
  StatusRequest get statusRequest;
  bool get isLoading;
  Map<String, dynamic> get stats;
  bool get isLoadingStats;
  void changeSelectedProject(ProjectModel? project);
  Future<void> loadAllProjects({bool refresh = false});
  Future<void> loadStats();
}

class ProjectDashboardControllerImp extends ProjectDashboardController {
  final ProjectsRepository _repository = ProjectsRepository();
  final AuthService _authService = AuthService();
  List<ProjectModel> _allProjects = [];
  ProjectModel? _selectedProject;
  StatusRequest _statusRequest = StatusRequest.none;
  bool _isLoading = false;
  Map<String, dynamic> _stats = {};
  bool _isLoadingStats = false;

  @override
  List<ProjectModel> get allProjects => _allProjects;

  @override
  ProjectModel? get selectedProject => _selectedProject;

  @override
  StatusRequest get statusRequest => _statusRequest;

  @override
  bool get isLoading => _isLoading;

  @override
  Map<String, dynamic> get stats => _stats;

  @override
  bool get isLoadingStats => _isLoadingStats;

  @override
  void onInit() {
    super.onInit();
    loadAllProjects();
    loadStats();
  }

  @override
  Future<void> loadAllProjects({bool refresh = false}) async {
    if (_isLoading && !refresh) return;
    _isLoading = true;
    _statusRequest = StatusRequest.loading;
    update();
    try {
      final companyId = await _authService.getCompanyId();
      if (companyId == null || companyId.isEmpty) {
        _isLoading = false;
        _statusRequest = StatusRequest.serverFailure;
        update();
        return;
      }
      final result = await _repository.getAllProjectsWithStats(
        companyId: companyId,
      );
      _isLoading = false;
      result.fold(
        (error) {
          _statusRequest = error;
          _allProjects = [];
          _stats = {};
        },
        (data) {
          _allProjects = data['projects'] as List<ProjectModel>;
          _statusRequest = StatusRequest.success;

          if (_selectedProject == null && _allProjects.isNotEmpty) {
            _selectedProject = _allProjects.first;
          }

          _calculateStatsFromProjects();
          _isLoadingStats = false;
        },
      );
    } catch (e) {
      _isLoading = false;
      _statusRequest = StatusRequest.serverException;
      _allProjects = [];
    }
    update();
  }

  @override
  Future<void> loadStats() async {
    _isLoadingStats = true;
    update();
    try {
      _calculateStatsFromProjects();
    } catch (e) {
      _stats = {};
    }
    _isLoadingStats = false;
    update();
  }

  void _calculateStatsFromProjects() {
    if (_selectedProject == null) {
      _stats = {
        'activeProjects': 0,
        'totalTasks': 0,
        'teamMembers': 0,
        'completionRate': 0.0,
      };
      return;
    }

    final project = _selectedProject!;

    final isActive =
        project.status.toLowerCase() == 'active' ||
        project.status.toLowerCase() == 'in_progress';

    final teamMembers = project.teamMembers;

    _stats = {
      'activeProjects': isActive ? 1 : 0,
      'totalTasks': project.totalTasks ?? 0,
      'teamMembers': teamMembers,
      'completionRate': project.progressPercentage ?? 0.0,
    };
  }

  @override
  void changeSelectedProject(ProjectModel? project) {
    if (project != null) {
      _selectedProject = project;
      _calculateStatsFromProjects();
      update();
    }
  }

  int get activeProjectsCount {
    if (_stats.isEmpty) return 0;
    return _stats['activeProjects'] ??
        _stats['active'] ??
        _stats['activeProjectsCount'] ??
        0;
  }

  int get totalTasksCount {
    if (_stats.isEmpty) return 0;
    return _stats['totalTasks'] ??
        _stats['tasks'] ??
        _stats['totalTasksCount'] ??
        0;
  }

  int get teamMembersCount {
    if (_stats.isEmpty) return 0;
    return _stats['teamMembers'] ??
        _stats['members'] ??
        _stats['teamMembersCount'] ??
        0;
  }

  double get completionRate {
    if (_stats.isEmpty) return 0.0;
    final rate =
        _stats['completionRate'] ??
        _stats['completion'] ??
        _stats['progress'] ??
        _stats['avgCompletionRate'] ??
        0.0;
    if (rate is num) return rate.toDouble();
    return 0.0;
  }
}
