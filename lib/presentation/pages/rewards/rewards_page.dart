import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../theme/colors.dart';
import '../../bloc/voucher/voucher_bloc.dart';
import '../../bloc/voucher/voucher_event.dart';
import '../../bloc/voucher/voucher_state.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REWARDS'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocProvider.value(
        value: context.read<VoucherBloc>()..add(FetchVoucherData()),
        child: const RewardsView(),
      ),
    );
  }
}

class RewardsView extends StatelessWidget {
  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoucherBloc, VoucherState>(
      builder: (context, state) {
        if (state is VoucherLoading || state is VoucherInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.elegantGold));
        } else if (state is VoucherError) {
          return Center(child: Text(state.message, style: TextStyle(color: AppColors.error)));
        } else if (state is VoucherLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPointsCard(context, state.points.totalPoints),
                const SizedBox(height: 48),
                Text('AVAILABLE VOUCHERS', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 16),
                if (state.vouchers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text('No vouchers available.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.vouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = state.vouchers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(voucher.name, style: Theme.of(context).textTheme.titleSmall),
                                      const SizedBox(height: 4),
                                      Text(
                                        voucher.description,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                  Icon(Icons.confirmation_num_outlined, color: AppColors.elegantGold.withOpacity(0.5)),
                                ],
                              ),
                              const Divider(height: 32, color: AppColors.borderStroke),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${voucher.pointsRequired} Points',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.elegantGold, fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    onPressed: state.points.totalPoints >= voucher.pointsRequired
                                        ? () {
                                            context.read<VoucherBloc>().add(RedeemVoucherRequested(voucher.id));
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Text('REDEEM'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPointsCard(BuildContext context, int points) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.elegantGold.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.matteBlack.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          const Text('CURRENT BALANCE', style: TextStyle(color: AppColors.elegantGold, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                points.toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.textPrimary, fontSize: 48),
              ),
              const SizedBox(width: 8),
              Text(
                'PTS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.elegantGold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Keep booking to earn more rewards.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
