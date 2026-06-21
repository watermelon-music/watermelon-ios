import 'package:flutter/material.dart';

import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_icon.dart';

/// A labeled auth input matching the design: an uppercase label above a
/// rounded `#1A1A1A` field with an optional leading icon, and (for passwords)
/// an eye toggle. Pre-filled to mirror the mockups; fully editable.
class AuthField extends StatefulWidget {
  final String label;
  final String? iconAsset;
  final String initialValue;

  /// Optional externally-owned controller. When provided, the parent owns the
  /// field's text (and its lifecycle); [initialValue] is ignored.
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const AuthField({
    super.key,
    required this.label,
    this.iconAsset,
    this.initialValue = '',
    this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  TextEditingController? _internal;
  TextEditingController get _controller =>
      widget.controller ?? (_internal ??= TextEditingController(text: widget.initialValue));
  late bool _obscured = widget.obscure;

  @override
  void dispose() {
    // Only dispose the controller we created; a parent-owned one is theirs.
    _internal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: AppType.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 9),
        Container(
          height: AppSize.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: AppDecoration.input,
          child: Row(
            children: [
              if (widget.iconAsset != null) ...[
                AppIcon(widget.iconAsset!, size: 18, color: AppColors.textTertiary),
                const SizedBox(width: 11),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  obscureText: _obscured,
                  enabled: widget.enabled,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  cursorColor: AppColors.primary,
                  style: AppType.body.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                  ),
                ),
              ),
              if (widget.obscure)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _obscured = !_obscured),
                  child: AppIcon(AppAssets.eye, size: 19, color: AppColors.textTertiary),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
