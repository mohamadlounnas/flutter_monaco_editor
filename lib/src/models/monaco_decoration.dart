import 'monaco_range.dart';

/// Whether a decoration's range expands or shrinks when text is inserted at
/// its edges. Mirrors Monaco's `TrackedRangeStickiness`.
enum MonacoDecorationStickiness {
  alwaysGrowsWhenTypingAtEdges(0),
  neverGrowsWhenTypingAtEdges(1),
  growsOnlyWhenTypingBefore(2),
  growsOnlyWhenTypingAfter(3);

  const MonacoDecorationStickiness(this.wireValue);
  final int wireValue;
}

/// Position of a decoration in Monaco's overview ruler (the thin band on
/// the right of the editor next to the vertical scrollbar).
enum MonacoOverviewRulerLane {
  left(1),
  center(2),
  right(4),
  full(7);

  const MonacoOverviewRulerLane(this.wireValue);
  final int wireValue;
}

/// Position of a decoration in the minimap.
enum MonacoMinimapPosition {
  inline(1),
  gutter(2);

  const MonacoMinimapPosition(this.wireValue);
  final int wireValue;
}

class MonacoOverviewRuler {
  const MonacoOverviewRuler({
    required this.color,
    this.darkColor,
    this.position,
  });

  final String color;
  final String? darkColor;
  final MonacoOverviewRulerLane? position;

  Map<String, Object?> toJson() => {
        'color': color,
        if (darkColor != null) 'darkColor': darkColor,
        if (position != null) 'position': position!.wireValue,
      };
}

class MonacoMinimapDecoration {
  const MonacoMinimapDecoration({required this.color, this.position});

  final String color;
  final MonacoMinimapPosition? position;

  Map<String, Object?> toJson() => {
        'color': color,
        if (position != null) 'position': position!.wireValue,
      };
}

/// Styling options for a decoration — corresponds to a subset of Monaco's
/// `IModelDecorationOptions`.
///
/// `className` / `inlineClassName` / etc. reference CSS classes that must
/// be defined in the host app's stylesheet. For escape-hatch access to
/// fields not surfaced here, use [rawOptions].
class MonacoDecorationOptions {
  const MonacoDecorationOptions({
    this.className,
    this.inlineClassName,
    this.glyphMarginClassName,
    this.marginClassName,
    this.linesDecorationsClassName,
    this.firstLineDecorationClassName,
    this.afterContentClassName,
    this.beforeContentClassName,
    this.isWholeLine,
    this.stickiness,
    this.zIndex,
    this.hoverMessage,
    this.glyphMarginHoverMessage,
    this.overviewRuler,
    this.minimap,
    this.showIfCollapsed,
    this.rawOptions,
  });

  final String? className;
  final String? inlineClassName;
  final String? glyphMarginClassName;
  final String? marginClassName;
  final String? linesDecorationsClassName;
  final String? firstLineDecorationClassName;
  final String? afterContentClassName;
  final String? beforeContentClassName;
  final bool? isWholeLine;
  final MonacoDecorationStickiness? stickiness;
  final int? zIndex;

  /// Rendered as a Markdown hover when the mouse is over the decoration.
  final String? hoverMessage;
  final String? glyphMarginHoverMessage;

  final MonacoOverviewRuler? overviewRuler;
  final MonacoMinimapDecoration? minimap;

  final bool? showIfCollapsed;

  final Map<String, Object?>? rawOptions;

  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (className != null) out['className'] = className;
    if (inlineClassName != null) out['inlineClassName'] = inlineClassName;
    if (glyphMarginClassName != null) {
      out['glyphMarginClassName'] = glyphMarginClassName;
    }
    if (marginClassName != null) out['marginClassName'] = marginClassName;
    if (linesDecorationsClassName != null) {
      out['linesDecorationsClassName'] = linesDecorationsClassName;
    }
    if (firstLineDecorationClassName != null) {
      out['firstLineDecorationClassName'] = firstLineDecorationClassName;
    }
    if (afterContentClassName != null) {
      out['afterContentClassName'] = afterContentClassName;
    }
    if (beforeContentClassName != null) {
      out['beforeContentClassName'] = beforeContentClassName;
    }
    if (isWholeLine != null) out['isWholeLine'] = isWholeLine;
    if (stickiness != null) out['stickiness'] = stickiness!.wireValue;
    if (zIndex != null) out['zIndex'] = zIndex;
    if (hoverMessage != null) out['hoverMessage'] = {'value': hoverMessage};
    if (glyphMarginHoverMessage != null) {
      out['glyphMarginHoverMessage'] = {'value': glyphMarginHoverMessage};
    }
    if (overviewRuler != null) out['overviewRuler'] = overviewRuler!.toJson();
    if (minimap != null) out['minimap'] = minimap!.toJson();
    if (showIfCollapsed != null) out['showIfCollapsed'] = showIfCollapsed;
    if (rawOptions != null) out.addAll(rawOptions!);
    return out;
  }
}

class MonacoDecoration {
  const MonacoDecoration({required this.range, required this.options});

  final MonacoRange range;
  final MonacoDecorationOptions options;

  Map<String, Object?> toJson() => {
        'range': range.toJson(),
        'options': options.toJson(),
      };
}
