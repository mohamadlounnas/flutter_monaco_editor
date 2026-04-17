// Platform-conditional export for the diff editor view. Matches the
// regular editor's split: web impl when dart:js_interop is available,
// stub otherwise.
export 'diff_platform_view_stub.dart'
    if (dart.library.js_interop) 'diff_platform_view_web.dart';
