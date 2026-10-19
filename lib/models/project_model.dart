class Project {
  final String id;
  final String projectId;
  final String customer;
  final String site;
  final String status;
  final int elevatorCount;
  final DateTime startDate;
  final DateTime targetDate;
  final DateTime? actualDate;
  final double budget;
  final double cost;
  final int progress;
  final List<Milestone> milestones;
  final String? description;
  final DateTime createdAt;

  Project({
    required this.id,
    required this.projectId,
    required this.customer,
    required this.site,
    required this.status,
    required this.elevatorCount,
    required this.startDate,
    required this.targetDate,
    this.actualDate,
    required this.budget,
    required this.cost,
    required this.progress,
    required this.milestones,
    this.description,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'] ?? json['id'] ?? '',
      projectId: json['projectId'] ?? '',
      customer: json['customer'] ?? '',
      site: json['site'] ?? '',
      status: json['status'] ?? 'Pending',
      elevatorCount: json['elevatorCount'] ?? 0,
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      targetDate: DateTime.tryParse(json['targetDate'] ?? '') ?? DateTime.now(),
      actualDate: json['actualDate'] != null ? DateTime.tryParse(json['actualDate']) : null,
      budget: (json['budget'] ?? 0).toDouble(),
      cost: (json['cost'] ?? 0).toDouble(),
      progress: json['progress'] ?? 0,
      milestones: (json['milestones'] as List<dynamic>?)
          ?.map((m) => Milestone.fromJson(m))
          .toList() ?? [],
      description: json['description'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'projectId': projectId,
    'customer': customer,
    'site': site,
    'status': status,
    'elevatorCount': elevatorCount,
    'startDate': startDate.toIso8601String(),
    'targetDate': targetDate.toIso8601String(),
    'actualDate': actualDate?.toIso8601String(),
    'budget': budget,
    'cost': cost,
    'progress': progress,
    'milestones': milestones.map((m) => m.toJson()).toList(),
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };
}

class Milestone {
  final String id;
  final String name;
  final String status;
  final DateTime? completedDate;
  final String? remarks;

  Milestone({
    required this.id,
    required this.name,
    required this.status,
    this.completedDate,
    this.remarks,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'Pending',
      completedDate: json['completedDate'] != null ? DateTime.tryParse(json['completedDate']) : null,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'status': status,
    'completedDate': completedDate?.toIso8601String(),
    'remarks': remarks,
  };
}
