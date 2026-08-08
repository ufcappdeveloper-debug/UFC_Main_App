import 'dart:ui';

import 'package:flutter/material.dart';

// Design For Frost Glass
class FrozenGlassContainer extends StatelessWidget {
  const FrozenGlassContainer({
    super.key,
    required this.icon,
  });
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1)),
              ],
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.white.withValues(alpha: 0.8),
                  Colors.white.withValues(alpha: 0.5),
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.4),
                  Colors.white.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
