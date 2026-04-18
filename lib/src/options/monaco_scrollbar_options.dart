import 'enums.dart';

/// Corresponds to Monaco's `IEditorScrollbarOptions`.
class MonacoScrollbarOptions {
  const MonacoScrollbarOptions({
    this.vertical,
    this.horizontal,
    this.arrowSize,
    this.useShadows,
    this.verticalHasArrows,
    this.horizontalHasArrows,
    this.handleMouseWheel,
    this.alwaysConsumeMouseWheel,
    this.horizontalScrollbarSize,
    this.verticalScrollbarSize,
    this.verticalSliderSize,
    this.horizontalSliderSize,
    this.scrollByPage,
    this.ignoreHorizontalScrollbarInContentHeight,
  });

  final MonacoScrollbarVisibility? vertical;
  final MonacoScrollbarVisibility? horizontal;
  final int? arrowSize;
  final bool? useShadows;
  final bool? verticalHasArrows;
  final bool? horizontalHasArrows;
  final bool? handleMouseWheel;
  final bool? alwaysConsumeMouseWheel;
  final int? horizontalScrollbarSize;
  final int? verticalScrollbarSize;
  final int? verticalSliderSize;
  final int? horizontalSliderSize;
  final bool? scrollByPage;
  final bool? ignoreHorizontalScrollbarInContentHeight;

  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (vertical != null) out['vertical'] = vertical!.wireId;
    if (horizontal != null) out['horizontal'] = horizontal!.wireId;
    if (arrowSize != null) out['arrowSize'] = arrowSize;
    if (useShadows != null) out['useShadows'] = useShadows;
    if (verticalHasArrows != null) out['verticalHasArrows'] = verticalHasArrows;
    if (horizontalHasArrows != null) {
      out['horizontalHasArrows'] = horizontalHasArrows;
    }
    if (handleMouseWheel != null) out['handleMouseWheel'] = handleMouseWheel;
    if (alwaysConsumeMouseWheel != null) {
      out['alwaysConsumeMouseWheel'] = alwaysConsumeMouseWheel;
    }
    if (horizontalScrollbarSize != null) {
      out['horizontalScrollbarSize'] = horizontalScrollbarSize;
    }
    if (verticalScrollbarSize != null) {
      out['verticalScrollbarSize'] = verticalScrollbarSize;
    }
    if (verticalSliderSize != null) {
      out['verticalSliderSize'] = verticalSliderSize;
    }
    if (horizontalSliderSize != null) {
      out['horizontalSliderSize'] = horizontalSliderSize;
    }
    if (scrollByPage != null) out['scrollByPage'] = scrollByPage;
    if (ignoreHorizontalScrollbarInContentHeight != null) {
      out['ignoreHorizontalScrollbarInContentHeight'] =
          ignoreHorizontalScrollbarInContentHeight;
    }
    return out;
  }
}
