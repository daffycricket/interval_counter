import 'package:flutter/material.dart';

/// Contrôle ±/valeur pour une étape avancée (temps ou répétitions).
class StepValueControl extends StatelessWidget {
  final String value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final String decreaseSemanticLabel;
  final String increaseSemanticLabel;
  final Color foregroundColor;
  final Color borderColor;

  const StepValueControl({
    super.key,
    required this.value,
    this.onDecrease,
    this.onIncrease,
    required this.decreaseSemanticLabel,
    required this.increaseSemanticLabel,
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(
          icon: Icons.remove,
          onPressed: onDecrease,
          semanticLabel: decreaseSemanticLabel,
        ),
        Expanded(
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
            ),
          ),
        ),
        _buildButton(
          icon: Icons.add,
          onPressed: onIncrease,
          semanticLabel: increaseSemanticLabel,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: onPressed != null,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: borderColor),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4),
            child: Center(
              child: Icon(icon, size: 16, color: foregroundColor),
            ),
          ),
        ),
      ),
    );
  }
}
