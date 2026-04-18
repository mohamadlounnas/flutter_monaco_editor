// Platform-conditional export: web picks up the js_interop implementation
// when `dart:js_interop` is available; every other build picks the
// dart:io dispatcher which runtime-switches between the webview_flutter
// (mobile) and webview_cef (desktop) implementations.
export 'platform_view_io.dart'
    if (dart.library.js_interop) 'platform_view_web.dart';
