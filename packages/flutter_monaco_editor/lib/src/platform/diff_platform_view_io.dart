import 'package:flutter/widgets.dart';

import '../monaco_diff_controller.dart';

/// Diff editor on non-web platforms — placeholder for now. A mobile /
/// desktop implementation using the same webview transport is tracked
/// for a future release.
class MonacoDiffPlatformView extends StatelessWidget {
  const MonacoDiffPlatformView({super.key, required this.controller});

  final MonacoDiffController controller;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'MonacoDiffEditor: only supported on web for now.\n'
          'Mobile / desktop diff support is a planned follow-up.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
