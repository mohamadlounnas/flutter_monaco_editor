import 'dart:io';

import '../bridge/bridge.dart';
import '../native/native_monaco_bridge.dart';

Future<MonacoBridge> acquireBridge() async {
  if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
    return NativeMonacoBridge.instance();
  }
  throw UnsupportedError(
    'flutter_monaco_editor: Linux and Windows are not yet supported. '
    'Use the web build on those platforms for now.',
  );
}
