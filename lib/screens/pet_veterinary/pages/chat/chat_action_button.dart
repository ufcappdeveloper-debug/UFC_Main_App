import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

// class ChatActionbutton extends StatelessWidget {
//   const ChatActionbutton({
//     super.key,
//     this.borderRadius,
//     required this.icon,
//     required this.onPressed,
//   });
//   final String icon;
//   final VoidCallback onPressed;
//   final BorderRadius? borderRadius;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//         color: PetVeterinaryColors.customLightBackground,
//         borderRadius: borderRadius ?? BorderRadius.circular(6),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onPressed,
//           splashColor: Colors.grey.withValues(alpha: 0.11),
//           highlightColor: Colors.grey.withValues(alpha: 0.11),
//           borderRadius: borderRadius ?? BorderRadius.circular(5),
//           child: Center(child: SvgPicture.asset(icon, width: 15, height: 15)),
//         ),
//       ),
//     );
//   }
// }

class ChatActionButton extends StatelessWidget {
  const ChatActionButton({
    super.key,
    this.borderRadius,
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
  });

  final String icon;
  final bool isLoading;
  final VoidCallback onPressed;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    bool isSvg = icon.endsWith('.svg');
    bool isPng = icon.endsWith('.png');

    return Container(
      width: 33,
      height: 33,
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
                        width: 15,
                        height: 15,
                      )
                    : isPng
                        ? Image.asset(
                            icon,
                            width: 15,
                            height: 15,
                          )
                        : Container(),
          ),
        ),
      ),
    );
  }
}
