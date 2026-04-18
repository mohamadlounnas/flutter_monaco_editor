import 'package:flutter/widgets.dart';

import '../monaco_diff_controller.dart';
import '../native/native_diff_platform_view.dart';

class MonacoDiffPlatformView extends StatelessWidget {
  const MonacoDiffPlatformView({super.key, required this.controller});

  final MonacoDiffController controller;

  @override
  Widget build(BuildContext context) {
    return NativeMonacoDiffPlatformView(controller: controller);
  }
}
