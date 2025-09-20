import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../theme/text_styles.dart';

class PresetCard extends StatelessWidget {
  const PresetCard({
    super.key,
    required this.name,
    required this.time,
    required this.repetitions,
    required this.workTime,
    required this.restTime,
    this.onTap,
  });

  final String name;
  final String time;
  final String repetitions;
  final String workTime;
  final String restTime;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: Tokens.rMd,
        side: const BorderSide(color: Tokens.divider),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: Tokens.rMd,
        child: Padding(
          padding: const EdgeInsets.all(Tokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name, style: AppTextStyles.body),
                  Text(time, style: AppTextStyles.muted),
                ],
              ),
              const SizedBox(height: Tokens.spaceSm),
              Text('RÉPÉTITIONS $repetitions', style: AppTextStyles.label),
              const SizedBox(height: Tokens.spaceXs),
              Text('TRAVAIL $workTime', style: AppTextStyles.label),
              const SizedBox(height: Tokens.spaceXs),
              Text('REPOS $restTime', style: AppTextStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}
