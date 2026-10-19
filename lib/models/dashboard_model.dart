class DashboardData {
  final int totalProjects;
  final int projectsInProgress;
  final int installedElevators;
  final int activeServiceRequests;
  final int upcomingMaintenance;
  final int overdueItems;
  final List<Notification> recentNotifications;
  final List<ExpiryAlert> expiryAlerts;

  DashboardData({
    required this.totalProjects,
    required this.projectsInProgress,
    required this.installedElevators,
    required this.activeServiceRequests,
    required this.upcomingMaintenance,
    required this.overdueItems,
    required this.recentNotifications,
    required this.expiryAlerts,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalProjects: json['totalProjects'] ?? 0,
      projectsInProgress: json['projectsInProgress'] ?? 0,
      installedElevators: json['installedElevators'] ?? 0,
      activeServiceRequests: json['activeServiceRequests'] ?? 0,
      upcomingMaintenance: json['upcomingMaintenance'] ?? 0,
      overdueItems: json['overdueItems'] ?? 0,
      recentNotifications: (json['recentNotifications'] as List<dynamic>?)
          ?.map((n) => Notification.fromJson(n))
          .toList() ?? [],
      expiryAlerts: (json['expiryAlerts'] as List<dynamic>?)
          ?.map((a) => ExpiryAlert.fromJson(a))
          .toList() ?? [],
    );
  }
}

class Notification {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;
  final String? link;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.read,
    this.link,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? 'info',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      read: json['read'] ?? false,
      link: json['link'],
    );
  }
}

class ExpiryAlert {
  final String elevatorId;
  final String elevatorName;
  final String type; // 'warranty' or 'amc'
  final int daysRemaining;
  final DateTime expiryDate;

  ExpiryAlert({
    required this.elevatorId,
    required this.elevatorName,
    required this.type,
    required this.daysRemaining,
    required this.expiryDate,
  });

  factory ExpiryAlert.fromJson(Map<String, dynamic> json) {
    return ExpiryAlert(
      elevatorId: json['elevatorId'] ?? '',
      elevatorName: json['elevatorName'] ?? '',
      type: json['type'] ?? 'warranty',
      daysRemaining: json['daysRemaining'] ?? 0,
      expiryDate: DateTime.tryParse(json['expiryDate'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isExpired => daysRemaining <= 0;
  bool get isUrgent => daysRemaining <= 30 && daysRemaining > 0;
}

class MaintenanceVisit {
  final String id;
  final String elevator;
  final String building;
  final String status;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String? technician;
  final String? report;

  MaintenanceVisit({
    required this.id,
    required this.elevator,
    required this.building,
    required this.status,
    required this.scheduledDate,
    this.completedDate,
    this.technician,
    this.report,
  });

  factory MaintenanceVisit.fromJson(Map<String, dynamic> json) {
    return MaintenanceVisit(
      id: json['_id'] ?? json['id'] ?? '',
      elevator: json['elevator'] ?? '',
      building: json['building'] ?? '',
      status: json['status'] ?? 'Scheduled',
      scheduledDate: DateTime.tryParse(json['scheduledDate'] ?? '') ?? DateTime.now(),
      completedDate: json['completedDate'] != null ? DateTime.tryParse(json['completedDate']) : null,
      technician: json['technician'],
      report: json['report'],
    );
  }
}
