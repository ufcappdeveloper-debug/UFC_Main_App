import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/file_picker.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/models/ticket_issues_model.dart';
import 'package:ufc_mobile/screens/feed_old/support/pages/contact_us_page.dart';
import 'package:ufc_mobile/screens/feed_old/ticket/ticket_success_page.dart';

import '../../../data/ticket_service.dart';
import '../../../global/shared/constants/app_colors.dart';
import '../../../global/shared/widgets/custom_ticket_textfield.dart';
import '../../../models/create_ticket_model/create_ticket_model.dart';
import '../../feed/domain/entities/order/order_model.dart';
import '../../../riverpod/order/order_history.dart';
import '../../../riverpod/ticket/my_tickets.dart';
import '../../../riverpod/ticket/ticket.dart';

class TicketPage extends ConsumerStatefulWidget {
  const TicketPage({super.key, required this.page});

  final int? page;

  @override
  ConsumerState<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends ConsumerState<TicketPage>
    with ScreenEngagementTracker {
  final orderNumberController = TextEditingController();
  final detailsController = TextEditingController();
  final orderNumberNode = FocusNode();
  final detailsNode = FocusNode();
  final _key = GlobalKey<FormState>();
  File? image;
  bool isImageValid = false;
  bool isImageExists = false;
  List<TicketIssuesModel> issueList = [];
  List<OrderModel> orderHistory = [];
  String selectedCity = "";
  int? issueId;
  int? orderId;
  bool isSubmitting = false;
  bool showImageError = false;
  bool imageAlreadyExists = false;

  @override
  void initState() {
    super.initState();
    Future(() => ref.read(ticketProvider.notifier).getIssues());

    Future(() => ref.read(orderHistoryProvider.notifier).getAllOrders());
    debugPrint("ASDAS ${ref.read(ticketProvider)}");
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(ticketProvider).when(
        data: (List<TicketIssuesModel> data) =>
            data.isEmpty ? debugPrint("Error happeend") : issueList = data,
        error: (e, s) => Center(child: Text(e.toString())),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));

    ref.watch(orderHistoryProvider).when(
        data: (List<OrderModel> data) =>
            data.isEmpty ? debugPrint("Error happeend") : orderHistory = data,
        error: (e, s) => Center(child: Text(e.toString())),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CommonBackAppBar(title: "New Ticket"),
        body: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // CustomSupportFormField(
              //   nameController: orderNumberController,
              //   nameNode: orderNumberNode,
              //   label: 'Order Number',
              //   textInputType: TextInputType.text,
              //   textColor: Colors.black,
              //   fontWeight: FontWeight.w500,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 23, right: 20, bottom: 5),
                child: CustomText(
                  text: 'Order Number',
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  textAlign: TextAlign.start,
                ),
              ),

              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                          hint: CustomText(
                            text: "",
                            fontSize: 16,
                            color: const Color(0xff8b8b8b),
                            textAlign: TextAlign.center,
                          ),
                          onChanged: (value) {
                            // issueId = value!.id;
                            orderId = value!.id;
                            debugPrint(value.toString());
                          },
                          padding: const EdgeInsets.all(0),
                          icon: const RotatedBox(
                              quarterTurns: 3,
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 18)),
                          borderRadius: BorderRadius.circular(10),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(bottom: 8, left: 10)),
                          items: [
                            ...orderHistory.map((e) => DropdownMenuItem(
                                value: e,
                                child: CustomText(
                                  text: e.id.toString(),
                                  fontFamily: null,
                                  fontSize: 13,
                                ))),
                          ]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                          hint: CustomText(
                            text: "What's the problem",
                            fontSize: 16,
                            color: const Color(0xff8b8b8b),
                            textAlign: TextAlign.center,
                          ),
                          onChanged: (value) {
                            issueId = value!.id;
                            debugPrint(value.toString());
                          },
                          padding: const EdgeInsets.all(0),
                          icon: const RotatedBox(
                              quarterTurns: 3,
                              child: Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 18)),
                          borderRadius: BorderRadius.circular(10),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(bottom: 8, left: 10)),
                          items: [
                            ...issueList.map((e) => DropdownMenuItem(
                                value: e,
                                child: CustomText(
                                  text: e.name.toString(),
                                  fontFamily: null,
                                  fontSize: 13,
                                ))),
                          ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TicketTextField(
                nameController: detailsController,
                nameNode: detailsNode,
                label: 'Add Details',
                textInputType: TextInputType.text,
                maxLines: 10,
              ),
              // CustomSupportFormField(
              //   nameController: detailsController,
              //   nameNode: detailsNode,
              //   label: 'Add Details',
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "";
              //     }
              //     return null;
              //   },
              //   textInputType: TextInputType.text,
              //   textColor: Colors.black,
              //   fontWeight: FontWeight.w500,
              //   maxLines: 10,
              // ),
              CustomSupportFormField(
                nameController: null,
                file: image,
                upload: true,
                nameNode: detailsNode,
                label: '',
                showError: false,
                textInputType: TextInputType.text,
                textColor: Colors.black,
                fontWeight: FontWeight.w500,
                hintText: image != null ? image!.path.split("/").last : "",
                readOnly: true,
                onTap: () async {
                  debugPrint('here');
                  final newFile = await AppFilePicker().showFilePicker(context);
                  if (newFile != null && newFile.isNotEmpty) {
                    setState(() {
                      image = newFile.first;
                      debugPrint(image.toString());
                    });
                  }
                },
                onTapDelete: () {
                  image = null;
                  isImageValid = false;
                  imageAlreadyExists = false;
                  // nationalFrontAlreadyExists = false;
                  // isFrontIDValid = false;
                  if (mounted) setState(() {});
                },
              ),

              Expanded(
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 0),
                    alignment: Alignment.center,
                    child: CustomButton(
                        title: 'Send Ticket',
                        color:
                            primaryColor, //isSubmitting ? Colors.grey : primaryColor,
                        onTap: () async {
                          if (_key.currentState!.validate()) {
                            setState(() {
                              isSubmitting = true;
                            });
                            try {
                              if (orderId == null) {
                                CustomSnackBar.error(
                                    context, 'Please select order number');
                                return;
                              }
                              if (issueId == null) {
                                CustomSnackBar.error(
                                    context, 'Please select an issue');
                                return;
                              }

                              CreateTicketModel sentTicket =
                                  await TicketService().createTicket(
                                orderId: orderId.toString(),
                                issueId: issueId,
                                image: image,
                                details: detailsController.text,
                              );
                              debugPrint(sentTicket.status);
                              if (!context.mounted) return;
                              CustomSnackBar.success(
                                  context, sentTicket.status.toString());
                              setState(() {
                                isSubmitting = false;
                              });
                              //before pop call the method

                              Future(() => ref
                                  .read(ticketsProvider.notifier)
                                  .addNewTicket(sentTicket.data!));
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TicketSuccessPage()),
                              );
                            } on DioException catch (e) {
                              debugPrint('error $e');
                              if (!context.mounted) return;
                              CustomSnackBar.error(context,
                                  'Unable to submit comment, please try again later.');
                              setState(() {
                                isSubmitting = false;
                              });
                            }
                          } else {
                            CustomSnackBar.error(
                                context, "Kindly fill in the all fields");
                          }
                        })),
              )
            ]),
          ),
        ));
  }
}
// {{base_url}}/api/ufc/v1/ticket/create_ticket
// 830|laravel_sanctum_oFxLAVuUW1DHvcAmIC2pkHHOfz7wbHqmz4BSxwDr6c7dc21f
// Bearer 55|laravel_sanctum_WbAfq7CgHlt6iFaAuNFnmGN6cWSC9qnNNaVRnuHi6ab50b57
