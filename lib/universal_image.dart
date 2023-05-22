library universal_image;

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:extended_image/extended_image.dart';
import 'package:universal_io/io.dart';
import 'dart:convert';
import 'platforms/image_file.dart';

/// The prefix of memory data
final String _memoryUriPrefix = 'base64://';

extension $Uint8List on Uint8List {
  /// Convert bytes array into uri
  String get uri => '$_memoryUriPrefix${base64Encode(this)}';
}

/// Image loader engine. By default its use `flutter_svg` for svg file, flutter image for memory or icon and use extended_image for the rest
enum ImageEngine {
  /// Use default flutter image
  defaultImage,

  /// Use extended_image lib
  extendedImage,
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
/// `Icon provider`: `UniversalImage.icon(Icons.add)`
///
/// `Memory provider`: `UniversalImage('base64://base64string')`
class UniversalImage extends StatelessWidget {
  const UniversalImage(
    this.imageUri, {
    Key? key,
    this.scale = 1.0,
    this.icon,
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
    this.assetPrefix = 'assets',
    this.compressionRatio,
    this.maxBytes,
    this.imageEngine = ImageEngine.extendedImage,
    this.heroTag,
    this.colorFilter,
  }) : super(key: key);

  UniversalImage.icon(
    this.icon, {
    Key? key,
    this.imageUri = '',
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
    this.assetPrefix = 'assets',
    this.compressionRatio,
    this.maxBytes,
    this.imageEngine = ImageEngine.extendedImage,
    this.heroTag,
    this.colorFilter,
  }) : super(key: key);

  final Alignment alignment;
  final bool allowDrawingOutsideViewBox;
  final int? cacheHeight;
  final int? cacheWidth;
  final Rect? centerSlice;
  final Color? color;
  final BlendMode? colorBlendMode;
  final ImageErrorWidgetBuilder? errorBuilder;
  final bool excludeFromSemantics;
  final FilterQuality filterQuality;
  final BoxFit? fit;
  final ImageFrameBuilder? frameBuilder;
  final bool gaplessPlayback;
  final double? height;
  final Widget? placeholder;
  final Widget? errorPlaceholder;
  final bool cache;
  final bool enableMemoryCache;
  final bool clearMemoryCacheIfFailed;
  final bool clearMemoryCacheWhenDispose;
  final double? compressionRatio;
  final int? maxBytes;
  final ImageEngine imageEngine;
  final Object? heroTag;
  final ui.ColorFilter? colorFilter;

  /// Image uri, it can be http url, assets file path (assets path must start with `assets`) or local file
  final String imageUri;

  final bool isAntiAlias;
  final bool matchTextDirection;
  final ImageRepeat repeat;
  final double scale;
  final String? semanticLabel;
  final double? width;
  final bool svgSkiaMode;
  final IconData? icon;

  /// For Icon only
  final double? size;

  /// For Icon only
  final TextDirection? textDirection;

  final String assetPrefix;

  bool get _isNetwork => imageUri.startsWith('http');

  bool get _isAsset => imageUri.startsWith(assetPrefix);

  bool get _isSvg => imageUri.endsWith('.svg');

  bool get _isIcon => icon != null;

  bool get _isMemory => imageUri.startsWith(_memoryUriPrefix);

  /// Create svg image widget.
  ///
  /// For web (without skia enable), it uses [Image](https://api.flutter.dev/flutter/widgets/Image-class.html)
  ///
  /// Otherwise it uses [flutter_svg](https://pub.dev/packages/flutter_svg)
  Widget _createSvgImage() {
    if (_isAsset) {
      return SvgPicture.asset(
        imageUri,
        key: key,
        fit: fit ?? BoxFit.contain,
        width: width,
        height: height,
        alignment: alignment,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder:
            placeholder != null ? (BuildContext context) => placeholder! : null,
        colorFilter: _getColorFilter(colorFilter, color, colorBlendMode),
      );
    }

    if (_isNetwork) {
      return SvgPicture.network(
        imageUri,
        key: key,
        fit: fit ?? BoxFit.contain,
        width: width,
        height: height,
        alignment: alignment,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
        placeholderBuilder:
            placeholder != null ? (BuildContext context) => placeholder! : null,
        colorFilter: _getColorFilter(colorFilter, color, colorBlendMode),
      );
    }

    return svgFile(
      imageUri,
      key: key,
      fit: fit ?? BoxFit.contain,
      color: color,
      width: width,
      height: height,
      alignment: alignment,
      colorBlendMode: colorBlendMode ?? BlendMode.srcIn,
      excludeFromSemantics: excludeFromSemantics,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholder: placeholder,
      colorFilter: colorFilter,
    );
  }

