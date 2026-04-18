import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class DiagnosticsDemo extends StatefulWidget {
  const DiagnosticsDemo({super.key});

  static Widget builder(BuildContext context) => const DiagnosticsDemo();

  @override
  State<DiagnosticsDemo> createState() => _DiagnosticsDemoState();
}

class _DiagnosticsDemoState extends State<DiagnosticsDemo> {
  static const Demo _demo = Demo(
    label: 'Diagnostics',
    blurb: 'Error / warning / info markers and inline + gutter decorations.',
    icon: Icons.error_outline,
    builder: DiagnosticsDemo.builder,
  );

  static const String _code = '''
// Hover the squiggles to see messages.
// Gutter icons (the "i" circles) are decorations with glyphMarginClassName.

void main() {
  final unusedVariable = 42;         // info: "unused"
  String name = null;                // error: null-assigned to non-null
  var typo = "hello wrld";           // warning: spelling
  print(name);
  print(typo);

  // Highlighted range below uses an inline decoration class.
  final highlighted = 'this phrase is decorated';
  print(highlighted);
}
''';

  late final MonacoController _controller;
  List<String> _decorations = const [];
  bool _hasDiagnostics = false;

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _code,
      language: 'dart',
      options: const MonacoEditorOptions(
        glyphMargin: true,
        bracketPairColorization: true,
      ),
    );
    _controller.ready.then((_) => _applyDiagnostics());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyDiagnostics() async {
    await _controller.setModelMarkers(
      const [
        MonacoMarker(
          range: MonacoRange(
            startLine: 5, startColumn: 9, endLine: 5, endColumn: 24,
          ),
          severity: MonacoMarkerSeverity.info,
          message: 'Unused variable "unusedVariable".',
          source: 'demo-analyzer',
          code: 'unused_local',
        ),
        MonacoMarker(
          range: MonacoRange(
            startLine: 6, startColumn: 17, endLine: 6, endColumn: 21,
          ),
          severity: MonacoMarkerSeverity.error,
          message: 'Cannot assign null to non-nullable String.',
          source: 'demo-analyzer',
          code: 'nullable_assignment',
        ),
        MonacoMarker(
          range: MonacoRange(
            startLine: 7, startColumn: 15, endLine: 7, endColumn: 29,
          ),
          severity: MonacoMarkerSeverity.warning,
          message: 'Possible typo: "wrld" — did you mean "world"?',
          source: 'demo-spellcheck',
        ),
      ],
      owner: 'demo',
    );

    _decorations = await _controller.deltaDecorations(const [], const [
      MonacoDecoration(
        range: MonacoRange(
          startLine: 5, startColumn: 1, endLine: 5, endColumn: 1,
        ),
        options: MonacoDecorationOptions(
          isWholeLine: true,
          className: 'demo-info-line',
          glyphMarginClassName: 'demo-glyph-info',
          overviewRuler: MonacoOverviewRuler(color: '#58a6ff'),
        ),
      ),
      MonacoDecoration(
        range: MonacoRange(
          startLine: 12, startColumn: 27, endLine: 12, endColumn: 51,
        ),
        options: MonacoDecorationOptions(
          inlineClassName: 'demo-highlight-inline',
          hoverMessage: 'Whole-range decoration with hover tooltip.',
        ),
      ),
    ]);
    if (mounted) setState(() => _hasDiagnostics = true);
  }

  Future<void> _clear() async {
    await _controller.clearModelMarkers(owner: 'demo');
    if (_decorations.isNotEmpty) {
      await _controller.deltaDecorations(_decorations, const []);
    }
    if (mounted) {
      setState(() {
        _decorations = const [];
        _hasDiagnostics = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      demo: _demo,
      actions: [
        FilledButton.tonalIcon(
          icon: Icon(_hasDiagnostics ? Icons.clear : Icons.refresh),
          label: Text(_hasDiagnostics ? 'Clear' : 'Apply'),
          onPressed: _hasDiagnostics ? _clear : _applyDiagnostics,
        ),
        const SizedBox(width: 8),
      ],
      child: MonacoEditor(controller: _controller),
    );
  }
}
