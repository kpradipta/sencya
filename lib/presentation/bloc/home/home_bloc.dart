import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/service_repository.dart';
import '../../../domain/repositories/capster_repository.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../domain/entities/service.dart';
import '../../../domain/entities/capster.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ServiceRepository serviceRepository;
  final CapsterRepository capsterRepository;

  HomeBloc({
    required this.serviceRepository,
    required this.capsterRepository,
  }) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(FetchHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    
    final servicesResult = await serviceRepository.getServices();
    final capstersResult = await capsterRepository.getCapsters();

    servicesResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (services) {
        capstersResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (capsters) => emit(HomeLoaded(services: services, capsters: capsters)),
        );
      },
    );
  }
}
