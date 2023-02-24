import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

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
  throw UnsupportedError('File is not supported on web');
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
  throw UnsupportedError('File is not supported on web');
}

Future<void> precacheSvgFile(String imageUri) async {
  // do nothing on web
}

Future<void> precacheExtendedImageFile(
    BuildContext context, String imageUri) async {
  // do nothing on web
}
