import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Booking>> createBooking({
    required String serviceId,
    required String capsterId,
    required DateTime scheduledAt,
  }) async {
    try {
      final booking = await remoteDataSource.createBooking(
        serviceId: serviceId,
        capsterId: capsterId,
        scheduledAt: scheduledAt,
      );
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings() async {
    try {
      final bookings = await remoteDataSource.getUserBookings();
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
