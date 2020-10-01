import 'package:flutter_test/flutter_test.dart';

import 'package:universal_image/universal_image.dart';

void main() {
  test('Test widget', () {
    final widget = UniversalImage('test.png');
    expect(() => widget.imageUri, throwsNoSuchMethodError);
  });
}
