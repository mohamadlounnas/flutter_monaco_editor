import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class OptionsDemo extends StatefulWidget {
  const OptionsDemo({super.key});

  static Widget builder(BuildContext context) => const OptionsDemo();

  @override
  State<OptionsDemo> createState() => _OptionsDemoState();
}

class _OptionsDemoState extends State<OptionsDemo> {
  static const Demo _demo = Demo(
    label: 'Options',
    blurb: 'Live toggles for font size, word wrap, minimap, line numbers, cursor style.',
    icon: Icons.tune,
    builder: OptionsDemo.builder,
  );

  static const String _code = '''
// Resize the font, toggle word wrap, flip the minimap — every change
// goes through MonacoController.updateOptions(MonacoEditorOptions(...))
// and is applied live by Monaco with no editor recreation.
//
// A very long comment that demonstrates word-wrap: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

import 'dart:async';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key, required this.initial});

  final int initial;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _count = widget.initial;

  void _increment() => setState(() => _count++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Text('\$_count', style: Theme.of(context).textTheme.displayLarge),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

  late final MonacoController _controller;

  double _fontSize = 14;
  bool _wordWrap = false;
  bool _minimap = true;
  bool _lineNumbers = true;
  bool _smoothCursor = true;
  MonacoCursorStyle _cursorStyle = MonacoCursorStyle.line;
  int _tabSize = 2;

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _code,
      language: 'dart',
      options: _buildOptions(),
    );
  }

  MonacoEditorOptions _buildOptions() => MonacoEditorOptions(
        fontSize: _fontSize,
        wordWrap: _wordWrap ? MonacoWordWrap.on : MonacoWordWrap.off,
        minimap: MonacoMinimapOptions(enabled: _minimap),
        lineNumbers: _lineNumbers
            ? MonacoLineNumbersStyle.on
            : MonacoLineNumbersStyle.off,
        cursorSmoothCaretAnimation: _smoothCursor,
        cursorStyle: _cursorStyle,
        tabSize: _tabSize,
        bracketPairColorization: true,
        smoothScrolling: true,
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _apply() => _controller.updateOptions(_buildOptions());

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      demo: _demo,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 280,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Font size: ${_fontSize.toInt()}px'),
                  Slider(
                    value: _fontSize,
                    min: 10,
                    max: 22,
                    divisions: 12,
                    label: '${_fontSize.toInt()}',
                    onChanged: (v) {
                      setState(() => _fontSize = v);
                      _apply();
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Tab size: $_tabSize'),
                  Slider(
                    value: _tabSize.toDouble(),
                    min: 2,
                    max: 8,
                    divisions: 3,
                    label: '$_tabSize',
                    onChanged: (v) {
                      setState(() => _tabSize = v.round());
                      _apply();
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('Word wrap'),
                    value: _wordWrap,
                    onChanged: (v) {
                      setState(() => _wordWrap = v);
                      _apply();
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('Minimap'),
                    value: _minimap,
                    onChanged: (v) {
                      setState(() => _minimap = v);
                      _apply();
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('Line numbers'),
                    value: _lineNumbers,
                    onChanged: (v) {
                      setState(() => _lineNumbers = v);
                      _apply();
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('Smooth caret'),
                    value: _smoothCursor,
                    onChanged: (v) {
                      setState(() => _smoothCursor = v);
                      _apply();
                    },
                  ),
                  const Divider(),
                  const Text('Cursor style'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: MonacoCursorStyle.values.map((s) {
                      return ChoiceChip(
                        label: Text(s.name),
                        selected: _cursorStyle == s,
                        onSelected: (sel) {
                          if (!sel) return;
                          setState(() => _cursorStyle = s);
                          _apply();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: MonacoEditor(controller: _controller)),
        ],
      ),
    );
  }
}
