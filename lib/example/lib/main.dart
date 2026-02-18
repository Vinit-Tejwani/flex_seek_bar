import 'package:flex_seek_bar/flex_seek_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlexSeekBar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});
  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  // ── State for "uncontrolled" variants ─────────────────────────────────────
  double _singleValue = 40;
  double _rangeMin = 20;
  double _rangeMax = 80;
  double _circularValue = 65;

  // ── Controller-driven variants ────────────────────────────────────────────
  final _ctrlSingle = SeekBarController(initialValue: 55);
  final _ctrlRange = SeekBarController(
    initialMinRange: 30,
    initialMaxRange: 70,
  );
  final _ctrlCircular = SeekBarController(initialValue: 50);

  @override
  void dispose() {
    _ctrlSingle.dispose();
    _ctrlRange.dispose();
    _ctrlCircular.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlexSeekBar Demo'),
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _section('1 · Single Slider (uncontrolled)', [
            FlexSeekBar(
              type: SeekBarType.single,
              minValue: 0,
              maxValue: 100,
              value: _singleValue,
              label: 'Speed',
              unit: 'km/h',
              onChanged: (v) => setState(() => _singleValue = v.start),
            ),
          ]),
          _section('2 · Range Slider (uncontrolled)', [
            FlexSeekBar(
              type: SeekBarType.range,
              minValue: 0,
              maxValue: 200,
              value: _rangeMin,
              showTooltip: false,
              maxRangeValue: _rangeMax,
              label: 'Distance Range',
              unit: 'km',
              onChanged: (v) => setState(() {
                _rangeMin = v.start;
                _rangeMax = v.end;
              }),
            ),
          ]),
          _section('3 · Circular Slider (uncontrolled)', [
            Center(
              child: CircularSeekBar(
                minValue: 0,
                maxValue: 100,
                value: _circularValue,
                label: 'Volume',
                unit: '%',
                onChanged: (v) => setState(() => _circularValue = v),
                style: const SeekBarStyle(
                  circularSize: 180,
                  activeTrackColor: Color(0xFF10B981),
                  circularTrackWidth: 14,
                ),
              ),
            ),
          ]),
          _section('4 · Single Slider with Controller', [
            FlexSeekBar(
              type: SeekBarType.single,
              minValue: 0,
              maxValue: 100,
              controller: _ctrlSingle,
              label: 'Brightness',
              unit: '%',
              style: const SeekBarStyle(
                activeTrackColor: Color(0xFFF59E0B),
                chipColor: Color(0xFFFEF3C7),
                chipBorderColor: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _ctrlSingle.setValue(0),
                  child: const Text('0'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _ctrlSingle.setValue(50),
                  child: const Text('50'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _ctrlSingle.setValue(100),
                  child: const Text('100'),
                ),
                const SizedBox(width: 8),
                ListenableBuilder(
                  listenable: _ctrlSingle,
                  builder: (_, __) => Switch(
                    value: !_ctrlSingle.disabled,
                    onChanged: (v) => _ctrlSingle.setDisabled(!v),
                  ),
                ),
                const Text('Enabled'),
              ],
            ),
          ]),
          _section('5 · Range Slider with Controller', [
            FlexSeekBar(
              type: SeekBarType.range,
              minValue: 0,
              maxValue: 500,
              controller: _ctrlRange,
              label: 'Price Range',
              unit: '₹',
              style: const SeekBarStyle(
                activeTrackColor: Color(0xFF8B5CF6),
                thumbRadius: 12,
                chipBorderRadius: 20,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _ctrlRange.setRange(0, 500),
                  child: const Text('Full'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _ctrlRange.setRange(100, 300),
                  child: const Text('Mid'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _ctrlRange.reset(minRange: 0, maxRange: 100),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ]),
          _section('6 · Circular Slider with Controller', [
            Center(
              child: CircularSeekBar(
                minValue: 0,
                maxValue: 360,
                controller: _ctrlCircular,
                label: 'Rotation',
                unit: '°',
                startAngle: 270,
                sweepAngle: 360,
                style: const SeekBarStyle(
                  circularSize: 160,
                  activeTrackColor: Color(0xFFEF4444),
                  circularTrackWidth: 10,
                  thumbRadius: 8,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _ctrlCircular.setValue(0),
                    child: const Text('0°'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _ctrlCircular.setValue(180),
                    child: const Text('180°'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _ctrlCircular.setValue(360),
                    child: const Text('360°'),
                  ),
                ],
              ),
            ),
          ]),
          _section('7 · Custom Styled Slider (discrete + border thumb)', [
            FlexSeekBar(
              type: SeekBarType.single,
              minValue: 1,
              maxValue: 5,
              value: 3,
              label: 'Rating',
              divisions: 4,
              unit: '★',
              showTooltip: true,
              style: SeekBarStyle(
                activeTrackColor: const Color(0xFFF97316),
                trackHeight: 6,
                thumbRadius: 14,
                thumbBorder: const BorderSide(
                  color: Color(0xFFF97316),
                  width: 2,
                ),
                overlayColor: const Color(0xFFF97316),
                chipTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onChanged: (_) {},
            ),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
          const Divider(height: 32),
        ],
      ),
    );
  }
}
