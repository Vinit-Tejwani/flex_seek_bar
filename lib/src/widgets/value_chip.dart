import 'package:flutter/material.dart';
import '../models/seek_bar_style.dart';

/// A small pill-shaped chip that shows a formatted value + unit.
class ValueChip extends StatelessWidget {
  final double value;
  final String unit;
  final SeekBarStyle style;
  final bool roundValue;

  const ValueChip({
    super.key,
    required this.value,
    required this.unit,
    required this.style,
    this.roundValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = style.activeTrackColor ?? theme.colorScheme.primary;
    final chipBg = style.chipColor ?? activeColor.withValues(alpha: 0.12);
    final chipBorder =
        style.chipBorderColor ?? activeColor.withValues(alpha: 0.35);
    final radius = style.chipBorderRadius ?? 8.0;
    final displayed = roundValue
        ? value.round().toString()
        : value.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: chipBorder, width: 1),
      ),
      child: Text(
        unit.isEmpty ? displayed : '$displayed $unit',
        style:
            (style.chipTextStyle ??
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))
                .copyWith(
                  color: style.activeTrackColor ?? theme.colorScheme.primary,
                ),
      ),
    );
  }
}
