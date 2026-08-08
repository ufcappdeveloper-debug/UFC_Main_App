import 'package:flutter/material.dart';

class DragDownPop extends StatefulWidget {
  const DragDownPop({super.key, this.onDismiss, required this.child});
  final Widget child;
  final Function()? onDismiss;

  @override
  State<StatefulWidget> createState() => DragDownPopState();
}

class DragDownPopState extends State<DragDownPop> {
  final ValueNotifier<Offset> _offsetNotifier = ValueNotifier<Offset>(
    Offset.zero,
  );
  double _startY = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: widget.onDismiss == null
          ? null
          : (details) {
              _startY =
                  details.localPosition.dy; // Store the initial touch position
            },
      onVerticalDragUpdate: widget.onDismiss == null
          ? null
          : (details) {
              double delta = details.localPosition.dy - _startY;
              if (delta > 0) {
                _offsetNotifier.value = Offset(
                  0,
                  delta,
                ); // Update the offset as the user drags
              }
            },
      onVerticalDragEnd: widget.onDismiss == null
          ? null
          : (details) {
              if (_offsetNotifier.value.dy > 100) {
                widget.onDismiss
                    ?.call(); // If drag is greater than threshold, dismiss
              } else {
                _offsetNotifier.value =
                    Offset.zero; // Otherwise, reset position
              }
            },
      child: ValueListenableBuilder<Offset>(
        valueListenable: _offsetNotifier,
        builder: (context, offset, child) {
          return Transform.translate(offset: offset, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
