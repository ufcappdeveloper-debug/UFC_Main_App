import 'package:flutter/material.dart';
import 'package:ufc_mobile/main.dart';
import 'package:ufc_mobile/models/banner_model.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_cached_image.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';

class BannerDialog extends StatefulWidget {
  final BannerModel? banner;
  const BannerDialog({super.key, this.banner});

  @override
  _BannerDialogState createState() => _BannerDialogState();
}

class _BannerDialogState extends State<BannerDialog> {
  @override
  void initState() {
    Future(() async {
      await preferences.setBool('banner', true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(8),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ))),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.banner?.mainHeading ?? "",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      CustomText(
                        text: widget.banner?.subHeading ?? "",
                        fontSize: 14,
                        maxLines: 3,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CustomCachedImage(
                    imageUrl: widget.banner?.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomCachedImage(
                  imageUrl: widget.banner?.imageUrl ?? "",
                  fit: BoxFit.contain,
                ))
          ],
        ),
      ),
    );
  }
}
