import 'package:ufc_mobile/global/util/common/common_utils.dart';

class AttachementModel {
  int? id;
  int? messageId;
  String? fileUrl;
  String? fileType;
  String? thumbnailUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  AttachementModel(
      {this.id,
      this.messageId,
      this.fileUrl,
      this.fileType,
      this.thumbnailUrl,
      this.createdAt,
      this.updatedAt});

  AttachementModel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    messageId = parseInt(json['message_id']);
    fileUrl = parseString(json['file_url']);
    fileType = parseString(json['file_type']);
    thumbnailUrl = parseString(json['thumbnail_url']);

    String createdat = parseString(json['created_at']) ?? '';
    createdAt = createdat.isNotEmpty ? DateTime.parse(createdat) : null;

    String updatedat = parseString(json['updated_at']) ?? '';
    updatedAt = updatedat.isNotEmpty ? DateTime.parse(updatedat) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message_id'] = messageId;
    data['file_url'] = fileUrl;
    data['file_type'] = fileType;
    data['thumbnail_url'] = thumbnailUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class AttachedImageModel {
  int? id;
  String? imageUrl;
  AttachedImageModel({
    this.id,
    this.imageUrl,
  });
  factory AttachedImageModel.fromJson(Map<String, dynamic> json) =>
      AttachedImageModel(
        id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
        imageUrl: json['image'],
      );
}
