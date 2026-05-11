import 'package:equatable/equatable.dart';

class AIAnalysis extends Equatable {
  final String? photoId;
  final String? requestId;
  final String faceShape;
  final String faceAnalysisResult;
  final Map<String, dynamic> hairAnalysisResult;
  final List<StyleRecommendation> recommendations;
  final String extra;

  const AIAnalysis({
    this.photoId,
    this.requestId,
    required this.faceShape,
    required this.faceAnalysisResult,
    required this.hairAnalysisResult,
    required this.recommendations,
    required this.extra,
  });

  @override
  List<Object?> get props => [
        photoId,
        requestId,
        faceShape,
        faceAnalysisResult,
        hairAnalysisResult,
        recommendations,
        extra,
      ];
}

class StyleRecommendation extends Equatable {
  final String haircutName;
  final String analysis;
  final String styling;
  final String rating;

  const StyleRecommendation({
    required this.haircutName,
    required this.analysis,
    required this.styling,
    required this.rating,
  });

  @override
  List<Object?> get props => [haircutName, analysis, styling, rating];
}

class HaircutRecommendation extends Equatable {
  final String imageUrl;
  final String styleName;
  final List<String> addOns;

  const HaircutRecommendation({
    required this.imageUrl,
    required this.styleName,
    required this.addOns,
  });

  @override
  List<Object?> get props => [imageUrl, styleName, addOns];
}

class AIGenerationRequest extends Equatable {
  final String requestId;
  final String status;

  const AIGenerationRequest({
    required this.requestId,
    required this.status,
  });

  @override
  List<Object?> get props => [requestId, status];
}

class GeneratedPhoto extends Equatable {
  final String id;
  final String url;
  final String? styleName;
  final DateTime createdAt;

  const GeneratedPhoto({
    required this.id,
    required this.url,
    this.styleName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, url, styleName, createdAt];
}
