import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/models/schedule/appointment_model.dart';
import 'package:ufc_mobile/riverpod/schedule/schedule_riverpod.dart';
import 'package:ufc_mobile/screens/feed/application/navbar/app_bar_cubit.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/file_downloader.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/truncate_strings.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/doctor_appointment_screen.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/pages/pet_vet_bottom_bar.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/providers/appointment_details_riverpod.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/widgets/action_btn_with_icon.dart';

class BookingDetailsScreen extends ConsumerStatefulWidget {
  final bool notFromPastBooking;
  final int bookingId;
  final int doctorId;
  final String doctorName;
  final double rating;
  final String specialization;
  final String doctorImage;
  final bool isFromHome;

  const BookingDetailsScreen({
    super.key,
    required this.notFromPastBooking,
    required this.bookingId,
    required this.doctorId,
    required this.doctorName,
    required this.rating,
    required this.specialization,
    required this.doctorImage,
    this.isFromHome = false,
  });

  @override
  ConsumerState<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends ConsumerState<BookingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(appointmentDetailsProvider.notifier)
          .fetchAppointmentDetails(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentDetailsProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Directionality(
          textDirection: flutter.TextDirection.ltr,
          child: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Booking details".tr(),
              style: PetVeterinaryFontstyles2.getMediumStyle(context, 17)
                  .copyWith(color: Colors.black),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  size: 16, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: appointmentState.when(
        data: (appointment) {
          if (appointment == null) {
            return Center(
                child: Text("No appointment found".tr(),
                    textAlign: TextAlign.center,
                    style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
                        .copyWith(
                      color: PetVeterinaryColors.newPetDarkGray,
                    )));
          }

          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDoctorCard(context),
                const SizedBox(height: 16),
                _buildBookingInfoCard(context, appointment),
                const SizedBox(height: 16),
                _buildLivestockInfoCard(context, appointment),
                const SizedBox(height: 56),
                if (widget.notFromPastBooking)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorAppointmentScreen(
                                doctorId: widget.doctorId,
                                doctorName: widget.doctorName,
                                specialization: widget.specialization,
                                doctorImage: widget.doctorImage,
                                rating: widget.rating,
                                bookingId: widget.bookingId,
                                forEditBooking: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          margin: const EdgeInsets.only(
                              top: 60, bottom: 16, left: 16, right: 16),
                          height: 54,
                          decoration: BoxDecoration(
                            color:
                                PetVeterinaryColors.newPetMainColorVeterinary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Edit Appointment".tr(),
                            style: PetVeterinaryFontstyles2.getRegularStyle(
                                    context, 14)
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCancelDialog(context, widget.bookingId);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          margin: const EdgeInsets.only(
                              bottom: 48, left: 16, right: 16),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel Appointment".tr(),
                            style: PetVeterinaryFontstyles2.getRegularStyle(
                                    context, 14)
                                .copyWith(color: PetVeterinaryColors.redColor),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: GestureDetector(
            onTap: () {
              ref
                  .read(appointmentDetailsProvider.notifier)
                  .fetchAppointmentDetails(widget.bookingId);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Something went wrong".tr(),
                    style: PetVeterinaryFontstyles2.getRegularStyle(
                      context,
                      14,
                      color: PetVeterinaryColors.newPetLightGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  const Icon(
                    Icons.refresh,
                    color: PetVeterinaryColors.newPetLightGray,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLivestockInfoCard(
      BuildContext context, AppointmentModel appointment) {
    // Assuming the first prescription is the relevant one
    final prescription = (appointment.prescriptions?.isNotEmpty ?? false)
        ? appointment.prescriptions!.first
        : null;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: _cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Livestock Information".tr(),
            style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
          ),
          const SizedBox(height: 20),
          _infoRow(
            context,
            "Livestock number",
            appointment.animalRef ?? "-".tr(),
          ),
          Divider(
            thickness: 1,
            color: PetVeterinaryColors.lightGrayBackground,
          ),
          const SizedBox(height: 12),
          Text(
            "Note".tr(),
            style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
          ),
          const SizedBox(height: 16),
          Text(
            prescription?.notes?.isNotEmpty == true
                ? prescription!.notes!
                : "-",
            style: PetVeterinaryFontstyles2.getRegularStyle(context, 15),
          ),
          const SizedBox(height: 28),
          ActionButtonWithIcon(
            iconPath: "assets/new_design/icons/download_prescription.png",
            label: "Download prescription",
            isOutlined: true,
            onTap: () {
              if (prescription == null || prescription.files?.isEmpty == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Prescription unavailable".tr()),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                FileDownloader.show(context, prescription.files!);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: _cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dr. Information".tr(),
            style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 14.5,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (widget.doctorImage.isNotEmpty)
                    ? NetworkImage(widget.doctorImage)
                    : null,
                child: widget.doctorImage.isEmpty
                    ? Image.asset(
                        'assets/new_design/icons/chat_user.png',
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                widget.doctorName,
                style: PetVeterinaryFontstyles2.getMediumStyle(
                  context,
                  14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _infoRow(
            context,
            "Specialization",
            truncateSpecialization(context, widget.specialization),
          ),
          Divider(
            thickness: 1,
            color: PetVeterinaryColors.lightGrayBackground,
          ),
          const SizedBox(height: 12),
          _infoRow(context, "Rating", widget.rating.toStringAsFixed(1),
              icon: const Icon(Icons.star, size: 16, color: Colors.amber)),
        ],
      ),
    );
  }

  Widget _buildBookingInfoCard(
      BuildContext context, AppointmentModel? appointment) {
    if (appointment == null) {
      return const SizedBox();
    }

    String formattedDateTime = "";
    if (appointment.startTime != null) {
      final dateTimeUtc = DateTime.parse(appointment.startTime!);
      final dateTimeLocal = dateTimeUtc.toLocal();

      formattedDateTime =
          "${_formatDate(dateTimeLocal)} / ${_formatTime(dateTimeLocal)}";
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: _cardBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Basic Booking Information".tr(),
            style: PetVeterinaryFontstyles2.getMediumStyle(context, 15),
          ),
          const SizedBox(height: 20),
          _infoRow(
            context,
            "Reservation number",
            "#${appointment.id ?? ''}",
          ),
          Divider(
            thickness: 1,
            color: PetVeterinaryColors.lightGrayBackground,
          ),
          const SizedBox(height: 12),
          _infoRow(
            context,
            "Date",
            formattedDateTime,
            icon: const Icon(Icons.access_time, size: 16, color: Colors.black),
          ),
          Divider(
            thickness: 1,
            color: PetVeterinaryColors.lightGrayBackground,
          ),
          const SizedBox(height: 12),
          _infoRow(
              context,
              "Reservation status",
              // _capitalize(appointment.status ?? '')),
              _capitalize(
                  DoctorUtils.getTranslatedStatusText(appointment.status))),
          Divider(
            thickness: 1,
            color: PetVeterinaryColors.lightGrayBackground,
          ),
          const SizedBox(height: 12),
          _infoRow(
              context,
              "Payment method",
              _capitalize(DoctorUtils.getTranslatedStatusText(
                  appointment.paymentStatus))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final locale = isEnglish ? 'en' : 'ar';
    return DateFormat.yMMMMd(locale).format(date);
  }

  String _formatTime(DateTime date) {
    final locale = isEnglish ? 'en' : 'ar';
    return DateFormat.jm(locale).format(date);
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _infoRow(BuildContext context, String key, String value,
      {Widget? icon}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            key.tr(),
            style: PetVeterinaryFontstyles2.getRegularStyle(context, 15)
                .copyWith(color: PetVeterinaryColors.newPetDarkGray),
          ),
        ),
        if (icon != null) ...[
          icon,
          const SizedBox(width: 8),
        ],
        Text(
          value,
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 15),
        ),
      ],
    );
  }

  void showCancelDialog(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              kHeight16,
              Image.asset(
                "assets/new_design/images/cancel_booking.png",
                width: 57,
                height: 57,
              ),
              kHeight16,
              SizedBox(
                width: 225,
                child: Text(
                  "Are you sure you want to cancel your booking?".tr(),
                  textAlign: TextAlign.center,
                  style: PetVeterinaryFontstyles2.getMediumStyle(context, 17),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
              kHeight25,
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        EasyLoading.show();
                        final data = await ref
                            .read(appointmentAsyncProvider.notifier)
                            .cancelAppointMent(bookingId);
                        if (!context.mounted) return;
                        EasyLoading.dismiss();
                        if (data != null) {
                          CustomSnackBar.success(context,
                              data.message ?? 'Cancelled successfully');
                          context.read<SelectedAppbarItemCubit>().setIndex(1);
                          ref.read(petVetTabIndexProvider.notifier).state =
                              widget.isFromHome ? 0 : 2;

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const BottomBar(initialIndex: 1)),
                            (route) => false,
                          );
                        } else {
                          CustomSnackBar.error(context, "Cancellation failed");
                        }
                      } catch (e) {
                        EasyLoading.dismiss();
                        CustomSnackBar.error(context, e.toString());
                      } finally {
                        if (EasyLoading.isShow) {
                          EasyLoading.dismiss();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      margin: const EdgeInsets.only(bottom: 16),
                      height: 54,
                      decoration: BoxDecoration(
                        color: PetVeterinaryColors.newPetMainColorVeterinary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes".tr(),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                                context, 14)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: PetVeterinaryColors.newPetMainColorVeterinary,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "No".tr(),
                        style: PetVeterinaryFontstyles2.getRegularStyle(
                                context, 14)
                            .copyWith(
                          color: PetVeterinaryColors.newPetMainColorVeterinary,
                        ),
                      ),
                    ),
                  ),

                  // Yes Button
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _cardBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          spreadRadius: 0.5,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
