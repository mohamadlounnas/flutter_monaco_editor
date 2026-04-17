import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class IntelliSenseDemo extends StatefulWidget {
  const IntelliSenseDemo({super.key});

  static Widget builder(BuildContext context) => const IntelliSenseDemo();

  @override
  State<IntelliSenseDemo> createState() => _IntelliSenseDemoState();
}

class _IntelliSenseDemoState extends State<IntelliSenseDemo> {
  static const Demo _demo = Demo(
    label: 'IntelliSense',
    blurb: 'Dart-side completion + hover providers with async round-trip to Monaco.',
    icon: Icons.auto_awesome,
    builder: IntelliSenseDemo.builder,
  );

  static const String _code = '''
// Try it:
//   Ctrl/Cmd+Space — trigger completion
//   Type `fl`, `pr`, `Fu` — completions appear
//   Hover "print", "Future", "main", "Monaco" — doc tooltips appear
//
// All provider output is computed in Dart — MonacoLanguages routes the
// request through a single JS↔Dart round-trip with an 8s timeout.

import 'dart:async';

Future<void> main() async {
  print('Hello from Monaco!');
  await Future<void>.delayed(const Duration(seconds: 1));
}
''';

  late final MonacoController _controller;
  MonacoDisposable? _completionDispose;
  MonacoDisposable? _hoverDispose;

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _code,
      language: 'dart',
      options: const MonacoEditorOptions(
        quickSuggestions: true,
        bracketPairColorization: true,
      ),
    );
    unawaited(_registerProviders());
  }

  Future<void> _registerProviders() async {
    _completionDispose = await MonacoLanguages.registerCompletionProvider(
      'dart',
      _DartDemoCompletionProvider(),
    );
    _hoverDispose = await MonacoLanguages.registerHoverProvider(
      'dart',
      _DartDemoHoverProvider(),
    );
  }

  @override
  void dispose() {
    unawaited(_completionDispose?.dispose());
    unawaited(_hoverDispose?.dispose());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      demo: _demo,
      actions: [
        FilledButton.tonalIcon(
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Trigger'),
          onPressed: () => _controller.trigger('editor.action.triggerSuggest'),
        ),
        const SizedBox(width: 8),
      ],
      child: MonacoEditor(controller: _controller),
    );
  }
}

class _DartDemoCompletionProvider implements MonacoCompletionProvider {
  @override
  List<String> get triggerCharacters => const ['.'];

  static const List<MonacoCompletionItem> _items = [
    MonacoCompletionItem(
      label: 'print',
      kind: MonacoCompletionKind.function,
      insertText: 'print(\${1:value});',
      insertTextRules: MonacoInsertTextRule.insertAsSnippet,
      detail: 'void print(Object? value)',
      documentation: 'Writes the string representation of `value` to stdout.',
    ),
    MonacoCompletionItem(
      label: 'Future.delayed',
      kind: MonacoCompletionKind.constructor,
      insertText: 'Future<void>.delayed(const Duration(milliseconds: \${1:100}));',
      insertTextRules: MonacoInsertTextRule.insertAsSnippet,
      detail: 'Future<T>.delayed(Duration, [FutureOr<T> Function()?])',
      documentation: 'Creates a future that completes after the given duration.',
    ),
    MonacoCompletionItem(
      label: 'for-loop',
      kind: MonacoCompletionKind.snippet,
      insertText: 'for (var \${1:i} = 0; \$1 < \${2:length}; \$1++) {\n  \$0\n}',
      insertTextRules: MonacoInsertTextRule.insertAsSnippet,
      detail: 'for loop',
      documentation: 'Classic C-style for loop.',
    ),
    MonacoCompletionItem(
      label: 'for-in',
      kind: MonacoCompletionKind.snippet,
      insertText: 'for (final \${1:item} in \${2:items}) {\n  \$0\n}',
      insertTextRules: MonacoInsertTextRule.insertAsSnippet,
      detail: 'for-in loop',
    ),
    MonacoCompletionItem(
      label: 'flutter_monaco_editor',
      kind: MonacoCompletionKind.module,
      insertText: 'flutter_monaco_editor',
      detail: 'package',
      documentation:
          'This package — a complete Flutter wrapper for Monaco Editor.',
    ),
  ];

  @override
  Future<MonacoCompletionList> provideCompletionItems(
    MonacoCompletionParams params,
  ) async {
    return const MonacoCompletionList(suggestions: _items);
  }
}

class _DartDemoHoverProvider implements MonacoHoverProvider {
  static const Map<String, String> _docs = {
    'print': '**print(value)** — writes the value to stdout.\n\n_Provided by the demo hover provider._',
    'Future': '**Future&lt;T&gt;** — represents a computation that may not have completed yet.',
    'main': '**main()** — the entry point of every Dart program.',
    'Monaco': '**Monaco Editor** — VS Code\'s editor, embedded in Flutter via `flutter_monaco_editor`.',
  };

  @override
  Future<MonacoHover?> provideHover(MonacoProviderParams params) async {
    final line = _lineAt(params.value, params.position.line);
    final word = _wordAt(line, params.position.column);
    final doc = _docs[word];
    return doc == null ? null : MonacoHover(contents: [doc]);
  }

  static String _lineAt(String value, int line) {
    final lines = value.split('\n');
    return (line - 1) < lines.length ? lines[line - 1] : '';
  }

  static String _wordAt(String line, int column) {
    final idx = column - 1;
    if (idx < 0 || idx > line.length) return '';
    var start = idx;
    var end = idx;
    bool isWord(int i) =>
        i >= 0 && i < line.length && RegExp(r'[A-Za-z_]').hasMatch(line[i]);
    while (isWord(start - 1)) {
      start--;
    }
    while (isWord(end)) {
      end++;
    }
    return line.substring(start, end);
  }
}
