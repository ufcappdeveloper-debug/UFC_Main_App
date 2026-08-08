import 'package:flutter/foundation.dart';

int calculateRemainingPoints(int userPoints, int tierMaxPoints) {
  return (tierMaxPoints - userPoints).clamp(0, tierMaxPoints);
}

double calculateUserPointsPercentage(
  int userPoints,
  int tierMinPoints,
  int tierMaxPoints,
) {
  // Ensure valid range
  if (tierMinPoints >= tierMaxPoints) {
    debugPrint(
        'Invalid tier range: tierMinPoints=$tierMinPoints, tierMaxPoints=$tierMaxPoints');
    return 0.0; // Return 0 progress for invalid ranges
  }

  final effectiveUserPoints = userPoints.clamp(tierMinPoints, tierMaxPoints);

  final totalTierRange = tierMaxPoints - tierMinPoints;

  return (effectiveUserPoints - tierMinPoints) / totalTierRange;
}
