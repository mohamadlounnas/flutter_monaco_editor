import 'monaco_range.dart';

/// Maps to Monaco's `MarkerSeverity`.
enum MonacoMarkerSeverity {
  hint(1),
  info(2),
  warning(4),
  error(8);

  const MonacoMarkerSeverity(this.wireValue);
  final int wireValue;

  static MonacoMarkerSeverity fromWire(int value) => switch (value) {
        1 => MonacoMarkerSeverity.hint,
        2 => MonacoMarkerSeverity.info,
        4 => MonacoMarkerSeverity.warning,
        8 => MonacoMarkerSeverity.error,
        _ => throw ArgumentError('unknown MarkerSeverity wire value: $value'),
      };
}

/// Tags for marker presentation (Monaco's `MarkerTag` enum).
enum MonacoMarkerTag {
  unnecessary(1),
  deprecated(2);

  const MonacoMarkerTag(this.wireValue);
  final int wireValue;
}

/// A diagnostic attached to an editor model — error/warning/info squiggles,
/// shown in the minimap and overview ruler.
///
/// Corresponds to Monaco's `IMarkerData`.
class MonacoMarker {
  const MonacoMarker({
    required this.range,
    required this.severity,
    required this.message,
    this.source,
    this.code,
    this.codeHref,
    this.tags,
    this.relatedInformation,
  });

  final MonacoRange range;
  final MonacoMarkerSeverity severity;
  final String message;

  /// Human-readable origin of the diagnostic (e.g. `'dart analyzer'`).
  final String? source;

  /// A machine-readable code (e.g. `'UNDEFINED_IDENTIFIER'`).
  final String? code;

  /// Optional URL for [code] (rendered as a clickable link in the hover).
  final String? codeHref;

  final List<MonacoMarkerTag>? tags;

  /// Related code locations shown in the marker hover.
  final List<MonacoRelatedInformation>? relatedInformation;

  Map<String, Object?> toJson() => {
        ...range.toJson(),
        'severity': severity.wireValue,
        'message': message,
        if (source != null) 'source': source,
        if (code != null)
          'code': codeHref == null
              ? code
              : {'value': code, 'target': codeHref},
        if (tags != null)
          'tags': tags!.map((t) => t.wireValue).toList(),
        if (relatedInformation != null)
          'relatedInformation':
              relatedInformation!.map((r) => r.toJson()).toList(),
      };
}

class MonacoRelatedInformation {
  const MonacoRelatedInformation({
    required this.resource,
    required this.range,
    required this.message,
  });

  /// URI of the related resource. E.g. `file:///path/to/other.dart`.
  final String resource;
  final MonacoRange range;
  final String message;

  Map<String, Object?> toJson() => {
        'resource': resource,
        'message': message,
        ...range.toJson(),
      };
}
