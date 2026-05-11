import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/ai_model.dart';
import '../../domain/entities/ai_recommendation.dart';

abstract class AIRemoteDataSource {
  Future<String> uploadPhoto(File photo);
  Future<AIAnalysisModel> analyzePhoto(String photoId, {String? serviceId});
  Future<HaircutRecommendationModel> generateHaircut({
    required String styleName,
    List<String>? addOns,
  });
  Future<AIGenerationRequestModel> generateImageByName({
    required String photoId,
    required List<StyleRecommendation> recommendations,
  });
  Future<List<GeneratedPhotoModel>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  });
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final ApiClient apiClient;

  AIRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> uploadPhoto(File photo) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
      });

      final response = await apiClient.dio.post('/photos', data: formData);
      if (response.statusCode == 201) {
        return response.data['data']['id'];
      } else {
        throw ServerException(message: response.data['message'] ?? 'Upload failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<AIAnalysisModel> analyzePhoto(String photoId, {String? serviceId}) async {
    int retryCount = 0;
    const int maxRetries = 3;

    while (true) {
      try {
        final response = await apiClient.dio.post(
          '/analyze-photo',
          data: {
            'photo_id': photoId,
            'service_id': serviceId ?? '',
          },
          options: Options(
            receiveTimeout: const Duration(minutes: 5),
            sendTimeout: const Duration(minutes: 5),
          ),
        );
        if (response.statusCode == 200) {
          return AIAnalysisModel.fromJson(response.data['data']);
        } else {
          throw ServerException(message: response.data['message'] ?? 'Analysis failed');
        }
      } on DioException catch (e) {
        if (retryCount < maxRetries && (e.type == DioExceptionType.receiveTimeout || e.type == DioExceptionType.connectionTimeout)) {
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        throw ServerException(message: e.response?.data['message'] ?? 'Connection error: ${e.type}');
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    }
  }

  @override
  Future<HaircutRecommendationModel> generateHaircut({
    required String styleName,
    List<String>? addOns,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/ai/generate',
        data: {
          'style_name': styleName,
          'add_ons': addOns ?? [],
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      if (response.statusCode == 200) {
        return HaircutRecommendationModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Generation failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<AIGenerationRequestModel> generateImageByName({
    required String photoId,
    required List<StyleRecommendation> recommendations,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/generate-image/by-name',
        data: {
          'photo_id': photoId,
          'recommendation': recommendations.map((e) => {
            'haircut_name': e.haircutName,
            'analysis': e.analysis,
            'styling': e.styling,
            'rating': e.rating,
          }).toList(),
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      if (response.statusCode == 200) {
        return AIGenerationRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Generation failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<List<GeneratedPhotoModel>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  }) async {
    try {
      final response = await apiClient.dio.get('/photos/$userId/$requestId');

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => GeneratedPhotoModel.fromJson(e))
            .toList();
      } else {
        throw ServerException(message: response.data['message'] ?? 'Failed to retrieve photos');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
