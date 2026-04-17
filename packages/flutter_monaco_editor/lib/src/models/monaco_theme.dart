/// A custom Monaco theme — a set of tokenizer rules + semantic colors on
/// top of one of the built-in base themes.
///
/// See <https://microsoft.github.io/monaco-editor/docs.html#interfaces/editor.IStandaloneThemeData.html>.
class MonacoTheme {
  const MonacoTheme({
    required this.base,
    this.inherit = true,
    this.rules = const [],
    this.colors = const {},
  });

  /// One of: `'vs'`, `'vs-dark'`, `'hc-black'`, `'hc-light'`.
  final String base;

  /// When true, theme rules and colors inherit from [base] where not
  /// overridden.
  final bool inherit;

  /// Token-scope → color rules. Scopes follow the TextMate-grammar-based
  /// naming from VS Code (`'comment'`, `'keyword'`, `'string.quoted'`, ...).
  final List<MonacoTokenRule> rules;

  /// Semantic UI colors — e.g. `{'editor.background': '#1E1E2E',
  /// 'editor.foreground': '#CDD6F4'}`.
  final Map<String, String> colors;

  Map<String, Object?> toJson() => {
        'base': base,
        'inherit': inherit,
        'rules': rules.map((r) => r.toJson()).toList(),
        'colors': colors,
      };
}

/// A single tokenizer rule — what foreground/background/style to apply to
/// a given TextMate scope.
class MonacoTokenRule {
  const MonacoTokenRule({
    required this.token,
    this.foreground,
    this.background,
    this.fontStyle,
  });

  /// The TextMate scope (e.g. `'comment'`, `'keyword'`, `'string'`).
  final String token;

  /// Hex color **without the leading `#`** — e.g. `'6A9955'`.
  final String? foreground;
  final String? background;

  /// Space-separated font styles: `'italic'`, `'bold'`, `'underline'`,
  /// `'strikethrough'`.
  final String? fontStyle;

  Map<String, Object?> toJson() {
    final out = <String, Object?>{'token': token};
    if (foreground != null) out['foreground'] = foreground;
    if (background != null) out['background'] = background;
    if (fontStyle != null) out['fontStyle'] = fontStyle;
    return out;
  }
}
