import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class ChatActionCircleButton extends StatelessWidget {
  const ChatActionCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String icon;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isSvg = icon.endsWith('.svg');
    final bool isPng = icon.endsWith('.png');

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: PetVeterinaryColors.newPetMainColorVeterinary,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withOpacity(0.15),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Center(
            child: isLoading
                ? const CupertinoActivityIndicator()
                : isSvg
                    ? SvgPicture.asset(
                        icon,
                        width: 16,
                        height: 16,
                        color:
                            Colors.white, // Set icon color if SVG supports it
                      )
                    : isPng
                        ? Image.asset(
                            icon,
                            width: 16,
                            height: 16,
                          )
                        : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
