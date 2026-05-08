import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/voucher_repository.dart';
import 'voucher_event.dart';
import 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository voucherRepository;

  VoucherBloc({required this.voucherRepository}) : super(VoucherInitial()) {
    on<FetchVoucherData>(_onFetchVoucherData);
    on<RedeemVoucherRequested>(_onRedeemVoucherRequested);
  }

  Future<void> _onFetchVoucherData(FetchVoucherData event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());
    final pointsResult = await voucherRepository.getPointsSummary();
    final vouchersResult = await voucherRepository.getVouchers();

    pointsResult.fold(
      (failure) => emit(VoucherError(failure.message)),
      (points) {
        vouchersResult.fold(
          (failure) => emit(VoucherError(failure.message)),
          (vouchers) => emit(VoucherLoaded(points: points, vouchers: vouchers)),
        );
      },
    );
  }

  Future<void> _onRedeemVoucherRequested(RedeemVoucherRequested event, Emitter<VoucherState> emit) async {
    // Note: In real app we might want to keep the current loaded data
    // For now we just emit loading for redemption
    final result = await voucherRepository.redeemVoucher(event.voucherId);
    result.fold(
      (failure) => emit(VoucherError(failure.message)),
      (voucher) {
        emit(VoucherRedeemed(voucher));
        add(FetchVoucherData()); // Refresh data
      },
    );
  }
}
