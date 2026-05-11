import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_data_source.dart';
import '../models/ai_model.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AIAnalysis>> analyzePhoto(File photo) async {
    try {
      final photoId = await remoteDataSource.uploadPhoto(photo);
      final analysis = await remoteDataSource.analyzePhoto(photoId);
      
      // Automatically trigger image generation after analysis
      final generationRequest = await remoteDataSource.generateImageByName(
        photoId: photoId,
        recommendations: analysis.recommendations,
      );

      // Create a final model with both photoId and requestId
      final analysisWithIds = AIAnalysisModel(
        photoId: photoId,
        requestId: generationRequest.requestId,
        faceShape: analysis.faceShape,
        faceAnalysisResult: analysis.faceAnalysisResult,
        hairAnalysisResult: analysis.hairAnalysisResult,
        recommendations: analysis.recommendations,
        extra: analysis.extra,
      );
      return Right(analysisWithIds);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HaircutRecommendation>> generateHaircut({
    required String styleName,
    List<String>? addOns,
  }) async {
    try {
      final recommendation = await remoteDataSource.generateHaircut(
        styleName: styleName,
        addOns: addOns,
      );
      return Right(recommendation);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AIGenerationRequest>> generateImageByName({
    required String photoId,
    required List<StyleRecommendation> recommendations,
  }) async {
    try {
      final request = await remoteDataSource.generateImageByName(
        photoId: photoId,
        recommendations: recommendations,
      );
      return Right(request);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GeneratedPhoto>>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  }) async {
    try {
      final photos = await remoteDataSource.getGeneratedPhotos(
        userId: userId,
        requestId: requestId,
      );
      return Right(photos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
