import 'dart:io';

import 'package:flutter/widgets.dart';

import '../monaco_controller.dart';
import '../native/native_platform_view.dart';

/// Non-web platform view dispatcher.
///
/// Android / iOS / macOS use `webview_flutter` (mobile-shaped WebView).
/// Linux / Windows are not yet supported — see README for current status
/// (we previously shipped a webview_cef integration but CEF proved
/// unstable on KDE Plasma and other Wayland-first desktops; a
/// WebKitGTK-based replacement is planned).
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
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return NativeMonacoPlatformView(
        controller: controller,
        onChanged: onChanged,
        transparent: transparent,
      );
    }
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'flutter_monaco_editor: Linux and Windows are not yet supported '
          'as native binaries.\n\nRun the web build instead: '
          '`flutter run -d chrome`, or serve the release build and use '
          '`chromium --app=<url>` for a desktop-like window.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
