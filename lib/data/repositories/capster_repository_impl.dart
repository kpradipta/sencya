import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/capster.dart';
import '../../domain/entities/capster_history.dart';
import '../../domain/repositories/capster_repository.dart';
import '../datasources/capster_remote_data_source.dart';

class CapsterRepositoryImpl implements CapsterRepository {
  final CapsterRemoteDataSource remoteDataSource;

  CapsterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Capster>>> getCapsters() async {
    try {
      final capsters = await remoteDataSource.getCapsters();
      return Right(capsters);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Capster>> getCapsterById(String id) async {
    try {
      final capster = await remoteDataSource.getCapsterById(id);
      return Right(capster);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CapsterHistory>>> getCapsterHistory() async {
    try {
      final history = await remoteDataSource.getCapsterHistory();
      return Right(history);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
