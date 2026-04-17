import 'package:flutter/widgets.dart';

import '../monaco_controller.dart';

/// Non-web stub. Phase 4 replaces this with a webview-backed implementation.
class MonacoPlatformView extends StatelessWidget {
  const MonacoPlatformView({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final MonacoController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'flutter_monaco_editor: this platform is not yet supported.\n'
          'Run on web (Chrome) for now — native support arrives in Phase 4.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
