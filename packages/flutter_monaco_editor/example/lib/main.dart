import 'dart:async';

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
// flutter_monaco_editor — Phase 2 preview
// Bundled Monaco: $monacoVersion
//
// Try:
//   * Ctrl/Cmd+Shift+L  — excited-greeting action (replaces "Hello" → "Hello!")
//   * Ctrl/Cmd+K        — shows a demo snackbar (via addCommand)
//   * Right-click       — see the registered action in the context menu
//   * Hover line 10     — custom decoration with tooltip

import 'dart:async';
import 'package:flutter/material.dart';

Future<void> main() async {
  final greetings = ['Hello', 'Bonjour', 'Hallo', 'Hola', 'こんにちは'];
  for (final greeting in greetings) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    print('\$greeting from Monaco!');
  }
  print('All done.');
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
  List<String> _decorationIds = const [];

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _initialCode,
      language: 'dart',
      options: const MonacoEditorOptions(
        fontSize: 14,
        bracketPairColorization: true,
        smoothScrolling: true,
        cursorSmoothCaretAnimation: true,
        glyphMargin: true,
      ),
    );

    _controller.onDidChangeContent.listen((value) {
      setState(() => _charCount = value.length);
    });
    _controller.onDidChangeCursorPosition.listen((pos) {
      setState(() => _position = pos);
    });

    // Phase 2 demos run once the controller is attached.
    unawaited(_afterReady());
  }

  Future<void> _afterReady() async {
    await _controller.ready;

    // Action with keybinding + context menu entry.
    await _controller.addAction(MonacoAction(
      id: 'example.exciteGreeting',
      label: 'Excite the first "Hello"',
      keybindings: const [
        MonacoKeyMod.ctrlCmd | MonacoKeyMod.shift | MonacoKeyCode.keyL,
      ],
      contextMenuGroupId: '1_modification',
      contextMenuOrder: 1.5,
      run: (_) async {
        final value = _controller.value;
        if (!value.contains('Hello')) return;
        final updated = value.replaceFirst('Hello', 'Hello!');
        await _controller.setValue(updated);
        if (mounted) _snack('Added enthusiasm to "Hello"');
      },
    ));

    // Bare keybinding, no command palette / context menu entry.
    await _controller.addCommand(
      MonacoKeyMod.ctrlCmd | MonacoKeyCode.keyK,
      () => _snack('Ctrl/Cmd+K fired from Monaco'),
    );

    // Warning marker + decoration on line 10.
    await _controller.setModelMarkers(
      const [
        MonacoMarker(
          range: MonacoRange(
            startLine: 10, startColumn: 1, endLine: 10, endColumn: 80,
          ),
          severity: MonacoMarkerSeverity.warning,
          message: 'Example warning — this line is decorated for demo purposes.',
          source: 'flutter_monaco_editor example',
        ),
      ],
      owner: 'example',
    );

    _decorationIds = await _controller.deltaDecorations(const [], const [
      MonacoDecoration(
        range: MonacoRange(
          startLine: 10, startColumn: 1, endLine: 10, endColumn: 1,
        ),
        options: MonacoDecorationOptions(
          isWholeLine: true,
          className: 'fme-highlight-line',
          glyphMarginClassName: 'fme-glyph-info',
          hoverMessage: 'This line has a whole-line decoration.',
          overviewRuler: MonacoOverviewRuler(color: '#58a6ff'),
        ),
      ),
      MonacoDecoration(
        range: MonacoRange(
          startLine: 1, startColumn: 4, endLine: 1, endColumn: 30,
        ),
        options: MonacoDecorationOptions(
          inlineClassName: 'fme-highlight-inline',
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ));
  }

  Future<void> _toggleReadOnly() async {
    setState(() => _readOnly = !_readOnly);
    await _controller.setReadOnly(_readOnly);
  }

  Future<void> _formatDocument() async {
    await _controller.trigger('editor.action.formatDocument');
  }

  Future<void> _clearDecorations() async {
    if (_decorationIds.isEmpty) return;
    await _controller.deltaDecorations(_decorationIds, const []);
    await _controller.clearModelMarkers(owner: 'example');
    setState(() => _decorationIds = const []);
  }

  @override
  Widget build(BuildContext context) {
    final pos = _position;
    final statusLine = [
      'Monaco $monacoVersion',
      '$_charCount chars',
      if (pos != null) 'Ln ${pos.line}, Col ${pos.column}',
      if (_readOnly) 'read-only',
      if (_decorationIds.isNotEmpty) '${_decorationIds.length} decorations',
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
            tooltip: 'Format document (built-in action)',
            icon: const Icon(Icons.auto_fix_high),
            onPressed: _formatDocument,
          ),
          IconButton(
            tooltip: 'Clear demo decorations / markers',
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clearDecorations,
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
