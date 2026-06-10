import 'package:flutter/material.dart';

class GlitchTransition extends StatefulWidget {
  final Widget child;
  final bool active;

  const GlitchTransition({
    super.key,
    required this.child,
    required this.active,
  });

  @override
  State<GlitchTransition> createState() => _GlitchTransitionState();
}

class _GlitchTransitionState extends State<GlitchTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void didUpdateWidget(covariant GlitchTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.active) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final offset = (_controller.value * 10) - 5;

        return Transform.translate(
          offset: Offset(offset, 0),
          child: Opacity(
            opacity: widget.active ? 0.85 : 1.0,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}