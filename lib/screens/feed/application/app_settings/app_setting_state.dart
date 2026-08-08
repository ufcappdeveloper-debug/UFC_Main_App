import 'package:equatable/equatable.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/app_setting/app_settings_model.dart';

abstract class AppSettingState extends Equatable {
  const AppSettingState();

  @override
  List<Object?> get props => [];
}

class AppSettingInitial extends AppSettingState {}

class AppSettingLoading extends AppSettingState {}

class AppSettingLoaded extends AppSettingState {
  final AppSettingsModel appSettings;

  const AppSettingLoaded(this.appSettings);

  @override
  List<Object?> get props => [appSettings];
}

class AppSettingError extends AppSettingState {
  final Object message;

  const AppSettingError(this.message);

  @override
  List<Object?> get props => [message];
}
