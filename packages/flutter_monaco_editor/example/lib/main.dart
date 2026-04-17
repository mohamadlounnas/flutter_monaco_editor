import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_monaco_editor example',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

const String _initialCode = '''
// flutter_monaco_editor — Phase 1.4 preview
// Bundled Monaco: $monacoVersion

import 'dart:async';
import 'package:flutter/material.dart';

/// Toggle options with the buttons in the app bar — read-only, word wrap,
/// font size, minimap — to see MonacoEditorOptions in action.
Future<void> main() async {
  final greetings = ['Hello', 'Bonjour', 'Hallo', 'Hola', 'こんにちは'];
  for (final greeting in greetings) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    print('\$greeting from Monaco!');
  }
}
''';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final MonacoController _controller;

  MonacoPosition? _position;
  int _charCount = _initialCode.length;
  bool _readOnly = false;
  bool _wordWrap = false;
  bool _minimap = true;
  double _fontSize = 14;

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _initialCode,
      language: 'dart',
      options: MonacoEditorOptions(
        fontSize: _fontSize,
        wordWrap:
            _wordWrap ? MonacoWordWrap.on : MonacoWordWrap.off,
        minimap: MonacoMinimapOptions(enabled: _minimap),
        bracketPairColorization: true,
        smoothScrolling: true,
        cursorSmoothCaretAnimation: true,
      ),
    );
    _controller.onDidChangeContent.listen((value) {
      setState(() => _charCount = value.length);
    });
    _controller.onDidChangeCursorPosition.listen((pos) {
      setState(() => _position = pos);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleReadOnly() async {
    setState(() => _readOnly = !_readOnly);
    await _controller.setReadOnly(_readOnly);
  }

  Future<void> _toggleWordWrap() async {
    setState(() => _wordWrap = !_wordWrap);
    await _controller.updateOptions(
      MonacoEditorOptions(
        wordWrap: _wordWrap ? MonacoWordWrap.on : MonacoWordWrap.off,
      ),
    );
  }

  Future<void> _toggleMinimap() async {
    setState(() => _minimap = !_minimap);
    await _controller.updateOptions(
      MonacoEditorOptions(minimap: MonacoMinimapOptions(enabled: _minimap)),
    );
  }

  Future<void> _cycleFontSize() async {
    setState(() {
      _fontSize = switch (_fontSize) {
        == 14.0 => 16,
        == 16.0 => 18,
        == 18.0 => 12,
        _ => 14,
      };
    });
    await _controller.updateOptions(MonacoEditorOptions(fontSize: _fontSize));
  }

  Future<void> _jumpToLine10() async {
    await _controller.setPosition(const MonacoPosition(line: 10, column: 1));
    await _controller.revealLineInCenter(10);
    await _controller.focus();
  }

  @override
  Widget build(BuildContext context) {
    final pos = _position;
    final statusLine = [
      'Monaco $monacoVersion',
      '$_charCount chars',
      if (pos != null) 'Ln ${pos.line}, Col ${pos.column}',
      '${_fontSize.toInt()}px',
      if (_readOnly) 'read-only',
      if (_wordWrap) 'wrap',
      if (_minimap) 'minimap',
    ].join('  •  ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_monaco_editor'),
        actions: [
          IconButton(
            tooltip: _readOnly ? 'Enable editing' : 'Set read-only',
            icon: Icon(_readOnly ? Icons.lock : Icons.lock_open),
            onPressed: _toggleReadOnly,
          ),
          IconButton(
            tooltip: 'Toggle word wrap',
            icon: Icon(_wordWrap ? Icons.wrap_text : Icons.chevron_right),
            onPressed: _toggleWordWrap,
          ),
          IconButton(
            tooltip: 'Toggle minimap',
            icon: Icon(_minimap ? Icons.map : Icons.map_outlined),
            onPressed: _toggleMinimap,
          ),
          IconButton(
            tooltip: 'Cycle font size',
            icon: const Icon(Icons.format_size),
            onPressed: _cycleFontSize,
          ),
          IconButton(
            tooltip: 'Jump to line 10',
            icon: const Icon(Icons.south),
            onPressed: _jumpToLine10,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                statusLine,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
      body: MonacoEditor(controller: _controller),
    );
  }
}
