import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_mobile/riverpod/rating/rating_async_riverpod.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/constants/widgets.dart';
import 'package:ufc_mobile/global/shared/widgets/common_back_app_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/shared/widgets/loading/loading_dialog.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class AddReviewPage extends ConsumerStatefulWidget {
  const AddReviewPage({
    super.key,
    required this.productId,
  });
  final int productId;

  @override
  ConsumerState<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends ConsumerState<AddReviewPage>
    with ScreenEngagementTracker {
  double selectedRating = 2;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController ratingTextController = TextEditingController();

  @override
  void dispose() {
    ratingTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: CommonBackAppBar(
                title: "Add a review".tr(),
                boxShadow: const [appBarShadow],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 46),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Align(
                              alignment: (isArOrUr)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: CustomText(
                                text: "Rate us".tr(),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF838383),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.center,
                            child: RatingBar(
                              glow: false,
                              minRating: 1,
                              itemCount: 5,
                              initialRating: 2,
                              allowHalfRating: true,
                              direction: Axis.horizontal,
                              unratedColor: Colors.white,
                              itemPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      constraints.maxWidth < 300 ? 0.0 : 11.0),
                              ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star,
                                      color: Color(0xffF8E71C)),
                                  half: const Icon(Icons.star_half,
                                      color: Color(0xffF8E71C)),
                                  empty: const Icon(Icons.star_border,
                                      color: Color(0xffF8E71C))),
                              onRatingUpdate: (rating) {
                                selectedRating = rating;
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            ),
                          ),
                          const SizedBox(height: 27.44),
                          TextFormField(
                            minLines: 8,
                            maxLines: 8,
                            cursorColor: primaryColor,
                            controller: ratingTextController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "required".tr();
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Comment".tr(),
                              hintStyle: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                color: Color(0xFF838383),
                                fontWeight: FontWeight.w300,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFEBEBEB),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFEBEBEB),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 59),
                        child: CustomButton(
                          title: 'Post'.tr(),
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                FocusManager.instance.primaryFocus?.unfocus();

                                Map<String, dynamic> data = {
                                  "product_id": widget.productId,
                                  "rating": selectedRating,
                                  "review": ratingTextController.text,
                                };
                                final future = ref
                                    .read(ratingAsyncProvider.notifier)
                                    .addProductRating(data);
                                final bool result =
                                    await LoadingDialog.show(context, future);
                                if (result) {
                                  if (!context.mounted) return;
                                  CustomSnackBar.success(
                                      context, "Rating added successfully");
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                }
                              } catch (e) {
                                if (!context.mounted) return;
                                CustomSnackBar.error(context, e.toString());
                              }
                            }
                          },
                          radius: 10,
                          height: 42,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
