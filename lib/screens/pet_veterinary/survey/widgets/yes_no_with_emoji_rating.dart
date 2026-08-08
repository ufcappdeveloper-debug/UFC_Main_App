import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/emoji_rating_widget.dart';
import 'package:ufc_mobile/screens/pet_veterinary/survey/widgets/selectable_check_box_tile.dart';

class YesNoWithEmojiRating extends StatelessWidget {
  final bool isYesSelected;
  final bool isNoSelected;
  final VoidCallback onYesTap;
  final VoidCallback onNoTap;

  const YesNoWithEmojiRating({
    super.key,
    required this.isYesSelected,
    required this.isNoSelected,
    required this.onYesTap,
    required this.onNoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: SelectableCheckboxTile(
                    label: 'Yes',
                    isSelected: isYesSelected,
                    onTap: onYesTap,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: SelectableCheckboxTile(
                    label: 'No',
                    isSelected: isNoSelected,
                    onTap: onNoTap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.95,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
              );
            },
            child: isYesSelected
                ? Column(
                    key: const ValueKey("emoji-section"),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'If yes, please rate the experience',
                          style:
                              PetVeterinaryFontstyles.poppinsRegularTextStyle13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(child: EmojiRatingWidget()),
                    ],
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }
}
