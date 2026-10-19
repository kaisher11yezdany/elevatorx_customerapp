class Elevator {
  final String id;
  final String elevatorId;
  final String site;
  final String building;
  final String model;
  final String type;
  final String serialNumber;
  final int capacity;
  final double speed;
  final int floorCount;
  final String location;
  final DateTime installationDate;
  final DateTime commissioningDate;
  final String status;
  final DateTime? warrantyExpiryDate;
  final String amcStatus;
  final DateTime? amcExpiryDate;
  final String manufacturer;
  final String? technicalSpecs;
  final List<String>? documents;
  final DateTime createdAt;

  Elevator({
    required this.id,
    required this.elevatorId,
    required this.site,
    required this.building,
    required this.model,
    required this.type,
    required this.serialNumber,
    required this.capacity,
    required this.speed,
    required this.floorCount,
    required this.location,
    required this.installationDate,
    required this.commissioningDate,
    required this.status,
    this.warrantyExpiryDate,
    required this.amcStatus,
    this.amcExpiryDate,
    required this.manufacturer,
    this.technicalSpecs,
    this.documents,
    required this.createdAt,
  });

  factory Elevator.fromJson(Map<String, dynamic> json) {
    return Elevator(
      id: json['_id'] ?? json['id'] ?? '',
      elevatorId: json['elevatorId'] ?? '',
      site: json['site'] ?? '',
      building: json['building'] ?? '',
      model: json['model'] ?? '',
      type: json['type'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      capacity: json['capacity'] ?? 0,
      speed: (json['speed'] ?? 0).toDouble(),
      floorCount: json['floorCount'] ?? 0,
      location: json['location'] ?? '',
      installationDate: DateTime.tryParse(json['installationDate'] ?? '') ?? DateTime.now(),
      commissioningDate: DateTime.tryParse(json['commissioningDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Operational',
      warrantyExpiryDate: json['warrantyExpiryDate'] != null ? DateTime.tryParse(json['warrantyExpiryDate']) : null,
      amcStatus: json['amcStatus'] ?? 'Inactive',
      amcExpiryDate: json['amcExpiryDate'] != null ? DateTime.tryParse(json['amcExpiryDate']) : null,
      manufacturer: json['manufacturer'] ?? '',
      technicalSpecs: json['technicalSpecs'],
      documents: List<String>.from(json['documents'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'elevatorId': elevatorId,
    'site': site,
    'building': building,
    'model': model,
    'type': type,
    'serialNumber': serialNumber,
    'capacity': capacity,
    'speed': speed,
    'floorCount': floorCount,
    'location': location,
    'installationDate': installationDate.toIso8601String(),
    'commissioningDate': commissioningDate.toIso8601String(),
    'status': status,
    'warrantyExpiryDate': warrantyExpiryDate?.toIso8601String(),
    'amcStatus': amcStatus,
    'amcExpiryDate': amcExpiryDate?.toIso8601String(),
    'manufacturer': manufacturer,
    'technicalSpecs': technicalSpecs,
    'documents': documents,
    'createdAt': createdAt.toIso8601String(),
  };

  bool get isWarrantyExpired => warrantyExpiryDate?.isBefore(DateTime.now()) ?? false;
  bool get isAmcExpired => amcExpiryDate?.isBefore(DateTime.now()) ?? false;

  int get warrantyDaysRemaining {
    if (warrantyExpiryDate == null) return -1;
    return warrantyExpiryDate!.difference(DateTime.now()).inDays;
  }

  int get amcDaysRemaining {
    if (amcExpiryDate == null) return -1;
    return amcExpiryDate!.difference(DateTime.now()).inDays;
  }
}
