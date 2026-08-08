import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class AddReviewDialog extends StatefulWidget {
  final int productId;
  final bool isEnglish;
  final void Function(int rating, String review)? onSubmit;

  const AddReviewDialog({
    super.key,
    required this.productId,
    required this.isEnglish,
    this.onSubmit,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  int selectedRating = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isEnglish = widget.isEnglish;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Close button and title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                Text(
                  isEnglish ? "Add Review" : "اضف تقييم",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                  ),
                ),
                const SizedBox(width: 24), // For alignment
              ],
            ),
            const SizedBox(height: 20),

            /// Star rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < selectedRating
                        ? PetVeterinaryColors.yellowBackground
                        : PetVeterinaryColors.newPetLightGray,
                    size: 23,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 24),

            /// Review input
            TextField(
              controller: _controller,
              maxLines: 3,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText:
                    isEnglish ? "Write your review..." : "اكتب تقييمك هنا...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 24),

            /// Submit button
            CustomButton(
              height: 50,
              width: MediaQuery.sizeOf(context).width,
              title: isEnglish ? "Submit" : "ارسال",
              onTap: () {
                final review = _controller.text.trim();
                if (selectedRating == 0 || review.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(isEnglish
                            ? "Please add rating and review"
                            : "يرجى إضافة التقييم والمراجعة")),
                  );
                  return;
                }

                // Send back values
                if (widget.onSubmit != null) {
                  widget.onSubmit!(selectedRating, review);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
