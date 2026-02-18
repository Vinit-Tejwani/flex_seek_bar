import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../controller/seek_bar_controller.dart';
import '../models/seek_bar_style.dart';
import 'value_chip.dart';

/// A circular arc seek bar.
///
/// The arc spans from [startAngle] to [startAngle] + [sweepAngle] (in degrees).
/// By default it draws a 270° arc starting at the bottom-left (like a typical
/// volume knob).
///
/// ```dart
/// CircularSeekBar(
///   minValue: 0,
///   maxValue: 100,
///   value: 65,
///   unit: '%',
///   label: 'Volume',
///   onChanged: (v) => setState(() => _vol = v),
/// )
/// ```
class CircularSeekBar extends StatefulWidget {
  final double minValue;
  final double maxValue;

  /// Current value. Ignored when [controller] is provided.
  final double? value;

  /// Optional label drawn below the widget.
  final String? label;

  /// Unit appended to the centre text.
  final String unit;

  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  final SeekBarStyle style;
  final SeekBarController? controller;

  /// Start angle in degrees. 0 = right, 90 = bottom. Defaults to 135.
  final double startAngle;

  /// Total sweep in degrees. Defaults to 270.
  final double sweepAngle;

  /// Whether to show value in the centre of the circle.
  final bool showCenterValue;

  const CircularSeekBar({
    super.key,
    required this.minValue,
    required this.maxValue,
    this.value,
    this.label,
    this.unit = '',
    this.onChanged,
    this.onChangeEnd,
    this.style = const SeekBarStyle(),
    this.controller,
    this.startAngle = 135,
    this.sweepAngle = 270,
    this.showCenterValue = true,
  });

  @override
  State<CircularSeekBar> createState() => _CircularSeekBarState();
}

class _CircularSeekBarState extends State<CircularSeekBar> {
  late double _currentValue;

  SeekBarController? get _ctrl => widget.controller;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    _ctrl?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(CircularSeekBar old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (_ctrl == null) _syncFromProps();
  }

  @override
  void dispose() {
    _ctrl?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _syncFromProps() {
    _currentValue = (widget.value ?? widget.minValue).clamp(
      widget.minValue,
      widget.maxValue,
    );
  }

  void _onControllerChanged() {
    setState(() {
      _currentValue = _ctrl!.value.clamp(widget.minValue, widget.maxValue);
    });
  }

  bool get _disabled => _ctrl?.disabled ?? false;

  double get _fraction =>
      (_currentValue - widget.minValue) / (widget.maxValue - widget.minValue);

  void _updateFromGesture(Offset localPosition, Size size) {
    if (_disabled) return;
    final center = Offset(size.width / 2, size.height / 2);
    final angle = math.atan2(
      localPosition.dy - center.dy,
      localPosition.dx - center.dx,
    );
    final degrees = (angle * 180 / math.pi + 360) % 360;

    // Map degrees into the arc
    final start = widget.startAngle % 360;
    final sweep = widget.sweepAngle;
    double relative = (degrees - start + 360) % 360;
    if (relative > sweep) {
      relative = relative < sweep + (360 - sweep) / 2 ? sweep : 0;
    }
    final fraction = (relative / sweep).clamp(0.0, 1.0);
    final newValue =
        widget.minValue + fraction * (widget.maxValue - widget.minValue);
    setState(() => _currentValue = newValue);
    _ctrl?.setValue(newValue);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.style.circularSize ?? 200.0;
    final active =
        widget.style.circularActiveColor ??
        widget.style.activeTrackColor ??
        theme.colorScheme.primary;
    final inactive =
        widget.style.circularInactiveColor ??
        widget.style.inactiveTrackColor ??
        active.withValues(alpha: 0.2);
    final trackWidth = widget.style.circularTrackWidth ?? 12.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onPanDown: _disabled
              ? null
              : (d) => _updateFromGesture(d.localPosition, Size(size, size)),
          onPanUpdate: _disabled
              ? null
              : (d) => _updateFromGesture(d.localPosition, Size(size, size)),
          onPanEnd: _disabled
              ? null
              : (_) => widget.onChangeEnd?.call(_currentValue),
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _CircularPainter(
                fraction: _fraction,
                startAngle: widget.startAngle,
                sweepAngle: widget.sweepAngle,
                activeColor: _disabled ? inactive : active,
                inactiveColor: inactive,
                trackWidth: trackWidth,
                thumbColor: _disabled
                    ? inactive
                    : (widget.style.thumbColor ?? active),
                thumbRadius: widget.style.thumbRadius ?? 10,
              ),
              child: widget.showCenterValue
                  ? Center(
                      child: widget.style.showValueChip
                          ? ValueChip(
                              value: _currentValue,
                              unit: widget.unit,
                              style: widget.style,
                            )
                          : Text(
                              widget.unit.isEmpty
                                  ? _currentValue.round().toString()
                                  : '${_currentValue.round()} ${widget.unit}',
                              style:
                                  widget.style.circularCenterTextStyle ??
                                  TextStyle(
                                    fontSize: size * 0.12,
                                    fontWeight: FontWeight.bold,
                                    color: active,
                                  ),
                            ),
                    )
                  : null,
            ),
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.label!,
            style: widget.style.labelTextStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _CircularPainter extends CustomPainter {
  final double fraction;
  final double startAngle;
  final double sweepAngle;
  final Color activeColor;
  final Color inactiveColor;
  final double trackWidth;
  final Color thumbColor;
  final double thumbRadius;

  const _CircularPainter({
    required this.fraction,
    required this.startAngle,
    required this.sweepAngle,
    required this.activeColor,
    required this.inactiveColor,
    required this.trackWidth,
    required this.thumbColor,
    required this.thumbRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - trackWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startRad = startAngle * math.pi / 180;
    final sweepRad = sweepAngle * math.pi / 180;

    // Background arc
    final bgPaint = Paint()
      ..color = inactiveColor
      ..strokeWidth = trackWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startRad, sweepRad, false, bgPaint);

    // Active arc
    if (fraction > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..strokeWidth = trackWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, startRad, sweepRad * fraction, false, activePaint);
    }

    // Thumb
    final thumbAngle = startRad + sweepRad * fraction;
    final thumbPos = Offset(
      center.dx + radius * math.cos(thumbAngle),
      center.dy + radius * math.sin(thumbAngle),
    );
    final thumbPaint = Paint()..color = thumbColor;
    canvas.drawCircle(thumbPos, thumbRadius, thumbPaint);
    // White inner dot
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(thumbPos, thumbRadius * 0.4, innerPaint);
  }

  @override
  bool shouldRepaint(_CircularPainter old) =>
      old.fraction != fraction ||
      old.activeColor != activeColor ||
      old.inactiveColor != inactiveColor;
}
