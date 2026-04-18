import 'enums.dart';

/// Corresponds to Monaco's `IEditorMinimapOptions`.
class MonacoMinimapOptions {
  const MonacoMinimapOptions({
    this.enabled,
    this.autohide,
    this.side,
    this.size,
    this.showSlider,
    this.renderCharacters,
    this.maxColumn,
    this.scale,
    this.showRegionSectionHeaders,
    this.showMarkSectionHeaders,
    this.sectionHeaderFontSize,
    this.sectionHeaderLetterSpacing,
  });

  final bool? enabled;
  final bool? autohide;
  final MonacoMinimapSide? side;
  final MonacoMinimapSize? size;
  final MonacoMinimapSlider? showSlider;
  final bool? renderCharacters;
  final int? maxColumn;
  final double? scale;
  final bool? showRegionSectionHeaders;
  final bool? showMarkSectionHeaders;
  final double? sectionHeaderFontSize;
  final double? sectionHeaderLetterSpacing;

  Map<String, Object?> toJson() {
    final out = <String, Object?>{};
    if (enabled != null) out['enabled'] = enabled;
    if (autohide != null) out['autohide'] = autohide;
    if (side != null) out['side'] = side!.wireId;
    if (size != null) out['size'] = size!.wireId;
    if (showSlider != null) out['showSlider'] = showSlider!.wireId;
    if (renderCharacters != null) out['renderCharacters'] = renderCharacters;
    if (maxColumn != null) out['maxColumn'] = maxColumn;
    if (scale != null) out['scale'] = scale;
    if (showRegionSectionHeaders != null) {
      out['showRegionSectionHeaders'] = showRegionSectionHeaders;
    }
    if (showMarkSectionHeaders != null) {
      out['showMarkSectionHeaders'] = showMarkSectionHeaders;
    }
    if (sectionHeaderFontSize != null) {
      out['sectionHeaderFontSize'] = sectionHeaderFontSize;
    }
    if (sectionHeaderLetterSpacing != null) {
      out['sectionHeaderLetterSpacing'] = sectionHeaderLetterSpacing;
    }
    return out;
  }
}
