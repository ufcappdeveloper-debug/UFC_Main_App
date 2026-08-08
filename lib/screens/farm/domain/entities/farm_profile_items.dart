import 'package:flutter/widgets.dart';

class FarmProfileItems {
  final String icon;
  final String title;
  final List<FarmProfileChildItem> children;

  FarmProfileItems({
    required this.icon,
    required this.title,
    required this.children,
  });
}

class FarmProfileChildItem {
  final String? label;
  final String value;
  final bool needArrow;
  final bool isProfilePic;
  final TextEditingController? controller;
  final Color? color;
  final FocusNode? focusNode;
  final bool showEditIcon;
  bool isEditing;
  String? localImagePath;
  final Function(String path)? onImageSelected;

  FarmProfileChildItem({
    this.label,
    required this.value,
    this.needArrow = false,
    this.isProfilePic = false,
    this.controller,
    this.color,
    this.focusNode,
    this.showEditIcon = false,
    this.isEditing = false,
    this.onImageSelected,
    this.localImagePath,
  });
}
