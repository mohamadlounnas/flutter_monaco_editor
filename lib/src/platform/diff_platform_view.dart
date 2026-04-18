// Platform-conditional export for the diff editor.
// Web: js_interop implementation.
// Everything else: a "not yet supported" placeholder (planned follow-up).
export 'diff_platform_view_io.dart'
    if (dart.library.js_interop) 'diff_platform_view_web.dart';
