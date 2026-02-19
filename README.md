# flex_seek_bar

[![pub package](https://img.shields.io/pub/v/flex_seek_bar.svg)](https://pub.dev/packages/flex_seek_bar)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A highly customizable Flutter seek bar plugin supporting linear, range, and circular slider types with controller-driven state updates and flexible styling options.

Built for developers who need more interaction control and UI flexibility than Flutter’s default slider widgets provide.

---

## ✨ Features

* Linear Single Seek Bar
* Linear Range Seek Bar (Dual Thumb)
* Circular Seek Bar
* Controller-Based Updates
* Custom Styling Options
* Value Labels & Units Support
* Lightweight & Flutter Native

---

## 📸 Preview

| Linear / Range           | Circular                 | Custom Styled            |
| ------------------------ | ------------------------ | ------------------------ |
| ![](https://raw.githubusercontent.com/Vinit-Tejwani/flex_seek_bar/main/images/1.png) | ![](https://raw.githubusercontent.com/Vinit-Tejwani/flex_seek_bar/main/images/2.png) | ![](https://raw.githubusercontent.com/Vinit-Tejwani/flex_seek_bar/main/images/3.png) |


---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flex_seek_bar: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

### Import

```dart
import 'package:flex_seek_bar/flex_seek_bar.dart';
```

---

### Single Seek Bar

```dart
FlexSeekBar(
  type: SeekBarType.single,
  minValue: 0,
  maxValue: 100,
  value: 40,
  label: 'Speed',
  unit: 'km/h',
  onChanged: (v) {
    print(v.start);
  },
)
```

---

### Range Seek Bar

```dart
FlexSeekBar(
  type: SeekBarType.range,
  minValue: 0,
  maxValue: 200,
  value: 20,
  maxRangeValue: 150,
  label: 'Distance',
  unit: 'km',
  onChanged: (v) {
    print(v.start);
    print(v.end);
  },
)
```

---

### Circular Seek Bar

```dart
CircularSeekBar(
  minValue: 0,
  maxValue: 100,
  value: 50,
  label: "Volume",
)
```

---

### Controller Usage

```dart
final controller = SeekBarController();

controller.setValue(75);
controller.reset();
```

---

## 🧩 Platform Support

| Platform | Supported |
| -------- | --------- |
| Android  | ✅         |
| iOS      | ✅         |
| Web      | ✅         |
| macOS    | ✅         |
| Windows  | ✅         |
| Linux    | ✅         |

---

## 📘 Additional Information

This plugin provides flexible seek bar experiences beyond Flutter’s default sliders, especially useful for advanced UI/UX scenarios involving:

* Multiple slider modes
* Circular interactions
* Programmatic control
* Custom styling

Contributions and feedback are welcome.

---

## 🐞 Issues & Contributions

Found a bug or want to contribute?

GitHub Repository:
https://github.com/Vinit-Tejwani/flex_seek_bar

---

## 📄 License

MIT License — see the LICENSE file for details.
