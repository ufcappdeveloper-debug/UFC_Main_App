import 'package:flutter/material.dart';

class TemporarySplashScreen extends StatefulWidget {
  const TemporarySplashScreen({super.key});

  @override
  State<TemporarySplashScreen> createState() => _TemporarySplashScreenState();
}

class _TemporarySplashScreenState extends State<TemporarySplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    // Smooth fade-in effect (optional)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: const Scaffold(
        backgroundColor: Color(0xFFF4F8F0),
        body: SizedBox.expand(),
      ),
    );
  }
}
