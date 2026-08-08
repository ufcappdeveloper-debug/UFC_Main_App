class NotificationModel {
  int? id;
  int? userId;
  String? notificationType;
  String? title;
  String? description;
  String? category;
  dynamic image;
  dynamic data;
  dynamic readAt;
  dynamic sendById;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? notificationTypeDescription;

  NotificationModel({
    this.id,
    this.userId,
    this.notificationType,
    this.title,
    this.description,
    this.category,
    this.image,
    this.data,
    this.readAt,
    this.sendById,
    this.createdAt,
    this.updatedAt,
    this.notificationTypeDescription,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      notificationType: json['notification_type'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
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
        'description': description,
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
