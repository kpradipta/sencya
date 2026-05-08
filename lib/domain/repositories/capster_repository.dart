import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/capster.dart';

abstract class CapsterRepository {
  Future<Either<Failure, List<Capster>>> getCapsters();
  Future<Either<Failure, Capster>> getCapsterById(String id);
}
