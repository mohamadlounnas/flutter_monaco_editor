# flutter_monaco_editor

A complete Flutter wrapper for Monaco Editor that works on all platforms (Web, Android, iOS, macOS, Windows, Linux) with the full Monaco API exposed through a unified Dart interface.

## Why

Existing Flutter Monaco packages are either web-only (`monaco_editor`) or missing web support (`flutter_monaco`). No package covers all platforms with the complete API. Monaco is the editor behind VS Code — it deserves a proper Flutter integration.

## Architecture

```
flutter_monaco_editor/          # Main package (Dart API + Web implementation)
flutter_monaco_editor_native/   # Native platform implementation (webview-based)
```

### Platform Strategy

| Platform | Hosting | Communication |
|----------|---------|---------------|
| Web | `HtmlElementView` — Monaco loaded directly in DOM | `dart:js_interop` direct calls |
| Android/iOS | `webview_flutter` loading local HTML asset | WebView JavaScript channels |
| macOS/Windows/Linux | `webview_flutter` loading local HTML asset | WebView JavaScript channels |

The key insight: Monaco's JavaScript API is identical regardless of how it's hosted. The Dart API is the same on all platforms — only the JS bridge differs.

### Core Design

```
MonacoEditor (Widget)
  ├── MonacoController (Dart API surface)
  │     ├── content get/set
  │     ├── language get/set
  │     ├── theme get/set
  │     ├── options (all Monaco IEditorOptions)
  │     ├── decorations
  │     ├── markers (errors, warnings)
  │     ├── actions (custom keybindings)
  │     ├── commands
  │     ├── IntelliSense providers
  │     └── events (onChange, onCursor, onScroll, etc.)
  └── MonacoBridge (platform-specific)
        ├── WebBridge (js_interop)
        └── NativeBridge (webview message channel)
```

## Phase 1: Core Package + Web Platform

**Goal**: A working Monaco editor widget on Flutter Web with the essential API.

### 1.1 Project Setup
- Create Flutter package with `flutter create --template=package flutter_monaco_editor`
- Set up example app for testing
- Bundle Monaco Editor assets (from CDN or local)
  - `monaco-editor/min/vs/` directory
  - Version-pinned (e.g. 0.52.0)

### 1.2 Web Platform Implementation
- `HtmlElementView` with a unique `<div>` for each editor instance
- JavaScript interop layer (`monaco_bridge.js`):
  - `createEditor(elementId, options)` → returns editor instance ID
  - `disposeEditor(id)`
  - `getValue(id)` / `setValue(id, value)`
  - `setLanguage(id, lang)`
  - `setTheme(theme)`
  - `setOptions(id, options)`
  - `getPosition(id)` / `setPosition(id, line, col)`
  - `getSelection(id)` / `setSelection(id, range)`
  - `revealLine(id, line)`
  - `focus(id)`
  - Event callbacks via `postMessage` or JS function references:
    - `onDidChangeContent`
    - `onDidChangeCursorPosition`
    - `onDidChangeCursorSelection`
    - `onDidScrollChange`
    - `onDidFocusEditorText`
    - `onDidBlurEditorText`
    - `onKeyDown` / `onKeyUp`
- Dart `WebMonacoBridge` class wrapping JS interop calls
- Multiple independent editor instances supported

### 1.3 MonacoController (Dart API)
```dart
class MonacoController {
  /// Current editor content
  String get value;
  set value(String text);
  
  /// Language mode
  String get language;
  set language(String lang);
  
  /// Editor theme (vs, vs-dark, hc-black, hc-light, or custom)
  static void setTheme(String theme);
  
  /// Cursor position
  MonacoPosition get position;
  set position(MonacoPosition pos);
  
  /// Selection
  MonacoRange? get selection;
  set selection(MonacoRange? range);
  
  /// Scroll to line
  void revealLine(int line);
  void revealLineInCenter(int line);
  
  /// Focus
  void focus();
  
  /// Read-only mode
  bool get readOnly;
  set readOnly(bool value);
  
  /// All editor options (type-safe)
  void updateOptions(MonacoEditorOptions options);
  
  /// Event streams
  Stream<String> get onDidChangeContent;
  Stream<MonacoPosition> get onDidChangeCursorPosition;
  Stream<MonacoRange> get onDidChangeCursorSelection;
  Stream<MonacoScrollEvent> get onDidScroll;
  Stream<void> get onDidFocus;
  Stream<void> get onDidBlur;
  
  /// Dispose
  void dispose();
}
```

