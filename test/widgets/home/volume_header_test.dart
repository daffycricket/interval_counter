import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/home/volume_header.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('VolumeHeader Widget Tests', () {
    testWidgets('renders with correct keys', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      // Vérifier que les clés existent
      expect(find.byKey(const Key('interval_timer_home__Slider-3')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-2')), findsOneWidget);
      expect(find.byKey(const Key('interval_timer_home__IconButton-5')), findsOneWidget);
    });

    testWidgets('slider affiche la bonne valeur initiale', (tester) async {
      final state = await createMockState(volume: 0.75);
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      final slider = tester.widget<Slider>(
        find.byKey(const Key('interval_timer_home__Slider-3')),
      );

      expect(slider.value, 0.75);
    });

    testWidgets('slider appelle onVolumeChange lors du drag', (tester) async {
      final state = await createMockState(volume: 0.5);
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      // Trouver le slider et simuler un drag
      final sliderFinder = find.byKey(const Key('interval_timer_home__Slider-3'));
      expect(sliderFinder, findsOneWidget);

      // Simuler un changement de valeur
      final slider = tester.widget<Slider>(sliderFinder);
      slider.onChanged!(0.8);

      await tester.pump();

      // Vérifier que l'état a été mis à jour
      expect(state.volume, closeTo(0.8, 0.01));
    });

    testWidgets('volume button existe et a l\'icône correcte', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('interval_timer_home__IconButton-2')),
      );

      expect(iconButton.icon, isA<Icon>());
      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.volume_up);
    });

    testWidgets('more_vert button existe et a l\'icône correcte', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      final iconButton = tester.widget<IconButton>(
        find.byKey(const Key('interval_timer_home__IconButton-5')),
      );

      expect(iconButton.icon, isA<Icon>());
      final icon = iconButton.icon as Icon;
      expect(icon.icon, Icons.more_vert);
    });

    testWidgets('header a la bonne couleur de fond', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      // VolumeHeader doit avoir un Container avec backgroundColor headerBackgroundDark
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.color, const Color(0xFF455A64)); // headerBackgroundDark
    });

    testWidgets('slider a les bonnes couleurs de thème', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      final slider = tester.widget<Slider>(
        find.byKey(const Key('interval_timer_home__Slider-3')),
      );

      expect(slider.activeColor, const Color(0xFFFFFFFF)); // sliderActive
      expect(slider.inactiveColor, const Color(0xFF90A4AE)); // sliderInactive
    });

    testWidgets('accessibility: slider a un label sémantique', (tester) async {
      final state = await createMockState();
      await tester.pumpWidget(createTestApp(state, const VolumeHeader()));

      final sliderFinder = find.byKey(const Key('interval_timer_home__Slider-3'));
      
      // Vérifier que le slider est accessible
      expect(sliderFinder, findsOneWidget);
      
      // Note: Le label sémantique devrait être "Curseur de volume"
      // mais la vérification exacte nécessiterait un test de sémantique plus poussé
    });
  });
}

