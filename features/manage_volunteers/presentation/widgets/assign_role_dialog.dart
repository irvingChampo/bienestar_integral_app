import 'package:flutter/material.dart';

class AssignRoleDialog extends StatefulWidget {
  final String volunteerName;

  const AssignRoleDialog({
    super.key,
    required this.volunteerName,
  });

  @override
  State<AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends State<AssignRoleDialog> {
  String? _selectedRole;

  final List<String> _roles = [
    'Coordinador',
    'Voluntario extra',
    'Apoyo logístico',
    'Atención al público',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asignar cargo', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Para: ${widget.volunteerName}', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            ..._roles.map((role) => RadioListTile<String>(
              title: Text(role, style: theme.textTheme.bodyLarge),
              value: role,
              groupValue: _selectedRole,
              activeColor: theme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) => setState(() => _selectedRole = value),
            )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedRole != null ? () => Navigator.pop(context, _selectedRole) : null,
                  child: const Text('Asignar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}