### 1.4 MonacoEditor Widget
```dart
class MonacoEditor extends StatefulWidget {
  final MonacoController controller;
  final String? initialValue;
  final String language;
  final String theme;
  final MonacoEditorOptions? options;
  final ValueChanged<String>? onChanged;
  
  /// Create with default controller
  const MonacoEditor({
    this.initialValue,
    this.language = 'plaintext',
    this.theme = 'vs-dark',
    this.options,
    this.onChanged,
  });
  
  /// Create with explicit controller (for programmatic access)
  const MonacoEditor.controlled({
    required this.controller,
    this.options,
    this.onChanged,
  });
}
```

### 1.5 Type-Safe Options
```dart
class MonacoEditorOptions {
  final bool? readOnly;
  final bool? minimap;
  final bool? lineNumbers;         // on, off, relative, interval
  final bool? wordWrap;            // on, off, wordWrapColumn, bounded
  final int? fontSize;
  final String? fontFamily;
  final int? tabSize;
  final bool? insertSpaces;
  final bool? autoIndent;
  final bool? formatOnPaste;
  final bool? formatOnType;
  final bool? folding;
  final bool? bracketPairColorization;
  final bool? renderWhitespace;    // none, boundary, selection, trailing, all
  final bool? scrollBeyondLastLine;
  final bool? smoothScrolling;
  final bool? cursorBlinking;      // blink, smooth, phase, expand, solid
  final bool? cursorSmoothCaretAnimation;
  final String? cursorStyle;       // line, block, underline, etc.
  // ... all IEditorOptions mapped
}
```

## Phase 2: Decorations, Markers, and Actions

### 2.1 Decorations (inline highlights, gutter icons)
```dart
class MonacoDecoration {
  final MonacoRange range;
  final MonacoDecorationOptions options; // className, glyphMarginClassName, inlineClassName, etc.
}

// On controller:
List<String> deltaDecorations(List<String> oldIds, List<MonacoDecoration> newDecorations);
```

### 2.2 Markers (error/warning squiggles)
```dart
class MonacoMarker {
  final MonacoRange range;
  final MonacoMarkerSeverity severity; // Error, Warning, Info, Hint
  final String message;
  final String? source;
  final String? code;
}

// On controller:
void setModelMarkers(List<MonacoMarker> markers, {String owner = 'default'});
void clearModelMarkers({String owner = 'default'});
```

### 2.3 Custom Actions and Keybindings
```dart
class MonacoAction {
  final String id;
  final String label;
  final List<MonacoKeyMod> keybindings;
  final void Function() run;
}

// On controller:
void addAction(MonacoAction action);
void addCommand(MonacoKeyMod keybinding, void Function() handler);
```

## Phase 3: IntelliSense and Language Features

### 3.1 Completion Provider
```dart
abstract class MonacoCompletionProvider {
  Future<List<MonacoCompletionItem>> provideCompletionItems(
    String model,
    MonacoPosition position,
    MonacoCompletionContext context,
  );
}

class MonacoCompletionItem {
  final String label;
  final MonacoCompletionKind kind; // Method, Function, Variable, Class, etc.
  final String? detail;
  final String? documentation;
  final String insertText;
  final MonacoInsertTextRule? insertTextRules; // InsertAsSnippet, etc.
  final MonacoRange? range;
}
```

### 3.2 Hover Provider
```dart
abstract class MonacoHoverProvider {
  Future<MonacoHover?> provideHover(String model, MonacoPosition position);
}
```

### 3.3 Signature Help Provider
```dart
abstract class MonacoSignatureHelpProvider {
  Future<MonacoSignatureHelp?> provideSignatureHelp(
    String model,
    MonacoPosition position,
    MonacoSignatureHelpContext context,
  );
}
```

### 3.4 Definition/Reference Provider
```dart
abstract class MonacoDefinitionProvider {
  Future<List<MonacoLocation>?> provideDefinition(String model, MonacoPosition position);
}
```

## Phase 4: Native Platform Implementation

### 4.1 Webview Bridge
- Shared HTML host page (`monaco_host.html`) bundled as asset
- Loads Monaco from local assets (no CDN dependency)
- JS bridge layer identical API to web bridge
- Communication via `WebViewController.runJavaScript()` + `JavaScriptChannel`
- Bidirectional: Dart→JS via `runJavaScript`, JS→Dart via channel messages

