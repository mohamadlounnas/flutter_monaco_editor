import 'monaco_position.dart';
import 'monaco_range.dart';

/// A directional selection: like a [MonacoRange] but with an anchor point
/// ("selection start") and an active point ("position" — where the cursor is).
///
/// Matches Monaco's `ISelection` / `Selection` types.
class MonacoSelection extends MonacoRange {
  const MonacoSelection({
    required super.startLine,
    required super.startColumn,
    required super.endLine,
    required super.endColumn,
    required this.selectionStartLine,
    required this.selectionStartColumn,
    required this.positionLine,
    required this.positionColumn,
  });

  /// A collapsed (zero-length) selection at [position].
  factory MonacoSelection.collapsed(MonacoPosition position) => MonacoSelection(
        startLine: position.line,
        startColumn: position.column,
        endLine: position.line,
        endColumn: position.column,
        selectionStartLine: position.line,
        selectionStartColumn: position.column,
        positionLine: position.line,
        positionColumn: position.column,
      );

  factory MonacoSelection.fromJson(Map<String, Object?> json) =>
      MonacoSelection(
        startLine: (json['startLine']! as num).toInt(),
        startColumn: (json['startColumn']! as num).toInt(),
        endLine: (json['endLine']! as num).toInt(),
        endColumn: (json['endColumn']! as num).toInt(),
        selectionStartLine: (json['selectionStartLine']! as num).toInt(),
        selectionStartColumn:
            (json['selectionStartColumn']! as num).toInt(),
        positionLine: (json['positionLine']! as num).toInt(),
        positionColumn: (json['positionColumn']! as num).toInt(),
      );

  final int selectionStartLine;
  final int selectionStartColumn;
  final int positionLine;
  final int positionColumn;

  MonacoPosition get selectionStart => MonacoPosition(
        line: selectionStartLine,
        column: selectionStartColumn,
      );

  MonacoPosition get position =>
      MonacoPosition(line: positionLine, column: positionColumn);

  /// True if the cursor is placed before the anchor — i.e. the user selected
  /// backward.
  bool get isReversed =>
      positionLine < selectionStartLine ||
      (positionLine == selectionStartLine &&
          positionColumn < selectionStartColumn);

  @override
  Map<String, Object?> toJson() => {
        ...super.toJson(),
        'selectionStartLine': selectionStartLine,
        'selectionStartColumn': selectionStartColumn,
        'positionLine': positionLine,
        'positionColumn': positionColumn,
      };

  @override
  bool operator ==(Object other) =>
      other is MonacoSelection &&
      super == other &&
      other.selectionStartLine == selectionStartLine &&
      other.selectionStartColumn == selectionStartColumn &&
      other.positionLine == positionLine &&
      other.positionColumn == positionColumn;

  @override
  int get hashCode => Object.hash(
        super.hashCode,
        selectionStartLine,
        selectionStartColumn,
        positionLine,
        positionColumn,
      );

  @override
  String toString() =>
      'MonacoSelection($startLine:$startColumn-$endLine:$endColumn, '
      'anchor=$selectionStartLine:$selectionStartColumn, '
      'pos=$positionLine:$positionColumn)';
}
