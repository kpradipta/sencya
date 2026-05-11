import 'package:flutter/material.dart';
import '../../../theme/colors.dart';

class EarningsAnalyticsPage extends StatelessWidget {
  const EarningsAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Earnings & Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Text('Simulated Data: API integration in progress', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildTabSwitcher(),
            const SizedBox(height: 24),
            _buildHeroStats(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildSmallStat('Tips', '\$412.00', '+5%', Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildSmallStat('Total Cuts', '58', '-2%', Colors.orange)),
              ],
            ),
            const SizedBox(height: 24),
            _buildWeeklyPerformance(),
            const SizedBox(height: 24),
            _buildTopServices(),
            const SizedBox(height: 24),
            _buildRecentPayouts(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderDark)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem('Day', false),
          _buildTabItem('Week', true),
          _buildTabItem('Month', false),
          _buildTabItem('Year', false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isActive ? const Border(bottom: BorderSide(color: AppColors.primaryRed, width: 2)) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildHeroStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
              Icon(Icons.trending_up, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          const Text('\$2,410.50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('+14.2% from last week', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value, String trend, Color trendColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(trend, style: TextStyle(color: trendColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWeeklyPerformance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weekly Performance', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Mon, Oct 16 - Sun, Oct 22', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('M', 0.65),
                _buildBar('T', 0.45),
                _buildBar('W', 0.85),
                _buildBar('T', 0.30),
                _buildBar('F', 0.95, isToday: true),
                _buildBar('S', 0.70),
                _buildBar('S', 0.20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double percentage, {bool isToday = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 10,
          height: 100 * percentage,
          decoration: BoxDecoration(
            color: isToday ? AppColors.primaryRed : AppColors.borderDark,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isToday ? [
              BoxShadow(color: AppColors.primaryRed.withOpacity(0.4), blurRadius: 8)
            ] : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isToday ? AppColors.primaryRed : AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTopServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TOP SERVICES', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              _buildServiceRow('Skin Fade & Styling', 0.42, Colors.white),
              const SizedBox(height: 16),
              _buildServiceRow('Beard Grooming', 0.28, Colors.white70),
              const SizedBox(height: 16),
              _buildServiceRow('Hot Towel Shave', 0.18, Colors.white70),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRow(String name, double percentage, Color textColor) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600)),
            Text('${(percentage * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.borderDark,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed.withOpacity(1 - (1 - percentage) * 0.5)),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPayouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('RECENT PAYOUTS', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
            TextButton(onPressed: () {}, child: const Text('SEE ALL', style: TextStyle(color: AppColors.primaryRed, fontSize: 11, fontWeight: FontWeight.w900))),
          ],
        ),
        const SizedBox(height: 4),
        _buildPayoutItem('Bank Transfer', 'Oct 20 • Completed', '\$1,120.00', Colors.green),
        const SizedBox(height: 12),
        _buildPayoutItem('Bank Transfer', 'Oct 22 • Processing', '\$845.50', Colors.orange),
      ],
    );
  }

  Widget _buildPayoutItem(String title, String subtitle, String amount, Color statusColor) {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet, color: statusColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
        ],
      ),
    );
  }
}
