# flutter_monaco_editor — example gallery

A multi-demo Flutter app showcasing every major feature of
`flutter_monaco_editor`.

## Running (web)

```sh
cd packages/flutter_monaco_editor/example
flutter pub get
flutter run -d chrome
```

The app opens with a sidebar listing eight demos. Click any entry to see
that feature in action.

## Demos

| Demo | What it shows |
|---|---|
| **Basic** | Minimal editor, read-only toggle, theme dropdown, live cursor position |
| **Languages** | Switch syntax highlighting between Dart, JavaScript, TypeScript, Python, JSON, HTML, Markdown, SQL, YAML, CSS |
| **Options** | Live toggles for font size, tab size, word wrap, minimap, line numbers, cursor style, smooth caret — applied via `controller.updateOptions()` |
| **Diagnostics** | Error / warning / info markers + inline highlight + whole-line decoration + gutter glyph icon |
| **Actions & Commands** | `Ctrl/Cmd+Shift+U` uppercase line, `Ctrl/Cmd+Shift+D` duplicate line, `Ctrl/Cmd+K` bare command. Event log at the bottom |
| **IntelliSense** | Dart-side completion provider (try typing `pr`, `fl`, `Fu`) + hover provider (hover `print`, `Future`, `main`, `Monaco`) |
| **Diff Editor** | `MonacoDiffEditor` side-by-side vs. inline mode |
| **Custom Themes** | `MonacoThemes.defineTheme` registering Catppuccin Mocha, Solarized Warm, Tokyo Night; dropdown to switch globally |

## Notes

- On first load Monaco weighs ~16 MB of assets (the bundled `vs/` tree),
  plus CanvasKit if Flutter's web renderer is set to CanvasKit. Subsequent
  navigations in the gallery reuse a single in-page Monaco runtime.
- The Diagnostics demo requires the CSS classes in `web/index.html` —
  they style the decorations Monaco emits for inline highlights and the
  gutter glyph. Real apps add their own classes alongside.
- Native platforms (Android, iOS, macOS, Windows, Linux) require
  `flutter_monaco_editor_native` plus `MonacoNative.register()` in
  `main()` — see that package's README.
