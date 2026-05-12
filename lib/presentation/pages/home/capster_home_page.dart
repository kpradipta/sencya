import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../widgets/common/authenticated_image.dart';
import '../../../core/di/injection_container.dart';
import '../../../theme/colors.dart';
import '../../bloc/capster_home/capster_home_bloc.dart';
import '../../bloc/capster_home/capster_home_event.dart';
import '../../bloc/capster_home/capster_home_state.dart';
import '../../../domain/entities/capster_history.dart';

class CapsterHomePage extends StatelessWidget {
  const CapsterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CapsterHomeBloc>()..add(LoadCapsterHomeRequested()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<CapsterHomeBloc, CapsterHomeState>(
          builder: (context, state) {
            if (state is CapsterHomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryRed),
              );
            } else if (state is CapsterHomeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            } else if (state is CapsterHomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CapsterHomeBloc>().add(
                    LoadCapsterHomeRequested(),
                  );
                },
                color: AppColors.primaryRed,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      _buildHeader(context, state.capster),
                      const SizedBox(height: 24),
                      _buildCheckInBanner(),
                      const SizedBox(height: 32),
                      _buildDailySummary(context, state.capster),
                      const SizedBox(height: 32),
                      _buildSectionHeader(
                        context,
                        'PRIORITY TASKS',
                        '2 PENDING',
                      ),
                      const SizedBox(height: 16),
                      _buildTaskItem(
                        context,
                        icon: Icons.notifications_active,
                        title: '2 New Booking Requests',
                        subtitle: 'Waiting for your approval',
                        iconColor: AppColors.primaryRed,
                      ),
                      const SizedBox(height: 12),
                      _buildTaskItem(
                        context,
                        icon: Icons.account_circle,
                        title: 'Update Portfolio Price List',
                        subtitle: 'Recommended for peak season',
                        iconColor: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 48),
                      _buildSectionHeader(
                        context,
                        'AVAILABLE SERVICES',
                        'VIEW ALL',
                      ),
                      const SizedBox(height: 16),
                      _buildServiceList(context, state.services),
                      const SizedBox(height: 48),
                      _buildSectionHeader(
                        context,
                        'RECENT PORTFOLIO',
                        'SEE ALL',
                      ),
                      const SizedBox(height: 16),
                      _buildRecentPortfolio(context),
                      const SizedBox(height: 48),
                      _buildSectionHeader(
                        context,
                        'RECENT HISTORY',
                        'SERVICES',
                      ),
                      const SizedBox(height: 16),
                      if (state.history.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Text(
                              'No history found',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.history.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildHistoryItem(context, state.history[index]),
                        ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic capster) {
    final today = DateFormat('EEEE, MMM dd').format(DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              today.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primaryRed,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Good morning, ${capster.name.split(' ')[0]}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            AuthenticatedImage(
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBoEdViXDrKo30tRXhTqcG-jS6_8DeEOlnzY9jHjABIhGno0vhk4baEJXxKvB22z6wivhhX2cl6QuP8HJA6-p5qL73jCXmK2ildKXnEaI1ZQGMqcJp749EnOlZXAwAxBR5zs0vWiIliPbEH2p_VqBOPirCqKah_NZ41i5KWI5rY1PwQ_DMsWz5tnrQXsGQfKHLaZyxxcLcGUADOyzvljxJt29Jnk1xm0IbezMqfammbfnLN9dgaRHghJ-MlU_9gXdi8_VH0IDBlI8JB',
              width: 52,
              height: 52,
              borderRadius: BorderRadius.circular(26),
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckInBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently Checked-in',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Studio 4 • Total Time: 4h 12m',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'OUT',
            style: TextStyle(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummary(BuildContext context, dynamic capster) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSummaryCard(
            'TOTAL ACHIEV.',
            currencyFormatter.format(capster.achievement),
            '${(capster.progressPercentage * 100).toInt()}% of Target',
            AppColors.primaryRed,
            true,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            'DAILY TARGET',
            currencyFormatter.format(capster.target),
            'Goal for Today',
            AppColors.surfaceDark,
            false,
          ),
          const SizedBox(width: 12),
          _buildSummaryCard(
            'EST. INCENTIVE',
            currencyFormatter.format(
              capster.achievement * 0.1,
            ), // Mock formula if not in entity
            'Real-time Est.',
            AppColors.surfaceDark,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String label,
    String value,
    String trend,
    Color bgColor,
    bool isPrimary,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isPrimary ? null : Border.all(color: AppColors.borderDark),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white70 : AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPrimary
                  ? Colors.white24
                  : AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trend,
              style: TextStyle(
                color: isPrimary ? Colors.white : AppColors.primaryRed,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String action,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.primaryRed,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.borderDark,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPortfolio(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildPortfolioItem(
            'High Skin Fade',
            '2h ago',
            '124',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBMF-Jfxwfm-IpW3YoASDTH9MKD5TTReGNpTsaUK4eMNnCCi08AJ1QR63Lei4yDMwJZnPUla2yu5lmABaLJEXfsEVXGsInaRkC9Iqe7-xmE6Kwaf5FCJ76sY6F7KlN3m_1ycvjjuWdxErutqur1OXXdXpTEl5mBW2UdKycKk2vL06lj0INKIKIdp9Or0yHZUKrkFDduh7vOmFrRQD_38wXqMpigQBqzC1fD3PhNVc-M2Wdo26-iYpMOllGHJi45KBrU7MdeTcBsupyc',
          ),
          const SizedBox(width: 16),
          _buildPortfolioItem(
            'Premium Beard Sculpt',
            '5h ago',
            '89',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC26RCrioBI0zjmCbyABrplQoPLeJ_OEvzQ15VW1uFYf_byTBMOnaz4eUQlRg5Xa1PwJQfDsWCrNPkFufAGYxAzMVkfJAEHreBXzo8q9zpkweQuDFutfjCvFGdlfysAUvJr1HQQg88EPmrOq3BDhNOyeiffsC9-mEYGtSUNgBNFJ1C9C0M1O9mbC5hz8_pfHTAYkG8vUp350tSyYqYv01Dxvd6pJaxyiITgzGS_0QuzaNjraPnzYjoian0mEvkzLS8bcRk7w0Nkdd-1',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList(BuildContext context, List<dynamic> services) {
    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length > 3
              ? 3
              : services.length, // Show only 3 initially
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceCard(context, service);
          },
        ),
        if (services.length > 3) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to all services
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.borderDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SEE MORE SERVICES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, dynamic service) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/ai-upload'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            AuthenticatedImage(
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBMF-Jfxwfm-IpW3YoASDTH9MKD5TTReGNpTsaUK4eMNnCCi08AJ1QR63Lei4yDMwJZnPUla2yu5lmABaLJEXfsEVXGsInaRkC9Iqe7-xmE6Kwaf5FCJ76sY6F7KlN3m_1ycvjjuWdxErutqur1OXXdXpTEl5mBW2UdKycKk2vL06lj0INKIKIdp9Or0yHZUKrkFDduh7vOmFrRQD_38wXqMpigQBqzC1fD3PhNVc-M2Wdo26-iYpMOllGHJi45KBrU7MdeTcBsupyc',
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${service.duration} Mins Session',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(service.price),
                    style: const TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.borderDark,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioItem(
    String title,
    String time,
    String likes,
    String imageUrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AuthenticatedImage(
              imageUrl: imageUrl,
              width: 160,
              height: 160,
              borderRadius: BorderRadius.circular(16),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.primaryRed,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      likes,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          time,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, CapsterHistory history) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.borderDark,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.member.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'DONE',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        history.haircutName,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            currencyFormatter.format(history.transactionAmount),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
