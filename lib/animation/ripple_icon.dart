import 'package:flutter/material.dart';


class RippleIcon extends StatefulWidget {
  final String iconPath;
  final double size;

  const RippleIcon({super.key, required this.iconPath, required this.size});

  @override
  State<RippleIcon> createState() => RippleIconState();
}

class RippleIconState extends State<RippleIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final scale = Tween(begin: 0.5, end: 2.0).evaluate(_controller);
        final opacity = Tween(begin: 0.4, end: 0.0).evaluate(_controller);

        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: opacity,
              child: Container(
                width: widget.size * scale,
                height: widget.size * scale,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Image.asset(
              widget.iconPath,
              width: widget.size,
              height: widget.size,
            ),
          ],
        );
      },
    );
  }
}

