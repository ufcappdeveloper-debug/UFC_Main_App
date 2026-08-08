import 'package:flutter/material.dart';

enum PageTransitionType {
  slideRight,
  slideUp,
}

PageRouteBuilder createSmoothRoute(
  Widget page, {
  PageTransitionType type = PageTransitionType.slideRight,
}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (type) {
        case PageTransitionType.slideUp:
          final slideUp = Tween<Offset>(
            begin: const Offset(0, 1), // start from bottom
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          final fadeUp = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );
          return FadeTransition(
            opacity: fadeUp,
            child: SlideTransition(position: slideUp, child: child),
          );

        default:
          final slide = Tween<Offset>(
            begin: const Offset(0.05, 0), // original right slide
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );
          final fade = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
      }
    },
  );
}
