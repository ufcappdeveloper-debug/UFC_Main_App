import 'package:ufc_mobile/models/schedule/appointment_model.dart';

class AppointmentPageResult {
  final List<AppointmentModel> validAppointments;
  final bool hadOnlyCancelled;
  final bool dataWasEmpty;

  AppointmentPageResult({
    required this.validAppointments,
    this.hadOnlyCancelled = false,
    this.dataWasEmpty = false,
  });
}
