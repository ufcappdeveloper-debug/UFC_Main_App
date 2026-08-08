import 'package:flutter/material.dart';

class PetVeterinaryShadows {
  static final List<BoxShadow> standard = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      spreadRadius: 0.5,
      offset: const Offset(0, 0),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      spreadRadius: 1,
      offset: const Offset(0, 0),
    ),
  ];

  static final List<BoxShadow> standardLight = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 6,
      spreadRadius: 0.2,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 10,
      spreadRadius: 0.4,
      offset: const Offset(0, 3),
    ),
  ];

  static final List<BoxShadow> light = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

    static final List<BoxShadow> standard2 = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      spreadRadius: 0.5,
      offset: const Offset(0, 2), // matches your first offset
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      spreadRadius: 1,
      offset: const Offset(0, 4), // matches your second offset
    ),
  ];
}
