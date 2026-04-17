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
// flutter_monaco_editor — Phase 1.3 preview
// Bundled Monaco: $monacoVersion

void main() {
  final greetings = ['Hello', 'Bonjour', 'Hallo', 'Hola'];
  for (final greeting in greetings) {
    print('\$greeting, Monaco!');
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

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _initialCode,
      language: 'dart',
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

  Future<void> _jumpToLine5() async {
    await _controller.setPosition(const MonacoPosition(line: 5, column: 1));
    await _controller.revealLineInCenter(5);
    await _controller.focus();
  }

  @override
  Widget build(BuildContext context) {
    final pos = _position;
    final statusLine = [
      'Monaco $monacoVersion',
      '$_charCount chars',
      if (pos != null) 'Ln ${pos.line}, Col ${pos.column}',
      if (_readOnly) 'read-only',
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
            tooltip: 'Jump to line 5',
            icon: const Icon(Icons.south),
            onPressed: _jumpToLine5,
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
