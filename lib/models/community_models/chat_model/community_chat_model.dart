import 'package:ufc_mobile/models/community_models/channel_model/admin_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/attachement_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_reply_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_sender_mode.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';

class CommunityChatModel {
  int? id;
  String? message;
  int? senderId;
  int? adminId;
  int? channelId;
  int? refId;
  DateTime? createdAt;
  CommunitySenderModel? sender;
  bool? isEdited;
  DateTime? deletedAt;
  List<AttachedImageModel>? imageList;
  ReplyForMessage? replyForMessage;
  CommunityAdminModel? admin;
  List<AttachementModel>? attachements;
  CommunityChatModel({
    this.id,
    this.message,
    this.createdAt,
    this.sender,
    this.isEdited,
    this.deletedAt,
    this.imageList,
    this.replyForMessage,
    this.admin,
    this.refId,
    this.channelId,
    this.adminId,
    this.senderId,
    this.attachements,
  });
  factory CommunityChatModel.fromJson(Map<String, dynamic> json) =>
      CommunityChatModel(
        id: parseInt(json['id']),
        message: parseString(json['message']),
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        sender: json['sender'] != null
            ? CommunitySenderModel.fromJson(json['sender'])
            : null,
        isEdited: json['is_edited'] != null
            ? bool.tryParse(json['is_edited'].toString())
            : null,
        deletedAt: json['deleted_at'] != null
            ? DateTime.tryParse(json['deleted_at'].toString())
            : null,
        imageList: json['images'] != null && json['images'] is List
            ? List<AttachedImageModel>.from(
                (json['images'] as List<dynamic>).map(
                  (e) => AttachedImageModel.fromJson(e),
                ),
              )
            : null,
        replyForMessage: json['reply_for_message'] != null
            ? ReplyForMessage.fromJson(json['reply_for_message'])
            : null,
        admin: json['admin'] != null
            ? CommunityAdminModel.fromJson(json['admin'])
            : null,
        refId: json['ref_id'],
        senderId: json['sender_id'],
        adminId: json['admin_id'],
        channelId: json['channel_id'],
        attachements: json['attachments'] != null && json['attachments'] is List
            ? List<AttachementModel>.from(
                (json['attachments'] as List<dynamic>).map(
                  (e) => AttachementModel.fromJson(e),
                ),
              )
            : null,
      );
}
