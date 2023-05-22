import 'dart:io';
import 'dart:ui' as ui;
import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgFile(
  String imageUri, {
  Key? key,
  BoxFit? fit,
  Color? color,
  double? width,
  double? height,
  Alignment alignment = Alignment.center,
  BlendMode? colorBlendMode,
  bool excludeFromSemantics = false,
  bool matchTextDirection = false,
  bool allowDrawingOutsideViewBox = false,
  Widget? placeholder,
  bool cacheColorFilter = false,
  ui.ColorFilter? colorFilter,
}) {
  return SvgPicture.file(
    File(imageUri),
    key: key,
    fit: fit ?? BoxFit.contain,
    width: width,
    height: height,
    alignment: alignment,
    excludeFromSemantics: excludeFromSemantics,
    matchTextDirection: matchTextDirection,
    allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    placeholderBuilder:
        placeholder != null ? (BuildContext context) => placeholder : null,
    colorFilter: _getColorFilter(colorFilter, color, colorBlendMode),
  );
}

Widget extendedImageFile(
  String imageUri, {
  Key? key,
  BoxFit? fit,
  Color? color,
  double? width,
  double? height,
  Alignment alignment = Alignment.center,
  BlendMode? colorBlendMode,
  bool excludeFromSemantics = false,
  bool matchTextDirection = false,
  Widget? placeholder,
  double scale = 1.0,
  FilterQuality filterQuality = FilterQuality.low,
  bool isAntiAlias = false,
  ImageRepeat repeat = ImageRepeat.noRepeat,
  Rect? centerSlice,
  String? semanticLabel,
  bool gaplessPlayback = false,
  int? cacheWidth,
  int? cacheHeight,
  Widget? errorPlaceholder,
  bool enableMemoryCache = true,
  bool clearMemoryCacheIfFailed = true,
  bool clearMemoryCacheWhenDispose = false,
  int? maxBytes,
  double? compressionRatio,
}) {
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
    maxBytes: maxBytes,
    compressionRatio: compressionRatio,
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

Future<void> precacheSvgFile(String imageUri) async {
  final loader = SvgAssetLoader(imageUri);
  await svg.cache
      .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
}

Future<void> precacheExtendedImageFile(
    BuildContext context, String imageUri) async {
  await precacheImage(ExtendedFileImageProvider(File(imageUri)), context);
}
