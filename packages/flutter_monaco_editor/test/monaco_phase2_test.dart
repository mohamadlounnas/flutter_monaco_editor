import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonacoMarker', () {
    test('serializes with Monaco-native field names via MonacoRange', () {
      const marker = MonacoMarker(
        range: MonacoRange(startLine: 1, startColumn: 1, endLine: 2, endColumn: 5),
        severity: MonacoMarkerSeverity.error,
        message: 'boom',
        source: 'test',
        code: 'E123',
      );
      final json = marker.toJson();
      expect(json['severity'], 8); // error wire value
      expect(json['startLine'], 1);
      expect(json['endLine'], 2);
      expect(json['message'], 'boom');
      expect(json['source'], 'test');
      expect(json['code'], 'E123');
    });

    test('severity values match Monaco', () {
      expect(MonacoMarkerSeverity.hint.wireValue, 1);
      expect(MonacoMarkerSeverity.info.wireValue, 2);
      expect(MonacoMarkerSeverity.warning.wireValue, 4);
      expect(MonacoMarkerSeverity.error.wireValue, 8);
    });

    test('code with href produces {value,target} object', () {
      const marker = MonacoMarker(
        range: MonacoRange(startLine: 1, startColumn: 1, endLine: 1, endColumn: 2),
        severity: MonacoMarkerSeverity.warning,
        message: 'x',
        code: 'E1',
        codeHref: 'https://example.com/E1',
      );
      expect(marker.toJson()['code'],
          {'value': 'E1', 'target': 'https://example.com/E1'});
    });
  });

  group('MonacoDecoration', () {
    test('wraps range + options', () {
      const d = MonacoDecoration(
        range: MonacoRange(startLine: 1, startColumn: 1, endLine: 1, endColumn: 10),
        options: MonacoDecorationOptions(
          className: 'my-highlight',
          isWholeLine: true,
        ),
      );
      final json = d.toJson();
      expect(json['range'], isA<Map<String, Object?>>());
      expect((json['options']! as Map<String, Object?>)['className'], 'my-highlight');
      expect((json['options']! as Map<String, Object?>)['isWholeLine'], true);
    });

    test('hoverMessage wraps into {value}', () {
      const opts = MonacoDecorationOptions(hoverMessage: 'hello');
      expect(opts.toJson()['hoverMessage'], {'value': 'hello'});
    });

    test('overviewRuler + minimap serialize with wireValue positions', () {
      const opts = MonacoDecorationOptions(
        overviewRuler: MonacoOverviewRuler(
          color: '#ff0000',
          position: MonacoOverviewRulerLane.right,
        ),
        minimap: MonacoMinimapDecoration(
          color: '#00ff00',
          position: MonacoMinimapPosition.inline,
        ),
      );
      final json = opts.toJson();
      expect(json['overviewRuler'], {'color': '#ff0000', 'position': 4});
      expect(json['minimap'], {'color': '#00ff00', 'position': 1});
    });

    test('rawOptions merges last', () {
      const opts = MonacoDecorationOptions(
        className: 'typed',
        rawOptions: {'className': 'raw-wins', 'custom': 42},
      );
      final json = opts.toJson();
      expect(json['className'], 'raw-wins');
      expect(json['custom'], 42);
    });
  });

  group('MonacoAction', () {
    test('registration JSON excludes run callback, includes keybindings', () {
      final action = MonacoAction(
        id: 'test.action',
        label: 'Test',
        keybindings: const [
          MonacoKeyMod.ctrlCmd | MonacoKeyCode.keyS,
        ],
        contextMenuGroupId: 'navigation',
        contextMenuOrder: 1.5,
        run: (_) {},
      );
      final json = action.toRegistrationJson();
      expect(json['id'], 'test.action');
      expect(json['label'], 'Test');
      expect(json['keybindings'], isA<List<int>>());
      expect((json['keybindings']! as List).first, 2048 | 49); // CtrlCmd+S
      expect(json['contextMenuGroupId'], 'navigation');
      expect(json['contextMenuOrder'], 1.5);
      expect(json.containsKey('run'), isFalse);
    });
  });

  group('MonacoKeyCode / MonacoKeyMod constants', () {
    test('values match Monaco', () {
      expect(MonacoKeyMod.ctrlCmd, 2048);
      expect(MonacoKeyMod.shift, 1024);
      expect(MonacoKeyMod.alt, 512);
      expect(MonacoKeyMod.winCtrl, 256);
      expect(MonacoKeyCode.enter, 3);
      expect(MonacoKeyCode.keyS, 49);
      expect(MonacoKeyCode.f12, 70);
    });
  });
}
