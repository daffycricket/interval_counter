import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/volume_header.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  group('VolumeHeader', () {
    testWidgets('renders with menu button when onMenuPressed is provided', (tester) async {
      double volume = 0.5;
      bool menuPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: VolumeHeader(
              volume: volume,
              onVolumeChange: (value) {
                volume = value;
              },
              onMenuPressed: () {
                menuPressed = true;
              },
            ),
          ),
        ),
      );

      // Verify volume icon
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      
      // Verify slider
      expect(find.byType(Slider), findsOneWidget);
      
      // Verify menu button (should be present)
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      
      // Tap menu button
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump();
      
      expect(menuPressed, true);
    });

    testWidgets('renders without menu button when onMenuPressed is null', (tester) async {
      double volume = 0.5;
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: VolumeHeader(
              volume: volume,
              onVolumeChange: (value) {
                volume = value;
              },
              onMenuPressed: null, // No menu button
            ),
          ),
        ),
      );

      // Verify volume icon
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      
      // Verify slider
      expect(find.byType(Slider), findsOneWidget);
      
      // Verify menu button is NOT present
      expect(find.byIcon(Icons.more_vert), findsNothing);
    });

    testWidgets('calls onVolumeChange when slider is moved', (tester) async {
      double volume = 0.5;
      double? changedVolume;
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: VolumeHeader(
              volume: volume,
              onVolumeChange: (value) {
                changedVolume = value;
              },
              onMenuPressed: null,
            ),
          ),
        ),
      );

      // Find and interact with slider
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);
      
      // Get slider widget
      final Slider slider = tester.widget(sliderFinder);
      
      // Trigger onChanged with new value
      slider.onChanged!(0.8);
      await tester.pump();
      
      expect(changedVolume, 0.8);
    });

    testWidgets('volume icon button does nothing (informative only)', (tester) async {
      double volume = 0.5;
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr')],
          home: Scaffold(
            body: VolumeHeader(
              volume: volume,
              onVolumeChange: (value) {},
              onMenuPressed: null,
            ),
          ),
        ),
      );

      // Tap volume icon (should do nothing, just informative)
      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();
      
      // No exception should be thrown
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });
  });
}

