import 'package:equatable/equatable.dart';
import '../../../domain/entities/service.dart';
import '../../../domain/entities/capster.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Service> services;
  final List<Capster> capsters;

  const HomeLoaded({required this.services, required this.capsters});

  @override
  List<Object?> get props => [services, capsters];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
