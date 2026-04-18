import 'dart:io';

import '../bridge/bridge.dart';
import '../desktop/desktop_monaco_bridge.dart';
import '../native/native_monaco_bridge.dart';

Future<MonacoBridge> acquireBridge() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return NativeMonacoBridge.instance();
  }
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    return DesktopMonacoBridge.instance();
  }
  throw UnsupportedError(
    'flutter_monaco_editor: no Monaco transport for this platform',
  );
}
