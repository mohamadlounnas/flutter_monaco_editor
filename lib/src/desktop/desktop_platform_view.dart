import 'dart:async';

import 'package:flutter/widgets.dart';

import '../monaco_controller.dart';
import 'desktop_monaco_bridge.dart';

/// Desktop platform view — one `webview_cef` webview per editor widget.
class DesktopMonacoPlatformView extends StatefulWidget {
  const DesktopMonacoPlatformView({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.transparent,
  });

  final MonacoController controller;
  final ValueChanged<String>? onChanged;
  final bool transparent;

  @override
  State<DesktopMonacoPlatformView> createState() =>
      _DesktopMonacoPlatformViewState();
}

class _DesktopMonacoPlatformViewState extends State<DesktopMonacoPlatformView> {
  DesktopMonacoBridge? _bridge;
  String? _editorId;
  StreamSubscription<String>? _onChangedSub;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
    _wireOnChanged(widget.controller);
  }

  @override
  void didUpdateWidget(DesktopMonacoPlatformView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        oldWidget.onChanged != widget.onChanged) {
      _onChangedSub?.cancel();
      _wireOnChanged(widget.controller);
    }
  }

  void _wireOnChanged(MonacoController controller) {
    final cb = widget.onChanged;
    if (cb == null) return;
    _onChangedSub = controller.onDidChangeContent.listen(cb);
  }

  Future<void> _initialize() async {
    final bridge = await DesktopMonacoBridge.create();
    if (!mounted) {
      unawaited(bridge.dispose());
      return;
    }
    _bridge = bridge;
    setState(() {});

    final editorId = await bridge.invoke('editor.create', {
      'containerId': 'monaco-root',
      'options': widget.controller.buildCreateOptions(),
    }) as String;
    if (!mounted || widget.controller.isDisposed) {
      unawaited(bridge.invoke('editor.dispose', {'editorId': editorId}));
      return;
    }
    _editorId = editorId;
    widget.controller.attach(bridge, editorId);
  }

  @override
  void dispose() {
    _onChangedSub?.cancel();
    final bridge = _bridge;
    final editorId = _editorId;
    if (bridge != null) {
      if (editorId != null) {
        widget.controller.detach();
        unawaited(bridge.invoke('editor.dispose', {'editorId': editorId}));
      }
      unawaited(bridge.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bridge = _bridge;
    if (bridge == null) {
      return const Center(child: Text('Loading editor…'));
    }
    return bridge.webController.webviewWidget;
  }
}
