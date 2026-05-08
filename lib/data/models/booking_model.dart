import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.serviceId,
    required super.capsterId,
    required super.scheduledAt,
    required super.status,
    required super.totalPrice,
    required super.date,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      serviceId: json['service_id'] ?? '',
      capsterId: json['capster_id'] ?? '',
      scheduledAt: DateTime.parse(json['scheduled_at'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      totalPrice: json['total_price'] ?? 0,
      date : json['date']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'capster_id': capsterId,
      'scheduled_at': scheduledAt.toIso8601String(),
    };
  }
}
