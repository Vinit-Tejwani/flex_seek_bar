import 'package:flutter/foundation.dart';

/// A controller that lets you read and programmatically update seek bar values.
///
/// Attach it to a [FlexSeekBar] via the `controller` parameter.
///
/// ```dart
/// final controller = SeekBarController(initialValue: 30);
///
/// // Later:
/// controller.setValue(60);
/// controller.setRange(20, 80);
/// ```
class SeekBarController extends ChangeNotifier {
  double _value;
  double _minRangeValue;
  double _maxRangeValue;
  bool _disabled;

  SeekBarController({
    double initialValue = 0,
    double initialMinRange = 0,
    double initialMaxRange = 100,
    bool disabled = false,
  }) : _value = initialValue,
       _minRangeValue = initialMinRange,
       _maxRangeValue = initialMaxRange,
       _disabled = disabled;

  // ── Getters ─────────────────────────────────────────────────────────────

  /// Current value for single / circular sliders.
  double get value => _value;

  /// Current minimum value for range sliders.
  double get minRangeValue => _minRangeValue;

  /// Current maximum value for range sliders.
  double get maxRangeValue => _maxRangeValue;

  /// Whether the slider is disabled (non-interactive).
  bool get disabled => _disabled;

  // ── Setters ─────────────────────────────────────────────────────────────

  /// Update the single slider value and notify listeners.
  void setValue(double value) {
    _value = value;
    notifyListeners();
  }

  /// Update the range slider values and notify listeners.
  void setRange(double min, double max) {
    assert(min <= max, 'min must be ≤ max');
    _minRangeValue = min;
    _maxRangeValue = max;
    notifyListeners();
  }

  /// Enable or disable the seek bar.
  void setDisabled(bool value) {
    _disabled = value;
    notifyListeners();
  }

  /// Convenience: reset to initial values.
  void reset({double value = 0, double minRange = 0, double maxRange = 100}) {
    _value = value;
    _minRangeValue = minRange;
    _maxRangeValue = maxRange;
    notifyListeners();
  }
}
