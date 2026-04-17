import 'dart:async';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

import '../monaco_controller.dart';
import '../web/web_monaco_bridge.dart';

class MonacoPlatformView extends StatefulWidget {
  const MonacoPlatformView({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final MonacoController controller;
  final ValueChanged<String>? onChanged;

  @override
  State<MonacoPlatformView> createState() => _MonacoPlatformViewState();
}

class _MonacoPlatformViewState extends State<MonacoPlatformView> {
  static int _factorySeq = 0;

  String? _viewType;
  String? _editorId;
  Completer<web.HTMLDivElement>? _containerReady;
  StreamSubscription<String>? _onChangedSub;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
    _wireOnChanged(widget.controller);
  }

  @override
  void didUpdateWidget(MonacoPlatformView oldWidget) {
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
    final bridge = await WebMonacoBridge.instance();
    if (!mounted) return;

    final seq = ++_factorySeq;
    final containerId = 'monaco-container-$seq';
    final viewType = 'flutter-monaco-editor-$seq';
    _containerReady = Completer<web.HTMLDivElement>();

    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
      final div = web.HTMLDivElement()
        ..id = containerId
        ..style.width = '100%'
        ..style.height = '100%';
      _containerReady?.complete(div);
      return div;
    });

    setState(() => _viewType = viewType);

    await _containerReady!.future;
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    final editorId = await bridge.invoke('editor.create', {
      'containerId': containerId,
      'options': widget.controller.buildCreateOptions(),
    }) as String;
    _editorId = editorId;
    widget.controller.attach(bridge, editorId);
  }

  @override
  void dispose() {
    _onChangedSub?.cancel();
    final editorId = _editorId;
    if (editorId != null) {
      widget.controller.detach();
      // Bridge call is fire-and-forget; the bridge survives beyond this widget.
      unawaited(
        WebMonacoBridge.instance().then(
          (b) => b.invoke('editor.dispose', {'editorId': editorId}),
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewType = _viewType;
    if (viewType == null) {
      return const SizedBox.expand();
    }
    return HtmlElementView(viewType: viewType);
  }
}
