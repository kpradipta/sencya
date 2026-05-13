import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors.dart';

class ActiveServiceTimerPage extends StatefulWidget {
  const ActiveServiceTimerPage({super.key});

  @override
  State<ActiveServiceTimerPage> createState() => _ActiveServiceTimerPageState();
}

class _ActiveServiceTimerPageState extends State<ActiveServiceTimerPage> {
  Timer? _timer;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  const SizedBox(height: 16),
                  _buildClientProfile(),
                  const SizedBox(height: 48),
                  _buildTimerCircle(),
                  const SizedBox(height: 24),
                  const Text(
                    'Target duration: 45:00 MIN',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTimeCards(),
                  const SizedBox(height: 32),
                  _buildAddServiceButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Column(
            children: [
              Text(
                'LIVE SESSION',
                style: TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Capster Management',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildClientProfile() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryRed, width: 2),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBNuCihcziubMYJsvN1uIbYnvLUUIvvgSJDQLozwbcqJGS56zwu6VzTmajZBxrH7P-nQ2PEdhyO_Y0ZmD2TcRvoG3gFn-2UqCi_4DhZIGTfOzmCdQuH0x7VUHd4raYTmhC_SnlWip16tF2Bc2SfbRWtEp4_5ZixfHmL0oX2cz-uFdL5jJnZIss1bAl58LLPY9GeM-9MvfTy9xeWJ3W4UOkwwaB7OnLeDyKQVAtOLinQuay48-djIgqrhkfkfiB6-XnYN6WD2N85nWQG',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 3),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Marcus V.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text(
          'Classic Fade & Styling',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCircle() {
    // Mock target duration for progress calculation
    const double targetSeconds = 45 * 60;
    double progress = _elapsedTime.inSeconds / targetSeconds;
    if (progress > 1.0) progress = 1.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryRed.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        // Progress Circle
        SizedBox(
          width: 240,
          height: 240,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryRed,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              _formatDuration(_elapsedTime),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
              ),
            ),
            const Text(
              'ELAPSED TIME',
              style: TextStyle(
                color: Colors.white24,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeCards() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeCard(
            'Started',
            _isRunning ? 'LIVE' : '--:--',
            Icons.schedule,
            AppColors.primaryRed,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTimeCard(
            'Est. End',
            '2:45 PM',
            Icons.event_available,
            Colors.white24,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard(
    String label,
    String time,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor == Colors.white24 ? Colors.white60 : iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white24,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddServiceButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle, color: AppColors.primaryRed, size: 24),
              SizedBox(width: 12),
              Text(
                'Add Beard Trim',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '(+\$25)',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.background.withOpacity(0.8),
            AppColors.background,
          ],
        ),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (!_isRunning && _elapsedTime == Duration.zero) {
                _startTimer();
              } else if (_isRunning) {
                _stopTimer();
                GoRouter.of(context).go('/capster-home');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRunning
                  ? Colors.white10
                  : AppColors.primaryRed,
              foregroundColor: _isRunning ? Colors.white : Colors.white,
              minimumSize: const Size(double.infinity, 64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: _isRunning ? 0 : 20,
              shadowColor: AppColors.primaryRed.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRunning
                      ? 'COMPLETE SESSION'
                      : (_elapsedTime == Duration.zero
                            ? 'START SESSION'
                            : 'RESUME SESSION'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  _isRunning ? Icons.check_circle : Icons.play_arrow,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
