import 'dart:async';

import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MonacoController pre-attach', () {
    test('cached state reflects constructor values', () {
      final c = MonacoController(
        initialValue: 'hello',
        language: 'dart',
        theme: 'vs-dark',
        readOnly: true,
      );
      expect(c.value, 'hello');
      expect(c.language, 'dart');
      expect(c.theme, 'vs-dark');
      expect(c.readOnly, isTrue);
      expect(c.position, isNull);
      expect(c.selection, isNull);
      expect(c.isAttached, isFalse);
      expect(c.isDisposed, isFalse);
      c.dispose();
    });

    test('setValue/setLanguage/setReadOnly/setTheme update cache without attach',
        () async {
      final c = MonacoController();
      await c.setValue('updated');
      await c.setLanguage('javascript');
      await c.setReadOnly(true);
      await c.setTheme('vs');
      expect(c.value, 'updated');
      expect(c.language, 'javascript');
      expect(c.readOnly, isTrue);
      expect(c.theme, 'vs');
      expect(c.isAttached, isFalse);
      c.dispose();
    });

    test('buildCreateOptions reflects cached state', () {
      final c = MonacoController(
        initialValue: 'x',
        language: 'yaml',
        theme: 'hc-black',
        readOnly: true,
      );
      expect(c.buildCreateOptions(), {
        'value': 'x',
        'language': 'yaml',
        'theme': 'hc-black',
        'readOnly': true,
        'automaticLayout': true,
      });
      c.dispose();
    });

    test('operations on disposed controller throw StateError', () async {
      final c = MonacoController();
      await c.dispose();
      expect(c.isDisposed, isTrue);
      expect(() => c.setValue('x'), throwsStateError);
    });

    test('ready future does not complete before attach', () async {
      final c = MonacoController();
      var completed = false;
      unawaited(c.ready.then((_) => completed = true));
      await Future<void>.delayed(Duration.zero);
      expect(completed, isFalse);
      c.dispose();
    });

    test('event streams exist and are broadcast', () {
      final c = MonacoController();
      expect(c.onDidChangeContent.isBroadcast, isTrue);
      expect(c.onDidChangeCursorPosition.isBroadcast, isTrue);
      expect(c.onDidChangeCursorSelection.isBroadcast, isTrue);
      expect(c.onDidScroll.isBroadcast, isTrue);
      expect(c.onDidFocus.isBroadcast, isTrue);
      expect(c.onDidBlur.isBroadcast, isTrue);
      expect(c.onKeyDown.isBroadcast, isTrue);
      expect(c.onKeyUp.isBroadcast, isTrue);
      c.dispose();
    });
  });

  group('MonacoPosition / MonacoRange / MonacoSelection', () {
    test('MonacoPosition equality + JSON round trip', () {
      const p = MonacoPosition(line: 3, column: 5);
      expect(p, MonacoPosition.fromJson(p.toJson()));
      expect(p, const MonacoPosition(line: 3, column: 5));
      expect(p == const MonacoPosition(line: 3, column: 6), isFalse);
    });

    test('MonacoRange basics', () {
      const r = MonacoRange(startLine: 1, startColumn: 1, endLine: 2, endColumn: 5);
      expect(r.isEmpty, isFalse);
      expect(MonacoRange.collapsed(const MonacoPosition(line: 4, column: 2)).isEmpty, isTrue);
    });

    test('MonacoSelection.isReversed', () {
      const forward = MonacoSelection(
        startLine: 1, startColumn: 1, endLine: 3, endColumn: 1,
        selectionStartLine: 1, selectionStartColumn: 1,
        positionLine: 3, positionColumn: 1,
      );
      const reversed = MonacoSelection(
        startLine: 1, startColumn: 1, endLine: 3, endColumn: 1,
        selectionStartLine: 3, selectionStartColumn: 1,
        positionLine: 1, positionColumn: 1,
      );
      expect(forward.isReversed, isFalse);
      expect(reversed.isReversed, isTrue);
    });
  });
}
