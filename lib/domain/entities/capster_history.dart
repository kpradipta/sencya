import 'package:equatable/equatable.dart';

class CapsterHistory extends Equatable {
  final String id;
  final DateTime date;
  final CustomerMember member;
  final int totalVisits;
  final DateTime lastServedDate;
  final String lastServiceType;
  final String haircutName;
  final bool isMember;
  final num transactionAmount;

  const CapsterHistory({
    required this.id,
    required this.date,
    required this.member,
    required this.totalVisits,
    required this.lastServedDate,
    required this.lastServiceType,
    required this.haircutName,
    required this.isMember,
    required this.transactionAmount,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        member,
        totalVisits,
        lastServedDate,
        lastServiceType,
        haircutName,
        isMember,
        transactionAmount,
      ];
}

class CustomerMember extends Equatable {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final int point;
  final String role;
  final String status;

  const CustomerMember({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.point,
    required this.role,
    required this.status,
  });

  @override
  List<Object?> get props => [id, email, phone, fullName, point, role, status];
}
