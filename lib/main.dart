import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbershop_app/theme/app_theme.dart';
import 'package:barbershop_app/core/routes/app_router.dart';
import 'package:barbershop_app/core/di/injection_container.dart' as di;
import 'package:barbershop_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:barbershop_app/presentation/bloc/auth/auth_event.dart';

import 'package:barbershop_app/presentation/bloc/booking/booking_bloc.dart';
import 'package:barbershop_app/presentation/bloc/voucher/voucher_bloc.dart';
import 'package:barbershop_app/presentation/bloc/review/review_bloc.dart';
import 'package:barbershop_app/presentation/bloc/ai/ai_bloc.dart';
import 'package:barbershop_app/core/storage/dev_settings_storage.dart';
import 'package:barbershop_app/presentation/widgets/dev/floating_dev_tools.dart';
import 'package:barbershop_app/presentation/bloc/dev/dev_settings_bloc.dart';
import 'package:barbershop_app/presentation/bloc/dev/dev_settings_event.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable Edge-to-Edge support
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await di.init();
  AppRouter.init();

  // Chucker: only show floating button when developer mode is enabled
  final devModeEnabled = await DevSettingsStorage.isEnabled();
  ChuckerFlutter.showOnRelease = devModeEnabled;
  ChuckerFlutter.showNotification = false;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check auth when the user brings the app back to the foreground
      di.sl<AuthBloc>().add(AuthCheckRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<BookingBloc>()),
        BlocProvider(create: (_) => di.sl<VoucherBloc>()),
        BlocProvider(create: (_) => di.sl<ReviewBloc>()),
        BlocProvider(create: (_) => di.sl<AIBloc>()),
        BlocProvider(
          create: (_) => di.sl<DevSettingsBloc>()..add(LoadDevSettings()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Modern Gentleman Barbershop',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return FloatingDevTools(child: child!);
        },
      ),
    );
  }
}
