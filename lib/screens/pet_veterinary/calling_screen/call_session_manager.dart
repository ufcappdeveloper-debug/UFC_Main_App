class CallSessionManager {
  static final CallSessionManager _instance = CallSessionManager._internal();

  factory CallSessionManager() => _instance;

  CallSessionManager._internal();

  String? token;
  String? channelName;
  int? uid;
  dynamic doctor;
  dynamic appointment;
  int? senderID;

  void setSession({
    required String token,
    required String channelName,
    required int uid,
    required dynamic doctor,
    required dynamic appointment,
    required int? senderID,
  }) {
    this.token = token;
    this.channelName = channelName;
    this.uid = uid;
    this.doctor = doctor;
    this.appointment = appointment;
    this.senderID = senderID;
  }

  bool get isSessionAvailable =>
      token != null && channelName != null && uid != null && senderID != null;
}
