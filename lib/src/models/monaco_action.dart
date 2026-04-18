/// Called when a Monaco action registered via `addAction` fires. The
/// callback receives the action id for convenience when one handler is
/// reused for multiple actions.
typedef MonacoActionCallback = void Function(String actionId);

/// A user-registered editor action — shows in the command palette and the
/// context menu, and can be bound to keybindings.
///
/// Corresponds to Monaco's `IActionDescriptor`.
class MonacoAction {
  const MonacoAction({
    required this.id,
    required this.label,
    required this.run,
    this.keybindings = const [],
    this.contextMenuGroupId,
    this.contextMenuOrder,
    this.precondition,
    this.keybindingContext,
  });

  /// Unique id. Use a reverse-DNS-like string (`com.yourapp.save`).
  final String id;

  /// Human-readable label shown in the command palette and context menu.
  final String label;

  /// Combine `MonacoKeyMod` and `MonacoKeyCode` with bitwise OR. Multiple
  /// bindings for the same action are supported; each must fire the
  /// action independently.
  final List<int> keybindings;

  /// Context menu group id — `'navigation'`, `'1_modification'`, ... or a
  /// custom id. Null hides from the context menu.
  final String? contextMenuGroupId;

  /// Ordering within [contextMenuGroupId]. Lower sorts earlier.
  final double? contextMenuOrder;

  /// Monaco context-key expression gating when the action is enabled.
  final String? precondition;

  /// Monaco context-key expression gating when the keybinding is active.
  final String? keybindingContext;

  /// Callback invoked when the action fires (via keybinding, command
  /// palette, or context menu).
  final MonacoActionCallback run;

  Map<String, Object?> toRegistrationJson() => {
        'id': id,
        'label': label,
        'keybindings': keybindings,
        if (contextMenuGroupId != null)
          'contextMenuGroupId': contextMenuGroupId,
        if (contextMenuOrder != null) 'contextMenuOrder': contextMenuOrder,
        if (precondition != null) 'precondition': precondition,
        if (keybindingContext != null) 'keybindingContext': keybindingContext,
      };
}
