class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String receiverId;
  final String? messageType;
  final String? mediaType;
  final String? mediaUrl;
  final String? room;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isDoctorSender;
  final String? senderProfilePicture;
  final String? receiverProfilePicture;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.isDoctorSender,
    this.updatedAt,
    this.messageType,
    this.mediaType,
    this.mediaUrl,
    this.room,
    this.senderProfilePicture,
    this.receiverProfilePicture,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      text: json['content'] ?? '',
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      messageType: json['message_type'],
      mediaType: json['media_type'],
      mediaUrl: json['media_url'],
      room: json['room'],
      isDoctorSender: json['is_doctor_sender'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      senderProfilePicture: json['sender']?['profile_picture'],
      receiverProfilePicture: json['receiver']?['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': text,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_type': messageType,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'room': room,
      'is_doctor_sender': isDoctorSender,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'sender': {'profile_picture': senderProfilePicture},
      'receiver': {'profile_picture': receiverProfilePicture},
    };
  }
}

class ChatPagination {
  final int page;
  final int pageSize;
  final int totalMessages;
  final int totalPages;
  final bool? hasMore;

  ChatPagination({
    required this.page,
    required this.pageSize,
    required this.totalMessages,
    required this.totalPages,
    this.hasMore,
  });

  factory ChatPagination.fromJson(Map<String, dynamic> json) {
    return ChatPagination(
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalMessages: json['totalMessages'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'totalMessages': totalMessages,
      'totalPages': totalPages,
      'hasMore': hasMore,
    };
  }
}

class ChatPaginatedMessages {
  final List<ChatMessage> messages;
  final ChatPagination pagination;

  ChatPaginatedMessages({
    required this.messages,
    required this.pagination,
  });

  // factory ChatPaginatedMessages.fromJson(Map<String, dynamic> json) {
  //   final rawMessages = json['data'];
  //   return ChatPaginatedMessages(
  //     messages: rawMessages is List
  //         ? rawMessages.map((msg) => ChatMessage.fromJson(msg)).toList()
  //         : [],
  //     pagination: ChatPagination.fromJson(json['pagination'] ?? {}),
  //   );
  // }
  factory ChatPaginatedMessages.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['data'];
    final parsedMessages = rawMessages is List
        ? rawMessages.map((msg) => ChatMessage.fromJson(msg)).toList()
        : <ChatMessage>[];

    return ChatPaginatedMessages(
      messages: parsedMessages.reversed.toList(),
      pagination: ChatPagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}
