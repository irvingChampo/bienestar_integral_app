import 'package:flutter/material.dart';

class AvailabilityDayCard extends StatelessWidget {
  final String dayName;
  final String dayInitial;
  final bool isSelected;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final ValueChanged<bool> onDaySelected;
  final ValueChanged<TimeOfDay?> onStartTimeChanged;
  final ValueChanged<TimeOfDay?> onEndTimeChanged;

  const AvailabilityDayCard({
    super.key,
    required this.dayName,
    required this.dayInitial,
    required this.isSelected,
    this.startTime,
    this.endTime,
    required this.onDaySelected,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final initialTime = (isStartTime ? startTime : endTime) ?? TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (pickedTime != null) {
      if (isStartTime) {
        onStartTimeChanged(pickedTime);
      } else {
        onEndTimeChanged(pickedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? colors.primary : colors.outline.withOpacity(0.3),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CheckboxListTile(
              title: Text(dayName, style: textTheme.titleMedium),
              value: isSelected,
              onChanged: (value) => onDaySelected(value ?? false),
              activeColor: colors.primary,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _TimePickerChip(
                        label: 'Inicio',
                        time: startTime,
                        onTap: () => _selectTime(context, true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TimePickerChip(
                        label: 'Fin',
                        time: endTime,
                        onTap: () => _selectTime(context, false),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerChip extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimePickerChip({required this.label, this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 16, color: colors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              time != null ? time!.format(context) : label,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}