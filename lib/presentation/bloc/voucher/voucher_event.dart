import 'package:equatable/equatable.dart';

abstract class VoucherEvent extends Equatable {
  const VoucherEvent();

  @override
  List<Object> get props => [];
}

class FetchVoucherData extends VoucherEvent {}

class RedeemVoucherRequested extends VoucherEvent {
  final String voucherId;

  const RedeemVoucherRequested(this.voucherId);

  @override
  List<Object> get props => [voucherId];
}
