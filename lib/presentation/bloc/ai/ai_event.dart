import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AIEvent extends Equatable {
  const AIEvent();

  @override
  List<Object> get props => [];
}

class AnalyzePhotoRequested extends AIEvent {
  final File photo;

  const AnalyzePhotoRequested(this.photo);

  @override
  List<Object> get props => [photo];
}

class GenerateHaircutRequested extends AIEvent {
  final String styleName;
  final List<String>? addOns;

  const GenerateHaircutRequested({required this.styleName, this.addOns});

  @override
  List<Object> get props => [styleName, addOns ?? []];
}
