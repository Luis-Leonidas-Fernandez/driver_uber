// lib/widgets/draggable_card.dart
import 'package:flutter/material.dart';

class DraggableCard extends StatefulWidget {
  final Widget child;
  final double startTopFactor; // por ejemplo 0.5 (50%)
  final double dragPercent; // cuánto puede bajar (ej: 0.5 = 50%)

  const DraggableCard({
    super.key,
    required this.child,
    this.startTopFactor = 0.53,
    this.dragPercent = 0.35,
  });

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  double offsetY = 0;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double initialTop = screenHeight * widget.startTopFactor;
    final double maxOffset = screenHeight * widget.dragPercent;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      top: initialTop + offsetY,
      left: 0,
      right: 0,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offsetY += details.delta.dy;
            if (offsetY > maxOffset) offsetY = maxOffset;
            if (offsetY < 0) offsetY = 0;
          });
        },
        onPanEnd: (_) {
          setState(() {
            if (offsetY > maxOffset / 2) {
              offsetY = maxOffset;
              isExpanded = true;
            } else {
              offsetY = 0;
              isExpanded = false;
            }
          });
        },
        child: widget.child,
      ),
    );
  }
}
