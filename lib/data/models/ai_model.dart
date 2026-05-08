import '../../domain/entities/ai_recommendation.dart';

class AIAnalysisModel extends AIAnalysis {
  const AIAnalysisModel({
    required super.faceShape,
    required super.recommendedStyles,
    required super.description,
  });

  factory AIAnalysisModel.fromJson(Map<String, dynamic> json) {
    return AIAnalysisModel(
      faceShape: json['face_shape'] ?? '',
      recommendedStyles: List<String>.from(json['recommended_styles'] ?? []),
      description: json['description'] ?? '',
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
