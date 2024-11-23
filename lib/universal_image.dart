library universal_image;

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:extended_image/extended_image.dart';
import 'platforms/file.dart';
import 'dart:convert';
import 'platforms/image_file.dart';

/// The prefix of memory data
const String _base64UriPrefix = 'data:image/';

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
/// `Icon provider`: `UniversalImage(Icons.add)`
///
/// `Memory provider`: `UniversalImage('base64://base64string')`
class UniversalImage extends StatelessWidget {
  ///
  /// Create image widet base on uri
  ///
  const UniversalImage(
    this.imageSource, {
    Key? key,
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
  })  : assert(imageSource is String ||
            imageSource is IconData ||
            imageSource is Uint8List),
        super(key: key);

  ///Represents the alignment of the image within its container.
  final Alignment alignment;

  /// A boolean property that determines whether the image can be drawn outside its viewBox. Default is `false`.
  final bool allowDrawingOutsideViewBox;

  /// An optional integer property that sets the height of the image cache.
  final int? cacheHeight;

  /// An optional integer property that sets the width of the image cache.
  final int? cacheWidth;

  ///  An optional `Rect` property that defines the center slice of the image.
  final Rect? centerSlice;

  /// An optional `Color` property that sets the color of the image.
  final Color? color;

  /// An optional `BlendMode` property that defines how the image color should blend with the background.
  final BlendMode? colorBlendMode;

  /// An optional `ImageErrorWidgetBuilder` property that defines the error widget when the image fails to load.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// A boolean property that determines whether the image is excluded from semantics. Default is `false`.
  final bool excludeFromSemantics;

  /// A `FilterQuality` property that sets the quality of image filtering.
  final FilterQuality filterQuality;

  /// An optional `BoxFit` property that defines how the image should fit within its container.
  final BoxFit? fit;

  /// An optional `ImageFrameBuilder` property that defines the frame builder for the image.
  final ImageFrameBuilder? frameBuilder;

  /// A boolean property that determines whether the image should have gapless playback. Default is `false`.
  final bool gaplessPlayback;

  /// An optional double property that sets the height of the image.
  final double? height;

  /// An optional `Widget` property that defines the placeholder widget displayed while the image is loading.
  final Widget? placeholder;

  /// An optional `Widget` property that defines the error placeholder widget displayed when the image fails to load.
  final Widget? errorPlaceholder;

  /// A boolean property that determines whether the image should be cached. Default is `true`.
  final bool cache;

  /// A boolean property that determines whether the memory cache is enabled. Default is `true`.
  final bool enableMemoryCache;

  /// A boolean property that determines whether to clear the memory cache if the image fails to load. Default is `true`.
  final bool clearMemoryCacheIfFailed;

  /// A boolean property that determines whether to clear the memory cache when the widget is disposed. Default is `false`.
  final bool clearMemoryCacheWhenDispose;

  /// An optional double property that sets the image compression ratio.
  final double? compressionRatio;

  ///  An optional integer property that sets the maximum number of bytes for the image.
  final int? maxBytes;

  /// An `ImageEngine` property that sets the image engine.
  final ImageEngine imageEngine;

  ///  An optional `Object` property that sets the hero tag for the image.
  final Object? heroTag;

  /// An optional `ui.ColorFilter` property that sets the color filter of the image.
  final ui.ColorFilter? colorFilter;

  /// Image source, it can be http url, assets file path (assets path must start with `assets`), local file or icon data
  final dynamic imageSource;

  /// A boolean property that determines whether the image should be anti-aliased. Default is `false`.
  final bool isAntiAlias;

  /// Indicates whether the image should match the text direction or not.
  final bool matchTextDirection;

  /// Determines how the image should be repeated.
  final ImageRepeat repeat;

  /// The scale to apply to the image.
  final double scale;

  /// The semantic label for the image, used for accessibility.
  final String? semanticLabel;

  /// The width of the image.
  final double? width;

  /// Indicates whether the image should be rendered using Skia for SVGs.
  final bool svgSkiaMode;

  /// The size of the icon, if the resource is an icon.
  final double? size;

  /// The text direction for the icon, if the resource is an icon.
  final TextDirection? textDirection;

  /// The prefix used for asset images.
  final String assetPrefix;

  /// Checks if the image is a network image.
  bool get _isNetwork => imageUri.startsWith('http');

  /// Checks if the image is an asset image.
  bool get _isAsset => imageUri.startsWith(assetPrefix);

