import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'demo.dart';

class ActionsDemo extends StatefulWidget {
  const ActionsDemo({super.key});

  static Widget builder(BuildContext context) => const ActionsDemo();

  @override
  State<ActionsDemo> createState() => _ActionsDemoState();
}

class _ActionsDemoState extends State<ActionsDemo> {
  static const Demo _demo = Demo(
    label: 'Actions & Commands',
    blurb: 'Custom actions with keybindings, context-menu entries, and bare commands.',
    icon: Icons.keyboard,
    builder: ActionsDemo.builder,
  );

  static const String _code = '''
// This demo wires up:
//
//   Ctrl/Cmd+Shift+U    — "Uppercase current line" (action, in context menu)
//   Ctrl/Cmd+Shift+D    — "Duplicate current line" (action)
//   Ctrl/Cmd+K          — demo command (no palette entry)
//
// Try each: right-click the editor to see the actions in the
// "Modification" group of the context menu, or use the keybindings.

String greet(String name) {
  return 'hello, \$name!';
}

void main() {
  final names = ['alice', 'bob', 'carol'];
  for (final n in names) {
    print(greet(n));
  }
}
''';

  late final MonacoController _controller;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    _controller = MonacoController(
      initialValue: _code,
      language: 'dart',
    );
    unawaited(_wire());
  }

  Future<void> _wire() async {
    await _controller.ready;

    await _controller.addAction(MonacoAction(
      id: 'demo.uppercaseLine',
      label: 'Uppercase current line',
      keybindings: const [
        MonacoKeyMod.ctrlCmd | MonacoKeyMod.shift | MonacoKeyCode.keyU,
      ],
      contextMenuGroupId: '1_modification',
      contextMenuOrder: 1.5,
      run: (_) => _uppercaseLine(),
    ));

    await _controller.addAction(MonacoAction(
      id: 'demo.duplicateLine',
      label: 'Duplicate current line',
      keybindings: const [
        MonacoKeyMod.ctrlCmd | MonacoKeyMod.shift | MonacoKeyCode.keyD,
      ],
      contextMenuGroupId: '1_modification',
      contextMenuOrder: 1.6,
      run: (_) => _duplicateLine(),
    ));

    await _controller.addCommand(
      MonacoKeyMod.ctrlCmd | MonacoKeyCode.keyK,
      () => _pushLog('Ctrl/Cmd+K fired'),
    );
  }

  void _pushLog(String msg) {
    if (!mounted) return;
    setState(() {
      _log.insert(0, msg);
      if (_log.length > 20) _log.removeLast();
    });
  }

  Future<void> _uppercaseLine() async {
    final pos = _controller.position;
    if (pos == null) return;
    final lines = _controller.value.split('\n');
    final idx = pos.line - 1;
    if (idx < 0 || idx >= lines.length) return;
    lines[idx] = lines[idx].toUpperCase();
    await _controller.setValue(lines.join('\n'));
    _pushLog('Uppercased line ${pos.line}');
  }

  Future<void> _duplicateLine() async {
    final pos = _controller.position;
    if (pos == null) return;
    final lines = _controller.value.split('\n');
    final idx = pos.line - 1;
    if (idx < 0 || idx >= lines.length) return;
    lines.insert(idx + 1, lines[idx]);
    await _controller.setValue(lines.join('\n'));
    _pushLog('Duplicated line ${pos.line}');
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
      child: Column(
        children: [
          Expanded(child: MonacoEditor(controller: _controller)),
          SizedBox(
            height: 120,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'event log',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: _log.isEmpty
                        ? Text(
                            'Waiting for actions / commands…',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          )
                        : ListView(
                            children: _log
                                .map((m) => Text(
                                      m,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12,
                                      ),
                                    ))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
