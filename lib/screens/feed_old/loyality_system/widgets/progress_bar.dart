import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_colors.dart';
import 'package:ufc_mobile/screens/feed_old/loyality_system/extensions/loyality_points_fontstyles.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';

class ProgressBar extends StatefulWidget {
  final double progress;
  final double barHeight;
  final double pointerSize;
  final double pointerPositionHelper;
  final bool isInLoyalityScreen;
  final int currentPoints;
  final int tierMinPoints;

  const ProgressBar({
    super.key,
    required this.progress,
    this.barHeight = 7.0,
    this.pointerSize = 15.0,
    this.pointerPositionHelper = ((32 * 2) + 15),
    this.isInLoyalityScreen = true,
    this.currentPoints = 0,
    this.tierMinPoints = 0,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<int> _pointsAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _progressAnimation =
        Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _pointsAnimation = IntTween(
      begin: widget.tierMinPoints,
      end: widget.currentPoints,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimation(
        widget.progress, widget.tierMinPoints, widget.currentPoints);
  }

  @override
  void didUpdateWidget(covariant ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress ||
        oldWidget.currentPoints != widget.currentPoints ||
        oldWidget.tierMinPoints != widget.tierMinPoints) {
      _startAnimation(
        widget.progress,
        widget.tierMinPoints,
        widget.currentPoints,
      );
    }
  }

  void _startAnimation(double newProgress, int minPoints, int maxPoints) {
    _progressAnimation = Tween<double>(
      begin: _previousProgress,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pointsAnimation = IntTween(
      begin: minPoints,
      end: maxPoints,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _previousProgress = newProgress;
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRTL = isArabic;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            Padding(
              padding: isRTL
                  ? EdgeInsets.only(
                      left: widget.isInLoyalityScreen ? 10.5 : 7.5)
                  : EdgeInsets.only(
                      right: widget.isInLoyalityScreen ? 10.5 : 7.5),
              child: Container(
                height: widget.barHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[300],
                ),
              ),
            ),
            Padding(
              padding: isRTL
                  ? EdgeInsets.only(left: widget.isInLoyalityScreen ? 15 : 10.5)
                  : EdgeInsets.only(
                      right: widget.isInLoyalityScreen ? 15 : 10.5),
              child: ClipRect(
                child: Align(
                  alignment:
                      isRTL ? Alignment.centerRight : Alignment.centerLeft,
                  widthFactor: _progressAnimation.value,
                  child: Container(
                    height: widget.barHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(120, 184, 51, 1),
                          Color.fromRGBO(139, 245, 25, 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!widget.isInLoyalityScreen)
              Positioned(
                bottom: widget.pointerSize + 3,
                left: isRTL
                    ? null
                    : ((MediaQuery.of(context).size.width) -
                                widget.pointerPositionHelper) *
                            _progressAnimation.value -
                        ((widget.pointerSize / 2) + 14),
                right: isRTL
                    ? ((MediaQuery.of(context).size.width) -
                                widget.pointerPositionHelper) *
                            _progressAnimation.value -
                        ((widget.pointerSize / 2) + 14)
                    : null,
                child: Text(
                  '${NumberFormat.decimalPattern('en').format(_pointsAnimation.value)} ${'Points'.tr()}',
                  style: LoyalityPointsFontstyles.lpTierDescTextStyle.copyWith(
                    color: LoyalityPointsColors.lpCurrentPointsTextColor,
                  ),
                ),
              ),
            Positioned(
              left: isRTL
                  ? null
                  : ((MediaQuery.of(context).size.width) -
                              widget.pointerPositionHelper) *
                          _progressAnimation.value -
                      (widget.pointerSize / 2),
              right: isRTL
                  ? ((MediaQuery.of(context).size.width) -
                              widget.pointerPositionHelper) *
                          _progressAnimation.value -
                      (widget.pointerSize / 2)
                  : null,
              child: Container(
                height: widget.pointerSize,
                width: widget.pointerSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/loyality_points/Ellipse.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              // right: 0,
              right: isRTL ? null : 0,
              left: isRTL ? 0 : null,
              child: Container(
                height: 21,
                width: 21,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/loyality_points/Polygon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
