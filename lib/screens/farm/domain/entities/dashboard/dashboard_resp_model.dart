import 'package:ufc_mobile/screens/farm/domain/entities/dashboard/farm_dashboard_model.dart';

class DashboardResponseModel {
  String? status;
  String? message;
  DashboardModel? data;

  DashboardResponseModel({
    this.status,
    this.message,
    this.data,
  });

  DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = DashboardModel.fromJson(json['data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
