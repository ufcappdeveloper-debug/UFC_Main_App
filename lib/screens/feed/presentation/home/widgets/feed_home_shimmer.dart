import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ufc_mobile/global/util/common/screen_width_utils.dart';

class FeedShimmerPage extends StatelessWidget {
  const FeedShimmerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final isWide = ScreenWidthUtils.isWide(context);
    final isSmall = ScreenWidthUtils.isSmall(context);
    final isWideLess = ScreenWidthUtils.isWideLess(context);
    final isWideMore = ScreenWidthUtils.isWideMore(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ----- Horizontal Product List Shimmer -----
            SizedBox(
              height: screenHeight * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 160,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image placeholder
                          Container(
                            height: screenHeight *
                                (isWideMore
                                    ? 0.08
                                    : isSmall
                                        ? 0.07
                                        : 0.075),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Product title placeholder
                          Container(
                            height: 16,
                            width: 140,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 4),
                          // Product subtitle / price placeholder
                          Container(
                            height: 14,
                            width: 100,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          // Favorite button placeholder
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16), // Extra bottom padding
          ],
        ),
      ),
    );
  }
}
