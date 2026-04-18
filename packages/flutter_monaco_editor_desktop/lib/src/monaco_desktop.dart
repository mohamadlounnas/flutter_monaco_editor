import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';

import 'desktop_monaco_bridge.dart';
import 'desktop_platform_view.dart';

/// Entrypoint for wiring the desktop transport into
/// `flutter_monaco_editor`. Call [register] once before `runApp()`:
///
/// ```dart
/// import 'dart:io';
/// import 'package:flutter_monaco_editor_desktop/flutter_monaco_editor_desktop.dart';
///
/// void main() {
///   if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
///     MonacoDesktop.register();
///   }
///   runApp(const MyApp());
/// }
/// ```
///
/// No-op on web — the main package uses its own js_interop transport there.
///
/// Note on `transparent: true`: webview_cef does not currently expose a
/// runtime hook for the underlying CEF browser background. The flag is
/// accepted for API symmetry but does not affect the WebView layer — use
/// a transparent `MonacoTheme` (see `MonacoTheme.transparent()`) to
/// achieve the visual effect; CEF blends the Flutter layer behind it
/// through its transparent page background.
class MonacoDesktop {
  const MonacoDesktop._();

  static bool _registered = false;

  static void register() {
    if (_registered) return;
    _registered = true;
    MonacoPlatformHooks.install(
      bridgeFactory: DesktopMonacoBridge.instance,
      platformViewFactory: (controller, onChanged, transparent) =>
          DesktopMonacoPlatformView(
        controller: controller,
        onChanged: onChanged,
        transparent: transparent,
      ),
    );
  }

  static bool get isRegistered => _registered;
}