  /// Checks if the image is an SVG.
  bool get _isSvg => imageUri.endsWith('.svg');

  /// Checks if the image is a base64 memory image.
  bool get _isBase64 => imageUri.startsWith(_base64UriPrefix);

  /// The URI string of the image.
  String get imageUri => imageSource.toString();

  /// The icon data, if the resource is an icon.
  IconData? get icon => imageSource is IconData ? imageSource : null;

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
      dynamic file = File(imageUri);
      return Image.file(
        file,
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

    dynamic file = File(imageUri);
    return ExtendedImage.file(
      file,
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

  ///
  /// Create image from icon data
  ///
  Widget _createIconImage() {
    return Icon(
      icon,
      size: size,
      color: color,
      textDirection: textDirection,
    );
  }

  /// Create image from base64 data
  Widget _createBase64Image() {
    var data = imageUri;
    var bytes = data.base64Bytes;
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

  /// Create image from memory image
  Widget _createMemoryImage() {
    Uint8List bytes = imageSource;
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

  ///
  /// Get color filter for svg base on `color` and `colorBlendMode`
  ///
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

  /// Build widget
  @override
  Widget build(BuildContext context) {
    if (imageSource is String) {
      if (_isSvg) return _createSvgImage();
      if (_isBase64) return _createBase64Image();
      return _createOtherImage();
    } else if (imageSource is IconData) {
      return _createIconImage();
    } else if (imageSource is Uint8List) {
      return _createMemoryImage();
    }

    throw Exception('Unsupported image type ${imageSource.runtimeType}');
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

extension $Uint8List on Uint8List {
  /// Convert bytes array into base64 image
  String get base64Image {
    final base64String = base64Encode(this);
    final format = _detectFormat(this);
    return 'data:${format};base64,$base64String';
  }
}

extension $String on String {
  /// Convert base64 image into bytes array
  Uint8List get base64Bytes {
    String normalizedString = this;
    if (normalizedString.contains(',')) {
      normalizedString = normalizedString.split(',')[1];
    }
    return base64Decode(normalizedString);
  }
}

/// Detect the MIME type of an image from its bytes.
///
/// Supports the following formats:
///
/// * JPEG
/// * PNG
/// * GIF
/// * WebP
/// * BMP
/// * TIFF (Intel and Motorola)
/// * ICO
///
/// If the format is not recognized, returns 'image/unknown'.
String _detectFormat(Uint8List bytes) {
  if (bytes.length < 12) {
    return 'image/unknown';
  }

  // Check for JPEG
  if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    return 'image/jpeg';
  }

  // Check for PNG
  if (bytes[0] == 0x89 &&
      bytes[1] == 0x50 && // P
      bytes[2] == 0x4E && // N
      bytes[3] == 0x47 && // G
      bytes[4] == 0x0D && // CR
      bytes[5] == 0x0A && // LF
      bytes[6] == 0x1A && // EOF
      bytes[7] == 0x0A) {
    // LF
    return 'image/png';
  }

  // Check for GIF
  if (bytes[0] == 0x47 && // G
      bytes[1] == 0x49 && // I
      bytes[2] == 0x46 && // F
      bytes[3] == 0x38 && // 8
      (bytes[4] == 0x37 || bytes[4] == 0x39) && // 7 or 9
      bytes[5] == 0x61) {
    return 'image/gif';
  }

  // Check for WebP
  if (bytes.length > 12 &&
      bytes[8] == 0x57 && // W
      bytes[9] == 0x45 && // E
      bytes[10] == 0x42 && // B
      bytes[11] == 0x50) {
    // P
    return 'image/webp';
  }

  // Check for BMP
  if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
    // BM
    return 'image/bmp';
  }

  // Check for TIFF (Intel)
  if (bytes[0] == 0x49 &&
      bytes[1] == 0x49 &&
      bytes[2] == 0x2A &&
      bytes[3] == 0x00) {
    return 'image/tiff';
  }

  // Check for TIFF (Motorola)
  if (bytes[0] == 0x4D &&
      bytes[1] == 0x4D &&
      bytes[2] == 0x00 &&
      bytes[3] == 0x2A) {
    return 'image/tiff';
  }

  // Check for ICO
  if (bytes[0] == 0x00 &&
      bytes[1] == 0x00 &&
      bytes[2] == 0x01 &&
      bytes[3] == 0x00) {
    return 'image/x-icon';
  }

  return 'image/unknown';
}
