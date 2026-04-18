import 'package:flutter_monaco_editor/flutter_monaco_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bundled Monaco version is declared', () {
    expect(monacoVersion, isNotEmpty);
    expect(RegExp(r'^\d+\.\d+\.\d+').hasMatch(monacoVersion), isTrue);
  });
}
