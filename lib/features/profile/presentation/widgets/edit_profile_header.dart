import 'package:flutter/material.dart';
class EditProfileHeader extends StatelessWidget {
  final VoidCallback onCameraPressed;
  final String? photoUrl;
  const EditProfileHeader({
    super.key,
    required this.onCameraPressed,
    this.photoUrl,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      color: theme.colorScheme.primary,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.onPrimary,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                child: photoUrl == null
                    ? Icon(
                  Icons.person,
                  size: 60,
                  color: theme.colorScheme.primary,
                )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onCameraPressed,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.primary)
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Editar perfil',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Actualiza tu información',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}