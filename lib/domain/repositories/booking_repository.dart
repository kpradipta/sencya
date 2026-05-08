import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, Booking>> createBooking({
    required String serviceId,
    required String capsterId,
    required DateTime scheduledAt,
  });
  Future<Either<Failure, List<Booking>>> getUserBookings();
}
