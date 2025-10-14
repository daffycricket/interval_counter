import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interval_counter/widgets/interval_timer_home/volume_header.dart';
import '../../helpers/widget_test_helpers.dart';

void main() {
  group('VolumeHeader', () {
    testWidgets('renders with all keys', (tester) async {
      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.5,
          onVolumeToggle: () {},
          onVolumeChange: (_) {},
          onMoreOptions: () {},
        ),
      );

      expectWidgetWithKey('interval_timer_home__Container-1');
      expectWidgetWithKey('interval_timer_home__IconButton-2');
      expectWidgetWithKey('interval_timer_home__Slider-3');
      expectWidgetWithKey('interval_timer_home__IconButton-5');
    });

    testWidgets('Icon-4 is NOT rendered (excluded per rule)', (tester) async {
      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.5,
          onVolumeToggle: () {},
          onVolumeChange: (_) {},
          onMoreOptions: () {},
        ),
      );

      // Icon-4 should not exist (slider thumb sibling)
      expect(findByKeyString('interval_timer_home__Icon-4'), findsNothing);
    });

    testWidgets('volume toggle button calls callback', (tester) async {
      var toggled = false;

      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.5,
          onVolumeToggle: () => toggled = true,
          onVolumeChange: (_) {},
          onMoreOptions: () {},
        ),
      );

      await tapByKey(tester, 'interval_timer_home__IconButton-2');
      expect(toggled, true);
    });

    testWidgets('slider changes value', (tester) async {
      double? newValue;

      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.5,
          onVolumeToggle: () {},
          onVolumeChange: (value) => newValue = value,
          onMoreOptions: () {},
        ),
      );

      // Find the slider
      final slider = tester.widget<Slider>(
        findByKeyString('interval_timer_home__Slider-3'),
      );

      // Simulate value change
      slider.onChanged!(0.8);
      await tester.pump();

      expect(newValue, 0.8);
    });

    testWidgets('more options button calls callback', (tester) async {
      var called = false;

      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.5,
          onVolumeToggle: () {},
          onVolumeChange: (_) {},
          onMoreOptions: () => called = true,
        ),
      );

      await tapByKey(tester, 'interval_timer_home__IconButton-5');
      expect(called, true);
    });

    testWidgets('displays correct volume value', (tester) async {
      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.62,
          onVolumeToggle: () {},
          onVolumeChange: (_) {},
          onMoreOptions: () {},
        ),
      );

      final slider = tester.widget<Slider>(
        findByKeyString('interval_timer_home__Slider-3'),
      );

      expect(slider.value, 0.62);
    });

    testWidgets('has correct semantic labels', (tester) async {
      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.5,
          onVolumeToggle: () {},
          onVolumeChange: (_) {},
          onMoreOptions: () {},
        ),
      );

      // Volume button should have tooltip
      final volumeButton = tester.widget<IconButton>(
        findByKeyString('interval_timer_home__IconButton-2'),
      );
      expect(volumeButton.tooltip, 'Régler le volume');

      // More options button should have tooltip
      final moreButton = tester.widget<IconButton>(
        findByKeyString('interval_timer_home__IconButton-5'),
      );
      expect(moreButton.tooltip, 'Plus d\'options');
    });

    testWidgets('slider has semantic formatter', (tester) async {
      await pumpTestWidget(
        tester,
        VolumeHeader(
          volume: 0.75,
          onVolumeToggle: () {},
          onVolumeChange: (_) {},
          onMoreOptions: () {},
        ),
      );

      final slider = tester.widget<Slider>(
        findByKeyString('interval_timer_home__Slider-3'),
      );

      // Check semantic formatter returns percentage
      expect(slider.semanticFormatterCallback!(0.75), '75%');
      expect(slider.semanticFormatterCallback!(0.5), '50%');
      expect(slider.semanticFormatterCallback!(1.0), '100%');
    });
  });
}
