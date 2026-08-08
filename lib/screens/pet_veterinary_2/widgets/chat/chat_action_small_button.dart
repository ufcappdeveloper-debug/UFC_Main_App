import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class ChatActionSmallButton extends StatelessWidget {
  const ChatActionSmallButton({
    super.key,
    this.borderRadius,
    required this.icon,
    this.buttonKey,
    this.isLoading = false,
    required this.onPressed,
  });

  final String icon;
  final bool isLoading;
  final VoidCallback onPressed;
  final BorderRadius? borderRadius;
  final GlobalKey? buttonKey;

  @override
  Widget build(BuildContext context) {
    bool isSvg = icon.endsWith('.svg');
    bool isPng = icon.endsWith('.png');

    return Container(
      key: buttonKey,
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: PetVeterinaryColors.customLightBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          splashColor: Colors.grey.withOpacity(0.11),
          highlightColor: Colors.grey.withOpacity(0.11),
          borderRadius: borderRadius ?? BorderRadius.circular(5),
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator()
                : isSvg
                    ? SvgPicture.asset(
                        icon,
                        width: 12,
                        height: 12,
                      )
                    : isPng
                        ? Image.asset(
                            icon,
                            width: 12,
                            height: 12,
                          )
                        : Container(),
          ),
        ),
      ),
    );
  }
}
