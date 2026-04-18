# Changelog

## 0.5.0-dev

### Phase 5 — Diff editor, multi-model, custom themes

- **Diff editor**: `MonacoDiffEditor` widget + `MonacoDiffController`. Side-by-side and inline modes via `renderSideBySide`. Separate original/modified content streams.
- **Custom themes**: `MonacoThemes.defineTheme(name, MonacoTheme(base, rules, colors))` + `MonacoThemes.setTheme(name)` wrapping `monaco.editor.defineTheme` / `setTheme`.
- **Multi-model**: `controller.createModel / switchToModel / disposeMonacoModel` for IDE-style tab switching (models are independent of editors).
- Bridge JS handlers for all three.

## 0.4.0

### Phase 4 — Native platform (webview)

- `flutter_monaco_editor_native` package: `MonacoNative.register()` installs webview-based hooks into the main package.
- `NativeMonacoBridge` over `webview_flutter` with `JavaScriptChannel` + `runJavaScript`.
- One WebView per editor (documented limitation).

## 0.3.0

### Phase 3 — Language providers

- `MonacoLanguages.register{Completion,Hover,SignatureHelp,Definition}Provider`.
- Dart-side async providers via JS ↔ Dart round-trip through the bridge.

## 0.2.0

### Phase 2 — Decorations, markers, actions, commands

- `deltaDecorations`, `setModelMarkers`, `addAction`, `addCommand`, `trigger`.
- Key constants: `MonacoKeyMod`, `MonacoKeyCode`.

## 0.1.0

### Phase 1 — Core

- 1.1 Package scaffolding + bundled Monaco 0.55.1.
- 1.2 Shared JS bridge + web transport via `dart:js_interop`.
- 1.3 `MonacoController` + event streams.
- 1.4 `MonacoEditorOptions` (~60 typed fields + `rawOptions` escape hatch).
