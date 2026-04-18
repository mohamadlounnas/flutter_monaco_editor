import 'monaco_position.dart';

/// A half-open `[start, end)` range in the editor text buffer.
///
/// Matches Monaco's `IRange` interface. Positions are 1-based.
class MonacoRange {
  const MonacoRange({
    required this.startLine,
    required this.startColumn,
    required this.endLine,
    required this.endColumn,
  });

  factory MonacoRange.collapsed(MonacoPosition position) => MonacoRange(
        startLine: position.line,
        startColumn: position.column,
        endLine: position.line,
        endColumn: position.column,
      );

  factory MonacoRange.fromJson(Map<String, Object?> json) => MonacoRange(
        startLine: (json['startLine']! as num).toInt(),
        startColumn: (json['startColumn']! as num).toInt(),
        endLine: (json['endLine']! as num).toInt(),
        endColumn: (json['endColumn']! as num).toInt(),
      );

  final int startLine;
  final int startColumn;
  final int endLine;
  final int endColumn;

  MonacoPosition get start =>
      MonacoPosition(line: startLine, column: startColumn);

  MonacoPosition get end => MonacoPosition(line: endLine, column: endColumn);

  bool get isEmpty => startLine == endLine && startColumn == endColumn;

  Map<String, Object?> toJson() => {
        'startLine': startLine,
        'startColumn': startColumn,
        'endLine': endLine,
        'endColumn': endColumn,
      };

  @override
  bool operator ==(Object other) =>
      other is MonacoRange &&
      other.startLine == startLine &&
      other.startColumn == startColumn &&
      other.endLine == endLine &&
      other.endColumn == endColumn;

  @override
  int get hashCode => Object.hash(startLine, startColumn, endLine, endColumn);

  @override
  String toString() =>
      'MonacoRange($startLine:$startColumn-$endLine:$endColumn)';
}
