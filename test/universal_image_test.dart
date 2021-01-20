import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:universal_image/universal_image.dart';

void main() {
  test('Test widget', () {
    final widget = UniversalImage(
      'test.png',
      color: Colors.black,
      matchTextDirection: false,
      scale: 1.0,
      width: 100,
      height: 100,
      frameBuilder: null,
      errorBuilder: null,
      semanticLabel: null,
      excludeFromSemantics: false,
      colorBlendMode: BlendMode.clear,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      repeat: ImageRepeat.noRepeat,
      centerSlice: Rect.fromLTWH(0, 0, 100, 100),
      gaplessPlayback: false,
      isAntiAlias: false,
      filterQuality: FilterQuality.low,
      cacheWidth: 100,
      cacheHeight: 100,
      allowDrawingOutsideViewBox: false,
      svgSkiaMode: false,
    );

    expect(widget.imageUri != null, true);

    var iconWidget = UniversalImage.icon(
      Icons.add,
      color: Colors.red,
      textDirection: TextDirection.ltr,
    );

    expect(iconWidget.imageUri != null, true);
  });
}
