import 'package:equatable/equatable.dart';
import '../../../../domain/entities/capster_history.dart';
import '../../../../domain/entities/capster.dart';
import '../../../../domain/entities/service.dart';

abstract class CapsterHomeState extends Equatable {
  const CapsterHomeState();

  @override
  List<Object?> get props => [];
}

class CapsterHomeInitial extends CapsterHomeState {}

class CapsterHomeLoading extends CapsterHomeState {}

class CapsterHomeLoaded extends CapsterHomeState {
  final List<CapsterHistory> history;
  final Capster capster;
  final List<Service> services;

  const CapsterHomeLoaded({
    required this.history,
    required this.capster,
    required this.services,
  });

  @override
  List<Object?> get props => [history, capster, services];
}

class CapsterHomeError extends CapsterHomeState {
  final String message;
  const CapsterHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
