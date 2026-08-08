class ChatPreviewMessage {
  final String room;
  final int senderId;
  final int receiverId;
  final String messageType;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime latestMessageTime;
  final String? senderProfilePicture;
  final String senderName;
  final String? senderNameAr;
  final String? senderSpecializationEn;
  final String? senderSpecializationAr;
  final String? receiverProfilePicture;
  final String receiverName;
  final String? receiverNameAr;
  final String? receiverSpecializationEn;
  final String? receiverSpecializationAr;
  final int isDoctorSender;

  ChatPreviewMessage({
    required this.room,
    required this.senderId,
    required this.receiverId,
    required this.messageType,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.latestMessageTime,
    this.senderProfilePicture,
    required this.senderName,
    this.senderNameAr,
    this.senderSpecializationEn,
    this.senderSpecializationAr,
    this.receiverProfilePicture,
    required this.receiverName,
    this.receiverNameAr,
    this.receiverSpecializationEn,
    this.receiverSpecializationAr,
    required this.isDoctorSender,
  });

  factory ChatPreviewMessage.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse date string or fallback to current time
    DateTime parseDate(String? dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr);
      } catch (_) {
        return DateTime.now();
      }
    }

    return ChatPreviewMessage(
      room: json['room']?.toString() ?? '',
      senderId: (json['sender_id'] is int)
          ? json['sender_id']
          : int.tryParse(json['sender_id']?.toString() ?? '') ?? 0,
      receiverId: (json['receiver_id'] is int)
          ? json['receiver_id']
          : int.tryParse(json['receiver_id']?.toString() ?? '') ?? 0,
      messageType: json['message_type']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: parseDate(json['created_at']?.toString()),
      updatedAt: parseDate(json['updated_at']?.toString()),
      latestMessageTime: parseDate(json['latest_message_time']?.toString()),

      // Access dotted keys exactly as they appear in your JSON:
      senderProfilePicture: json['sender.sender_profile_picture']?.toString(),
      senderName: json['sender.sender_name']?.toString() ?? '',
      senderNameAr: json['sender.sender_name_ar']?.toString(),
      senderSpecializationEn: json['sender.specialization_en']?.toString(),
      senderSpecializationAr: json['sender.specialization_ar']?.toString(),
      receiverProfilePicture:
          json['receiver.receiver_profile_picture']?.toString(),
      receiverName: json['receiver.receiver_name']?.toString() ?? '',
      receiverNameAr: json['receiver.receiver_name_ar']?.toString(),
      receiverSpecializationEn: json['receiver.specialization_en']?.toString(),
      receiverSpecializationAr: json['receiver.specialization_ar']?.toString(),
      isDoctorSender:
          int.tryParse(json['is_doctor_sender']?.toString() ?? '0') ?? 0,
    );
  }
}

class ListResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  ListResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}
