import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ufc_mobile/global/shared/constants/app_colors.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

enum OrderStatusEnum {
  pending,
  completed,
  cancelled,
}

extension OrderStatusEnumData on OrderStatusEnum {
  String get getValue {
    switch (this) {
      case OrderStatusEnum.pending:
        return "PENDING";
      case OrderStatusEnum.completed:
        return "COMPLETED";
      case OrderStatusEnum.cancelled:
        return "CANCELLED";
    }
  }

  Color get color {
    switch (this) {
      case OrderStatusEnum.pending:
        return PetVeterinaryColors.yellowColor;
      case OrderStatusEnum.completed:
        return PetVeterinaryColors.mainColorUFC;
      case OrderStatusEnum.cancelled:
        return redColor;
    }
  }
}
