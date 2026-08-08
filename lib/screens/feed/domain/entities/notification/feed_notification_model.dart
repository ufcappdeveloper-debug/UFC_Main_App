class FeedNotificationModel {
  int? id;
  int? userId;
  String? notificationType;
  String? title;
  String? titleAr;
  String? titleUr;
  String? description;
  String? descriptionAr;
  String? descriptionUr;
  String? category;
  dynamic image;
  dynamic data;
  dynamic readAt;
  dynamic sendById;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? notificationTypeDescription;

  FeedNotificationModel({
    this.id,
    this.userId,
    this.notificationType,
    this.title,
    this.titleAr,
    this.titleUr,
    this.description,
    this.descriptionAr,
    this.descriptionUr,
    this.category,
    this.image,
    this.data,
    this.readAt,
    this.sendById,
    this.createdAt,
    this.updatedAt,
    this.notificationTypeDescription,
  });

  factory FeedNotificationModel.fromJson(Map<String, dynamic> json) {
    return FeedNotificationModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      notificationType: json['notification_type'] as String?,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      titleUr: json['title_ur'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionUr: json['description_ur'] as String?,
      category: json['category'] as String?,
      image: json['image'] as dynamic,
      data: json['data'] as dynamic,
      readAt: json['read_at'] as dynamic,
      sendById: json['send_by_id'] as dynamic,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      notificationTypeDescription:
      json['notification_type_description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'notification_type': notificationType,
    'title': title,
    'title_ar': titleAr,
    'title_ur': titleUr,
    'description': description,
    'description_ar': descriptionAr,
    'description_ur': descriptionUr,
    'category': category,
    'image': image,
    'data': data,
    'read_at': readAt,
    'send_by_id': sendById,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'notification_type_description': notificationTypeDescription,
  };
}
