import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final Map<String, bool> selectedDays;
  final Function(String) onDayToggle;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onDayToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final days = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        final day = days[index];
        final isSelected = selectedDays[day] ?? false;

        return GestureDetector(
          onTap: () => onDayToggle(day),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : Colors.transparent,
              border: Border.all(
                // CAMBIO: Se usan colores del tema.
                color: isSelected ? colors.primary : colors.outline, // ANTES: Colors.grey.shade400
                width: 1.5,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day,
                style: theme.textTheme.labelLarge?.copyWith(
                  // CAMBIO: Se usan colores del tema.
                  color: isSelected ? colors.onPrimary : colors.onSurfaceVariant, // ANTES: Colors.grey.shade600
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}