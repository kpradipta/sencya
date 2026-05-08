import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String serviceId;
  final String capsterId;
  final DateTime scheduledAt;
  final String status;
  final num totalPrice;
  final String date;

  const Booking({
    required this.id,
    required this.serviceId,
    required this.capsterId,
    required this.scheduledAt,
    required this.status,
    required this.totalPrice,
    required this.date
  });

  @override
  List<Object?> get props => [id, serviceId, capsterId, scheduledAt, status, totalPrice, date];
}
