import 'package:flutter/material.dart';

class LogoAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final IconData? icon;

  const LogoAvatar({
    super.key,
    this.size = 120,
    this.imageUrl,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: imageUrl != null
          ? ClipOval(
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultIcon(theme);
          },
        ),
      )
          : _buildDefaultIcon(theme),
    );
  }

  Widget _buildDefaultIcon(ThemeData theme) {
    return Icon(
      icon ?? Icons.person_outline,
      size: size * 0.5,
      color: theme.colorScheme.onSecondaryContainer,
    );
  }
}