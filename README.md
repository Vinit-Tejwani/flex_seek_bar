# flex_seek_bar

A highly customizable Flutter seek bar plugin supporting:

- Single slider
- Range slider (dual thumb)
- Circular seek bar
- Controller-based state control
- Custom styling options

Designed for flexibility, clean UI integration, and advanced interaction control beyond Flutter’s default Slider widgets.

---

## ✨ Features

✅ Linear Single Seek Bar  
✅ Linear Range Seek Bar  
✅ Circular Seek Bar  
✅ Controller Driven Updates  
✅ Styling Customization  
✅ Value Labels / Units Support  
✅ Lightweight & Flutter-native  

---

## 📦 Installation

Add to your `pubspec.yaml`:

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

### Using Controller

```dart
final controller = SeekBarController();

controller.setValue(75);
controller.reset();
```

---

## 🧩 Platform Support

| Platform | Supported |
|---------|----------|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| macOS | ✅ |
| Windows | ✅ |
| Linux | ✅ |

---

## 📘 Additional Information

This plugin is built to provide more flexible seek bar experiences than Flutter’s default slider widgets, especially for advanced UI/UX scenarios requiring multiple slider modes or programmatic control.

Contributions and feedback are welcome.

---

## 🐞 Issues & Contributions

Report issues or contribute here:

👉 https://github.com/Vinit-Tejwani/flex_seek_bar

---

## 📄 License

MIT License
