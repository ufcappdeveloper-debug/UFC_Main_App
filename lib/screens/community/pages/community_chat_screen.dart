import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:ufc_mobile/global/config/pusher_config.dart';
import 'package:ufc_mobile/data/community_service.dart';
import 'package:ufc_mobile/global/language_cubit/language_cubit.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/models/community_models/channel_model/datum.dart';
import 'package:ufc_mobile/models/community_models/chat_model/community_chat_model.dart';
import 'package:ufc_mobile/models/community_models/chat_model/upload_file_res_model.dart';
import 'package:ufc_mobile/riverpod/auth/auth.dart';
import 'package:ufc_mobile/riverpod/community/chat_riverpod.dart';
import 'package:ufc_mobile/riverpod/community/chat_send_edit_riverpod.dart';
import 'package:ufc_mobile/screens/community/widgets/community_chat_tile.dart';
import 'package:ufc_mobile/screens/community/widgets/community_list_tile.dart';
import 'package:ufc_mobile/screens/community/widgets/reply_preview_component.dart';
import 'package:ufc_mobile/screens/community/widgets/suffix_send.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/shadows.dart';
import 'package:ufc_mobile/global/shared/widgets/camera_file_widgets/chat_attachment_pop_menu.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_text_field.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/cupertino_loading.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/util/community/community_utils.dart';
import 'package:ufc_mobile/global/util/file/file_picker_utils.dart';

class CommunityChatScreen extends ConsumerStatefulWidget {
  final int channelId;
  final String? channelName;
  final String? channelDesc;
  final String? channelIcon;
  final ChannelModel channel;
  const CommunityChatScreen({
    super.key,
    required this.channelId,
    required this.channelName,
    required this.channelDesc,
    required this.channelIcon,
    required this.channel,
  });

  @override
  ConsumerState<CommunityChatScreen> createState() =>
      _CommunityChatScreenState();
}

class _CommunityChatScreenState extends ConsumerState<CommunityChatScreen> {
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  int page = 1;
  late TextEditingController controller;
  PusherConfig pusherConfig = PusherConfig();
  List<CommunityChatModel>? chatList;

  CommunityChatModel? selectedChat;

  bool editPressed = false;
  bool replyPressed = false;
  bool editVisibility = false;
  bool replyVisibility = false;

  int? selectedInd;
  int? selectedId;
  List<List<String>> paths = [];
  List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  final Map<int, GlobalKey> messageKeys = {};
  final ValueNotifier<int?> highlightedMessageId = ValueNotifier(null);
  void initializeRoom(int roomId) async {
    pusherConfig.initPusher(onEvent, roomId);
  }

