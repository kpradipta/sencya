import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barbershop_app/theme/app_theme.dart';
import 'package:barbershop_app/core/routes/app_router.dart';
import 'package:barbershop_app/core/di/injection_container.dart' as di;
import 'package:barbershop_app/presentation/bloc/auth/auth_bloc.dart';

import 'package:barbershop_app/presentation/bloc/booking/booking_bloc.dart';
import 'package:barbershop_app/presentation/bloc/voucher/voucher_bloc.dart';
import 'package:barbershop_app/presentation/bloc/review/review_bloc.dart';
import 'package:barbershop_app/presentation/bloc/ai/ai_bloc.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable Edge-to-Edge support
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<BookingBloc>()),
        BlocProvider(create: (_) => di.sl<VoucherBloc>()),
        BlocProvider(create: (_) => di.sl<ReviewBloc>()),
        BlocProvider(create: (_) => di.sl<AIBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Modern Gentleman Barbershop',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
