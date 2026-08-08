class DoctorTiming {
  final String message;
  final List<DoctorTimingDetail> doctorTimings;

  DoctorTiming({required this.message, required this.doctorTimings});

  factory DoctorTiming.fromJson(Map<String, dynamic> json) {
    var list = json['doctor_timings'] as List? ?? [];
    List<DoctorTimingDetail> timingsList =
        list.map((i) => DoctorTimingDetail.fromJson(i)).toList();

    return DoctorTiming(
      message: json['message'] ?? "No message",
      doctorTimings: timingsList,
    );
  }
}

class DoctorTimingDetail {
  final String day;
  final String date;
  final List<String> slots;

  DoctorTimingDetail(
      {required this.day, required this.date, required this.slots});

  factory DoctorTimingDetail.fromJson(Map<String, dynamic> json) {
    var slotsList = json['slots'] as List;
    List<String> slots = List<String>.from(slotsList);

    return DoctorTimingDetail(
      day: json['day'],
      date: json['date'],
      slots: slots,
    );
  }
}
