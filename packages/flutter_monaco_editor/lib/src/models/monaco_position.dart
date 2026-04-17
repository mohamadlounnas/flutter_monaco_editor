/// A 1-based `(lineNumber, column)` position in the editor text buffer.
///
/// Matches Monaco's `IPosition` interface semantics.
class MonacoPosition {
  const MonacoPosition({required this.line, required this.column});

  /// 1-based line number.
  final int line;

  /// 1-based column. Column 1 is before the first character.
  final int column;

  factory MonacoPosition.fromJson(Map<String, Object?> json) => MonacoPosition(
        line: (json['line']! as num).toInt(),
        column: (json['column']! as num).toInt(),
      );

  Map<String, Object?> toJson() => {'line': line, 'column': column};

  MonacoPosition copyWith({int? line, int? column}) =>
      MonacoPosition(line: line ?? this.line, column: column ?? this.column);

  @override
  bool operator ==(Object other) =>
      other is MonacoPosition && other.line == line && other.column == column;

  @override
  int get hashCode => Object.hash(line, column);

  @override
  String toString() => 'MonacoPosition($line:$column)';
}
