class AppSettingsModel {
  String? sadadStatus;
  String? madaStatus;
  String? bankStatus;
  List<AppSettingsKeyAndValue>? keyAndValues;

  AppSettingsModel({
    this.sadadStatus,
    this.madaStatus,
    this.bankStatus,
    this.keyAndValues,
  });

  AppSettingsModel.fromJson(Map<String, dynamic> json) {
    if (json['app_settings'] != null && json['app_settings'] is List) {
      keyAndValues = [];
      for (var item in json['app_settings']) {
        if (item['key'] == 'SADAD_STATUS') {
          sadadStatus = item['value'];
        } else if (item['key'] == 'MADA_STATUS') {
          madaStatus = item['value'];
        } else if (item['key'] == 'BANK_STATUS') {
          bankStatus = item['value'];
        }
        keyAndValues!.add(AppSettingsKeyAndValue.fromJson(item));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SADAD_STATUS'] = sadadStatus;
    data['MADA_STATUS'] = madaStatus;
    data['BANK_STATUS'] = bankStatus;
    return data;
  }
}

class AppSettingsKeyAndValue {
  String? key;
  String? value;
  AppSettingsKeyAndValue({
    this.key,
    this.value,
  });
  AppSettingsKeyAndValue.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }
}
