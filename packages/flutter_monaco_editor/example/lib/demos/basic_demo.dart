import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class BasicDemo extends StatefulWidget {
  const BasicDemo({super.key});

  static Widget builder(BuildContext context) => const BasicDemo();

  @override
  State<BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<BasicDemo> {
  static const String _code = '''
void main() {
  final greetings = ['Hello', 'Bonjour', 'Hallo', 'Hola', 'こんにちは'];
  for (final greeting in greetings) {
    print('\$greeting from Monaco!');
  }
}
''';

  late final MonacoController _controller;
  bool _readOnly = false;
  String _theme = 'vs-dark';
  MonacoPosition? _pos;

  static const Demo _demo = Demo(
    label: 'Basic',
    blurb: 'Minimal editor + read-only / theme toggles.',
    icon: Icons.article_outlined,
    builder: BasicDemo.builder,
  );

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _code,
      language: 'dart',
      theme: _theme,
    );
    _controller.onDidChangeCursorPosition.listen((p) {
      if (mounted) setState(() => _pos = p);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      demo: _demo,
      actions: [
        Tooltip(
          message: 'Theme',
          child: DropdownButton<String>(
            value: _theme,
            items: const [
              DropdownMenuItem(value: 'vs-dark', child: Text('vs-dark')),
              DropdownMenuItem(value: 'vs', child: Text('vs')),
              DropdownMenuItem(value: 'hc-black', child: Text('hc-black')),
              DropdownMenuItem(value: 'hc-light', child: Text('hc-light')),
            ],
            onChanged: (v) async {
              if (v == null) return;
              setState(() => _theme = v);
              await _controller.setTheme(v);
            },
          ),
        ),
        const SizedBox(width: 12),
        FilterChip(
          label: const Text('read-only'),
          selected: _readOnly,
          onSelected: (v) async {
            setState(() => _readOnly = v);
            await _controller.setReadOnly(v);
          },
        ),
        const SizedBox(width: 12),
        Text(
          _pos == null ? '—' : 'Ln ${_pos!.line}, Col ${_pos!.column}',
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
        const SizedBox(width: 8),
      ],
      child: MonacoEditor(controller: _controller),
    );
  }
}
