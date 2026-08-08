import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_fontstyles.dart';

class EmojiRatingWidget extends StatefulWidget {
  final double containerWidth;
  final double containerHeight;
  final List<Map<String, String>>? customEmojis;

  const EmojiRatingWidget({
    super.key,
    this.containerWidth = 60,
    this.containerHeight = 65,
    this.customEmojis,
  });

  @override
  State<EmojiRatingWidget> createState() => _EmojiRatingWidgetState();
}

class _EmojiRatingWidgetState extends State<EmojiRatingWidget> {
  int? selectedIndex;

  late final List<Map<String, String>> emojis;

  @override
  void initState() {
    super.initState();
    emojis = widget.customEmojis ??
        [
          {"emoji": "😠", "label": "Bad"},
          {"emoji": "😐", "label": "Okay"},
          {"emoji": "😊", "label": "Good"},
          {"emoji": "😁", "label": "Great"},
          {"emoji": "😍", "label": "Excellent"},
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(emojis.length, (index) {
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            width: widget.containerWidth,
            height: widget.containerHeight,
            padding:
                const EdgeInsets.only(left: 2, right: 2, top: 3, bottom: 3),
            decoration: BoxDecoration(
              color: PetVeterinaryColors.customGrayBackground3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? PetVeterinaryColors.borderLeftColor
                    : Colors.white,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emojis[index]["emoji"]!,
                  style: const TextStyle(fontSize: 18),
                ),
                // const SizedBox(height: 2),
                Text(
                  emojis[index]["label"]!,
                  style: PetVeterinaryFontstyles.kanitMediumTextStyle12_2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
