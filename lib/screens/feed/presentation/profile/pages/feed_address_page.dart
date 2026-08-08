import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/functions/is_network_error.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_reload_provider.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/no_internet.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_appbar.dart';

import '../../../../../global/shared/constants/app_colors.dart';
import '../../../../../global/shared/constants/constants.dart';
import '../../../../../global/shared/constants/custom_loading_dialog.dart';
import '../../../../../global/shared/widgets/custom_button.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import '../../../../../global/shared/widgets/custom_widgets/custom_text.dart';
import '../../../../feed_old/saved_address/widget/show_delete_address_dialog.dart';
import '../../../application/address/address_cubit.dart';
import '../../../application/address/address_state.dart';
import '../../../domain/entities/address/address_query_model.dart';
import 'feed_address_screen.dart';

class AddressScreen extends StatefulWidget {
  final int? currentDefaultAddressId;
  const AddressScreen({super.key, this.currentDefaultAddressId});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int? loadingDefaultAddressId;

  void callApi() {
    context
        .read<AddressCubit>()
        .fetchAddresses(AddressQueryParams(page: 1, limit: 10));
  }

  @override
  void initState() {
    super.initState();
    callApi();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        return Scaffold(
            appBar: CustomFarmAppBar(title: 'Address'),
            floatingActionButton: state is AddressError &&
                    isNetworkError(state.message)
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CustomButton(
                      fontFamily: isEnglish
                          ? AppFontsFamily.english
                          : AppFontsFamily.arabic,
                      title: "add_new_address".tr(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedAddressMapScreen()));
                      },
                      color: Color(0xFF78B943),
                      textColor: Colors.white,
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: state is AddressLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor))
                : state is AddressError
                    ? isNetworkError(state.message)
                        ? NoInternet(
                            type: AppType.feed,
                            onTap: () => callApi(),
                          )
                        : Center(
                            child: CustomReloadProviderV2(
                              error: state.message,
                              height: 120,
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              onPressed: () {
                                context.read<AddressCubit>().fetchAddresses(
                                    AddressQueryParams(page: 1, limit: 10));
                              },
                            ),
                          )
                    : state is AddressLoaded
                        ? isListEmpty(state.addresses)
                            ? Center(
                                child: CustomText(
                                text: "no_addresses",
                                fontSize: 16,
                                fontFamily: isEnglish
                                    ? AppFontsFamily.english
                                    : AppFontsFamily.arabic,
                              ))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.addresses?.length,
                                itemBuilder: (context, index) {
                                  final address = state.addresses?[index];
                                  final isDefault = address?.isDefault ?? false;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // top row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    size: 18,
                                                    color: Colors.green[700]),
                                                const SizedBox(width: 6),
                                                Text(
                                                  address?.label.tr() ??
                                                      "no_name".tr(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: isDefault ||
                                                      loadingDefaultAddressId ==
                                                          address?.id
                                                  ? null
                                                  : () async {
                                                      setState(() {
                                                        loadingDefaultAddressId =
                                                            address?.id;
                                                      });

                                                      try {
                                                        await context
                                                            .read<
                                                                AddressCubit>()
                                                            .setDefaultAddress(
                                                                address?.id ??
                                                                    0);

                                                        if (!context.mounted)
                                                          return;

                                                        CustomSnackBar.success(
                                                            context,
                                                            'address_set_default_success'
                                                                .tr());
                                                      } catch (e) {
                                                        if (!context.mounted)
                                                          return;
                                                        CustomSnackBar.error(
                                                            context,
                                                            'network_error_try_again'
                                                                .tr());
                                                      } finally {
                                                        if (!context.mounted)
                                                          return;
                                                        setState(() {
                                                          loadingDefaultAddressId =
                                                              null;
                                                        });
                                                      }
                                                    },
                                              child: Row(
                                                children: [
                                                  if (loadingDefaultAddressId ==
                                                      address?.id)
                                                    const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            Color(0xFF78B943),
                                                      ),
                                                    )
                                                  else
                                                    Icon(
                                                      isDefault
                                                          ? Icons.check_circle
                                                          : Icons
                                                              .radio_button_unchecked,
                                                      size: 18,
                                                      color: const Color(
                                                          0xFF78B943),
                                                    ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    isDefault
                                                        ? "default".tr()
                                                        : "make_default".tr(),
                                                    style: const TextStyle(
                                                      color: Color(0xFF78B943),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),

                                        const SizedBox(height: 8),
                                        Text(
                                          address?.address ?? "",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),

                                        // actions row
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FeedAddressMapScreen(
                                                      selectedAddressModel:
                                                          address, // ✅ pass current address
                                                      isEdit: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "edit".tr(),
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            if (!isDefault)
                                              GestureDetector(
                                                onTap: () async {
                                                  final confirm =
                                                      await showDeleteAddressDialog(
                                                          context: context);
                                                  if (!confirm) return;

                                                  // 2️⃣ Prepare deletion future
                                                  final future = context
                                                      .read<AddressCubit>()
                                                      .deleteAddress(
                                                          address?.id ?? 0);
                                                  try {
                                                    if (!context.mounted)
                                                      return;
                                                    await LoadingDialog.show(
                                                        context, future);

                                                    if (!context.mounted)
                                                      return;
                                                    CustomSnackBar.success(
                                                        context,
                                                        "Address deleted successfully");
                                                  } catch (e) {
                                                    if (!context.mounted)
                                                      return;
                                                    CustomSnackBar.error(
                                                        context,
                                                        tr('default_address_delete_error'));
                                                  }
                                                },
                                                child: Text(
                                                  "delete".tr(),
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              )
                        : const SizedBox.shrink());
      },
    );
  }
}
