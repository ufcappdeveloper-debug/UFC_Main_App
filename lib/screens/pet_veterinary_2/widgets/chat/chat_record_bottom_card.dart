// class ChatRecordBottomCard extends StatefulWidget {
//   const ChatRecordBottomCard({
//     super.key,
//     required this.room,
//     required this.recorder,
//     required this.receiverId,
//     required this.scrollController,
//     required this.recorderController,
//     required this.recordAudioController,
//   });
//   final String? room;
//   final int? receiverId;
//   final FlutterSoundRecorder recorder;
//   final ScrollController scrollController;
//   final RecorderController recorderController;
//   final ChatAudioPlayerController recordAudioController;

//   @override
//   State<ChatRecordBottomCard> createState() => _ChatRecordBottomCardState();
// }

// class _ChatRecordBottomCardState extends State<ChatRecordBottomCard> {
//   final ValueNotifier<bool> _isDeleting = ValueNotifier<bool>(false);

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AuthCubit>().user;
//     return BlocBuilder<UploadCubit, UploadState>(
//       builder: (context, state) {
//         return ValueListenableBuilder(
//           valueListenable: _isDeleting,
//           builder: (context, isDeleting, _) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ChatUploadedFileCard(
//                   isRecord: true,
//                   selectedFile: ChatRecordUtils.recordedFile,
//                   audioController: widget.recordAudioController,
//                   recorderController: widget.recorderController,
//                 ),
//                 Container(
//                   height: 88,
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(horizontal: 21),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 64,
//                         spreadRadius: -4,
//                         offset: Offset(0, 14),
//                         color: AppColors.deepNavyBlueColor.withValues(
//                           alpha: 0.12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ChatActionButton(
//                         icon: AppSvgs.delete,
//                         borderRadius: BorderRadius.circular(111),
//                         onPressed:
//                             isDeleting || state is UploadLoading
//                                 ? null
//                                 : () async {
//                                   try {
//                                     _isDeleting.value = true;
//                                     await ChatRecordUtils.deleteRecording(
//                                       deleteRecording: (path) async {
//                                         // await widget.recorder.deleteRecord(
//                                         //   fileName: path,
//                                         // );
//                                         // widget.recorderController.reset();
//                                         await widget.recorder.stopRecorder();
//                                         await widget.recorderController.stop();
//                                         ChatRecordUtils.isRecording.value =
//                                             false;
//                                       },
//                                     );
//                                   } finally {
//                                     _isDeleting.value = false;
//                                   }
//                                 },
//                       ),
//                       SizedBox(width: 14),
//                       Spacer(),
//                       ValueListenableBuilder(
//                         valueListenable: ChatRecordUtils.isPaused,
//                         builder: (context, value, _) {
//                           return ChatActionButton(
//                             iconWidth: value ? 22 : 15,
//                             iconHeight: value ? 22 : 15,
//                             iconColor: AppColors.warning600,
//                             borderRadius: BorderRadius.circular(111),
//                             icon:
//                                 value
//                                     ? AppSvgs.chatMicrophone
//                                     : AppSvgs.chatPause,
//                             onPressed:
//                                 isDeleting || state is UploadLoading
//                                     ? null
//                                     : () async {
//                                       if (widget.recorder.isRecording) {
//                                         await ChatRecordUtils.pauseRecording(
//                                           pauseRecording: () async {
//                                             await widget.recorder
//                                                 .pauseRecorder();
//                                             await widget.recorderController
//                                                 .pause();
//                                           },
//                                         );
//                                       } else if (widget.recorder.isPaused) {
//                                         await ChatRecordUtils.resumeRecording(
//                                           resumeRecording: () async {
//                                             await widget.recorder
//                                                 .resumeRecorder();
//                                             await widget.recorderController
//                                                 .record(
//                                                   path:
//                                                       ChatRecordUtils
//                                                           .recordedWaveFile
//                                                           .value
//                                                           ?.path,
//                                                 );
//                                           },
//                                         );
//                                       }
//                                     },
//                           );
//                         },
//                       ),
//                       Spacer(),
//                       SizedBox(width: 14),
//                       GestureDetector(
//                         onTap: () {},
//                         child: ChatActionButton(
//                           icon: AppSvgs.chatSend,
//                           isLoading: state is UploadLoading,
//                           borderRadius: BorderRadius.circular(111),
//                           onPressed:
//                               isDeleting
//                                   ? null
//                                   : () async => _sendMessage(
//                                     context,
//                                     user: user,
//                                     selectedFile: ChatRecordUtils.recordedFile,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _sendMessage(
//     BuildContext context, {
//     required UserModel? user,
//     required ValueNotifier<File?> selectedFile,
//   }) async {
//     String? mediaUrl;
//     await ChatRecordUtils.stopRecording(
//       stopRecorder: () async {
//         await widget.recorder.stopRecorder();
//         await widget.recorderController.stop();
//       },
//     );

//     final file = selectedFile.value;
//     if (file != null) {
//       if (!context.mounted) return;
//       await context.read<UploadCubit>().uploadMedia(media: file);
//       if (!context.mounted) return;
//       mediaUrl = context.read<UploadCubit>().mediaUrl;
//     }

//     final param = ChatMessageParam(
//       room: widget.room,
//       mediaUrl: mediaUrl,
//       senderId: user?.id,
//       receiverId: widget.receiverId,
//       messageType: MessageTypeEnum.media,
//     );
//     if (!context.mounted) return;
//     await context.read<ChatCubit>().onSendMessage(param);

//     if (!context.mounted) return;
//     context.read<UploadCubit>().clear;
//     ChatRecordUtils.isRecording.value = false;
//     widget.scrollController.jumpTo(
//       widget.scrollController.position.minScrollExtent,
//     );

//     await ChatRecordUtils.deleteRecording(
//       deleteRecording: (path) async {
//         await widget.recorder.deleteRecord(fileName: path);
//         widget.recorderController.reset();
//       },
//     );
//   }
// }
