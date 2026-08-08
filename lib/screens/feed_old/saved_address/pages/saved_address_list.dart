import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ufc_mobile/models/address_model.dart';
import 'package:ufc_mobile/riverpod/default_address/default_address.dart';
import 'package:ufc_mobile/riverpod/saved_address/saved_address.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/widget/refresh_footer.dart';
import 'package:ufc_mobile/screens/feed_old/saved_address/widget/show_delete_address_dialog.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

import '../../../../global/config/config.dart';
import '../../../../global/shared/constants/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../../../../global/shared/widgets/custom_appbar.dart';
import '../../../../global/shared/widgets/custom_button.dart';
import '../../../../global/shared/widgets/custom_pagination_header.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import 'address_map_screen.dart';

class SavedAddressList extends ConsumerStatefulWidget {
  const SavedAddressList({super.key, this.currentDefaultAddressId});
  static const int limit = 100;
  final int? currentDefaultAddressId;
  @override
  ConsumerState<SavedAddressList> createState() => _SavedAddressListState();
}

class _SavedAddressListState extends ConsumerState<SavedAddressList>
    with ScreenEngagementTracker {
  int page = 1;
  bool isLoading = false;
  late RefreshController controller;
  AddressModel? defaultAddress;

  @override
  void initState() {
    Future(() => ref.read(defaultAddressProvider.notifier).getDefaultAddress());
    super.initState();
    controller = RefreshController(initialRefresh: false);
    refresh();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void refresh() {
    page = 1;
    Future(() => ref
        .read(savedAddressProvider.notifier)
        .initialLoad(page, SavedAddressList.limit));
    controller.refreshCompleted();
  }

  Future<void> loadMore() async {
    bool loadMore = false;
    page += 1;
    loadMore = await ref
        .read(savedAddressProvider.notifier)
        .loadMore(page, SavedAddressList.limit);
    if (loadMore) {
      controller.loadComplete();
    } else {
      controller.loadNoData();
    }
  }

  Future<void> setDefaultAddress(AddressModel selectedAddress) async {
    ref
        .read(defaultAddressProvider.notifier)
        .setDefaultAddress(selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    final savedAddressList = ref.watch(savedAddressProvider);
    final defaultAddressData = ref.watch(defaultAddressProvider);
    ref.listen(savedAddressProvider, (previous, next) {
      if (mounted && next.isLoading) {
        page = 1;
        controller.resetNoData();
      }
    });
    return WillPopScope(
        onWillPop: () async {
          // Return true or false based on your logic
          Navigator.pop(context, true); // Ensure that true is passed
          return false; // Prevent the default pop behavior
        },
        child: Scaffold(
          appBar: CustomAppbar(
            title: 'Saved Address',
            leading: InkWell(
                onTap: () async {
                  await ref
                      .read(defaultAddressProvider.notifier)
                      .getDefaultAddress();
                  if (!context.mounted) return;
                  Navigator.pop(context, true);
                },
                child: const Icon(Icons.arrow_back_ios_rounded)),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CustomButton(
              title: "Add Address",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddressMapScreen()));
              },
              color: Colors.white,
              textColor: primaryColor,
              border: Border.all(color: primaryColor, width: 2),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: true,
                  onRefresh: refresh,
                  onLoading: loadMore,
                  controller: controller,
                  header: const CustomPaginationHeader(),
                  footer: const RefreshFooter(),
                  physics: const BouncingScrollPhysics(),
                  child: savedAddressList.when(
                      data: (List<AddressModel> data) => data.isEmpty
                          ? Center(
                              child: CustomText(
                                  text: "No Saved Addresses Yet",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.only(bottom: 55),
                              itemBuilder: (_, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: InkWell(
                                  onTap: () async {
                                    await setDefaultAddress(data[index]);
                                  },
                                  child: AddressCard(
                                    isDefault: data[index].id ==
                                        defaultAddressData.value?.id,
                                    addressModel: data[index],
                                    delete: (int id) async {
                                      final confirm =
                                          await showDeleteAddressDialog(
                                              context: context);
                                      if (!confirm) return;
                                      final future = ref
                                          .read(savedAddressProvider.notifier)
                                          .deleteAddress(id);
                                      if (!context.mounted) return;
                                      try {
                                        await LoadingDialog.show(
                                            context, future);
                                        if (!context.mounted) return;
                                        if (mounted) {
                                          CustomSnackBar.success(context,
                                              "Address deleted successfully");
                                        }
                                      } catch (e) {
                                        if (!context.mounted) return;
                                        CustomSnackBar.error(context,
                                            tr('default_address_delete_error'));
                                      }
                                    },
                                    onEdit:
                                        (AddressModel selectedAddressModel) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddressMapScreen(
                                            selectedAddressModel:
                                                selectedAddressModel,
                                            isEdit: true,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 2,
                              ),
                              itemCount: data.length,
                            ),
                      error: (error, stackTrace) => Center(
                            child: GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppConfig.isProduction
                                          ? "Something went wrong".tr()
                                          : "$error".tr(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    kHeight5,
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      loading: () => Center(
                              child: CircularProgressIndicator.adaptive(
                            backgroundColor: Platform.isIOS
                                ? mediumGreenColor
                                : Colors.transparent,
                            valueColor:
                                const AlwaysStoppedAnimation(mediumGreenColor),
                          ))),
                ),
        ));
  }
}

RegExp regExp = RegExp(r'(\d{2})(\d{3})(\d+)');

class AddressCard extends StatelessWidget {
  final AddressModel addressModel;
  final Function(int) delete;
  final Function(AddressModel) onEdit;
  final bool isDefault;
  const AddressCard(
      {super.key,
      this.isDefault = false,
      required this.addressModel,
      required this.delete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/profile/map.svg',
                width: 19,
                height: 19,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                text: (addressModel.label ?? '').capitalFirstLetter,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              const SizedBox(
                width: 10,
              ),
              isDefault
                  ? Container(
                      width: 64,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        text: 'Default',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox.shrink(),
              const Spacer(),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                  onPressed: () {
                    delete(addressModel.id!);
                  },
                  child: CustomText(
                    text: 'Delete',
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                  onPressed: () {
                    onEdit(addressModel);
                  },
                  child: CustomText(
                    text: 'Edit',
                    color: const Color(0xFF818181),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(2),
            },
            children: [
              addressTableRow(
                  title: "Name",
                  description:
                      "${addressModel.firstName} ${addressModel.lastName}"),
              addressTableRow(
                  title: "Address", description: addressModel.address ?? ''),
              PhoneNumberTableRow(
                  title: "Mobile Number",
                  context: context,
                  description:
                      "${addressModel.countryCode ?? ""} ${addressModel.phoneNumber == null ? "" : addressModel.phoneNumber?.replaceAllMapped(regExp, (Match m) => "${m[1]} ${m[2]} ${m[3]}")}"),
            ],
          ),
        ),
      ],
    );
  }
}

extension on String {
  String get capitalFirstLetter =>
      "${substring(0, 1).toUpperCase()}${substring(1)}";
}

TableRow addressTableRow({required String title, required String description}) {
  return TableRow(
    children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title.tr(),
              style: const TextStyle(
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          description,
          style: const TextStyle(
            color: Color(0xFF505050),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      )),
    ],
  );
}

TableRow PhoneNumberTableRow(
    {required String title,
    required String description,
    required BuildContext context}) {
  final isRtl = Directionality.of(context) == ui.TextDirection.rtl;

  return TableRow(
    children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title.tr(),
              style: const TextStyle(
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
          )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          description,
          textAlign: isRtl ? TextAlign.end : TextAlign.start,
          textDirection: ui.TextDirection.ltr,
          style: const TextStyle(
            color: Color(0xFF505050),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      )),
    ],
  );
}