### 4.2 Platform Package
- `flutter_monaco_editor_native` package
- Depends on `webview_flutter` (^4.0)
- Registers as platform implementation via federated plugins
- Android, iOS, macOS, Windows, Linux support

### 4.3 Asset Bundling
- Monaco Editor JS/CSS bundled in package assets
- No network dependency at runtime
- Version pinned, upgradeable via package update

## Phase 5: Advanced Features

### 5.1 Diff Editor
```dart
class MonacoDiffEditor extends StatefulWidget {
  final String original;
  final String modified;
  final String language;
  final bool? renderSideBySide;
  final bool? enableSplitViewResizing;
}
```

### 5.2 Multi-Model Support
- Multiple files/buffers per editor instance
- Tab-like model switching
- Per-model undo/redo history preserved

### 5.3 Custom Themes
```dart
MonacoEditor.defineTheme('myTheme', MonacoThemeData(
  base: 'vs-dark',
  inherit: true,
  rules: [
    MonacoTokenRule(token: 'comment', foreground: '6A9955'),
    MonacoTokenRule(token: 'keyword', foreground: 'C586C0', fontStyle: 'bold'),
  ],
  colors: {
    'editor.background': '#1E1E2E',
    'editor.foreground': '#CDD6F4',
  },
));
```

### 5.4 Collaboration Support (optional)
- Cursor decoration API enables showing remote cursors
- Content change events enable OT/CRDT sync
- Not built-in, but the API supports building it on top

## File Structure

```
flutter_monaco_editor/
  lib/
    flutter_monaco_editor.dart          # Public API barrel
    src/
      monaco_editor.dart                # Widget
      monaco_controller.dart            # Controller
      monaco_bridge.dart                # Abstract bridge
      web/
        web_monaco_bridge.dart          # Web JS interop implementation
        monaco_bridge.js                # JS bridge layer
      models/
        monaco_position.dart
        monaco_range.dart
        monaco_options.dart
        monaco_decoration.dart
        monaco_marker.dart
        monaco_action.dart
        monaco_completion.dart
        monaco_hover.dart
        monaco_theme.dart
  assets/
    monaco/                             # Bundled Monaco Editor
      min/vs/
        loader.js
        editor/editor.main.js
        ...
  example/
    lib/main.dart                       # Demo app
  test/
  pubspec.yaml
  
flutter_monaco_editor_native/
  lib/
    src/
      native_monaco_bridge.dart         # Webview implementation
      monaco_host.html                  # HTML host page
  pubspec.yaml
```

## API Parity Target

The goal is to expose **every** Monaco Editor API through Dart, not just the common subset. If Monaco can do it, this package should expose it. The mapping is:

| Monaco JS API | Dart API |
|---|---|
| `monaco.editor.create()` | `MonacoEditor()` widget |
| `editor.getValue()` / `setValue()` | `controller.value` |
| `editor.getModel().getLanguageId()` | `controller.language` |
| `editor.updateOptions()` | `controller.updateOptions()` |
| `editor.deltaDecorations()` | `controller.deltaDecorations()` |
| `monaco.editor.setModelMarkers()` | `controller.setModelMarkers()` |
| `editor.addAction()` | `controller.addAction()` |
| `editor.addCommand()` | `controller.addCommand()` |
| `monaco.languages.registerCompletionItemProvider()` | `controller.registerCompletionProvider()` |
| `monaco.languages.registerHoverProvider()` | `controller.registerHoverProvider()` |
| `monaco.editor.createDiffEditor()` | `MonacoDiffEditor()` widget |
| `monaco.editor.defineTheme()` | `MonacoEditor.defineTheme()` |
| `editor.onDidChangeModelContent` | `controller.onDidChangeContent` |
| `editor.onDidChangeCursorPosition` | `controller.onDidChangeCursorPosition` |

## Build Order

1. **Phase 1** first — get a working editor on web with the core API
2. Ship to pub.dev as 0.1.0
3. **Phase 2** — decorations and markers (needed for error display)
4. **Phase 3** — IntelliSense (needed for code intelligence)
5. Ship as 0.2.0
6. **Phase 4** — native platforms
7. Ship as 0.3.0
8. **Phase 5** — diff editor, themes, advanced features
9. Ship as 1.0.0

## Testing Strategy

- Unit tests for Dart API layer (mock bridge)
- Integration tests on web using `flutter_test` + `integration_test`
- Visual regression tests for rendering
- Example app covering all API features
