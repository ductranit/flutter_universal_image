# universal_image

A universal image package to display all image types for all platforms (mobile, desktop and web)

## General

- It does supports `JPEG`, `PNG`, `GIF`, `Animated GIF`, `WebP`, `Animated WebP`, `BMP`, and `WBMP` from [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
- For `SVG`, it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
- It also supports caching image with [extended_image](https://pub.dev/packages/extended_image)
- It can handle all providers without specifying network, assets or file, just use `imageUri`
- Notice that it doesn't support [Image.memory()](https://api.flutter.dev/flutter/widgets/Image/Image.memory.html)

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
    );
```