import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_all/webview_all.dart';

import '../monaco_diff_controller.dart';
import 'native_monaco_bridge.dart';

/// Native diff-editor platform view. Each instance owns a fresh
/// `NativeMonacoBridge` + WebView hosting a single Monaco diff editor.
class NativeMonacoDiffPlatformView extends StatefulWidget {
  const NativeMonacoDiffPlatformView({
    super.key,
    required this.controller,
  });

  final MonacoDiffController controller;

  @override
  State<NativeMonacoDiffPlatformView> createState() =>
      _NativeMonacoDiffPlatformViewState();
}

class _NativeMonacoDiffPlatformViewState
    extends State<NativeMonacoDiffPlatformView> {
  NativeMonacoBridge? _bridge;
  String? _diffId;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    final bridge = await NativeMonacoBridge.create();
    if (!mounted) {
      unawaited(bridge.dispose());
      return;
    }
    setState(() => _bridge = bridge);

    final diffId = await bridge.invoke('diff.create', {
      'containerId': 'monaco-root',
      'options': widget.controller.buildCreateOptions(),
    }) as String;
    if (!mounted || widget.controller.isDisposed) {
      unawaited(bridge.invoke('diff.dispose', {'diffId': diffId}));
      return;
    }
    _diffId = diffId;
    widget.controller.attach(bridge, diffId);
  }

  @override
  void dispose() {
    final bridge = _bridge;
    final diffId = _diffId;
    if (bridge != null) {
      if (diffId != null) {
        widget.controller.detach();
        unawaited(bridge.invoke('diff.dispose', {'diffId': diffId}));
      }
      unawaited(bridge.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bridge = _bridge;
    if (bridge == null) {
      return const Center(child: Text('Loading diff editor…'));
    }
    return _AlwaysRepaintDiff(
      child: WebViewWidget(controller: bridge.webViewController),
    );
  }
}

/// Same continuous-repaint trick as the regular native editor — see
/// `native_platform_view.dart` for the rationale.
class _AlwaysRepaintDiff extends SingleChildRenderObjectWidget {
  const _AlwaysRepaintDiff({required Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _AlwaysRepaintDiffBox();
}

class _AlwaysRepaintDiffBox extends RenderProxyBox {
  int _frameCallbackId = -1;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (_frameCallbackId != -1) {
      SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
    }
    _frameCallbackId =
        SchedulerBinding.instance.scheduleFrameCallback((_) {
      _frameCallbackId = -1;
      if (attached) markNeedsPaint();
    });
  }

  @override
  void detach() {
    if (_frameCallbackId != -1) {
      SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
      _frameCallbackId = -1;
    }
    super.detach();
  }
}
