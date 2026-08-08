import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/model/chat_preview_message.dart';
import 'package:ufc_mobile/screens/pet_veterinary/service/provider/messages_list_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary/widgets/try_again_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/chat/chat_screen_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/chat_list_shimmer.dart';

final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

class ChatListWrapper extends ConsumerStatefulWidget {
  const ChatListWrapper({super.key});

  @override
  ConsumerState<ChatListWrapper> createState() => _ChatListWrapperState();
}

class _ChatListWrapperState extends ConsumerState<ChatListWrapper> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;

  void callApi() {
    ref
        .read(messagesListForUserProvider.notifier)
        .fetchMessagesList(reset: true, search: "");
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      callApi();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  ChatItem _mapChatPreviewToChatItem(ChatPreviewMessage preview) {
    final bool isSenderDoctor = preview.isDoctorSender == 0;
    final int senderId = isSenderDoctor ? preview.senderId : preview.receiverId;

    final int receiverId =
        isSenderDoctor ? preview.receiverId : preview.senderId;

    final String name =
        isSenderDoctor ? preview.receiverName : preview.senderName;

    final String? nameAr =
        isSenderDoctor ? preview.receiverNameAr : preview.senderNameAr;

    final String doctorImage = isSenderDoctor
        ? (preview.receiverProfilePicture ?? "")
        : (preview.senderProfilePicture ?? "");

    final String? specializationEn = isSenderDoctor
        ? preview.receiverSpecializationEn
        : preview.senderSpecializationEn;
    final String? specializationAr = isSenderDoctor
        ? preview.receiverSpecializationAr
        : preview.senderSpecializationAr;
    return ChatItem(
        name: name,
        nameAr: nameAr,
        specializationAr: specializationAr,
        specializationEn: specializationEn,
        lastMessage: preview.content,
        profileImage: preview.receiverProfilePicture ?? "",
        timeAgo: _formatTimeAgo(preview.latestMessageTime),
        status: ChatStatus.sent,
        unreadCount: 0,
        roomId: preview.room,
        senderId: senderId,
        receiverId: receiverId,
        messageType: preview.messageType,
        createdAt: preview.createdAt,
        updatedAt: preview.updatedAt,
        latestMessageTime: preview.latestMessageTime,
        doctorImage: doctorImage);
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return "secondsAgo".tr(args: [difference.inSeconds.toString()]);
    } else if (difference.inMinutes < 60) {
      return "minutesAgo".tr(args: [difference.inMinutes.toString()]);
    } else if (difference.inHours < 24) {
      return "hoursAgo".tr(args: [difference.inHours.toString()]);
    } else {
      return "daysAgo".tr(args: [difference.inDays.toString()]);
    }
  }

  Future<void> _fetchMore({bool reset = false}) async {
    await ref
        .read(messagesListForUserProvider.notifier)
        .fetchMessagesList(reset: reset);
  }

  Widget content(AsyncValue<List<ChatPreviewMessage>> chatListAsync) =>
      Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 32, top: 6),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              spreadRadius: 0.5,
                              offset: Offset(0, 2),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              spreadRadius: 1,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          autocorrect: false,
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (value) {
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();

                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              ref
                                  .read(messagesListForUserProvider.notifier)
                                  .fetchMessagesList(
                                      reset: true, search: value);
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Find the doctor'.tr(),
                            hintStyle: PetVeterinaryFontstyles2.getRegularStyle(
                              context,
                              11,
                              color: PetVeterinaryColors.newPetLightGray,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                'assets/new_design/icons/search_icon.png',
                                width: 16,
                                height: 16,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 16),
                    // Container(
                    //   height: 40,
                    //   width: 40,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(12),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.1),
                    //         blurRadius: 6,
                    //         offset: Offset(0, 3),
                    //       ),
                    //     ],
                    //   ),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     padding: EdgeInsets.zero,
                    //     icon: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Image.asset(
                    //         'assets/new_design/icons/filter_icon.png',
                    //         width: 20,
                    //         height: 20,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 32),
                // -> use this(above) when search bar is on top
                // const SizedBox(height: 16),
                Expanded(
                    child: chatListAsync.when(
                  data: (chatRooms) {
                    final chatItems =
                        chatRooms.map(_mapChatPreviewToChatItem).toList();
                    if (chatItems.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("No Chats yet".tr(),
                              textAlign: TextAlign.center,
                              style: PetVeterinaryFontstyles2.getRegularStyle(
                                      context, 13)
                                  .copyWith(
                                color: PetVeterinaryColors.newPetDarkGray,
                              )),
                        ),
                      );
                    }
                    return ChatListScreen(
                      chatData: chatItems,
                      onFetchMore: _fetchMore,
                      isLoadingMore: ref.watch(isLoadingMoreProvider),
                    );
                  },
                  loading: () => const ChatListShimmer(),
                  error: (error, _) => TryAgainButton(
                    styleType: TryAgainButtonStyle.newPet,
                    message: "Error loading chats",
                    onPressed: () => _fetchMore(reset: true),
                  ),
                ))
              ])));

  @override
  Widget build(BuildContext context) {
    final chatListAsync = ref.watch(messagesListForUserProvider);

    return chatListAsync.maybeWhen(
      error: (error, stackTrace) => isNetworkError(error.toString())
          ? NoInternet(
              type: AppType.veterinary,
              onTap: () => callApi(),
            )
          : content(chatListAsync),
      orElse: () => content(chatListAsync),
    );
  }
}

