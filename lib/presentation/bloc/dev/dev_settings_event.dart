import 'package:equatable/equatable.dart';

abstract class DevSettingsEvent extends Equatable {
  const DevSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDevSettings extends DevSettingsEvent {}

class UpdateSetting extends DevSettingsEvent {
  final String key;
  final dynamic value;

  const UpdateSetting(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

class RefreshCounters extends DevSettingsEvent {}

class FlushStorage extends DevSettingsEvent {}

class RefreshFcmToken extends DevSettingsEvent {}

class TestApiCall extends DevSettingsEvent {}
