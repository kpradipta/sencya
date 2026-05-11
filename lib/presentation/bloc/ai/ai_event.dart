import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/ai_recommendation.dart';

abstract class AIEvent extends Equatable {
  const AIEvent();

  @override
  List<Object?> get props => [];
}

class AnalyzePhotoRequested extends AIEvent {
  final File photo;
  const AnalyzePhotoRequested(this.photo);

  @override
  List<Object?> get props => [photo];
}

class GenerateImageByNameRequested extends AIEvent {
  final String photoId;
  final List<StyleRecommendation> recommendations;

  const GenerateImageByNameRequested({
    required this.photoId,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [photoId, recommendations];
}

class FetchGeneratedPhotosRequested extends AIEvent {
  final String userId;
  final String requestId;

  const FetchGeneratedPhotosRequested({
    required this.userId,
    required this.requestId,
  });

  @override
  List<Object?> get props => [userId, requestId];
}

class GenerateHaircutRequested extends AIEvent {
  final String styleName;
  final List<String>? addOns;

  const GenerateHaircutRequested({
    required this.styleName,
    this.addOns,
  });

  @override
  List<Object?> get props => [styleName, addOns];
}
