import 'package:ufc_mobile/models/community_models/channel_model/admin_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_sender_mode.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

class ReplyForMessage {
  int? id;
  String? message;
  int? refId;
  int? senderId;
  int? adminId;
  int? channelId;
  int? replyFor;
  bool? isEdited;
  int? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? senderName;
  CommunitySenderModel? sender;
  CommunityAdminModel? admin;
  ReplyForMessage({
    this.id,
    this.message,
    this.refId,
    this.senderId,
    this.adminId,
    this.channelId,
    this.replyFor,
    this.isEdited,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.senderName,
    this.sender,
    this.admin,
  });

  ReplyForMessage.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    message = parseString(json['message']);
    refId = parseInt(json['ref_id']);
    senderId = parseInt(json['sender_id']);
    adminId = parseInt(json['admin_id']);
    channelId = parseInt(json['channel_id']);
    replyFor = parseInt(json['reply_for']);
    isEdited = parseBool(json['is_edited']);
    deletedAt = parseInt(json['deleted_at']);
    createdAt = parseString(json['created_at']);
    updatedAt = parseString(json['updated_at']);
    senderName = parseString(json['sender_name']);

    sender = json['sender'] != null
        ? CommunitySenderModel.fromJson(json['sender'])
        : null;
    admin = json['admin'] != null
        ? CommunityAdminModel.fromJson(json['admin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['ref_id'] = refId;
    data['sender_id'] = senderId;
    data['admin_id'] = adminId;
    data['channel_id'] = channelId;
    data['reply_for'] = replyFor;
    data['is_edited'] = isEdited;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sender_name'] = senderName;
    if (sender != null) {
      data['sender'] = sender;
    }
    if (admin != null) {
      data['admin'] = admin;
    }
    return data;
  }
}
