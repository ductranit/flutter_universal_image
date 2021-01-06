library universal_image;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:convert';

/// The prefix of icon uri
final String _iconUriPrefix = 'icons://';

/// The prefix of memory data
final String _memoryUriPrefix = 'base64://';

extension $IconData on IconData {
  /// Convert icon into uri to work with UniversalImage
  ///
  /// Example. `Icons.add.uri`
  String get uri =>
      '$_iconUriPrefix$codePoint/$fontFamily/$fontPackage/$matchTextDirection';
}

extension $Uint8List on Uint8List {
  /// Convert bytes array into uri
  String get uri => '$_memoryUriPrefix${base64Encode(this)}';
}

/// A widget to display all image types for all platforms.
///
/// It does supports `JPEG`, `PNG`, `GIF`, `Animated GIF`, `WebP`, `Animated WebP`, `BMP`, and `WBMP` from [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
///
/// For `SVG`, it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
///
/// It also supports caching image with [extended_image](https://pub.dev/packages/extended_image)
///
/// It can handle all providers without specifying network, assets or file, just use `imageUri`
///
/// It can work with Icons font & memory image as well
///
/// Example:
///
/// `Assets provider`: `UniversalImage('assets/image.png')`
///
/// `File provider`: `UniversalImage('/user/app/image.png')`
///
/// `Network provider`: `UniversalImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')`
///
/// `Icon provider`: `UniversalImage(Icons.add.uri)`
///
/// `Memory provider`: `UniversalImage('base64://base64string')`
class UniversalImage extends StatelessWidget {
  const UniversalImage(
    this.imageUri, {
    Key key,
    this.scale = 1.0,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.allowDrawingOutsideViewBox = false,
    this.svgSkiaMode = false,
    this.size,
    this.textDirection,
    this.placeholder,
    this.errorPlaceholder,
    this.cache = true,
    this.enableMemoryCache = true,
    this.clearMemoryCacheIfFailed = true,
    this.clearMemoryCacheWhenDispose = false,
  }) : super(key: key);

  final AlignmentGeometry alignment;
  final bool allowDrawingOutsideViewBox;
  final int cacheHeight;
  final int cacheWidth;
  final Rect centerSlice;
  final Color color;
  final BlendMode colorBlendMode;
  final ImageErrorWidgetBuilder errorBuilder;
  final bool excludeFromSemantics;
  final FilterQuality filterQuality;
  final BoxFit fit;
  final ImageFrameBuilder frameBuilder;
  final bool gaplessPlayback;
  final double height;
  final Widget placeholder;
  final Widget errorPlaceholder;
  final bool cache;
  final bool enableMemoryCache;
  final bool clearMemoryCacheIfFailed;
  final bool clearMemoryCacheWhenDispose;

  /// Image uri, it can be http url, assets file path (assets path must start with `assets`) or local file
  final String imageUri;

  final bool isAntiAlias;
  final bool matchTextDirection;
  final ImageRepeat repeat;
  final double scale;
  final String semanticLabel;
  final double width;
  final bool svgSkiaMode;

  /// For Icon only
  final double size;

  /// For Icon only
  final TextDirection textDirection;

  bool get _isNetwork => imageUri.startsWith('http');

  bool get _isAsset => imageUri.startsWith('assets');

  bool get _isSvg => imageUri.endsWith('.svg');

  bool get _isIcon => imageUri.startsWith(_iconUriPrefix);

  bool get _isMemory => imageUri.startsWith(_memoryUriPrefix);

