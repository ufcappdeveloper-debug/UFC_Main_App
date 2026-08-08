class VideoCallTokenResponse {
  String? token;
  String? channelName;
  String? uId;

  VideoCallTokenResponse({this.token, this.channelName, this.uId});

  VideoCallTokenResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    channelName = json['channel_name'];
    uId = json['uId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['channel_name'] = channelName;
    data['uId'] = uId;
    return data;
  }
}
