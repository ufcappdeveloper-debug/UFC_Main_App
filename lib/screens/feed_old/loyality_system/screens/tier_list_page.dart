import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/model/user_tier_model.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/service/provider/user_tier.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class TierListPage extends ConsumerStatefulWidget {
  const TierListPage({super.key});

  @override
  ConsumerState<TierListPage> createState() => _TierListPageState();
}

class _TierListPageState extends ConsumerState<TierListPage>
    with ScreenEngagementTracker {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(userTierProvider.notifier).fetchUserTierList();
    });
  }

  Future<void> _onRefresh() async {
    // Trigger the fetch again when the page is refreshed
    await ref.read(userTierProvider.notifier).fetchUserTierList();
  }

  List<double> getAllTierProgress({
    required List<Tier> tiers,
    required int currentTierIndex,
    required int userPoints,
  }) {
    return tiers.asMap().entries.map((entry) {
      int index = entry.key;
      Tier tier = entry.value;
      return getProgressForTier(
        tier: tier,
        userPoints: userPoints,
        currentTierIndex: currentTierIndex,
        tierIndex: index,
      );
    }).toList();
  }

  double getProgressForTier({
    required Tier tier,
    required int userPoints,
    required int currentTierIndex,
    required int tierIndex,
  }) {
    if (tierIndex < currentTierIndex) {
      return 1.0; // Full progress for tiers before the current one
    } else if (tierIndex == currentTierIndex) {
      // Calculate progress for the current tier
      int minPoints = tier.minPoints ?? 0; // Default to 0 if null
      int maxPoints = tier.maxPoints ?? 1;
      double progress = (userPoints - minPoints) / (maxPoints - minPoints);
      return progress.clamp(0.0, 1.0); // Ensure progress stays between 0 and 1
    } else {
      return 0.0; // No progress for tiers after the current one
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = isArabic;
    final userTier = ref.watch(userTierProvider).asData?.value;
    final currentPoints =
        userTier?.data?.userPoints ?? 0; // Defaults to 0 if null
    final tiers = userTier?.data?.tiers;

    final List<IconData> tierIcons = [
      MaterialCommunityIcons.check_circle_outline,
      MaterialCommunityIcons.circle_outline,
      MaterialCommunityIcons.square_rounded_outline,
      MaterialCommunityIcons.hexagon_outline,
      // Add more icons if needed
    ];

    final progressList = getAllTierProgress(
      tiers: tiers ?? [], // Ensure tiers is not null
      currentTierIndex:
          userTier?.data?.currentTierIndex ?? 0, // Default to 0 if null
      userPoints: userTier?.data?.userPoints ?? 0, // Default to 0 if null
    );

    const double barWidth = 7.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tier List'.tr(),
          style: TextStyle(
              fontSize: 15, color: LoyalityPointsColors.lpMainTitleTextColor),
        ),
        backgroundColor: LoyalityPointsColors.lpBgColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${NumberFormat.decimalPattern('en').format(currentPoints)} ${'Points'.tr()}',
                  style: LoyalityPointsFontstyles.lpCurrentPointsTextStyle
                      .copyWith(
                          color: LoyalityPointsColors.lpCurrentPointsTextColor),
                ),
                Text(
                  'Current Points'.tr(),
                  style: LoyalityPointsFontstyles.lpSubHeadingTextStyle
                      .copyWith(
                          color: LoyalityPointsColors.lpSubHeadingTextColor),
                ),
                const SizedBox(height: 40),
                ...?tiers?.asMap().entries.map((entry) {
                  int index = entry.key; // Get the index of the current tier
                  final tier = entry.value;
                  double progress = progressList[index];
                  return Column(
                    children: [
                      _buildVerticalProgressBar(
                          context,
                          progress,
                          barWidth,
                          tier.name ?? 'Tier',
                          tier.description ?? '',
                          tierIcons[index % tierIcons.length],
                          // tier.minPoints.toString(),
                          NumberFormat.decimalPattern('en')
                              .format(tier.minPoints)
                              .toString(),
                          isRTL,
                          isActive: progress > 0),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          )),
    );
  }

  Widget _buildVerticalProgressBar(
    BuildContext context,
    double progress,
    double barWidth,
    String heading,
    String description,
    IconData icon,
    String leftText,
    bool isRTL, {
    bool isActive = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left-side text
        Column(children: [
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 46, // Fixed width for alignment of icons
            child: Text(
              leftText,
              style: LoyalityPointsFontstyles.lpTierPointsScaleTextStyle
                  .copyWith(
                      color:
                          LoyalityPointsColors.lpTierNumberDisabledTextColor),
              textAlign: TextAlign.right, // Align text to the right for spacing
            ),
          ),
        ]),
        const SizedBox(width: 8), // Space between text and icon

        // Icon and Progress Bar
        Column(
          children: [
            Icon(
              icon,
              color: isActive
                  ? LoyalityPointsColors.lpTierMessageBoxBgColor
                  : Colors.grey,
              size: 22, // Icon size
            ),
            const SizedBox(height: 10), // Space between icon and bar
            // Vertical Progress Bar
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // Progress Bar Background
                Container(
                  width: barWidth,
                  height: 92, // Total height of the progress bar
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[300],
                  ),
                ),
                // Progress Bar Foreground
                Container(
                  width: barWidth,
                  height: 92 * progress, // Adjusted height based on progress
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(120, 184, 51, 1), // Start color
                        Color.fromRGBO(139, 245, 25, 1), // End color
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 20),

        Expanded(
            // child:
            // Padding(
            //   padding: const EdgeInsets.only(top: 5.0), // Slight top padding for alignment
            child: Align(
          alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // The message box

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? LoyalityPointsColors.lpTierMessageBoxBgColor
                      : Colors.white, // Message box color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                ),
                // child: Text(
                //   message,
                //   style: TextStyle(fontSize: 14, color: Colors.black),
                //   textAlign: TextAlign.left,
                // ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading (first line)
                    Text(heading,
                        style: LoyalityPointsFontstyles.lpTierNumberTextStyle
                            .copyWith(
                                color: isActive
                                    ? LoyalityPointsColors.lpMainTitleTextColor
                                    : LoyalityPointsColors
                                        .lpTierNumberDisabledTextColor)),
                    // SizedBox(height: 4), // Space between heading and description
                    // Description (second line)
                    Text(description,
                        style: LoyalityPointsFontstyles.lpTierDescTextStyle
                            .copyWith(
                                color: isActive
                                    ? LoyalityPointsColors.lpMainTitleTextColor
                                    : LoyalityPointsColors
                                        .lpTierNumberDisabledTextColor)),
                  ],
                ),
              ),

              // Positioned(
              //   // left: -12,
              //   left: isRTL ? null : -12,
              //   right: isRTL ? -12 : null,
              //   top: 18,
              //   child: CustomPaint(
              //     size: const Size(20, 20), // Size of the triangle
              //     painter: RoundedTrianglePainter(
              //       color: isActive
              //           ? LoyalityPointsColors.lpTierMessageBoxBgColor
              //           : Colors.white,
              //     ),
              //   ),
              // )
              Positioned(
                left: isRTL ? null : -12,
                right: isRTL ? -12 : null,
                top: 18,
                child: Transform(
                  alignment: Alignment.center,
                  transform: isRTL
                      ? Matrix4.rotationY(math.pi) // Flip horizontally for RTL
                      : Matrix4.identity(), // No flip for LTR
                  child: CustomPaint(
                    size: const Size(20, 20), // Size of the triangle
                    painter: RoundedTrianglePainter(
                      color: isActive
                          ? LoyalityPointsColors.lpTierMessageBoxBgColor
                          : Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
            // ),
            ),

        const SizedBox(
          height: 60,
        )
      ],
    );
  }
}

class RoundedTrianglePainter extends CustomPainter {
  final Color color;

  RoundedTrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0.0 + radius, size.height - radius * 1.4);
    path.arcToPoint(Offset(0.0 + (radius * 2), size.height),
        radius: const Radius.circular(radius), clockwise: false);
    path.lineTo(size.width - radius * 2, size.height);
    path.arcToPoint(Offset(size.width - radius, size.height - radius * 1.4),
        radius: const Radius.circular(radius), clockwise: false);
    path.lineTo(size.width / 2 + radius, 0.0 + radius * 2);
    path.arcToPoint(Offset(size.width / 2 - radius, 0.0 + radius * 2),
        radius: const Radius.circular(radius * 1.1), clockwise: false);
    path.close();

    // Rotate the path 90 degrees counterclockwise to make it point left
    canvas.save();
    canvas.translate(
        size.width / 2, size.height / 2); // Move the origin to the center
    canvas
        .rotate(-math.pi / 2); // Rotate the path by 90 degrees counterclockwise
    canvas.translate(-size.width / 2,
        -size.height / 2); // Move the origin back to top-left corner

    // Draw the rotated path
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
