import 'package:equatable/equatable.dart';

abstract class CapsterHomeEvent extends Equatable {
  const CapsterHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadCapsterHomeRequested extends CapsterHomeEvent {}
