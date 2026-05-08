import 'package:equatable/equatable.dart';
import '../../../domain/entities/voucher.dart';

abstract class VoucherState extends Equatable {
  const VoucherState();

  @override
  List<Object?> get props => [];
}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherLoaded extends VoucherState {
  final Points points;
  final List<Voucher> vouchers;

  const VoucherLoaded({required this.points, required this.vouchers});

  @override
  List<Object?> get props => [points, vouchers];
}

class VoucherRedeemed extends VoucherState {
  final Voucher voucher;

  const VoucherRedeemed(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

class VoucherError extends VoucherState {
  final String message;

  const VoucherError(this.message);

  @override
  List<Object?> get props => [message];
}
