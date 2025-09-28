import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final VoidCallback? onToggle;
  final bool isExpanded;
  final String? toggleKey;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onToggle,
    this.isExpanded = true,
    this.toggleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppTheme.getSpacing('xxs')),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (action != null) action!,
          if (onToggle != null)
            IconButton(
              key: toggleKey != null ? Key(toggleKey!) : null,
              onPressed: onToggle,
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: AppColors.textSecondary,
              ),
              padding: EdgeInsets.all(AppTheme.getSpacing('xs')),
              splashRadius: 12,
            ),
        ],
      ),
    );
  }
}

class PresetsSectionHeader extends StatelessWidget {
  final VoidCallback? onAdd;
  final VoidCallback? onEdit;

  const PresetsSectionHeader({
    super.key,
    this.onAdd,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.getSpacing('xxs'),
        vertical: AppTheme.getSpacing('xxs'),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'VOS PRÉRÉGLAGES',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: AppTheme.getSpacing('md')),
              if (onEdit != null)
                IconButton(
                  key: const Key('interval_timer_home__edit_presets'),
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.all(AppTheme.getSpacing('xs')),
                  splashRadius: 12,
                ),
            ],
          ),
          if (onAdd != null)
            OutlinedButton.icon(
              key: const Key('interval_timer_home__add_preset_button'),
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('AJOUTER'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.getRadius('xl')),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.getSpacing('sm'),
                  vertical: AppTheme.getSpacing('xs'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
