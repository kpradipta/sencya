import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBookingRequested extends BookingEvent {
  final String serviceId;
  final String capsterId;
  final DateTime scheduledAt;

  const CreateBookingRequested({
    required this.serviceId,
    required this.capsterId,
    required this.scheduledAt,
  });

  @override
  List<Object> get props => [serviceId, capsterId, scheduledAt];
}

class GetUserBookingsRequested extends BookingEvent {}
