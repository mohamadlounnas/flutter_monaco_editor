import 'package:flutter/widgets.dart';

import '../monaco_diff_controller.dart';

/// Stub for non-web platforms — the native package doesn't yet implement
/// the diff editor. Tracked for 0.5.0.
class MonacoDiffPlatformView extends StatelessWidget {
  const MonacoDiffPlatformView({super.key, required this.controller});

  final MonacoDiffController controller;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'MonacoDiffEditor: native support lands in a future release.\n'
          'Use web (Chrome) for the diff editor today.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
