import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonacoEditorOptions.toJson', () {
    test('empty options serialize to empty map', () {
      const opts = MonacoEditorOptions();
      expect(opts.toJson(), isEmpty);
    });

    test('null fields are omitted', () {
      const opts = MonacoEditorOptions(readOnly: true);
      expect(opts.toJson(), {'readOnly': true});
    });

    test('enum fields use wireId', () {
      const opts = MonacoEditorOptions(
        wordWrap: MonacoWordWrap.on,
        cursorStyle: MonacoCursorStyle.lineThin,
        lineNumbers: MonacoLineNumbersStyle.relative,
      );
      final json = opts.toJson();
      expect(json['wordWrap'], 'on');
      expect(json['cursorStyle'], 'line-thin');
      expect(json['lineNumbers'], 'relative');
    });

    test('bracketPairColorization wraps in {enabled}', () {
      const opts = MonacoEditorOptions(bracketPairColorization: true);
      expect(opts.toJson(), {
        'bracketPairColorization': {'enabled': true}
      });
    });

    test('parameterHints wraps in {enabled}', () {
      const opts = MonacoEditorOptions(parameterHints: true);
      expect(opts.toJson(), {
        'parameterHints': {'enabled': true}
      });
    });

    test('rawOptions overrides typed values', () {
      const opts = MonacoEditorOptions(
        readOnly: false,
        rawOptions: {'readOnly': true, 'experimentalPaste': 'yes'},
      );
      final json = opts.toJson();
      expect(json['readOnly'], true);
      expect(json['experimentalPaste'], 'yes');
    });

    test('nested minimap serialized', () {
      const opts = MonacoEditorOptions(
        minimap: MonacoMinimapOptions(
          enabled: false,
          side: MonacoMinimapSide.left,
          size: MonacoMinimapSize.fill,
        ),
      );
      expect(opts.toJson()['minimap'], {
        'enabled': false,
        'side': 'left',
        'size': 'fill',
      });
    });

    test('nested scrollbar serialized', () {
      const opts = MonacoEditorOptions(
        scrollbar: MonacoScrollbarOptions(
          vertical: MonacoScrollbarVisibility.hidden,
          horizontal: MonacoScrollbarVisibility.auto,
          scrollByPage: true,
        ),
      );
      expect(opts.toJson()['scrollbar'], {
        'vertical': 'hidden',
        'horizontal': 'auto',
        'scrollByPage': true,
      });
    });
  });

  group('MonacoEditorOptions.mergedWith', () {
    test('other non-null wins over base', () {
      const base = MonacoEditorOptions(
        fontSize: 14,
        wordWrap: MonacoWordWrap.off,
        readOnly: false,
      );
      const patch = MonacoEditorOptions(
        wordWrap: MonacoWordWrap.on,
        fontSize: 18,
      );
      final merged = base.mergedWith(patch);
      expect(merged.fontSize, 18);
      expect(merged.wordWrap, MonacoWordWrap.on);
      expect(merged.readOnly, false);
    });

    test('rawOptions merge with later wins', () {
      const base = MonacoEditorOptions(rawOptions: {'a': 1, 'b': 2});
      const patch = MonacoEditorOptions(rawOptions: {'b': 99, 'c': 3});
      final merged = base.mergedWith(patch);
      expect(merged.rawOptions, {'a': 1, 'b': 99, 'c': 3});
    });
  });

  group('MonacoController options integration', () {
    test('buildCreateOptions merges options with explicit state', () {
      final c = MonacoController(
        initialValue: 'hi',
        language: 'dart',
        options: const MonacoEditorOptions(
          fontSize: 16,
          readOnly: false, // will be overridden by the explicit false below
        ),
      );
      final out = c.buildCreateOptions();
      expect(out['fontSize'], 16);
      expect(out['value'], 'hi');
      expect(out['language'], 'dart');
      // explicit state fields always override
      expect(out['readOnly'], false);
      expect(out['automaticLayout'], true);
    });

    test('updateOptions pre-attach caches merged options', () async {
      final c = MonacoController(
        options: const MonacoEditorOptions(fontSize: 12),
      );
      await c.updateOptions(
        const MonacoEditorOptions(wordWrap: MonacoWordWrap.on),
      );
      expect(c.options?.fontSize, 12);
      expect(c.options?.wordWrap, MonacoWordWrap.on);
      await c.dispose();
    });
  });
}
