# Changelog

## 0.5.0-dev

### Initial release

- `MonacoDesktop.register()` installs hooks via `MonacoPlatformHooks`.
- `DesktopMonacoBridge` — `MonacoBridge` impl on `webview_cef`.
- `DesktopMonacoPlatformView` — one CEF browser per editor widget.
- `MonacoAssetServer` — in-process HTTP server serves Monaco assets
  from `rootBundle` to CEF.
- Supports Linux, Windows, macOS.