  void animateListToTheEnd({int time = 500}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: time), curve: Curves.easeInOut);
      }
    });
  }

  int? getIndex(int id) => chatList?.indexWhere((e) => e.id == id);

  Future<void> onEvent(PusherEvent event) async {
    try {
      if (event.data != {} &&
          event.eventName != 'pusher:subscription_succeeded') {
        Map<dynamic, dynamic>? data = jsonDecode(event.data);
        debugPrint("EVENT NAME --- ${event.eventName},    --- ${event.data}}");
        if (event.eventName == 'channel.message.new') {
          if (data != null && data['message'] != null) {
            CommunityChatModel? chat =
                CommunityChatModel.fromJson(data['message']);
            if (chatList != null && chatList!.isNotEmpty) {
              chatList?.insert(0, chat);
              setState(() {});
              animateListToTheEnd();
            } else {
              await ref
                  .read(chatRiverpodProvider.notifier)
                  .fetchChats(widget.channelId);
            }
          }
        } else if (event.eventName == 'channel.message.edit') {
          if (data != null && data['message'] != null) {
            CommunityChatModel? chat =
                CommunityChatModel.fromJson(data['message']);
            int? id = int.tryParse(data['message']['id'].toString());
            if (id != null) {
              int? index = getIndex(id);
              if (index != null) {
                chatList?[index] = chat;
              }
            }
            setState(() {});
          }
        } else if (event.eventName == 'channel.message.delete') {
          if (data != null && data['message_id'] != null) {
            int? id = int.tryParse(data['message_id'].toString());
            if (id != null) {
              int? index = getIndex(id);
              if (index != null) {
                chatList?[index].deletedAt = DateTime.now();
                setState(() {});
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error in event $e');
    }
  }

  void setVisibilityFalse() {
    editVisibility = false;
    selectedInd = null;
    selectedId = null;

    replyVisibility = false;
    setState(() {});
  }

  /// OPEN FILES
  Future<void> openFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result?.files.single.path != null) {
      File pickFile = File(result?.files.single.path ?? '');
      String? type = pickFile.path.split('.').lastOrNull;
      if (type != null) {
        paths.add([pickFile.path, type]);
        setState(() {});
      }
    }
    debugPrint("FILE --- $paths");
  }

  /// OPEN CAMERA OR GALLERY
  Future<void> openCameraOrGallery(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? pickedFile = await imagePicker.pickImage(source: source);
      String? type = pickedFile?.path.split('.').lastOrNull;
      if (pickedFile != null && type != null) {
        paths.add([pickedFile.path, type]);
        setState(() {});
      }
      debugPrint("XFILE --- $paths");
    } catch (e) {
      debugPrint("Error opening camera or gallery: $e");
      if (!mounted) return;
      CustomSnackBar.error(context, 'Failed to open camera or gallery'.tr());
    }
  }

  Future<void> sendPress() async {
    debugPrint("DATASS -- $editPressed, ${widget.channelId.toString()}");

    final text = controller.text.trim();
    if (paths.isEmpty && text == '') return;

    List<MultipartFile> imageFiles = [];
    List<UploadedFileModel> uploadedFiles = [];

    for (var path in paths) {
      final filePath = path[0];
      final fileType = path[1]; // example: 'image', 'file', 'pdf', etc.

      if (imageExtensions.contains(fileType)) {
        final file = await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        );
        imageFiles.add(file);
      } else {
        // Upload non-image file via API
        final uploaded = await uploadFileSeparately(filePath);
        if (uploaded != null) uploadedFiles.add(uploaded);
      }
    }

    final Map<String, dynamic> body = {
      if (!editPressed) 'channel_id': widget.channelId.toString(),
      if (text != '') 'message': text,
      if (editPressed) 'message_id': selectedId.toString(),
      if (replyVisibility) 'reply_for': selectedId.toString(),
      ...Map.fromEntries(
        List.generate(
          imageFiles.length,
          (i) => MapEntry('images[$i]', imageFiles[i]),
        ),
      ),
      if (uploadedFiles.isNotEmpty)
        ...Map.fromEntries(
          List.generate(
            uploadedFiles.length,
            (i) => [
              MapEntry('attachments[$i][url]', uploadedFiles[i].url),
              MapEntry('attachments[$i][type]', uploadedFiles[i].type),
            ],
          ).expand((pair) => pair),
        ),
    };

    final data = FormData.fromMap(body);

    if (editPressed && selectedId != null) {
      ref.read(chatSendEditRiverpodProvider.notifier).editMessage(data);
    } else {
      ref.read(chatSendEditRiverpodProvider.notifier).sendMessage(data);
    }

    // Cleanup
    paths.clear();
    controller.clear();
    if (editPressed) editPressed = false;
    if (replyVisibility) replyVisibility = false;
    if (editVisibility) setVisibilityFalse();

    setState(() {});
  }

  Future<UploadedFileModel?> uploadFileSeparately(
    String filePath,
  ) async {
    final file = await MultipartFile.fromFile(filePath,
        filename: filePath.split('/').last);
    final formData = FormData.fromMap({'file': file});

    try {
      final response = await CommunityService().uploadDocuments(formData);

      if (response != null) {
        return response;
      }
    } catch (e) {
      debugPrint('Upload failed: $e');
      if (mounted) {
        CustomSnackBar.error(context, 'File upload failed');
      }
    }

    return null;
  }

  @override
  void dispose() {
    controller.dispose();
    pusherConfig.disConnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    Future(() async {
      try {
        await ref
            .read(chatRiverpodProvider.notifier)
            .fetchChats(widget.channelId);
      } catch (e) {
        rethrow;
      }
    });
    initializeRoom(widget.channelId);
    debugPrint("CHANNEL ID -- ${widget.channelId}");
  }

  @override
  Widget build(BuildContext context) {
    final chatsDataAsync = ref.watch(chatRiverpodProvider);
    final chatSendEditPro = ref.watch(chatSendEditRiverpodProvider);

    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: khoriz(10),
                child: Column(
                  children: [
                    /// CustomCommunityTile for channel details
                    CustomCommunityTile(
                      showArrow: true,
                      fromChat: true,
                      title: widget.channelName ?? '',
                      subTitle: widget.channelDesc ?? '',
                      image: widget.channelIcon ?? '',
                    ),
                    Divider(
                      thickness: 1,
                      color: Color(0XFFF5F5F5),
                    ),
                    kHeight20,

                    /// Messengers List
                    chatsDataAsync.when(
                      data: (chats) {
                        chatList = chats;
                        return Expanded(child: messengersList());
                      },
                      error: (error, stack) {
                        chatList = null;
                        return Expanded(
                          child: Center(
                            child: CustomText(text: '$error',
                            fontSize: 14,),
                          ),
                        );
                      },
                      loading: () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: const Center(
                          child: CupertinoActivityIndicator(
                            color: primaryPurple,
                            radius: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Reply Text  filed container box
              Positioned(
                bottom: 0,
                left: 0,
                child: Column(
                  children: [
                    replyVisibility
                        ? ReplyPreviewComponent(
                            chat: selectedChat,
                            paths: paths,
                            selectedInd: selectedInd!,
                            primaryColor: primaryPurple,
                            onClose: () {
                              setState(
                                () {
                                  replyPressed = false;
                                  replyVisibility = false;
                                  setVisibilityFalse();
                                },
                              );
                            })
                        : SizedBox.shrink(),

                    Visibility(
                      visible: paths.isNotEmpty,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: btmSmContainerShadow,
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        width: sWidth(context),
                        height: 100,
                        padding: kall(6),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: paths.length,
                          padding: khoriz(10),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String path = paths[index][0];
                            String type = paths[index][1];
                            return Stack(
                              children: [
                                Padding(
                                  padding: konlyt(10),
                                  child: type == 'png' ||
                                          type == 'jpeg' ||
                                          type == 'jpg'
                                      ? paths[index][0].startsWith('http')
                                          ? CachedNetworkImage(
                                              imageUrl: path,
                                              width: 70,
                                              height: 70,
                                            )
                                          : Image.file(
                                              File(path),
                                              width: 70,
                                              height: 70,
                                            )
                                      : Padding(
                                          padding: konlyt(5),
                                          child: SvgPicture.asset(
                                            'assets/svg/global/file.svg',
                                            color: primaryPurple,
                                            width: 70,
                                            height: 70,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () {
                                        paths.removeAt(index);
                                      },
                                    ),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: cream,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              kWidth10,
                        ),
                      ),
                    ),

                    /// message input field and buttons
                    bottomWidget(context, chatSendEditPro),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /// Messages
  Widget messengersList() {
    return SingleChildScrollView(
      reverse: true,
      controller: scrollController,
      child: Padding(
        padding: konlyb(60),
        child: Column(
          children: List.generate(
            chatList?.length ?? 0,
            (index) {
              final reversedIndex = (chatList!.length - 1) - index;
              CommunityChatModel? chatItem = chatList?[reversedIndex];

              final messageId = chatItem?.id; // Assuming this is an `int`
              final messageKey =
                  messageKeys.putIfAbsent(messageId!, () => GlobalKey());
              return CommunityChatTile(
                key: messageKey,
                chatId: chatItem?.id,
                isSelected: isMessageSelected(index),
                messageSendDate: chatItem?.createdAt != null
                    ? loc.DateFormat('dd/MM/yyyy', 'en')
                        .format(chatItem!.createdAt!)
                    : '',
                nameInitial: nameInitial(chatItem),
                senderName: CommunityUtils.senderName(chatItem),
                message: chatItem?.message ?? '',
                primaryColorOfChat: primaryPurple,
                visible: editVisibility,
                actionList: getChatAction(chatItem),
                onReportPress: () => onReportPress(context, chatItem),
                isDeletedMessage: chatItem?.deletedAt != null,
                isEdited: chatItem?.isEdited ?? false,
                image: chatItem?.sender?.profilePic,
                listOfImages: chatItem?.imageList,
                listOfAttachments: chatItem?.attachements,
                onTap: () => onTap(),
                onLongPress: () => onLongPress(chatItem, index),
                onEditPress: () => onEditPress(chatItem),
                onDeletePress: () => onDeletePress(chatItem),
                onReplyPress: () => onReplyPress(),
                isRepliedMessage: chatItem?.replyForMessage != null,
                replyToUserName:
                    CommunityUtils.replyToUserName(chatItem?.replyForMessage),
                replyToMessage: chatItem?.replyForMessage?.message,
                profileBgColor: CommunityUtils.getColorForAvatar(chatItem),
                onTapOfRepliedMessage: () => onTapOfRepliedMessage(chatItem),
                highlightedMessageId: highlightedMessageId,
              );
            },
          ),
        ),
      ),
    );
  }

  String userName(CommunityChatModel? chat) {
    if (selectedId != null) {
      final user = ref.read(authProvider).asData?.value;
      if (chat?.sender?.id == user?.id) {
        return user?.name ?? 'Unknown';
      }
    } else {
      return CommunityUtils.replyToUserName(chat?.replyForMessage);
    }
    return 'Unknown';
  }

  void onTapOfRepliedMessage(CommunityChatModel? chatItem) {
    final replyId = chatItem?.replyForMessage?.id;
    if (replyId == null || chatList == null) return;

    final targetIndex = chatList!.indexWhere((chat) => chat.id == replyId);

    if (targetIndex != -1) {
      final key = messageKeys[replyId];
      highlightedMessageId.value = replyId;

      // Optional: Clear the highlight after a few seconds
      Future.delayed(Duration(milliseconds: 1300), () {
        if (highlightedMessageId.value == replyId) {
          highlightedMessageId.value = null;
        }
      });
      if (key != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = key.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 400),
              alignment: 0.5,
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  List<ChatMessageAction> getChatAction(CommunityChatModel? chat) {
    return isUserSender(chat)
        ? [
            ChatMessageAction.edit,
            ChatMessageAction.delete,
            ChatMessageAction.reply,
          ]
        : [
            ChatMessageAction.report,
            ChatMessageAction.reply,
          ];
  }

  bool isMessageSelected(int index) {
    return selectedInd == index && editVisibility;
  }

  /// ON EDIT PRESS
  void onEditPress(CommunityChatModel? chat) {
    FocusScope.of(context).requestFocus(focusNode);
    controller.text = chat?.message ?? '';
    chat?.imageList?.forEach((image) {
      if (image.imageUrl != null) {
        final File file = File.fromUri(Uri(path: image.imageUrl!));
        paths.add([file.path, image.imageUrl?.split('.').lastOrNull ?? '']);
      }
    });

    editPressed = true;
    setState(() {});
  }

  /// ON DELETE PRESS
  void onDeletePress(CommunityChatModel? chat) {
    customDialog(context, 'Do you want to delete this message?'.tr()).then((v) {
      if (v) {
        if (chat?.id != null) {
          ref
              .read(chatSendEditRiverpodProvider.notifier)
              .deleteMessage(chat!.id!);
          setVisibilityFalse();
        }
      }
    });
  }

  /// ON REPLY PRESS
  void onReplyPress() {
    replyVisibility = true;
    replyPressed = true;
    setState(() {});
  }

  /// ON TAP
  void onTap() {
    setVisibilityFalse();
  }

  /// ON LONG PRESS
  void onLongPress(CommunityChatModel? chat, int index) {
    setState(() {
      replyPressed = false;
      replyVisibility = false;
      editPressed = false;
      selectedInd = index;
      selectedId = chat?.id;
      selectedChat = chat;
      editVisibility = true;
    });
  }

  void onReportPress(BuildContext ctxt, CommunityChatModel? chatItem) async {
    try {
      await CommunityUtils.showCustomReportSheet(
        context: ctxt,
        userName: chatItem?.sender?.name ?? 'Unknown',
        messageText: chatItem?.message ?? '',
        onAction: (String? reason) async {
          final FormData data = FormData.fromMap({
            'message_id': selectedId.toString(),
            'report_reason': reason,
          });

          await ref
              .read(chatSendEditRiverpodProvider.notifier)
              .reportMessae(data);
          if (!mounted) return;
          Navigator.pop(context);
          CustomSnackBar.show(
            context,
            'Reported the message successfully'.tr(),
          );
        },
      );
    } catch (e) {
      rethrow;
    } finally {
      setVisibilityFalse();
    }
  }

  bool isUserSender(CommunityChatModel? chat) {
    final user = ref.read(authProvider).asData?.value;
    return chat?.sender?.id == user?.id;
  }

  /// Message sender's name initial
  String nameInitial(CommunityChatModel? chat) {
    if (chat?.sender != null && (chat?.sender?.name ?? '').isNotEmpty) {
      return (chat?.sender?.name ?? '')[0].toUpperCase();
    }
    return '';
  }

  ///  Bottom Widget Contains the message input field, attachment button, and send button.
  Widget bottomWidget(
    BuildContext context,
    AsyncValue<bool> chatSendEditPro,
  ) {
    return Container(
      color: Colors.white,
      width: sWidth(context),
      padding: konlyt(5),
      child: Padding(
        padding: konlyb(5),
        child: !allowToSend
            ? CustomTextField(
                readOnly: widget.channel.allowUsersToSend != true,
                cursorColor: Colors.black,
                width: sWidth(context) * 0.7,
                focusNode: focusNode,
                controller: controller,
                borderRadius: boRadius(12),
                fillColor1: cream,
                maxLength: 50000,
                counterText: '',
                inputTextColor: Colors.black,
                hint:
                    'You are not allowed to send messages in this channel'.tr(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// CHOOSE ATTACHMENT BUTTON
                  ChatAttachmentPopUpMenuButton(
                    buttonColor: primaryPurple,
                    options: [
                      AttachmentOption.camera,
                      AttachmentOption.gallery,
                      AttachmentOption.file
                    ],
                    onSelected: (option) {
                      switch (option) {
                        case AttachmentOption.camera:
                          openCameraOrGallery(ImageSource.camera);
                          break;
                        case AttachmentOption.gallery:
                          openCameraOrGallery(ImageSource.gallery);
                          break;
                        case AttachmentOption.file:
                          openFiles();
                          break;
                      }
                    },
                  ),
                  kWidth10,

                  /// MESSAGE INPUT FIELD
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 150, minHeight: 47),
                    child: CustomTextField(
                      readOnly: widget.channel.allowUsersToSend != true,
                      cursorColor: Colors.black,
                      width: sWidth(context) * 0.7,
                      focusNode: focusNode,
                      controller: controller,
                      borderRadius: boRadius(12),
                      fillColor1: cream,
                      maxLength: 50000,
                      counterText: '',
                      inputTextColor: Colors.black,
                      hint: (allowToSend)
                          ? 'Write your message...'.tr()
                          : 'You are not allowed to send messages in this channel'
                              .tr(),
                    ),
                  ),
                  kWidth10,

                  /// SEND BUTTON
                  chatSendEditPro.when(
                    data: (value) {
                      return suffixSend(
                        context,
                        () async {
                          if (allowToSend) {
                            sendPress();
                          }
                        },
                        primaryPurple,
                      );
                    },
                    error: (error, stack) {
                      return suffixSend(
                        context,
                        () async {
                          if (allowToSend) {
                            sendPress();
                          }
                        },
                        primaryPurple,
                      );
                    },
                    loading: () => cupertinoLoading(
                      padding: EdgeInsets.only(right: 5),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  bool get allowToSend {
    return widget.channel.allowUsersToSend ?? false;
  }
}
