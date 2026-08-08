import 'package:ufc_mobile/screens/feed/domain/entities/authentication/user_model.dart';

class RatingModel {
  int? id;
  int? productId;
  int? userId;
  double? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  RatingModel(
      {this.id,
      this.productId,
      this.userId,
      this.rating,
      this.review,
      this.createdAt,
      this.updatedAt,
      this.user});

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    rating =
        json['rating'] == null ? 0.0 : double.parse(json['rating'].toString());
    review = json['review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['user_id'] = userId;
    data['rating'] = rating;
    data['review'] = review;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
