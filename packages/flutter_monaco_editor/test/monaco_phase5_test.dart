import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonacoTheme', () {
    test('serializes base + inherit + rules + colors', () {
      const theme = MonacoTheme(
        base: 'vs-dark',
        rules: [
          MonacoTokenRule(
            token: 'comment',
            foreground: '6A9955',
            fontStyle: 'italic',
          ),
          MonacoTokenRule(
            token: 'keyword',
            foreground: 'C586C0',
            fontStyle: 'bold',
          ),
        ],
        colors: {
          'editor.background': '#1E1E2E',
          'editor.foreground': '#CDD6F4',
        },
      );
      final j = theme.toJson();
      expect(j['base'], 'vs-dark');
      expect(j['inherit'], true);
      expect((j['rules']! as List).length, 2);
      final commentRule = (j['rules']! as List).first as Map<String, Object?>;
      expect(commentRule['token'], 'comment');
      expect(commentRule['foreground'], '6A9955');
      expect(commentRule['fontStyle'], 'italic');
      expect((j['colors']! as Map<String, Object?>)['editor.background'],
          '#1E1E2E');
    });

    test('token rule omits null fields', () {
      const rule = MonacoTokenRule(token: 'string');
      expect(rule.toJson(), {'token': 'string'});
    });
  });

  group('MonacoDiffController', () {
    test('cached state + buildCreateOptions', () {
      final c = MonacoDiffController(
        originalValue: 'one',
        modifiedValue: 'two',
        language: 'dart',
        renderSideBySide: false,
        readOnly: true,
      );
      expect(c.originalValue, 'one');
      expect(c.modifiedValue, 'two');
      expect(c.language, 'dart');
      expect(c.isAttached, isFalse);
      final opts = c.buildCreateOptions();
      expect(opts['original'], 'one');
      expect(opts['modified'], 'two');
      expect(opts['renderSideBySide'], false);
      expect(opts['readOnly'], true);
      expect(opts['automaticLayout'], true);
      c.dispose();
    });

    test('setOriginalValue/setModifiedValue update cache pre-attach',
        () async {
      final c = MonacoDiffController();
      await c.setOriginalValue('A');
      await c.setModifiedValue('B');
      expect(c.originalValue, 'A');
      expect(c.modifiedValue, 'B');
      await c.dispose();
    });

    test('event streams are broadcast', () {
      final c = MonacoDiffController();
      expect(c.onOriginalChange.isBroadcast, isTrue);
      expect(c.onModifiedChange.isBroadcast, isTrue);
      c.dispose();
    });
  });
}
