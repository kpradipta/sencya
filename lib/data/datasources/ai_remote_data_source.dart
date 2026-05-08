import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/ai_model.dart';

abstract class AIRemoteDataSource {
  Future<AIAnalysisModel> analyzePhoto(File photo);
  Future<HaircutRecommendationModel> generateHaircut({
    required String styleName,
    List<String>? addOns,
  });
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final ApiClient apiClient;

  AIRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AIAnalysisModel> analyzePhoto(File photo) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(photo.path),
      });

      final response = await apiClient.dio.post('/ai/analyze', data: formData);
      if (response.statusCode == 200) {
        return AIAnalysisModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Analysis failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }

  @override
  Future<HaircutRecommendationModel> generateHaircut({
    required String styleName,
    List<String>? addOns,
  }) async {
    try {
      final response = await apiClient.dio.post('/ai/generate', data: {
        'style_name': styleName,
        'add_ons': addOns ?? [],
      });

      if (response.statusCode == 200) {
        return HaircutRecommendationModel.fromJson(response.data['data']);
      } else {
        throw ServerException(message: response.data['message'] ?? 'Generation failed');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.response?.data['message'] ?? 'Connection error');
    }
  }
}
