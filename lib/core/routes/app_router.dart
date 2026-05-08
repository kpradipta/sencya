import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/booking/booking_summary_page.dart';
import '../../presentation/pages/rewards/rewards_page.dart';
import '../../presentation/pages/ai/ai_upload_page.dart';
import '../../presentation/pages/ai/ai_analysis_result_page.dart';
import '../../presentation/pages/ai/ai_generation_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/booking/my_bookings_page.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/capster.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return BookingSummaryPage(
            service: extras['service'] as Service,
            capster: extras['capster'] as Capster,
          );
        },
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const RewardsPage(),
      ),
      GoRoute(
        path: '/ai-upload',
        builder: (context, state) => const AIUploadPage(),
      ),
      GoRoute(
        path: '/ai-results',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return AIAnalysisResultPage(analysis: extras['analysis']);
        },
      ),
      GoRoute(
        path: '/ai-generate',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return AIGenerationPage(styleName: extras['styleName']);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const MyBookingsPage(),
      ),
    ],
  );
}
