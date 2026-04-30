import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ChildAvatarWidget extends StatelessWidget {
  final String name;
  final String? riskLevel; // 'low', 'medium', 'high', or null
  final double radius;
  final String? imageUrl;

  const ChildAvatarWidget({
    super.key,
    required this.name,
    this.riskLevel,
    this.radius = 24.0,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.outlineVariant;
    if (riskLevel == 'low') borderColor = AppColors.riskLow;
    if (riskLevel == 'medium') borderColor = AppColors.riskMedium;
    if (riskLevel == 'high') borderColor = AppColors.riskHigh;

    String initials = '';
    if (name.isNotEmpty) {
      final parts = name.trim().split(' ');
      initials = parts.first[0].toUpperCase();
      if (parts.length > 1) {
        initials += parts.last[0].toUpperCase();
      }
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.0),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.surfaceContainerHigh,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: imageUrl == null
            ? Text(
                initials,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.8,
                ),
              )
            : null,
      ),
    );
  }
}
