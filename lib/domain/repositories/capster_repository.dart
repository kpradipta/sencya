import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/capster.dart';
import '../entities/capster_history.dart';

abstract class CapsterRepository {
  Future<Either<Failure, List<Capster>>> getCapsters();
  Future<Either<Failure, Capster>> getCapsterById(String id);
  Future<Either<Failure, List<CapsterHistory>>> getCapsterHistory();
}
