import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/capster_repository.dart';
import '../../../domain/repositories/service_repository.dart';
import 'capster_home_event.dart';
import 'capster_home_state.dart';

class CapsterHomeBloc extends Bloc<CapsterHomeEvent, CapsterHomeState> {
  final CapsterRepository capsterRepository;
  final ServiceRepository serviceRepository;

  CapsterHomeBloc({
    required this.capsterRepository,
    required this.serviceRepository,
  }) : super(CapsterHomeInitial()) {
    on<LoadCapsterHomeRequested>((event, emit) async {
      emit(CapsterHomeLoading());
      
      final historyResult = await capsterRepository.getCapsterHistory();
      final profileResult = await capsterRepository.getCapsters();
      final servicesResult = await serviceRepository.getServices();
      
      historyResult.fold(
        (failure) => emit(CapsterHomeError(failure.message)),
        (history) {
          profileResult.fold(
            (failure) => emit(CapsterHomeError(failure.message)),
            (capsters) {
              if (capsters.isNotEmpty) {
                servicesResult.fold(
                  (failure) => emit(CapsterHomeError(failure.message)),
                  (services) => emit(CapsterHomeLoaded(
                    history: history,
                    capster: capsters.first, // Ideally use the logged in capster
                    services: services,
                  )),
                );
              } else {
                emit(CapsterHomeError('Profile not found'));
              }
            },
          );
        },
      );
    });
  }
}
