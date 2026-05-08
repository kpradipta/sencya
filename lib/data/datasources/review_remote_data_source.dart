import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewModel> createReview({
    required String bookingId,
    required num rating,
    required String comment,
  });
  Future<List<ReviewModel>> getCapsterReviews(String capsterId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiClient apiClient;

  ReviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ReviewModel> createReview({
    required String bookingId,
    required num rating,
    required String comment,
  }) async {
    try {
      final response = await apiClient.dio.post('/reviews', data: {
        'booking_id': bookingId,
        'rating': rating,
        'comment': comment,
      });

      if (response.statusCode == 201) {
        return ReviewModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to create review');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<List<ReviewModel>> getCapsterReviews(String capsterId) async {
    try {
      final response = await apiClient.dio.get('/capsters/$capsterId/reviews');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data['data'];
        return jsonList.map((e) => ReviewModel.fromJson(e)).toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to get reviews');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
