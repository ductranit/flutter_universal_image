# universal_image

A universal image package to display all image types for all platforms.

## Getting Started

It does supports `JPEG`, `PNG`, `GIF`, `Animated GIF`, `WebP`, `Animated WebP`, `BMP`, and `WBMP` from [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)

For `SVG`, it uses [flutter_svg](https://pub.dev/packages/flutter_svg)

It also supports caching image with [extended_image](https://pub.dev/packages/extended_image)

It can handle all providers without specifying network, assets or file, just use `imageUri`

## Example usage:

```
Assets provider: UniversalImage('assets/image.png')
File provider: UniversalImage('/user/app/image.png')
Network provider: UniversalImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')
```