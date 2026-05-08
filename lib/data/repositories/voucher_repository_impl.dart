import 'package:fpdart/fpdart.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/voucher.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../datasources/voucher_remote_data_source.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remoteDataSource;

  VoucherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Points>> getPointsSummary() async {
    try {
      final points = await remoteDataSource.getPointsSummary();
      return Right(points);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Voucher>>> getVouchers() async {
    try {
      final vouchers = await remoteDataSource.getVouchers();
      return Right(vouchers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Voucher>> redeemVoucher(String voucherId) async {
    try {
      final voucher = await remoteDataSource.redeemVoucher(voucherId);
      return Right(voucher);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
