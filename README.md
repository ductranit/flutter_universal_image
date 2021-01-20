# universal_image
[![pub package](https://img.shields.io/pub/v/universal_image.svg)](https://pub.dartlang.org/packages/universal_image)

A universal image package to display all image types for all platforms (mobile, desktop and web)

## General

- It does supports `JPEG`, `PNG`, `GIF`, `Animated GIF`, `WebP`, `Animated WebP`, `BMP`, and `WBMP` from [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
- For `SVG`, it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
- It also supports caching image with [extended_image](https://pub.dev/packages/extended_image)
- It can handle all providers without specifying network, assets or file, just use `imageUri`
- It can work with Icons font & memory image as well

## Example usage:

- Assets provider
```
    var image = UniversalImage(
      'assets/image.png', // path must start with 'assets'
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
      placeholder: Container(),
      svgSkiaMode: true, // using flutter_svg on web, make sure building with FLUTTER_WEB_USE_SKIA=true
    );
```

- File provider:
```
var image = UniversalImage(
      '/com.package.app/files/image.png', // image storage file path
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
      placeholder: Container(),
    );
```

- Network provider:
```
var image = UniversalImage(
      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
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
      placeholder: Container(),
    );
```

- Icon provider:
```
var image = UniversalImage.icon(
      Icons.add,
      color: Colors.black,
      size: 30,
      textDirection: TextDirection.ltr
    );
```

- Memory provider:
```
Uint8List data = await loadImage();
var image = UniversalImage(
      data.uri,
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
    );
```

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/ductranit/flutter_universal_image/blob/master/LICENSE)
```
Copyright (C) 2020 ductranit

Licensed to the Apache Software Foundation (ASF) under one or more contributor license agreements. See the NOTICE file distributed with this work for additional information regarding copyright ownership. The ASF licenses this file to you under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
```

