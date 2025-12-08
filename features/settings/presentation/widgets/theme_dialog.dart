import 'package:bienestar_integral_app/core/application/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AlertDialog(
      title: const Text('Elegir tema'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRadioOption(
            context,
            title: 'Sistema',
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (v) => themeProvider.setTheme(v!),
          ),
          _buildRadioOption(
            context,
            title: 'Claro',
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (v) => themeProvider.setTheme(v!),
          ),
          _buildRadioOption(
            context,
            title: 'Oscuro',
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (v) => themeProvider.setTheme(v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget _buildRadioOption(
      BuildContext context, {
        required String title,
        required ThemeMode value,
        required ThemeMode groupValue,
        required ValueChanged<ThemeMode?> onChanged,
      }) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}