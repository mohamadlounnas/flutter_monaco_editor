/// Desktop (Linux, Windows, macOS) implementation for
/// `flutter_monaco_editor` — hosts Monaco inside a Chromium Embedded
/// Framework webview via `webview_cef`.
///
/// Call [MonacoDesktop.register] once before `runApp()` to install
/// desktop hooks into the main package.
library;

export 'src/desktop_monaco_bridge.dart';
export 'src/desktop_platform_view.dart';
export 'src/monaco_desktop.dart';
