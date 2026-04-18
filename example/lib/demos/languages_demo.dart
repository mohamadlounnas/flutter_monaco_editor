import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class LanguagesDemo extends StatefulWidget {
  const LanguagesDemo({super.key});

  static Widget builder(BuildContext context) => const LanguagesDemo();

  @override
  State<LanguagesDemo> createState() => _LanguagesDemoState();
}

class _LanguagesDemoState extends State<LanguagesDemo> {
  static const Demo _demo = Demo(
    label: 'Languages',
    blurb: 'Switch syntax highlighting between Dart, JS, Python, JSON, HTML, Markdown, SQL.',
    icon: Icons.translate,
    builder: LanguagesDemo.builder,
  );

  static const Map<String, String> _samples = {
    'dart': '''
import 'dart:async';

Future<int> fibonacci(int n) async {
  if (n < 2) return n;
  return await fibonacci(n - 1) + await fibonacci(n - 2);
}

void main() async {
  for (var i = 0; i < 10; i++) {
    print('fib(\$i) = \${await fibonacci(i)}');
  }
}
''',
    'javascript': '''
const fib = n => n < 2 ? n : fib(n - 1) + fib(n - 2);

for (let i = 0; i < 10; i++) {
  console.log(`fib(\${i}) = \${fib(i)}`);
}
''',
    'typescript': '''
function fibonacci(n: number): number {
  return n < 2 ? n : fibonacci(n - 1) + fibonacci(n - 2);
}

[...Array(10).keys()].forEach((i) => {
  console.log(`fib(\${i}) = \${fibonacci(i)}`);
});
''',
    'python': '''
def fibonacci(n: int) -> int:
    return n if n < 2 else fibonacci(n - 1) + fibonacci(n - 2)

for i in range(10):
    print(f"fib({i}) = {fibonacci(i)}")
''',
    'json': '''
{
  "name": "flutter_monaco_editor",
  "version": "0.5.0",
  "bundledMonaco": "0.55.1",
  "features": [
    "web",
    "native (webview)",
    "intellisense",
    "diff editor"
  ],
  "nested": {
    "deep": {
      "value": 42
    }
  }
}
''',
    'html': '''
<!DOCTYPE html>
<html>
  <head>
    <title>Hello</title>
    <style>
      body { font-family: system-ui; background: #111; color: #eee; }
      h1 { color: #58a6ff; }
    </style>
  </head>
  <body>
    <h1>Hello Monaco!</h1>
    <p>Rendered with Flutter + flutter_monaco_editor.</p>
  </body>
</html>
''',
    'markdown': '''
# flutter_monaco_editor

A complete **Flutter** wrapper for [Monaco Editor](https://microsoft.github.io/monaco-editor/).

## Features

- Full API parity with Monaco
- Works on web, Android, iOS, macOS, Windows, Linux
- IntelliSense providers
- Diff editor
- Custom themes

```dart
final controller = MonacoController(
  initialValue: 'hello',
  language: 'dart',
);
```
''',
    'sql': '''
-- Find top-selling products by category
WITH sales AS (
  SELECT
    p.category,
    p.name,
    SUM(oi.quantity * oi.unit_price) AS revenue
  FROM order_items oi
  INNER JOIN products p ON p.id = oi.product_id
  WHERE oi.created_at >= NOW() - INTERVAL '30 days'
  GROUP BY p.category, p.name
)
SELECT category, name, revenue
FROM sales
ORDER BY category, revenue DESC
LIMIT 20;
''',
    'yaml': '''
name: flutter_monaco_editor
description: A complete Flutter wrapper for Monaco Editor.
version: 0.5.0
environment:
  sdk: ^3.6.0
dependencies:
  flutter:
    sdk: flutter
  web: ^1.1.0
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
''',
    'css': '''
.monaco-editor {
  --accent: #58a6ff;
  --bg: #0d1117;
}

.monaco-editor .line-numbers {
  color: rgba(255, 255, 255, 0.35);
}

.monaco-editor:hover {
  outline: 1px solid var(--accent);
  transition: outline 120ms ease-out;
}
''',
  };

  late final MonacoController _controller;
  String _language = 'dart';

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _samples[_language]!,
      language: _language,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _switch(String lang) async {
    setState(() => _language = lang);
    await _controller.setValue(_samples[lang]!);
    await _controller.setLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      demo: _demo,
      actions: [
        DropdownButton<String>(
          value: _language,
          items: _samples.keys
              .map((k) => DropdownMenuItem(value: k, child: Text(k)))
              .toList(),
          onChanged: (v) {
            if (v != null) _switch(v);
          },
        ),
        const SizedBox(width: 8),
      ],
      child: MonacoEditor(controller: _controller),
    );
  }
}
