import 'package:flutter/material.dart';

class VolunteerItemCard extends StatelessWidget {
  final String name;
  final double reputation;
  final String? avatarUrl;
  final VoidCallback onViewProfile;
  final VoidCallback onAssignRole;

  const VolunteerItemCard({
    super.key,
    required this.name,
    required this.reputation,
    this.avatarUrl,
    required this.onViewProfile,
    required this.onAssignRole,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: colors.secondaryContainer,
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: textTheme.titleLarge?.copyWith(color: colors.onSecondaryContainer),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Reputación:', style: textTheme.bodySmall),
                      const SizedBox(width: 4),
                      Icon(Icons.star, size: 16, color: colors.primary),
                      const SizedBox(width: 2),
                      Text(reputation.toStringAsFixed(1), style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                _buildSmallButton('Ver perfil', onViewProfile, context),
                const SizedBox(height: 6),
                _buildSmallButton('Asignar cargo', onAssignRole, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallButton(String text, VoidCallback onPressed, BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: Theme.of(context).textTheme.labelSmall,
      ),
      child: Text(text),
    );
  }
}