  /// Create any image type except svg
  /// It uses [extended_image](https://github.com/fluttercandies/extended_image)
  Widget _createOtherImage() {
    if (_isAsset) {
      if (imageEngine == ImageEngine.defaultImage) {
        return Image.asset(
          imageUri,
          key: key,
          fit: fit,
          filterQuality: filterQuality,
          scale: scale,
          color: color,
          width: width,
          height: height,
          alignment: alignment,
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
        );
      }

      return ExtendedImage.asset(
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
        enableMemoryCache: enableMemoryCache,
        clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        maxBytes: maxBytes,
        compressionRatio: compressionRatio,
        heroBuilderForSlidingPage: heroTag != null
            ? (widget) {
                return Hero(
                  tag: heroTag!,
                  child: widget,
                  flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) {
                    var hero = (flightDirection == HeroFlightDirection.pop
                        ? fromHeroContext.widget
                        : toHeroContext.widget) as Hero;
                    return hero.child;
                  },
                );
              }
            : null,
      );
    }

    if (_isNetwork) {
      if (imageEngine == ImageEngine.defaultImage) {
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
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        );
      }
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
        maxBytes: maxBytes,
        compressionRatio: compressionRatio,
        heroBuilderForSlidingPage: heroTag != null
            ? (widget) {
                return Hero(
                  tag: heroTag!,
                  child: widget,
                  flightShuttleBuilder: (BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext) {
                    var hero = (flightDirection == HeroFlightDirection.pop
                        ? fromHeroContext.widget
                        : toHeroContext.widget) as Hero;
                    return hero.child;
                  },
                );
              }
            : null,
      );
    }

    if (imageEngine == ImageEngine.defaultImage) {
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
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
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
      enableMemoryCache: enableMemoryCache,
      clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
      clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
      maxBytes: maxBytes,
      compressionRatio: compressionRatio,
      heroBuilderForSlidingPage: heroTag != null
          ? (widget) {
              return Hero(
                tag: heroTag!,
                child: widget,
                flightShuttleBuilder: (BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext) {
                  var hero = (flightDirection == HeroFlightDirection.pop
                      ? fromHeroContext.widget
                      : toHeroContext.widget) as Hero;
                  return hero.child;
                },
              );
            }
          : null,
    );
  }

  Widget _createIconImage() {
    return Icon(
      icon,
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

  ui.ColorFilter? _getColorFilter(
      ui.ColorFilter? filter, ui.Color? color, ui.BlendMode? colorBlendMode) {
    if (filter != null) {
      return filter;
    }

    if (color != null) {
      return ui.ColorFilter.mode(color, colorBlendMode ?? ui.BlendMode.srcIn);
    }

    return null;
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

  /// Precache the image
  static Future<void> precache(BuildContext context, String imageUri,
      {String assetPrefix = 'assets'}) async {
    if (imageUri.endsWith('.svg')) {
      if (imageUri.startsWith(assetPrefix)) {
        final loader = SvgAssetLoader(imageUri);
        await svg.cache
            .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      } else if (imageUri.startsWith('http')) {
        final loader = SvgNetworkLoader(imageUri);
        await svg.cache
            .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      } else {
        await precacheSvgFile(imageUri);
      }
    } else {
      if (imageUri.startsWith(assetPrefix)) {
        await precacheImage(ExtendedExactAssetImageProvider(imageUri), context);
      } else if (imageUri.startsWith('http')) {
        await precacheImage(ExtendedNetworkImageProvider(imageUri), context);
      } else {
        await precacheExtendedImageFile(context, imageUri);
      }
    }
  }
}
