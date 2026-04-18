// Platform-conditional accessor for the process-global MonacoBridge.
//
// Web: uses dart:js_interop to drive Monaco in the host document.
// Mobile/desktop: dispatches to the webview_flutter / webview_cef
// bridge based on Platform.isXxx at runtime.
export 'bridge_acquire_io.dart'
    if (dart.library.js_interop) 'bridge_acquire_web.dart';
