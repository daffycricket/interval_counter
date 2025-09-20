import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../theme/text_styles.dart';

class LabeledValueRow extends StatelessWidget {
  const LabeledValueRow({
    super.key,
    required this.label,
    required this.value,
    this.onMinus,
    this.onPlus,
  });

  final String label;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: Tokens.spaceSm),
        Row(
          children: [
            IconButton(
              onPressed: onMinus,
              icon: const Icon(Icons.remove),
              tooltip: 'Réduire $label',
            ),
            const SizedBox(width: Tokens.spaceSm),
            Text(value, style: AppTextStyles.body.copyWith(fontSize: 18)),
            const SizedBox(width: Tokens.spaceSm),
            IconButton(
              onPressed: onPlus,
              icon: const Icon(Icons.add),
              tooltip: 'Augmenter $label',
            ),
          ],
        ),
      ],
    );
  }
}
