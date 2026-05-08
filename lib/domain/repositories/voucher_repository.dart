import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/voucher.dart';

abstract class VoucherRepository {
  Future<Either<Failure, Points>> getPointsSummary();
  Future<Either<Failure, List<Voucher>>> getVouchers();
  Future<Either<Failure, Voucher>> redeemVoucher(String voucherId);
}
