import 'package:ufc_mobile/global/util/common/common_utils.dart';

class UploadFileResponseModel {
  String? status;
  UploadedFileModel? fileModel;

  UploadFileResponseModel({this.status, this.fileModel});

  UploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    status = parseString(json['status']);
    fileModel =
        json['data'] != null ? UploadedFileModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (fileModel != null) {
      data['data'] = fileModel!.toJson();
    }
    return data;
  }
}

class UploadedFileModel {
  String? url;
  String? type;

  UploadedFileModel({this.url, this.type});

  UploadedFileModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['type'] = type;
    return data;
  }
}
