import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_data_source.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDataSource remoteDataSource;

  AIRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AIAnalysis>> analyzePhoto(File photo) async {
    try {
      final analysis = await remoteDataSource.analyzePhoto(photo);
      return Right(analysis);
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
}
