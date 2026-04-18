# flutter_monaco_editor_desktop

Desktop (Linux, Windows, macOS) implementation for
[`flutter_monaco_editor`](../flutter_monaco_editor). Uses
[`webview_cef`](https://pub.dev/packages/webview_cef) (Chromium Embedded
Framework) to host Monaco.

## Installation

```yaml
dependencies:
  flutter_monaco_editor: ^0.5.0
  flutter_monaco_editor_desktop: ^0.5.0
```

## Usage

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:flutter_monaco_editor_desktop/flutter_monaco_editor_desktop.dart';

void main() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    MonacoDesktop.register();
  }
  runApp(const MyApp());
}
```

Then use `MonacoEditor` / `MonacoDiffEditor` exactly as on web:

```dart
MonacoEditor(
  initialValue: 'void main() {}',
  language: 'dart',
)
```

## Architecture

- `webview_cef` ships CEF binaries that download to your user's machine
  the first time the app runs.
- Monaco assets (the bundled `vs/` tree + bridge JS) are served from an
  in-process HTTP server listening on `127.0.0.1` at an OS-assigned port.
- One CEF browser per `MonacoEditor` widget. The first bridge becomes
  the "shared" one used by global APIs (`MonacoLanguages` /
  `MonacoThemes`).

## Windows setup

`webview_cef` requires edits to `windows/runner/main.cpp`. See the
[webview_cef README](https://pub.dev/packages/webview_cef#windows) for
the exact calls (`initCEFProcesses`, `handleWndProcForCEF`).

Linux and macOS work with no extra setup.

## Limitations (0.5.x)

- Transparent WebView background: webview_cef doesn't expose a runtime
  hook for the underlying CEF browser's transparency. Use a transparent
  `MonacoTheme` instead — CEF's default page background is transparent,
  so the theme colors (`editor.background` = `#00000000`) visually
  blend with whatever Flutter widget sits behind.
- Language providers + custom themes register globally on the
  first-created bridge (same constraint as the mobile native package).

## License

MIT.
