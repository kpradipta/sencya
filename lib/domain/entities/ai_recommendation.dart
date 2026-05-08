import 'package:equatable/equatable.dart';

class AIAnalysis extends Equatable {
  final String faceShape;
  final List<String> recommendedStyles;
  final String description;

  const AIAnalysis({
    required this.faceShape,
    required this.recommendedStyles,
    required this.description,
  });

  @override
  List<Object?> get props => [faceShape, recommendedStyles, description];
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
