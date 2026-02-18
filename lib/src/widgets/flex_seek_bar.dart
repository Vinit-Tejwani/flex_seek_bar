import 'package:flutter/material.dart';
import '../controller/seek_bar_controller.dart';
import '../models/seek_bar_style.dart';
import '../models/seek_bar_type.dart';
import 'value_chip.dart';

/// A fully customisable linear seek bar that supports both **single** and
/// **range** slider modes.
///
/// For a circular seek bar use [CircularSeekBar] instead.
///
/// ## Basic usage
///
/// ```dart
/// // Single slider
/// FlexSeekBar(
///   type: SeekBarType.single,
///   minValue: 0,
///   maxValue: 100,
///   value: 40,
///   label: 'Speed',
///   unit: 'km/h',
///   onChanged: (v) => setState(() => _speed = v.start),
/// )
///
/// // Range slider
/// FlexSeekBar(
///   type: SeekBarType.range,
///   minValue: 0,
///   maxValue: 200,
///   value: 20,
///   maxRangeValue: 150,
///   label: 'Distance',
///   unit: 'km',
///   onChanged: (v) => setState(() { _lo = v.start; _hi = v.end; }),
/// )
/// ```
class FlexSeekBar extends StatefulWidget {
  // ── Type ─────────────────────────────────────────────────────────────────

  /// Whether this is a [SeekBarType.single] or [SeekBarType.range] slider.
  ///
  /// Use [CircularSeekBar] for [SeekBarType.circular].
  final SeekBarType type;

  // ── Range bounds ──────────────────────────────────────────────────────────

  /// The absolute minimum of the slider scale.
  final double minValue;

  /// The absolute maximum of the slider scale.
  final double maxValue;

  // ── Current values ────────────────────────────────────────────────────────

  /// For [SeekBarType.single]: the current thumb position.
  /// For [SeekBarType.range]: the *lower* thumb position.
  ///
  /// Ignored when a [controller] is provided.
  final double? value;

  /// For [SeekBarType.range]: the *upper* thumb position.
  ///
  /// Ignored when a [controller] is provided.
  final double? maxRangeValue;

  // ── Label / unit ──────────────────────────────────────────────────────────

  /// Optional label shown above the slider.
  final String? label;

  /// Unit appended to displayed values (e.g. `'km'`, `'%'`). Defaults to `''`.
  final String unit;

  // ── Callbacks ─────────────────────────────────────────────────────────────

  /// Called continuously while dragging.
  ///
  /// For [SeekBarType.single] only `values.start` is meaningful.
  final ValueChanged<RangeValues>? onChanged;

  /// Called once the user lifts their finger.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// Called when the user starts dragging.
  final ValueChanged<RangeValues>? onChangeStart;

  // ── Style / controller ────────────────────────────────────────────────────

  /// Visual customisation. All fields are optional.
  final SeekBarStyle style;

  /// Optional controller for programmatic access.
  final SeekBarController? controller;

  /// Number of discrete divisions. `null` = continuous.
  final int? divisions;

  /// Whether to display the floating tooltip while dragging.
  final bool showTooltip;

  const FlexSeekBar({
    super.key,
    this.type = SeekBarType.single,
    required this.minValue,
    required this.maxValue,
    this.value,
    this.maxRangeValue,
    this.label,
    this.unit = '',
    this.onChanged,
    this.onChangeEnd,
    this.onChangeStart,
    this.style = const SeekBarStyle(),
    this.controller,
    this.divisions,
    this.showTooltip = true,
  });

  @override
  State<FlexSeekBar> createState() => _FlexSeekBarState();
}

class _FlexSeekBarState extends State<FlexSeekBar> {
  late double _singleValue;
  late double _minRange;
  late double _maxRange;

  SeekBarController? get _ctrl => widget.controller;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    _ctrl?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(FlexSeekBar old) {
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
    _singleValue = (widget.value ?? widget.minValue).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _minRange = (widget.value ?? widget.minValue).clamp(
      widget.minValue,
      widget.maxValue,
    );
    _maxRange = (widget.maxRangeValue ?? widget.maxValue).clamp(
      widget.minValue,
      widget.maxValue,
    );
  }

  void _onControllerChanged() {
    setState(() {
      _singleValue = _ctrl!.value.clamp(widget.minValue, widget.maxValue);
      _minRange = _ctrl!.minRangeValue.clamp(widget.minValue, widget.maxValue);
      _maxRange = _ctrl!.maxRangeValue.clamp(widget.minValue, widget.maxValue);
    });
  }

  bool get _disabled => _ctrl?.disabled ?? false;

  void _handleSingleChange(double v) {
    setState(() => _singleValue = v);
    _ctrl?.setValue(v);
    widget.onChanged?.call(RangeValues(v, v));
  }

