import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class DiffDemo extends StatefulWidget {
  const DiffDemo({super.key});

  static Widget builder(BuildContext context) => const DiffDemo();

  @override
  State<DiffDemo> createState() => _DiffDemoState();
}

class _DiffDemoState extends State<DiffDemo> {
  static const Demo _demo = Demo(
    label: 'Diff Editor',
    blurb: 'Side-by-side or inline diff of original vs. modified text.',
    icon: Icons.compare_arrows,
    builder: DiffDemo.builder,
  );

  static const String _original = '''
class Counter {
  int count = 0;

  void increment() {
    count += 1;
    print('count is now \$count');
  }

  void reset() {
    count = 0;
  }
}
''';

  static const String _modified = '''
class Counter {
  int _count = 0;

  int get count => _count;

  void increment([int by = 1]) {
    _count += by;
    print('count is now \$_count');
  }

  Future<void> reset() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    _count = 0;
  }
}
''';

  bool _sideBySide = true;
  int _key = 0; // rebuilds the diff widget when toggling layout

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      demo: _demo,
      actions: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Side-by-side')),
            ButtonSegment(value: false, label: Text('Inline')),
          ],
          selected: {_sideBySide},
          onSelectionChanged: (sel) {
            setState(() {
              _sideBySide = sel.first;
              _key++;
            });
          },
        ),
        const SizedBox(width: 8),
      ],
      child: MonacoDiffEditor(
        key: ValueKey(_key),
        original: _original,
        modified: _modified,
        language: 'dart',
        renderSideBySide: _sideBySide,
      ),
    );
  }
}
