import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/booking_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  @override
  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<CreateBookingRequested>(_onCreateBookingRequested);
    on<GetUserBookingsRequested>(_onGetUserBookingsRequested);
  }

  Future<void> _onCreateBookingRequested(CreateBookingRequested event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await bookingRepository.createBooking(
      serviceId: event.serviceId,
      capsterId: event.capsterId,
      scheduledAt: event.scheduledAt,
    );
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (booking) => emit(BookingCreated(booking)),
    );
  }

  Future<void> _onGetUserBookingsRequested(GetUserBookingsRequested event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await bookingRepository.getUserBookings();
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(UserBookingsLoaded(bookings)),
    );
  }
}
