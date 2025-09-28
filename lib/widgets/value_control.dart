import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ValueControl extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final String decreaseKey;
  final String valueKey;
  final String increaseKey;

  const ValueControl({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
    required this.decreaseKey,
    required this.valueKey,
    required this.increaseKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: AppTheme.getSpacing('xs')),
          child: Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        // Contrôles
        SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bouton diminuer
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(AppTheme.getRadius('md')),
                ),
                child: IconButton(
                  key: Key(decreaseKey),
                  onPressed: onDecrease,
                  icon: const Icon(Icons.remove),
                  color: AppColors.primary,
                  padding: EdgeInsets.all(AppTheme.getSpacing('xs')),
                  splashRadius: 18,
                ),
              ),
              // Valeur
              Expanded(
                child: Center(
                  child: Text(
                    value,
                    key: Key(valueKey),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
              // Bouton augmenter
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(AppTheme.getRadius('md')),
                ),
                child: IconButton(
                  key: Key(increaseKey),
                  onPressed: onIncrease,
                  icon: const Icon(Icons.add),
                  color: AppColors.primary,
                  padding: EdgeInsets.all(AppTheme.getSpacing('xs')),
                  splashRadius: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
