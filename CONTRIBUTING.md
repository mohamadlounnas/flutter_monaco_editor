# Contributing

Contributions welcome. This project is in early development — the API surface is still moving, so please open an issue before large changes.

## Repository layout

```
flutter_monaco_editor/                  # the package — repo root
  lib/                                  # Dart source
    src/
      web/                              # web transport (js_interop)
      native/                           # Android/iOS transport (webview_flutter)
      desktop/                          # Linux/Windows/macOS transport (webview_cef)
      bridge/                           # shared MonacoBridge contract
      models/                           # position, range, marker, ...
      options/                          # MonacoEditorOptions + nested
      providers/                        # completion, hover, signature, definition
      platform/                         # conditional-import dispatchers
  assets/
    bridge/                             # shared JS bridge + host HTML
    monaco-min/vs/                      # bundled Monaco 0.55.1
  example/                              # gallery example app
  test/                                 # unit tests
```

## Getting started

```sh
flutter pub get
cd example
flutter run -d chrome     # or: linux, macos, android, ios
```

## Commit style

Commits are grouped by project phase (see [PLAN.md](PLAN.md)). Keep commits scoped to one phase where possible.

## Updating bundled Monaco

The Monaco version is pinned in `lib/src/monaco_version.dart`. To update:

```sh
cd /tmp && curl -sL "https://registry.npmjs.org/monaco-editor/-/monaco-editor-<VERSION>.tgz" | tar -xz
# replace <repo>/assets/monaco-min/ with package/min/
# update lib/src/monaco_version.dart
# update CHANGELOG.md
```

## Testing

```sh
flutter test
```

## Code style

Run `dart format .` and `flutter analyze` before submitting. Analyzer lints are in `analysis_options.yaml`.
