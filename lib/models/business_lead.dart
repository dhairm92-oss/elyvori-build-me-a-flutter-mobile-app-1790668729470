class BusinessLead {
  final String id;
  final String name;
  final String country;
  final String sector;
  final String phone;
  final String address;
  final bool hasWebsite;
  final bool hasApp;
  String status;
  String notes;
  final DateTime discoveredDate;

  BusinessLead({
    required this.id,
    required this.name,
    required this.country,
    required this.sector,
    required this.phone,
    required this.address,
    required this.hasWebsite,
    required this.hasApp,
    this.status = 'Pending',
    this.notes = '',
    required this.discoveredDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'country': country,
    'sector': sector,
    'phone': phone,
    'address': address,
    'hasWebsite': hasWebsite,
    'hasApp': hasApp,
    'status': status,
    'notes': notes,
    'discoveredDate': discoveredDate.toIso8601String(),
  };

  factory BusinessLead.fromJson(Map<String, dynamic> json) => BusinessLead(
    id: json['id'],
    name: json['name'],
    country: json['country'],
    sector: json['sector'],
    phone: json['phone'],
    address: json['address'],
    hasWebsite: json['hasWebsite'],
    hasApp: json['hasApp'],
    status: json['status'] ?? 'Pending',
    notes: json['notes'] ?? '',
    discoveredDate: DateTime.parse(json['discoveredDate']),
  );
}