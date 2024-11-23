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
          'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=';

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
      Uint8List imageData = ('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAA' +
              'AAC0lEQVR42mP8/5+hHgAFGwJ/uErYHwAAAABJRU5ErkJggg==')
          .base64Bytes;

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
