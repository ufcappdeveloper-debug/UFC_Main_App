import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ufc_mobile/models/communication_preferences_model.dart';

part "communication_preference_provider.g.dart";

@riverpod
class CommunicationPreference extends _$CommunicationPreference {
  @override
  CommunicationPreferencesModel build() {
    return CommunicationPreferencesModel();
  }

  void initPreferenceObject(
      CommunicationPreferencesModel communicationPreferencesModel) {
    state = communicationPreferencesModel;
  }

  void updatePreferences(bool value, PreferenceType preferenceType) {
    state.updateCommunicationPreferences(value, preferenceType);
  }
}
