import 'package:flutter/material.dart';

String truncateSpecialization(BuildContext context, String specialization) {
  final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

  final maxWords = isTablet ? 7 : 3;
  final words = specialization.split(' ');

  if (words.length > maxWords) {
    return '${words.sublist(0, maxWords).join(' ')}...';
  }
  return specialization;
}