  void _handleRangeChange(RangeValues v) {
    setState(() {
      _minRange = v.start;
      _maxRange = v.end;
    });
    _ctrl?.setRange(v.start, v.end);
    widget.onChanged?.call(v);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.style.labelTextStyle ??
                Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
        ],
        if (widget.style.showValueChip) _buildChips(),
        _buildSlider(context),
      ],
    );
  }

  Widget _buildChips() {
    if (widget.type == SeekBarType.range) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueChip(value: _minRange, unit: widget.unit, style: widget.style),
            ValueChip(value: _maxRange, unit: widget.unit, style: widget.style),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ValueChip(
          value: _singleValue,
          unit: widget.unit,
          style: widget.style,
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    final theme = Theme.of(context);
    final active = widget.style.activeTrackColor ?? theme.colorScheme.primary;
    final inactive =
        widget.style.inactiveTrackColor ?? active.withValues(alpha: 0.25);
    final thumbR = widget.style.thumbRadius ?? 10.0;
    final overlayR = widget.style.overlayRadius ?? 20.0;

    final sliderTheme = SliderTheme.of(context).copyWith(
      trackHeight: widget.style.trackHeight ?? 4,
      activeTrackColor: _disabled ? inactive : active,
      inactiveTrackColor: inactive,
      thumbColor: _disabled ? inactive : (widget.style.thumbColor ?? active),
      overlayColor: (widget.style.overlayColor ?? active).withValues(
        alpha: 0.15,
      ),
      thumbShape: _CustomThumbShape(
        radius: thumbR,
        border: widget.style.thumbBorder,
        color: _disabled ? inactive : (widget.style.thumbColor ?? active),
      ),
      overlayShape: RoundSliderOverlayShape(overlayRadius: overlayR),
      rangeThumbShape: _CustomRangeThumbShape(
        radius: thumbR,
        border: widget.style.thumbBorder,
        color: _disabled ? inactive : (widget.style.thumbColor ?? active),
      ),
      valueIndicatorColor: widget.style.valueIndicatorColor ?? active,
      valueIndicatorTextStyle: (widget.style.valueIndicatorTextStyle ??
              const TextStyle(fontSize: 12))
          .copyWith(color: Colors.white),
      showValueIndicator: widget.showTooltip
          ? ShowValueIndicator.always
          : ShowValueIndicator.never,
    );

    if (widget.type == SeekBarType.range) {
      return SliderTheme(
        data: sliderTheme,
        child: RangeSlider(
          min: widget.minValue,
          max: widget.maxValue,
          values: RangeValues(_minRange, _maxRange),
          divisions: widget.divisions,
          onChanged: _disabled ? null : _handleRangeChange,
          onChangeEnd:
              widget.onChangeEnd == null ? null : (v) => widget.onChangeEnd!(v),
          onChangeStart: widget.onChangeStart == null
              ? null
              : (v) => widget.onChangeStart!(v),
          labels: RangeLabels(
            '${_minRange.round()} ${widget.unit}'.trim(),
            '${_maxRange.round()} ${widget.unit}'.trim(),
          ),
        ),
      );
    }

    // Single slider
    return SliderTheme(
      data: sliderTheme,
      child: Slider(
        min: widget.minValue,
        max: widget.maxValue,
        value: _singleValue,
        divisions: widget.divisions,
        onChanged: _disabled ? null : _handleSingleChange,
        onChangeEnd: widget.onChangeEnd == null
            ? null
            : (v) => widget.onChangeEnd!(RangeValues(v, v)),
        onChangeStart: widget.onChangeStart == null
            ? null
            : (v) => widget.onChangeStart!(RangeValues(v, v)),
        label: '${_singleValue.round()} ${widget.unit}'.trim(),
      ),
    );
  }
}

// ── Custom thumb shapes ───────────────────────────────────────────────────────

class _CustomThumbShape extends SliderComponentShape {
  final double radius;
  final BorderSide? border;
  final Color color;

  const _CustomThumbShape({
    required this.radius,
    required this.color,
    this.border,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final fillPaint = Paint()..color = color;
    canvas.drawCircle(center, radius, fillPaint);
    if (border != null) {
      final borderPaint = Paint()
        ..color = border!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = border!.width;
      canvas.drawCircle(center, radius, borderPaint);
    }
  }
}

class _CustomRangeThumbShape extends RangeSliderThumbShape {
  final double radius;
  final BorderSide? border;
  final Color color;

  const _CustomRangeThumbShape({
    required this.radius,
    required this.color,
    this.border,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final canvas = context.canvas;
    final fillPaint = Paint()
      ..color = isEnabled ? color : color.withValues(alpha: 0.5);
    canvas.drawCircle(center, radius, fillPaint);
    if (border != null) {
      final borderPaint = Paint()
        ..color = border!.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = border!.width;
      canvas.drawCircle(center, radius, borderPaint);
    }
  }
}
