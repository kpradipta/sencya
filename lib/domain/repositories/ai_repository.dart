import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/ai_recommendation.dart';

abstract class AIRepository {
  Future<Either<Failure, AIAnalysis>> analyzePhoto(File photo);
  Future<Either<Failure, HaircutRecommendation>> generateHaircut({
    required String styleName,
    List<String>? addOns,
  });
}
