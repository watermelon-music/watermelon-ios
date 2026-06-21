import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// The app's primary CTA: a full-width red pill with the brand red glow.
/// (The red fill / pill shape come from the ElevatedButton theme.) Scales down
/// briefly while pressed for tactile feedback.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool glow;

  const PrimaryButton(this.label, {super.key, this.onPressed, this.glow = true});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  void _set(bool v) {
    if (widget.onPressed == null) return;
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    // A Listener sits above the button so it never absorbs the tap; it only
    // observes pointer up/down to drive the press scale.
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.curve,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: widget.glow ? AppShadow.primaryGlow : null,
          ),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