  /// Create svg image widget.
  ///
  /// For web (without skia enable), it uses [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
  ///
  /// Otherwise it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
  Widget _createSvgImage() {
    if (kIsWeb && !svgSkiaMode) {
      // Use `Image.network()` for both network and asset svg
      if (_isAsset || _isNetwork) {
        return Image.network(
          imageUri,
          key: key,
          fit: fit,
          scale: scale,
          color: color,
          width: width,
          height: height,
          alignment: alignment,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
          isAntiAlias: isAntiAlias,
          repeat: repeat,
          centerSlice: centerSlice,
          frameBuilder: frameBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        );
      }

      return Image.file(
        File(imageUri),
        key: key,
        fit: fit,
        scale: scale,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
        isAntiAlias: isAntiAlias,
        repeat: repeat,
        centerSlice: centerSlice,
        frameBuilder: frameBuilder,
        errorBuilder: errorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }

    if (_isAsset) {
      return SvgPicture.asset(
        imageUri,
        key: key,
        fit: fit,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder:
            placeholder != null ? (BuildContext context) => placeholder : null,
      );
    }

    if (_isNetwork) {
      return SvgPicture.network(
        imageUri,
        key: key,
        fit: fit,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        colorBlendMode: colorBlendMode,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder:
            placeholder != null ? (BuildContext context) => placeholder : null,
      );
    }

    return SvgPicture.file(
      File(imageUri),
      key: key,
      fit: fit,
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      colorBlendMode: colorBlendMode,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder:
          placeholder != null ? (BuildContext context) => placeholder : null,
    );
  }

  /// Create any image type except svg
  /// It uses [extended_image](https://github.com/fluttercandies/extended_image)
  Widget _createOtherImage() {
    if (_isAsset) {
      return ExtendedImage.asset(imageUri,
          key: key,
          fit: fit,
          scale: scale,
          color: color,
          width: width,
          height: height,
          alignment: alignment,
          filterQuality: filterQuality,
          colorBlendMode: colorBlendMode,
          isAntiAlias: isAntiAlias,
          repeat: repeat,
          centerSlice: centerSlice,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          loadStateChanged: placeholder != null
              ? (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return placeholder;
                    case LoadState.failed:
                      return errorPlaceholder ?? placeholder;
                    default:
                      return null;
                  }
                }
              : null,
          enableMemoryCache: enableMemoryCache,
          clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
          clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose);
    }

    if (_isNetwork) {
      return ExtendedImage.network(
        imageUri,
        key: key,
        fit: fit,
        scale: scale,
        color: color,
        width: width,
        height: height,
        alignment: alignment,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
        isAntiAlias: isAntiAlias,
        repeat: repeat,
        centerSlice: centerSlice,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        loadStateChanged: placeholder != null
            ? (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    return placeholder;
                  case LoadState.failed:
                    return errorPlaceholder ?? placeholder;
                  default:
                    return null;
                }
              }
            : null,
        cache: cache,
        enableMemoryCache: enableMemoryCache,
        clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
      );
    }

    return ExtendedImage.file(
      File(imageUri),
      key: key,
      fit: fit,
      scale: scale,
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      isAntiAlias: isAntiAlias,
      repeat: repeat,
      centerSlice: centerSlice,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      loadStateChanged: placeholder != null
          ? (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return placeholder;
                case LoadState.failed:
                  return errorPlaceholder ?? placeholder;
                default:
                  return null;
              }
            }
          : null,
      enableMemoryCache: enableMemoryCache,
      clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
      clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
    );
  }

  Widget _createIconImage() {
    var data = imageUri.replaceAll(_iconUriPrefix, ''); // remove prefix
    var tokens = data.split('/');
    var codePoint = int.parse(tokens[0]); // the first part must be int data
    var fontFamily = tokens.length > 1
        ? (tokens[1]?.toLowerCase() == 'null' ? null : tokens[1])
        : null;
    var fontPackage = tokens.length > 2
        ? (tokens[2]?.toLowerCase() == 'null' ? null : tokens[2])
        : null;
    var matchTextDirection =
        tokens.length > 3 ? (tokens[3]?.toLowerCase() == 'true') : false;

    return Icon(
      IconData(
        codePoint,
        fontFamily: fontFamily,
        fontPackage: fontPackage,
        matchTextDirection: matchTextDirection,
      ),
      size: size,
      color: color,
      textDirection: textDirection,
    );
  }

  Widget _createMemoryImage() {
    var data = imageUri.replaceAll(_memoryUriPrefix, ''); // remove prefix
    var bytes = base64Decode(data);
    return Image.memory(
      bytes,
      key: key,
      fit: fit,
      scale: scale,
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      isAntiAlias: isAntiAlias,
      repeat: repeat,
      centerSlice: centerSlice,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isIcon) return _createIconImage();
    if (_isSvg) return _createSvgImage();
    if (_isMemory) return _createMemoryImage();
    return _createOtherImage();
  }

  /// Clear cache from memory and disk
  static Future<void> clearCache() async {
    clearMemoryImageCache();
    await clearDiskCachedImages();
  }
}
