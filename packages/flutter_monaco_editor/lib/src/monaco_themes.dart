import 'models/monaco_theme.dart';
import 'platform/bridge_acquire.dart';

/// Top-level access to Monaco's theme registry
/// (`monaco.editor.defineTheme`, `monaco.editor.setTheme`).
///
/// Themes are process-global. Defining one makes it available to every
/// editor in the document. Switching activates it for all editors
/// (Monaco's theme system is global, not per-editor).
class MonacoThemes {
  MonacoThemes._();

  /// Define a named theme. Overwrites any existing theme with the same
  /// [name].
  static Future<void> defineTheme(String name, MonacoTheme theme) async {
    final bridge = await acquireBridge();
    await bridge.invoke('editor.defineTheme', {
      'name': name,
      'theme': theme.toJson(),
    });
  }

  /// Activate a previously-defined theme (or any built-in theme:
  /// `'vs'`, `'vs-dark'`, `'hc-black'`, `'hc-light'`).
  static Future<void> setTheme(String name) async {
    final bridge = await acquireBridge();
    await bridge.invoke('editor.setTheme', {
      'editorId': '_global_',
      'theme': name,
    });
  }
}
