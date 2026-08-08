import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/screens/feed/domain/entities/product/product_rating_model.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/extensions/pet_veterinary_fontstyles_2.dart';
import 'package:ufc_mobile/screens/pet_veterinary_2/components/utils/doctor_utils.dart';

class ReviewList extends StatefulWidget {
  final List<ReviewModel> reviews;
  final bool isFromProduct;
  const ReviewList(
      {super.key, required this.reviews, this.isFromProduct = false});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final reviews = widget.reviews;

    if (reviews.isEmpty) {
      return Text(
        'No reviews yet'.tr(),
        style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)
            .copyWith(color: PetVeterinaryColors.newPetDarkGray),
      );
    }

    if (!_expanded) {
      final showReviews = reviews.take(2).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildReviews(showReviews, widget.isFromProduct),
          if (reviews.length > 2) _toggleButton(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            child: ListView.separated(
              itemCount: reviews.length,
              separatorBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(
                    vertical: widget.isFromProduct ? 4 : 12),
                child: Divider(
                  color: widget.isFromProduct
                      ? Colors.transparent
                      : PetVeterinaryColors.lightGrayBackground,
                  thickness: widget.isFromProduct ? 0 : 1,
                ),
              ),
              itemBuilder: (context, index) {
                final review = reviews[index];

                String formattedDate = 'No date'.tr();
                if (review.createdAt != null) {
                  try {
                    DateTime utcDate =
                        DateTime.parse(review.createdAt!).toUtc();
                    DateTime localDate = utcDate.toLocal();

                    final locale = isEnglish ? 'en' : 'ar';
                    formattedDate =
                        DateFormat('dd MMM', locale).format(localDate);
                  } catch (_) {}
                }

                return _ReviewItem(
                  rating: review.rating?.toInt() ?? 0,
                  date: formattedDate,
                  text: DoctorUtils.getTranslatedReviewText(review.review),
                  reviewerName: review.user?.name,
                );
              },
            ),
          ),
          _toggleButton(),
        ],
      );
    }
  }

  List<Widget> _buildReviews(List<ReviewModel> reviews, bool isFromProduct) {
    return List.generate(reviews.length * 2 - 1, (index) {
      if (index.isEven) {
        final review = reviews[index ~/ 2];
        String formattedDate = 'No date'.tr();
        if (review.createdAt != null) {
          try {
            DateTime utcDate = DateTime.parse(review.createdAt!).toUtc();
            DateTime localDate = utcDate.toLocal();
            final locale = isEnglish ? 'en' : 'ar';
            formattedDate = DateFormat('dd MMM', locale).format(localDate);
          } catch (_) {}
        }

        return _ReviewItem(
          reviewerName: review.user?.name,
          rating: review.rating?.toInt() ?? 0,
          date: formattedDate,
          text: DoctorUtils.getTranslatedReviewText(review.review),
        );
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isFromProduct ? 4 : 12),
          child: Divider(
            color: isFromProduct
                ? Colors.transparent
                : PetVeterinaryColors.lightGrayBackground,
            thickness: isFromProduct ? 0 : 1,
          ),
        );
      }
    });
  }

  Widget _toggleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Text(
              _expanded ? "Show less".tr() : "Show more".tr(),
              style: PetVeterinaryFontstyles2.getRegularStyle(context, 12)
                  .copyWith(
                color: PetVeterinaryColors.newPetDarkGray,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
              color: PetVeterinaryColors.newPetDarkGray,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final int rating;
  final String date;
  final String text;
  final String? reviewerName;

  const _ReviewItem({
    required this.rating,
    required this.date,
    required this.text,
    this.reviewerName,
  });

  @override
  Widget build(BuildContext context) {
    final nameToShow = reviewerName?.isNotEmpty == true
        ? " - ${reviewerName!}"
        : " - ${'Unavailable'.tr()}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Rating and Date Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List.generate(
                rating,
                (index) => const Icon(
                  Icons.star,
                  color: PetVeterinaryColors.softYellow,
                  size: 14,
                ),
              ),
            ),
            Text(
              date,
              style: PetVeterinaryFontstyles2.getRegularStyle(context, 14)
                  .copyWith(color: PetVeterinaryColors.mediumGray),
            ),
          ],
        ),
        const SizedBox(height: 14),

        /// Review Text (with quotes)
        Text(
          '"$text"',
          style: PetVeterinaryFontstyles2.getRegularStyle(context, 14),
        ),
        const SizedBox(height: 6),

        /// Reviewer Name
        Text(nameToShow,
            style: PetVeterinaryFontstyles2.getRegularStyle(context, 13)),
      ],
    );
  }
}
