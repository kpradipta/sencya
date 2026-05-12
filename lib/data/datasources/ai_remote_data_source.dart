import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/error/exceptions.dart';
import '../models/ai_model.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../core/storage/dev_settings_storage.dart';

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
        throw ServerException(
          message: response.data['message'] ?? 'Upload failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }

  @override
  Future<AIAnalysisModel> analyzePhoto(
    String photoId, {
    String? serviceId,
  }) async {
    // Check for mock AI features setting
    final useMock = await DevSettingsStorage.getBool(
      DevSettingsStorage.mockAiFeaturesKey,
    );
    if (useMock) {
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay
      return AIAnalysisModel.fromJson(
        {
          "face_shape": "Oval/Lonjong",
          "face_analysis_result":
              "Wajah memiliki proporsi yang relatif seimbang, namun sedikit lebih panjang dari lebarnya, menempatkannya di antara oval dan lonjong. Dahi dan rahang memiliki lebar yang seimbang. Bentuk wajah ini sangat serbaguna untuk berbagai gaya rambut.",
          "hair_analysis_result": {
            "hair_line":
                "Lurus ke C-Shape (slight M-shape) di pelipis. Garis rambut depan cukup padat.",
            "hair_type": {
              "code": "1C/2A",
              "type":
                  "Lurus tebal cenderung sedikit bergelombang (Thick Straight to Slightly Wavy)",
            },
          },
          "recommendation": [
            {
              "haircut_name": "Modern Pompadour/Quiff dengan Low Fade",
              "analysis":
                  "Potongan ini bekerja sempurna untuk wajah oval karena menciptakan volume ke atas, memberikan ilusi wajah yang lebih pendek. Fade di samping menjaga tampilan tetap rapi dan modern.",
              "styling":
                  "Gunakan pomade atau clay dengan daya tahan tinggi untuk mempertahankan volume dan tekstur di bagian atas. Sisir ke atas dan sedikit ke belakang.",
              "rating": "9/10",
            },
            {
              "haircut_name": "Textured Crop (French Crop)",
              "analysis":
                  "Potongan ini sangat rendah perawatan dan memanfaatkan tekstur rambut alami. Poni pendek yang jatuh ke dahi dapat menyamarkan garis rambut dan memberikan kesan wajah lebih maskulin dan terstruktur.",
              "styling":
                  "Sedikit wax atau sea salt spray untuk menonjolkan tekstur. Styling cukup dengan jari.",
              "rating": "8.5/10",
            },
            {
              "haircut_name": "Classic Taper dengan Side Parting",
              "analysis":
                  "Potongan klasik yang selalu cocok dengan wajah oval. Panjang yang bergradasi (taper) di samping dan belakang memberikan kesan profesional namun tetap segar. Belahan samping menambah dimensi horizontal.",
              "styling":
                  "Gunakan produk berbasis krim atau pomade shine rendah. Sisir rapi sesuai belahan.",
              "rating": "8/10",
            },
          ],
          "extra":
              "Pria ini memiliki kumis dan janggut tipis yang menambah definisi pada rahang bawah. Potongan rambut harus selaras dengan gaya facial hair yang ada.",
        },
        photoId: photoId,
        requestId: "mock-request-id",
      );
    }

    int retryCount = 0;
    const int maxRetries = 3;

    while (true) {
      try {
        final response = await apiClient.dio.post(
          '/analyze-photo',
          data: {'photo_id': photoId, 'service_id': serviceId ?? ''},
          options: Options(
            receiveTimeout: const Duration(minutes: 5),
            sendTimeout: const Duration(minutes: 5),
          ),
        );
        if (response.statusCode == 200) {
          return AIAnalysisModel.fromJson(response.data['data']);
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'Analysis failed',
          );
        }
      } on DioException catch (e) {
        if (retryCount < maxRetries &&
            (e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout)) {
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          continue;
        }
        throw ServerException(
          message: e.response?.data['message'] ?? 'Connection error: ${e.type}',
        );
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
        data: {'style_name': styleName, 'add_ons': addOns ?? []},
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      if (response.statusCode == 200) {
        return HaircutRecommendationModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Generation failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }

  @override
  Future<AIGenerationRequestModel> generateImageByName({
    required String photoId,
    required List<StyleRecommendation> recommendations,
  }) async {
    // Check for mock AI features setting
    final useMock = await DevSettingsStorage.getBool(
      DevSettingsStorage.mockAiFeaturesKey,
    );
    if (useMock) {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      return AIGenerationRequestModel.fromJson({
        "request_id": "683ed1af-635e-43c0-8a93-6486080ff4e1",
        "status": "running",
      });
    }

    try {
      final response = await apiClient.dio.post(
        '/generate-image/by-name',
        data: {
          'photo_id': photoId,
          'recommendation': recommendations
              .map(
                (e) => {
                  'haircut_name': e.haircutName,
                  'analysis': e.analysis,
                  'styling': e.styling,
                  'rating': e.rating,
                },
              )
              .toList(),
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      if (response.statusCode == 200) {
        return AIGenerationRequestModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Generation failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }

  @override
  Future<List<GeneratedPhotoModel>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  }) async {
    // Check for mock AI features setting
    final useMock = await DevSettingsStorage.getBool(
      DevSettingsStorage.mockAiFeaturesKey,
    );
    if (useMock) {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      return [
        {
          "id": "584adfc3-ff68-4586-9959-57b073ea6434",
          "url":
              "//2e56a7d7-bc79-4707-a574-bf8355357749/original/Screenshot_20260511-191446.jpg",
          "created_at": "2025-12-17T22:22:01.902122+07:00",
        },
        {
          "id": "584adfc3-ff68-4586-9959-57b073ea6434",
          "url":
              "//2e56a7d7-bc79-4707-a574-bf8355357749/original/Screenshot_20260511-191446.jpg",
          "created_at": "2025-12-17T22:22:01.902122+07:00",
        },
        {
          "id": "584adfc3-ff68-4586-9959-57b073ea6434",
          "url":
              "//2e56a7d7-bc79-4707-a574-bf8355357749/original/Screenshot_20260511-191446.jpg",
          "created_at": "2025-12-17T22:22:01.902122+07:00",
        },
      ].map((e) => GeneratedPhotoModel.fromJson(e)).toList();
    }

    try {
      final response = await apiClient.dio.get('/photos/$userId/$requestId');

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((e) => GeneratedPhotoModel.fromJson(e))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to retrieve photos',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Connection error',
      );
    }
  }
}
