import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ufc_mobile/models/rating_model.dart';
import 'package:ufc_mobile/global/shared/constants/functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

ExpandableNotifier customerProductReview(BuildContext context,
    {required RatingModel ratingData}) {
  return ExpandableNotifier(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Theme(
        data: Theme.of(context).copyWith(
          highlightColor: Colors.transparent,
          splashColor: Colors.orange[200]!.withValues(alpha: 0.1),
        ),
        child: ExpandableButton(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange[200]!
                  .withValues(alpha: 0.1), //const Color(0xffFDFDFD),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CustomText(
                        text: hideUserName(ratingData.user?.name ?? "*"),
                        fontWeight: FontWeight.w500),
                    const Spacer(),
                    ratingData.createdAt == null ||
                            ratingData.createdAt!.isEmpty
                        ? const SizedBox()
                        : CustomText(
                            text: DateFormat('d MMM', 'en').format(
                                DateTime.parse(
                                    ratingData.createdAt.toString())),
                            fontSize: 10,
                            color: const Color(0xffA0A0A0))
                  ],
                ),
                const SizedBox(height: 2),
                if (ratingData.rating != null)
                  RatingBar.builder(
                    glow: false,
                    itemSize: 16,
                    minRating: 1,
                    itemCount: 5,
                    initialRating: ratingData.rating ?? 0.0,
                    ignoreGestures: true,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    unratedColor: Colors.transparent,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color(0xffF8E71C),
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                const SizedBox(height: 1),
                if (ratingData.review != null)
                  Expandable(
                    collapsed: CustomText(
                      text: ratingData.review ?? "",
                      maxLines: 1,
                      fontWeight: FontWeight.w300,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: CustomText(
                      text: ratingData.review ?? "",
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
