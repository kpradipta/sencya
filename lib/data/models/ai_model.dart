import '../../core/network/api_config.dart';
import '../../domain/entities/ai_recommendation.dart';

class AIAnalysisModel extends AIAnalysis {
  const AIAnalysisModel({
    super.photoId,
    super.requestId,
    required super.faceShape,
    required super.faceAnalysisResult,
    required super.hairAnalysisResult,
    required super.recommendations,
    required super.extra,
  });

  factory AIAnalysisModel.fromJson(Map<String, dynamic> json, {String? photoId, String? requestId}) {
    return AIAnalysisModel(
      photoId: photoId ?? json['photo_id'],
      requestId: requestId ?? json['request_id'],
      faceShape: json['face_shape'] ?? '',
      faceAnalysisResult: json['face_analysis_result'] ?? '',
      hairAnalysisResult: json['hair_analysis_result'] ?? {},
      recommendations: (json['recommendation'] as List? ?? [])
          .map((e) => StyleRecommendationModel.fromJson(e))
          .toList(),
      extra: json['extra'] ?? '',
    );
  }
}

class StyleRecommendationModel extends StyleRecommendation {
  const StyleRecommendationModel({
    required super.haircutName,
    required super.analysis,
    required super.styling,
    required super.rating,
  });

  factory StyleRecommendationModel.fromJson(Map<String, dynamic> json) {
    return StyleRecommendationModel(
      haircutName: json['haircut_name'] ?? '',
      analysis: json['analysis'] ?? '',
      styling: json['styling'] ?? '',
      rating: json['rating'] ?? '',
    );
  }
}

class HaircutRecommendationModel extends HaircutRecommendation {
  const HaircutRecommendationModel({
    required super.imageUrl,
    required super.styleName,
    required super.addOns,
  });

  factory HaircutRecommendationModel.fromJson(Map<String, dynamic> json) {
    return HaircutRecommendationModel(
      imageUrl: json['image_url'] ?? '',
      styleName: json['style_name'] ?? '',
      addOns: List<String>.from(json['add_ons'] ?? []),
    );
  }
}

class AIGenerationRequestModel extends AIGenerationRequest {
  const AIGenerationRequestModel({
    required super.requestId,
    required super.status,
  });

  factory AIGenerationRequestModel.fromJson(Map<String, dynamic> json) {
    return AIGenerationRequestModel(
      requestId: json['request_id'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class GeneratedPhotoModel extends GeneratedPhoto {
  const GeneratedPhotoModel({
    required super.id,
    required super.url,
    super.styleName,
    required super.createdAt,
  });

  factory GeneratedPhotoModel.fromJson(Map<String, dynamic> json) {
    String rawUrl = json['url'] ?? '';
    // Handle relative URLs by prefixing with base URL from config
    String fullUrl = rawUrl;
    if (rawUrl.startsWith('/') && !rawUrl.startsWith('http')) {
      final baseUrl = ApiConfig.baseUrl.endsWith('/') 
          ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1) 
          : ApiConfig.baseUrl;
      
      // Ensure /photos is included if missing from the relative path
      // The user example shows: baseUrl + /photos + rawUrl
      String pathPrefix = '';
      if (!rawUrl.startsWith('/photos/')) {
        pathPrefix = '/photos';
      }
      
      fullUrl = '$baseUrl$pathPrefix$rawUrl';
    }

    // Extract style name from URL if name/style_name is empty
    String? extractedStyle = json['style_name'] ?? json['name'];
    if ((extractedStyle == null || extractedStyle.isEmpty) && rawUrl.isNotEmpty) {
      final filename = rawUrl.split('/').last;
      final parts = filename.split('_');
      if (parts.length > 2) {
        // Example: Side_Part_Klas_... -> Side Part Klas
        extractedStyle = parts.take(parts.length - 2).join(' ');
      } else {
        extractedStyle = filename.split('.').first;
      }
    }

    return GeneratedPhotoModel(
      id: json['id'] ?? '',
      url: fullUrl,
      styleName: extractedStyle,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
