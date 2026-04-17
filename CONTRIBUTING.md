# Contributing

Contributions welcome. This project is in early development — the API surface is still moving, so please open an issue before large changes.

## Repository layout

```
packages/
  flutter_monaco_editor/              # main package (Dart API + web platform)
    lib/                              # Dart source
    assets/monaco-min/vs/             # bundled Monaco 0.55.1
    example/                          # example app
    test/                             # unit tests
```

## Getting started

```sh
cd packages/flutter_monaco_editor/example
flutter pub get
flutter run -d chrome
```

## Commit style

Commits are grouped by project phase (see [PLAN.md](PLAN.md)). Keep commits scoped to one phase where possible.

## Updating bundled Monaco

The Monaco version is pinned in `packages/flutter_monaco_editor/lib/src/monaco_version.dart`. To update:

```sh
cd /tmp && curl -sL "https://registry.npmjs.org/monaco-editor/-/monaco-editor-<VERSION>.tgz" | tar -xz
# replace packages/flutter_monaco_editor/assets/monaco-min/ with package/min/
# update monaco_version.dart
# update CHANGELOG.md
```

## Testing

```sh
flutter test                          # unit tests
flutter test integration_test         # integration tests (example app)
```

## Code style

Run `dart format .` and `flutter analyze` before submitting. Analyzer lints are in `analysis_options.yaml`.
