import 'dart:async';
import 'dart:convert';

import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:webview_cef/webview_cef.dart';

import 'asset_server.dart';

/// CEF-backed [MonacoBridge] for desktop platforms (Linux / Windows /
/// macOS via `webview_cef`). One WebView + one Monaco runtime per
/// instance. The first bridge created also becomes the shared one used
/// by `MonacoLanguages` / `MonacoThemes`.
class DesktopMonacoBridge implements MonacoBridge {
  DesktopMonacoBridge._({required this.webController});

  static const String _channelName = 'FmeChannel';

  /// Host HTML served by the asset server — path relative to the asset
  /// bundle's `packages/flutter_monaco_editor/` prefix.
  static const String _hostAssetPath =
      'packages/flutter_monaco_editor/assets/bridge/monaco_host.html';

  final WebViewController webController;
  final Completer<void> _readyCompleter = Completer<void>();
  final StreamController<BridgeEvent> _events =
      StreamController<BridgeEvent>.broadcast();
  final Map<String, Completer<Object?>> _pending = {};
  int _nextCallId = 1;
  bool _disposed = false;

  static DesktopMonacoBridge? _shared;

  /// Shared bridge for process-global APIs (language providers, theme
  /// registration). First-created wins.
  static Future<DesktopMonacoBridge> instance() async {
    final existing = _shared;
    if (existing != null && !existing._disposed) return existing;
    return create();
  }

  /// Create a fresh bridge with its own WebView + Monaco runtime.
  static Future<DesktopMonacoBridge> create() async {
    await WebviewManager().initialize();
    final server = await MonacoAssetServer.instance();
    final wc = WebviewManager().createWebView();
    final bridge = DesktopMonacoBridge._(webController: wc);
    await bridge._bootstrap(server.baseUrl);
    _shared ??= bridge;
    return bridge;
  }

  @override
  Future<void> get ready => _readyCompleter.future;

  @override
  Stream<BridgeEvent> get events => _events.stream;

  @override
  Future<Object?> invoke(
    String method, [
    Map<String, Object?> args = const {},
  ]) async {
    if (_disposed) {
      throw MonacoBridgeException('bridge disposed', method: method);
    }
    await ready;
    final callId = 'c-${_nextCallId++}';
    final completer = Completer<Object?>();
    _pending[callId] = completer;
    final frame = jsonEncode({
      'method': method,
      'args': args,
      'callId': callId,
    });
    // __fmeDispatch is defined in monaco_host.html's inline script.
    final escaped = jsonEncode(frame);
    await webController.executeJavaScript('window.__fmeDispatch($escaped);');
    return completer.future;
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    await _events.close();
    for (final c in _pending.values) {
      if (!c.isCompleted) c.completeError(StateError('bridge disposed'));
    }
    _pending.clear();
    if (identical(_shared, this)) _shared = null;
    await webController.dispose();
  }

  Future<void> _bootstrap(String baseUrl) async {
    webController.setWebviewListener(WebviewEventsListener(
      onUrlChanged: (_) {
        // Channels have to be (re)registered after every navigation. The
        // host page is loaded once, so this also fires our first
        // registration.
        unawaited(_registerChannel());
      },
    ));
    await webController.initialize('$baseUrl/$_hostAssetPath');
  }

  Future<void> _registerChannel() async {
    try {
      await webController.setJavaScriptChannels({
        JavascriptChannel(
          name: _channelName,
          onMessageReceived: _onChannelMessage,
        ),
      });
    } catch (_) {
      // Channel registration races with the first page load — ignore
      // transient failures, the `onUrlChanged` re-fire takes care of it.
    }
  }

  void _onChannelMessage(JavascriptMessage message) {
    if (_disposed) return;
    final Object? decoded;
    try {
      decoded = jsonDecode(message.message);
    } catch (_) {
      return;
    }
    if (decoded is! Map) return;
    final type = decoded['type']?.toString();
    if (type == null) return;

    final payloadRaw = decoded['payload'];
    final payload = payloadRaw is Map
        ? payloadRaw.map((k, v) => MapEntry(k.toString(), v))
        : <String, Object?>{};

    if (type == 'bridge.ready') {
      if (!_readyCompleter.isCompleted) _readyCompleter.complete();
      _events.add(BridgeEvent(type, payload));
      return;
    }

    if (type == '_return') {
      final callId = payload['callId']?.toString();
      if (callId == null) return;
      final completer = _pending.remove(callId);
      if (completer == null) return;
      if (payload.containsKey('error')) {
        completer.completeError(
          MonacoBridgeException(payload['error'].toString()),
        );
      } else {
        completer.complete(payload['value']);
      }
      return;
    }

    _events.add(BridgeEvent(type, payload));
  }
}
