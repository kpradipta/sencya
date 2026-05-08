import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/booking_model.dart';
import 'package:intl/intl.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking({
    required String serviceId,
    required String capsterId,
    required DateTime scheduledAt,
  });
  Future<List<BookingModel>> getUserBookings();
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BookingModel> createBooking({
    required String serviceId,
    required String capsterId,
    required DateTime scheduledAt,
  }) async {
    try {
      final response = await apiClient.dio.post('/bookings', data: {
        'service_id': serviceId,
        'capster_id': capsterId,
        'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      });

      if (response.statusCode == 201) {
        return BookingModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Booking failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings() async {
    try {
      final response = await apiClient.dio.get('/bookings');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList.map((e) => BookingModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get bookings');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
