import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AlleriskTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const AlleriskTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  State<AlleriskTextField> createState() => _AlleriskTextFieldState();
}

class _AlleriskTextFieldState extends State<AlleriskTextField> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseFillColor = isDark
        ? AppColors.surfaceContainerLowDark
        : AppColors.surfaceContainerLow;
        
    final focusedFillColor = AppColors.primary.withValues(alpha: 0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.xs),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: _focusNode.hasFocus ? focusedFillColor : baseFillColor,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.outline,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            border: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                topRight: Radius.circular(AppDimensions.radiusMd),
              ),
              borderSide: BorderSide.none,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                topRight: Radius.circular(AppDimensions.radiusMd),
              ),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                topRight: Radius.circular(AppDimensions.radiusMd),
              ),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusMd),
                topRight: Radius.circular(AppDimensions.radiusMd),
              ),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.md,
            ),
          ),
        ),
      ],
    );
  }
}
