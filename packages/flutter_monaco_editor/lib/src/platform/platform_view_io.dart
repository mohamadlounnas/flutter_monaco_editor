import 'dart:io';

import 'package:flutter/widgets.dart';

import '../desktop/desktop_platform_view.dart';
import '../monaco_controller.dart';
import '../native/native_platform_view.dart';

/// Non-web platform view dispatcher. Runtime-switches between the
/// webview_flutter (mobile) and webview_cef (desktop) implementations
/// based on the actual `Platform`.
class MonacoPlatformView extends StatelessWidget {
  const MonacoPlatformView({
    super.key,
    required this.controller,
    required this.onChanged,
    this.transparent = false,
  });

  final MonacoController controller;
  final ValueChanged<String>? onChanged;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return NativeMonacoPlatformView(
        controller: controller,
        onChanged: onChanged,
        transparent: transparent,
      );
    }
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return DesktopMonacoPlatformView(
        controller: controller,
        onChanged: onChanged,
        transparent: transparent,
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'flutter_monaco_editor: this platform has no Monaco transport.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
