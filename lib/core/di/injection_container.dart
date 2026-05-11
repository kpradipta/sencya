import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../domain/repositories/service_repository.dart';
import '../../data/datasources/service_remote_data_source.dart';
import '../../data/repositories/service_repository_impl.dart';
import '../../domain/repositories/capster_repository.dart';
import '../../data/datasources/capster_remote_data_source.dart';
import '../../data/repositories/capster_repository_impl.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/booking/booking_bloc.dart';
import '../../presentation/bloc/voucher/voucher_bloc.dart';
import '../../presentation/bloc/review/review_bloc.dart';
import '../../presentation/bloc/ai/ai_bloc.dart';
import '../../presentation/bloc/capster_home/capster_home_bloc.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../data/datasources/booking_remote_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/voucher_repository.dart';
import '../../data/datasources/voucher_remote_data_source.dart';
import '../../data/repositories/voucher_repository_impl.dart';
import '../../domain/repositories/review_repository.dart';
import '../../data/datasources/review_remote_data_source.dart';
import '../../data/repositories/review_repository_impl.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../data/datasources/ai_remote_data_source.dart';
import '../../data/repositories/ai_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Core
  sl.registerLazySingleton(() => ApiClient(sl(), sl()));

  // Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Features - Services
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDataSource: sl()),
  );

  // Features - Capsters
  sl.registerLazySingleton<CapsterRemoteDataSource>(
    () => CapsterRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CapsterRepository>(
    () => CapsterRepositoryImpl(remoteDataSource: sl()),
  );

  // Features - Booking
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => BookingBloc(bookingRepository: sl()));

  // Features - Voucher
  sl.registerLazySingleton<VoucherRemoteDataSource>(
    () => VoucherRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<VoucherRepository>(
    () => VoucherRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => VoucherBloc(voucherRepository: sl()));

  // Features - Review
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => ReviewBloc(reviewRepository: sl()));

  // Features - AI
  sl.registerLazySingleton<AIRemoteDataSource>(
    () => AIRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AIRepository>(
    () => AIRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => AIBloc(aiRepository: sl()));

  // Features - Capster Home
  sl.registerFactory(() => CapsterHomeBloc(
    capsterRepository: sl(),
    serviceRepository: sl(),
  ));

  // Features - Home
  sl.registerFactory(() => HomeBloc(
    serviceRepository: sl(),
    capsterRepository: sl(),
  ));
}
