import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class ThemesDemo extends StatefulWidget {
  const ThemesDemo({super.key});

  static Widget builder(BuildContext context) => const ThemesDemo();

  @override
  State<ThemesDemo> createState() => _ThemesDemoState();
}

class _ThemesDemoState extends State<ThemesDemo> {
  static const Demo _demo = Demo(
    label: 'Custom Themes',
    blurb: 'Define named themes at runtime and switch between them globally.',
    icon: Icons.palette_outlined,
    builder: ThemesDemo.builder,
  );

  static const String _code = '''
// flutter_monaco_editor — custom theme demo
//
// Monaco themes are global. Calling MonacoThemes.setTheme(name) swaps
// every editor in the page. Token rules follow the TextMate scope names
// you see in VS Code theme JSON files.

import 'dart:async';
import 'package:flutter/material.dart';

class Greeting {
  final String target;

  const Greeting(this.target);

  String render() {
    // The numeric literal, "Hello", and "\$target" should be recolored
    // as you cycle themes.
    return 'Hello, \$target! #1';
  }
}

void main() {
  print(const Greeting('Monaco').render());
}
''';

  static final Map<String, MonacoTheme> _themes = {
    'catppuccin-mocha': const MonacoTheme(
      base: 'vs-dark',
      rules: [
        MonacoTokenRule(token: 'comment', foreground: '6c7086', fontStyle: 'italic'),
        MonacoTokenRule(token: 'keyword', foreground: 'cba6f7', fontStyle: 'bold'),
        MonacoTokenRule(token: 'string', foreground: 'a6e3a1'),
        MonacoTokenRule(token: 'number', foreground: 'fab387'),
        MonacoTokenRule(token: 'type', foreground: 'f9e2af'),
        MonacoTokenRule(token: 'identifier', foreground: 'cdd6f4'),
      ],
      colors: {
        'editor.background': '#1e1e2e',
        'editor.foreground': '#cdd6f4',
        'editorLineNumber.foreground': '#585b70',
        'editorCursor.foreground': '#f5e0dc',
        'editor.selectionBackground': '#414355',
        'editorIndentGuide.background': '#313244',
      },
    ),
    'solarized-warm': const MonacoTheme(
      base: 'vs',
      rules: [
        MonacoTokenRule(token: 'comment', foreground: '93a1a1', fontStyle: 'italic'),
        MonacoTokenRule(token: 'keyword', foreground: '859900', fontStyle: 'bold'),
        MonacoTokenRule(token: 'string', foreground: '2aa198'),
        MonacoTokenRule(token: 'number', foreground: 'dc322f'),
        MonacoTokenRule(token: 'type', foreground: 'cb4b16'),
        MonacoTokenRule(token: 'identifier', foreground: '657b83'),
      ],
      colors: {
        'editor.background': '#fdf6e3',
        'editor.foreground': '#586e75',
        'editorLineNumber.foreground': '#93a1a1',
        'editorCursor.foreground': '#cb4b16',
        'editor.selectionBackground': '#eee8d5',
      },
    ),
    'tokyo-night': const MonacoTheme(
      base: 'vs-dark',
      rules: [
        MonacoTokenRule(token: 'comment', foreground: '565f89', fontStyle: 'italic'),
        MonacoTokenRule(token: 'keyword', foreground: 'bb9af7'),
        MonacoTokenRule(token: 'string', foreground: '9ece6a'),
        MonacoTokenRule(token: 'number', foreground: 'ff9e64'),
        MonacoTokenRule(token: 'type', foreground: '7aa2f7'),
        MonacoTokenRule(token: 'identifier', foreground: 'c0caf5'),
      ],
      colors: {
        'editor.background': '#1a1b26',
        'editor.foreground': '#a9b1d6',
        'editorLineNumber.foreground': '#3b4261',
        'editorCursor.foreground': '#c0caf5',
        'editor.selectionBackground': '#283457',
      },
    ),
  };

  late final MonacoController _controller;
  bool _themesRegistered = false;
  String _activeTheme = 'vs-dark';

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _code,
      language: 'dart',
    );
    unawaited(_registerAll());
  }

  Future<void> _registerAll() async {
    await _controller.ready;
    for (final entry in _themes.entries) {
      await MonacoThemes.defineTheme(entry.key, entry.value);
    }
    if (mounted) setState(() => _themesRegistered = true);
  }

  Future<void> _set(String name) async {
    setState(() => _activeTheme = name);
    await MonacoThemes.setTheme(name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = <String>['vs-dark', 'vs', 'hc-black', 'hc-light', ..._themes.keys];
    return DemoScaffold(
      demo: _demo,
      actions: [
        if (!_themesRegistered)
          const SizedBox(
            width: 16, height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
      // Put the theme picker in a sidebar (not a popup) — Flutter overlays
      // render beneath the webview's GtkOverlay on Linux, so a DropdownButton
      // popup would be hidden under the editor. Inline chips avoid that.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 220,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  for (final name in names)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ChoiceChip(
                        label: Text(name),
                        selected: _activeTheme == name,
                        onSelected: _themesRegistered
                            ? (sel) {
                                if (sel) _set(name);
                              }
                            : null,
                      ),
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
