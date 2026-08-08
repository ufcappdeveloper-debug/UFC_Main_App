class FeedWalletModel {
  int? count;
  String? date;
  List<Result>? result;

  FeedWalletModel({this.count, this.date, this.result});

  FeedWalletModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    date = json['date'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['date'] = date;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  int? userId;
  String? type;
  int? amount;
  String? title;
  String? createdAt;
  String? updatedAt;
  String? externalRefId; // added for safety

  Result({
    this.id,
    this.userId,
    this.type,
    this.amount,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.externalRefId,
  });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    amount = json['amount'];
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    externalRefId = json['external_ref_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['amount'] = amount;
    data['title'] = title;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['external_ref_id'] = externalRefId;
    return data;
  }
}
