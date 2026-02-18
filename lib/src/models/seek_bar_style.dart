import 'package:flutter/material.dart';

/// Controls every visual aspect of [FlexSeekBar].
///
/// All parameters are optional — unset values fall back to sensible defaults.
class SeekBarStyle {
  // ── Track ────────────────────────────────────────────────────────────────

  /// Height of the track (linear sliders). Defaults to 4.
  final double? trackHeight;

  /// Color of the "active" (filled) portion of the track.
  final Color? activeTrackColor;

  /// Color of the "inactive" (unfilled) portion of the track.
  final Color? inactiveTrackColor;

  // ── Thumb ────────────────────────────────────────────────────────────────

  /// Color of the slider thumb(s).
  final Color? thumbColor;

  /// Radius of the thumb circle. Defaults to 10.
  final double? thumbRadius;

  /// Optional border drawn around each thumb.
  final BorderSide? thumbBorder;

  // ── Overlay ──────────────────────────────────────────────────────────────

  /// Color of the pressed-state overlay behind the thumb.
  final Color? overlayColor;

  /// Radius of the pressed-state overlay. Defaults to 20.
  final double? overlayRadius;

  // ── Value Chip ───────────────────────────────────────────────────────────

  /// Whether to show the small chip(s) above the track displaying the value(s).
  /// Defaults to true.
  final bool showValueChip;

  /// Background color of the value chip.
  final Color? chipColor;

  /// Text style used inside value chip(s).
  final TextStyle? chipTextStyle;

  /// Border color of the value chip.
  final Color? chipBorderColor;

  /// Border radius of the value chip. Defaults to 8.
  final double? chipBorderRadius;

  // ── Value Indicator (popup) ───────────────────────────────────────────────

  /// Color of the tooltip that appears while dragging.
  final Color? valueIndicatorColor;

  /// Text style of the drag tooltip.
  final TextStyle? valueIndicatorTextStyle;

  // ── Label ────────────────────────────────────────────────────────────────

  /// Text style for the label above the seek bar.
  final TextStyle? labelTextStyle;

  // ── Circular-specific ────────────────────────────────────────────────────

  /// Width of the circular arc track. Defaults to 12.
  final double? circularTrackWidth;

  /// Color of the unfilled arc. Defaults to [inactiveTrackColor].
  final Color? circularInactiveColor;

  /// Color of the filled arc. Defaults to [activeTrackColor].
  final Color? circularActiveColor;

  /// Diameter of the circular slider widget. Defaults to 200.
  final double? circularSize;

  /// Text style for the centre value label inside the circle.
  final TextStyle? circularCenterTextStyle;

  const SeekBarStyle({
    this.trackHeight,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.thumbRadius,
    this.thumbBorder,
    this.overlayColor,
    this.overlayRadius,
    this.showValueChip = true,
    this.chipColor,
    this.chipBorderColor,
    this.chipBorderRadius,
    this.chipTextStyle,
    this.valueIndicatorColor,
    this.valueIndicatorTextStyle,
    this.labelTextStyle,
    this.circularTrackWidth,
    this.circularInactiveColor,
    this.circularActiveColor,
    this.circularSize,
    this.circularCenterTextStyle,
  });

  /// Returns a copy of this style with the given fields replaced.
  SeekBarStyle copyWith({
    double? trackHeight,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? thumbColor,
    double? thumbRadius,
    BorderSide? thumbBorder,
    Color? overlayColor,
    double? overlayRadius,
    bool? showValueChip,
    Color? chipColor,
    Color? chipBorderColor,
    double? chipBorderRadius,
    TextStyle? chipTextStyle,
    Color? valueIndicatorColor,
    TextStyle? valueIndicatorTextStyle,
    TextStyle? labelTextStyle,
    double? circularTrackWidth,
    Color? circularInactiveColor,
    Color? circularActiveColor,
    double? circularSize,
    TextStyle? circularCenterTextStyle,
  }) {
    return SeekBarStyle(
      trackHeight: trackHeight ?? this.trackHeight,
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbRadius: thumbRadius ?? this.thumbRadius,
      thumbBorder: thumbBorder ?? this.thumbBorder,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayRadius: overlayRadius ?? this.overlayRadius,
      showValueChip: showValueChip ?? this.showValueChip,
      chipColor: chipColor ?? this.chipColor,
      chipBorderColor: chipBorderColor ?? this.chipBorderColor,
      chipBorderRadius: chipBorderRadius ?? this.chipBorderRadius,
      chipTextStyle: chipTextStyle ?? this.chipTextStyle,
      valueIndicatorColor: valueIndicatorColor ?? this.valueIndicatorColor,
      valueIndicatorTextStyle:
          valueIndicatorTextStyle ?? this.valueIndicatorTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      circularTrackWidth: circularTrackWidth ?? this.circularTrackWidth,
      circularInactiveColor:
          circularInactiveColor ?? this.circularInactiveColor,
      circularActiveColor: circularActiveColor ?? this.circularActiveColor,
      circularSize: circularSize ?? this.circularSize,
      circularCenterTextStyle:
          circularCenterTextStyle ?? this.circularCenterTextStyle,
    );
  }
}
