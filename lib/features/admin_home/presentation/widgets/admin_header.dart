import 'package:flutter/material.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          'Bienestar Integral',
          style: textTheme.headlineSmall?.copyWith(
            color: colors.onPrimary,
          ),
        ),
      ),
    );
  }
}