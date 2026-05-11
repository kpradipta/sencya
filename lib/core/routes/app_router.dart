import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/auth/auth_state.dart';
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
import '../../presentation/pages/earnings/earnings_analytics_page.dart';
import '../../presentation/pages/availability/manage_availability_page.dart';
import '../../presentation/pages/service/active_service_timer_page.dart';
import '../../presentation/pages/clients/client_directory_page.dart';
import '../../presentation/pages/main/capster_main_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/capster.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((dynamic state) {
      debugPrint('GoRouterRefreshStream: Auth state changed to $state');
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(GetIt.I<AuthBloc>().stream),
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/';

      // While auth is loading or not yet checked, keep on splash
      if (authState is AuthInitial) {
        return isSplash ? null : '/';
      }

      if (authState is AuthLoading) {
        if (isSplash || isLoggingIn) return null;
        return '/';
      }

      if (authState is Unauthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (authState is Authenticated) {
        if (isLoggingIn || isSplash) {
          return authState.user.isCapster ? '/capster-home' : '/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/capster-home',
        builder: (context, state) =>
            const CapsterMainPage(), // Use the new Main Page
      ),
      GoRoute(
        path: '/earnings-analytics',
        builder: (context, state) => const EarningsAnalyticsPage(),
      ),
      GoRoute(
        path: '/manage-availability',
        builder: (context, state) => const ManageAvailabilityPage(),
      ),
      GoRoute(
        path: '/active-service-timer',
        builder: (context, state) => const ActiveServiceTimerPage(),
      ),
      GoRoute(
        path: '/client-directory',
        builder: (context, state) => const ClientDirectoryPage(),
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
          return AIGenerationPage(
            styleName: extras['styleName'],
            requestId: extras['requestId'],
          );
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
