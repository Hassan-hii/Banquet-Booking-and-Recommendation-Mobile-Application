/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/auth_bg.png
  AssetGenImage get authBg => const AssetGenImage('assets/images/auth_bg.png');

  /// File path: assets/images/banquet_logo.png
  AssetGenImage get banquetLogo =>
      const AssetGenImage('assets/images/banquet_logo.png');

  /// File path: assets/images/bookings.png
  AssetGenImage get bookings =>
      const AssetGenImage('assets/images/bookings.png');

  /// File path: assets/images/capacity.png
  AssetGenImage get capacity =>
      const AssetGenImage('assets/images/capacity.png');

  /// File path: assets/images/confetti.png
  AssetGenImage get confetti =>
      const AssetGenImage('assets/images/confetti.png');

  /// File path: assets/images/dessert.png
  AssetGenImage get dessert => const AssetGenImage('assets/images/dessert.png');

  /// File path: assets/images/drinks.png
  AssetGenImage get drinks => const AssetGenImage('assets/images/drinks.png');

  /// File path: assets/images/food_available.png
  AssetGenImage get foodAvailable =>
      const AssetGenImage('assets/images/food_available.png');

  /// File path: assets/images/home.png
  AssetGenImage get home => const AssetGenImage('assets/images/home.png');

  /// File path: assets/images/main_course.png
  AssetGenImage get mainCourse =>
      const AssetGenImage('assets/images/main_course.png');

  /// File path: assets/images/parking.png
  AssetGenImage get parking => const AssetGenImage('assets/images/parking.png');

  /// File path: assets/images/price_tag.png
  AssetGenImage get priceTag =>
      const AssetGenImage('assets/images/price_tag.png');

  /// File path: assets/images/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/images/profile.png');

  /// File path: assets/images/take_away_food.png
  AssetGenImage get takeAwayFood =>
      const AssetGenImage('assets/images/take_away_food.png');

  /// File path: assets/images/thumbs_up_down.png
  AssetGenImage get thumbsUpDown =>
      const AssetGenImage('assets/images/thumbs_up_down.png');

  /// File path: assets/images/type.png
  AssetGenImage get type => const AssetGenImage('assets/images/type.png');

  /// File path: assets/images/upcoming_events.png
  AssetGenImage get upcomingEvents =>
      const AssetGenImage('assets/images/upcoming_events.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        authBg,
        banquetLogo,
        bookings,
        capacity,
        confetti,
        dessert,
        drinks,
        foodAvailable,
        home,
        mainCourse,
        parking,
        priceTag,
        profile,
        takeAwayFood,
        thumbsUpDown,
        type,
        upcomingEvents
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
