import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/global/extensions/app_colors.dart';
import 'package:ufc_mobile/global/extensions/app_svg.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/chat_app_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/chat_bottom_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/chat/chat_card.dart';
import 'package:ufc_mobile/screens/pet_veterinary/pages/schedule_page.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/chat_socket_manager.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/doctor_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/chat_room_message_notifier.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/upload_media_notifier.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/chat_loading_section.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/try_again_button.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/call/agora_engine_singleton.dart';
import 'package:ufc_mobile/global/util/log/log_utils.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Doctor? doctor;
  final String roomId;
  final String bookingId;
  final int senderId;
  final int receiverId;
  final int userId;
  final AppointmentModel? appointment;
  final bool isFromNotification;
  final TabController? tabController;
  const ChatScreen({
    super.key,
    required this.doctor,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.bookingId,
    required this.userId,
    this.appointment,
    this.isFromNotification = false,
    this.tabController,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ChatRoomMessagesNotifier? _notifier;
  final ValueNotifier<File?> selectedFile = ValueNotifier(null);
  bool _showScrollButton = false;
  late bool isFromNotification;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();

    ChatSocketManager.init();
    isFromNotification = widget.isFromNotification;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _notifier = ref.read(chatRoomMessagesProvider.notifier);
      _waitForSocketConnectionAndJoinRoom(
          widget.roomId, widget.userId.toString());
    });

    _scrollController.addListener(_onScroll);
  }

  void _waitForSocketConnectionAndJoinRoom(String roomId, String userId) async {
    int retryCount = 0;
    while (!ChatSocketManager.isConnected && retryCount < 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      retryCount++;
    }

    if (ChatSocketManager.isConnected) {
      await _notifier?.joinRoom(roomId, userId);
    } else {
      debugLog('Unable to join room: Socket not connected.');
    }
  }

  void _onScroll() {
    final isFarFromBottom = _scrollController.offset > 300;

    if (_showScrollButton != isFarFromBottom) {
      setState(() {
        _showScrollButton = isFarFromBottom;
      });
    }
    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 100 &&
        _notifier?.hasMore == true) {
      _notifier?.fetchMessages();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final messagesAsync = ref.watch(chatRoomMessagesProvider);
    final user = ref.watch(authProvider).asData?.value;
    final uploadState = ref.watch(uploadMediaProvider);
    final isUploading = uploadState is AsyncLoading;
    return PopScope(
      canPop: !isFromNotification,
      onPopInvokedWithResult: (didPop, result) async {
        _notifier?.leaveRoom(widget.roomId, widget.userId.toString());

        final agora = AgoraEngineSingleton();
        if (agora.engine != null &&
            agora.appoinmentDetials != null &&
            agora.remoteUid == null) {
          agora.dispose();
        }

        if (isFromNotification) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const BottomBar(initialIndex: 3),
            ),
            (route) => false,
          );

          Future.delayed(Duration.zero, () {
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SchedulePage(),
              ),
            );
          });
        }
      },
      child: Scaffold(
        appBar: ChatAppBar(
          doctorId: (widget.doctor?.id ?? widget.senderId).toString(),
          bookingId: widget.bookingId,
          doctor: widget.doctor,
          userId: widget.userId,
          appointment: widget.appointment,
          userName: user?.name ?? user?.lastName ?? '',
          isFromNotification: isFromNotification,
          tabController: widget.tabController,
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ChatBottomCard(
                isUploading: isUploading,
                selectedFile: selectedFile,
                controller: chatController,
                scrollController: _scrollController,
                onSend: (text) {
                  final param = ChatMessageParam(
                    room: widget.roomId,
                    senderId: widget.senderId,
                    messageType: 'text',
                    receiverId: widget.receiverId,
                    content: text,
                  );

                  ref
                      .read(chatRoomMessagesProvider.notifier)
                      .sendMessage(param.toJson());
                  chatController.clear();
                },
                onMediaSend: (List<File> files) async {
                  final uploadNotifier = ref.read(uploadMediaProvider.notifier);

                  for (final file in files) {
                    await uploadNotifier.upload(file);
                    final uploadState = ref.read(uploadMediaProvider);

                    uploadState.when(
                      data: (mediaUrl) {
                        if (mediaUrl != null) {
                          final param = ChatMessageParam(
                            room: widget.roomId,
                            senderId: widget.senderId,
                            receiverId: widget.receiverId,
                            messageType: 'media',
                            mediaUrl: mediaUrl,
                            content: '',
                          );

                          ref
                              .read(chatRoomMessagesProvider.notifier)
                              .sendMessage(param.toJson());

                          _scrollController.animateTo(
                            _scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                      error: (e, _) {
                        CustomSnackBar.error(
                            context, "File too large or unsupported format");
                      },
                      loading: () {},
                    );
                  }
                }),
          ),
        ),
        floatingActionButton: _showScrollButton
            ? FloatingActionButton(
                onPressed: () {
                  _scrollToBottom();
                },
                mini: true,
                isExtended: false,
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(111),
                ),
                child: SvgPicture.asset(AppSvgs.chatDown),
              )
            : null,
        body: messagesAsync.when(
          loading: () => ChatLoadingSection(),
          error: (err, _) => TryAgainButton(
            message: "We couldn't fetch the chat message. \nPlease try again",
            onPressed: () async {
              await _notifier?.joinRoom(
                  widget.roomId, widget.userId.toString());
              await _notifier?.fetchMessages();
            },
          ),
          data: (messages) {
            final isLoading = _notifier?.isLoading ?? false;
            final currentPage = _notifier?.currentPage ?? 1;
            final showLoaderAtTop = isLoading && currentPage > 1;
            final itemCount = messages.length + (showLoaderAtTop ? 1 : 0);
            if (messages.isEmpty) {
              return Center(child: Text('No messages yet'.tr()));
            }
            return ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 33, horizontal: 20),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                final loaderIndex = itemCount - 1;

                if (showLoaderAtTop && index == loaderIndex) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  );
                }

                final actualIndex = showLoaderAtTop ? index : index;
                final chat = messages[messages.length - 1 - actualIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ChatCard(
                    chat: chat,
                    index: index,
                    isCustomer: chat.isDoctorSender == false,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatMessageParam {
  int? senderId;
  int? receiverId;
  String? messageType;
  String? content;
  String? mediaUrl;
  String? room;

  ChatMessageParam({
    this.senderId,
    this.receiverId,
    this.messageType,
    this.content,
    this.room,
    this.mediaUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['message_type'] = messageType;
    data['content'] = content;
    data['room'] = room;
    data['isDoctor'] = false;
    if (!isStringEmpty(mediaUrl)) data['media_url'] = mediaUrl;
    return data;
  }
}
