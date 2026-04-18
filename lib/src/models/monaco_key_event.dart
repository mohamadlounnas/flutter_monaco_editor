/// A keyboard event fired by Monaco's `onKeyDown` / `onKeyUp` hooks.
///
/// Monaco's `IKeyboardEvent` includes its own `keyCode` enum (see
/// <https://microsoft.github.io/monaco-editor/typedoc/enums/KeyCode.html>)
/// as well as the underlying browser `KeyboardEvent` fields.
///
/// `preventDefault` handling is not wired through the event payload (it
/// would require a synchronous JS→Dart→JS round-trip that the bridge
/// protocol does not support). Register an action or command instead —
/// see Phase 2's `MonacoAction` API.
class MonacoKeyEvent {
  const MonacoKeyEvent({
    required this.key,
    required this.code,
    required this.keyCode,
    required this.ctrl,
    required this.shift,
    required this.alt,
    required this.meta,
  });

  factory MonacoKeyEvent.fromJson(Map<String, Object?> json) => MonacoKeyEvent(
        key: json['key'] as String? ?? '',
        code: json['code'] as String? ?? '',
        keyCode: (json['keyCode'] as num?)?.toInt() ?? 0,
        ctrl: json['ctrl'] as bool? ?? false,
        shift: json['shift'] as bool? ?? false,
        alt: json['alt'] as bool? ?? false,
        meta: json['meta'] as bool? ?? false,
      );

  /// `KeyboardEvent.key` — e.g. `'a'`, `'Enter'`, `'ArrowUp'`.
  final String key;

  /// `KeyboardEvent.code` — e.g. `'KeyA'`, `'Enter'`, `'ArrowUp'`.
  final String code;

  /// Monaco's `KeyCode` enum value.
  final int keyCode;

  final bool ctrl;
  final bool shift;
  final bool alt;
  final bool meta;

  @override
  String toString() {
    final mods = [
      if (ctrl) 'Ctrl',
      if (shift) 'Shift',
      if (alt) 'Alt',
      if (meta) 'Meta',
    ].join('+');
    return mods.isEmpty
        ? 'MonacoKeyEvent($code)'
        : 'MonacoKeyEvent($mods+$code)';
  }
}
