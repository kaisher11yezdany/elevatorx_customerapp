class ServiceRequest {
  final String id;
  final String ticketId;
  final String customer;
  final String site;
  final String elevator;
  final String category;
  final String description;
  final String priority;
  final String status;
  final String? assignedTechnician;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolution;
  final List<Comment> comments;
  final List<String>? attachments;
  final String? serviceReport;

  ServiceRequest({
    required this.id,
    required this.ticketId,
    required this.customer,
    required this.site,
    required this.elevator,
    required this.category,
    required this.description,
    required this.priority,
    required this.status,
    this.assignedTechnician,
    required this.createdAt,
    this.resolvedAt,
    this.resolution,
    required this.comments,
    this.attachments,
    this.serviceReport,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['_id'] ?? json['id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      customer: json['customer'] ?? '',
      site: json['site'] ?? '',
      elevator: json['elevator'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'Medium',
      status: json['status'] ?? 'Submitted',
      assignedTechnician: json['assignedTechnician'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      resolvedAt: json['resolvedAt'] != null ? DateTime.tryParse(json['resolvedAt']) : null,
      resolution: json['resolution'],
      comments: (json['comments'] as List<dynamic>?)
          ?.map((c) => Comment.fromJson(c))
          .toList() ?? [],
      attachments: List<String>.from(json['attachments'] ?? []),
      serviceReport: json['serviceReport'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'ticketId': ticketId,
    'customer': customer,
    'site': site,
    'elevator': elevator,
    'category': category,
    'description': description,
    'priority': priority,
    'status': status,
    'assignedTechnician': assignedTechnician,
    'createdAt': createdAt.toIso8601String(),
    'resolvedAt': resolvedAt?.toIso8601String(),
    'resolution': resolution,
    'comments': comments.map((c) => c.toJson()).toList(),
    'attachments': attachments,
    'serviceReport': serviceReport,
  };

  bool get isResolved => status == 'Resolved' || status == 'Closed';
  bool get isOpen => !isResolved;

  int get daysSinceCreation {
    return DateTime.now().difference(createdAt).inDays;
  }
}

class Comment {
  final String id;
  final String author;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? json['id'] ?? '',
      author: json['author'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'author': author,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };

  String get timestamp => createdAt.toString().split('.')[0];
}

class CreateServiceRequestRequest {
  final String site;
  final String elevator;
  final String category;
  final String description;
  final String priority;
  final List<String>? attachments;

  CreateServiceRequestRequest({
    required this.site,
    required this.elevator,
    required this.category,
    required this.description,
    required this.priority,
    this.attachments,
  });

  Map<String, dynamic> toJson() => {
    'site': site,
    'elevator': elevator,
    'category': category,
    'description': description,
    'priority': priority,
    'attachments': attachments,
  };
}
