import 'package:flutter/widgets.dart';

import 'monaco_diff_controller.dart';
import 'platform/diff_platform_view.dart';

/// A side-by-side diff editor widget — Monaco's `createDiffEditor`.
///
/// Provide a [controller] for programmatic access to both panes. If omitted,
/// the widget creates an internal controller from the convenience props.
class MonacoDiffEditor extends StatefulWidget {
  const MonacoDiffEditor({
    super.key,
    this.controller,
    this.original = '',
    this.modified = '',
    this.language = 'plaintext',
    this.theme = 'vs-dark',
    this.renderSideBySide = true,
    this.readOnly = false,
    this.ignoreTrimWhitespace = false,
  }) : assert(
          controller == null ||
              (original == '' &&
                  modified == '' &&
                  language == 'plaintext' &&
                  theme == 'vs-dark' &&
                  renderSideBySide == true &&
                  readOnly == false &&
                  ignoreTrimWhitespace == false),
          'When a MonacoDiffController is provided, configure initial state '
          'on the controller instead of passing the convenience props.',
        );

  final MonacoDiffController? controller;
  final String original;
  final String modified;
  final String language;
  final String theme;
  final bool renderSideBySide;
  final bool readOnly;
  final bool ignoreTrimWhitespace;

  @override
  State<MonacoDiffEditor> createState() => _MonacoDiffEditorState();
}

class _MonacoDiffEditorState extends State<MonacoDiffEditor> {
  MonacoDiffController? _internal;

  MonacoDiffController get _effective => widget.controller ?? _internal!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internal = MonacoDiffController(
        originalValue: widget.original,
        modifiedValue: widget.modified,
        language: widget.language,
        theme: widget.theme,
        renderSideBySide: widget.renderSideBySide,
        readOnly: widget.readOnly,
        ignoreTrimWhitespace: widget.ignoreTrimWhitespace,
      );
    }
  }

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MonacoDiffPlatformView(controller: _effective);
  }
}
