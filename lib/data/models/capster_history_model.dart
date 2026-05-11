import '../../domain/entities/capster_history.dart';

class CapsterHistoryModel extends CapsterHistory {
  const CapsterHistoryModel({
    required super.id,
    required super.date,
    required super.member,
    required super.totalVisits,
    required super.lastServedDate,
    required super.lastServiceType,
    required super.haircutName,
    required super.isMember,
    required super.transactionAmount,
  });

  factory CapsterHistoryModel.fromJson(Map<String, dynamic> json) {
    return CapsterHistoryModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      member: CustomerMemberModel.fromJson(json['member']),
      totalVisits: json['total_visits'] ?? 0,
      lastServedDate: DateTime.parse(json['last_served_date']),
      lastServiceType: json['last_service_type'] ?? '',
      haircutName: json['haircut_name'] ?? '',
      isMember: json['is_member'] ?? false,
      transactionAmount: json['transaction_amount'] ?? 0,
    );
  }
}

class CustomerMemberModel extends CustomerMember {
  const CustomerMemberModel({
    required super.id,
    required super.email,
    required super.phone,
    required super.fullName,
    required super.point,
    required super.role,
    required super.status,
  });

  factory CustomerMemberModel.fromJson(Map<String, dynamic> json) {
    return CustomerMemberModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      fullName: json['full_name'] ?? '',
      point: json['point'] ?? 0,
      role: json['role'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
