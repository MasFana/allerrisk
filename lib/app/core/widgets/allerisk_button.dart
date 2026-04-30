import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_theme.dart';

class AlleriskButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const AlleriskButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppDimensions.radiusXl); // 24px

    if (isOutlined) {
      return Material(
        color: AppColors.surfaceContainerHigh,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius,
          child: Container(
            height: 52,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            alignment: Alignment.center,
            child: _buildContent(theme, isSecondary: true),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: (isLoading || onPressed == null)
            ? null
            : AppTheme.ctaGradient,
        color: (isLoading || onPressed == null)
            ? AppColors.surfaceContainerHighest
            : null,
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: borderRadius,
          child: Container(
            height: 52,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
            alignment: Alignment.center,
            child: _buildContent(theme, isSecondary: false),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, {required bool isSecondary}) {
    final textColor = isLoading || onPressed == null
        ? AppColors.onSurfaceVariant.withValues(alpha: 0.5)
        : (isSecondary ? AppColors.secondary : AppColors.onPrimary);

    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: textColor,
        ),
      );
    }

    final textStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      letterSpacing: 16 * 0.05,
      color: textColor,
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconMd, color: textColor),
          const SizedBox(width: AppDimensions.sm),
          Text(text.toUpperCase(), style: textStyle),
        ],
      );
    }

    return Text(
      text.toUpperCase(),
      style: textStyle,
    );
  }
}

