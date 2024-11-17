import 'dart:convert';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_image/universal_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  group('UniversalImage Widget Tests', () {
    testWidgets('Displays an asset image correctly',
        (WidgetTester tester) async {
      // Path to asset image (ensure this image exists in your assets)
      const String assetImagePath = 'example/assets/sample.png';

      await tester.pumpWidget(
        MaterialApp(
          home: UniversalImage(assetImagePath),
        ),
      );

      // Verify that an Image widget is displayed
      expect(find.byType(ExtendedImage), findsOneWidget);
    });

    testWidgets('Displays a network image correctly',
        (WidgetTester tester) async {
      const String networkImageUrl = 'https://picsum.photos/200';

      // Use network_image_mock to mock network images
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: UniversalImage(networkImageUrl),
          ),
        );

        // Wait for the image to load
        await tester.pump(Duration(seconds: 5));

        // Verify that an ExtendedImage widget is displayed for network images
        expect(find.byType(ExtendedImage), findsOneWidget);
      });
    });

    testWidgets('Displays an SVG asset correctly', (WidgetTester tester) async {
      // Path to SVG asset (ensure this image exists in your assets)
      const String svgAssetPath = 'example/assets/sample.svg';

      await tester.pumpWidget(
        MaterialApp(
          home: UniversalImage(svgAssetPath),
        ),
      );

      // Verify that an SvgPicture widget is displayed
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('Displays a base64 image correctly',
        (WidgetTester tester) async {
      // Base64 string of a small red dot image
      const String base64ImageString =
          'base64://iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAA' +
              'AAC0lEQVR42mP8/5+hHgAFGwJ/uErYHwAAAABJRU5ErkJggg==';

      await tester.pumpWidget(
        MaterialApp(
          home: UniversalImage(base64ImageString),
        ),
      );

      // Verify that an Image widget is displayed
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Displays a memory image correctly',
        (WidgetTester tester) async {
      // Uint8List representing a small red dot image
      Uint8List imageData = base64Decode(
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAA' +
              'AAC0lEQVR42mP8/5+hHgAFGwJ/uErYHwAAAABJRU5ErkJggg==');

      await tester.pumpWidget(
        MaterialApp(
          home: UniversalImage(imageData),
        ),
      );

      // Verify that an Image widget is displayed
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Displays an icon correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: UniversalImage(Icons.add),
        ),
      );

      // Verify that an Icon widget is displayed
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('Shows placeholder while loading network image',
        (WidgetTester tester) async {
      const String networkImageUrl =
          'https://example.com/nonexistent_image.jpg';

      // Create a placeholder widget
      const placeholderWidget = CircularProgressIndicator();

      // Use network_image_mock to mock network images
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: UniversalImage(
              networkImageUrl,
              placeholder: placeholderWidget,
            ),
          ),
        );

        // Since network images can't be loaded in widget tests,
        // the placeholder should be displayed
        await tester.pump(); // Simulate a frame
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