class ChatListScreen extends StatefulWidget {
  final List<ChatItem> chatData;
  final Future<void> Function({bool reset}) onFetchMore;
  final bool isLoadingMore;

  const ChatListScreen({
    super.key,
    required this.chatData,
    required this.onFetchMore,
    this.isLoadingMore = false,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !widget.isLoadingMore) {
        widget.onFetchMore(reset: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await widget.onFetchMore(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.separated(
          controller: _scrollController,
          itemCount: widget.chatData.length + (widget.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 28),
          itemBuilder: (context, index) {
            if (index < widget.chatData.length) {
              final chat = widget.chatData[index];

              return InkWell(
                  onTap: () async {
                    await Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen2(
                          isPast: true,
                          receiverId: chat.receiverId,
                          senderId: chat.senderId,
                          bookingId: '',
                          roomId: chat.roomId,
                          userId: chat.senderId,
                          doctorImage: chat.doctorImage,
                          doctorName: chat.name,
                          doctorNameAr: chat.nameAr,
                          specializationAr: chat.specializationAr,
                          specializationEn: chat.specializationEn,
                        ),
                      ),
                    );

                    await _handleRefresh();
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              color:
                                  PetVeterinaryColors.newPetMainColorVeterinary,
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Center(
                              child: (chat.doctorImage!.isNotEmpty)
                                  ? Image.network(
                                      chat.doctorImage!,
                                      width: 43,
                                      height: 43,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/new_design/icons/chat_user.png',
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/new_design/icons/chat_user.png',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEnglish
                                      ? chat.name
                                      : chat.nameAr ?? chat.name,
                                  style:
                                      PetVeterinaryFontstyles2.getRegularStyle(
                                    context,
                                    13,
                                  ).copyWith(
                                          color: PetVeterinaryColors
                                              .newPetLightGreyText),
                                ),
                                // const SizedBox(height: 4),
                                Text(
                                  chat.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      PetVeterinaryFontstyles2.getRegularStyle(
                                    context,
                                    13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 56),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                chat.timeAgo,
                                style: PetVeterinaryFontstyles2.getRegularStyle(
                                  context,
                                  13,
                                ).copyWith(
                                    color: PetVeterinaryColors
                                        .newPetLightGreyText),
                              ),
                              // const SizedBox(height: 6),
                              // if (chat.status == ChatStatus.unread)
                              //   Container(
                              //     width: 20,
                              //     height: 20,
                              //     decoration: const BoxDecoration(
                              //       color: PetVeterinaryColors
                              //           .newPetMainColorVeterinary,
                              //       shape: BoxShape.circle,
                              //     ),
                              //     alignment: Alignment.center,
                              //     child: Text(
                              //       chat.unreadCount.toString(),
                              //       style: PetVeterinaryFontstyles2
                              //           .manropeRegular14
                              //           .copyWith(
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   )
                              // else if (chat.status == ChatStatus.sent)
                              //   Image.asset(
                              //     'assets/new_design/icons/double_tick.png',
                              //     width: 16,
                              //     height: 16,
                              //   )
                              // else if (chat.status == ChatStatus.delivered)
                              //   Image.asset(
                              //     'assets/new_design/icons/double_tick.png',
                              //     width: 16,
                              //     height: 16,
                              //   )
                              // else if (chat.status == ChatStatus.read)
                              //   Image.asset(
                              //     'assets/new_design/icons/double_tick_blue.png',
                              //     width: 16,
                              //     height: 16,
                              //   ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                          height: 1,
                          width: double.infinity,
                          color: PetVeterinaryColors.newPetLighterGray2),
                    ],
                  ));
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
          }),
    );
  }
}

enum ChatStatus { sent, delivered, read, unread }

class ChatItem {
  final String name;
  final String lastMessage;
  final String profileImage;
  final String timeAgo;
  final ChatStatus status;
  final int unreadCount;
  final String roomId;
  final int senderId;
  final String? doctorImage;
  final int receiverId;
  final String messageType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime latestMessageTime;
  final String? specializationEn;
  final String? specializationAr;
  final String? nameAr;

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.profileImage,
    required this.timeAgo,
    this.doctorImage,
    required this.status,
    this.unreadCount = 0,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.messageType,
    required this.createdAt,
    required this.updatedAt,
    required this.latestMessageTime,
    this.specializationEn,
    this.specializationAr,
    this.nameAr,
  });
}
