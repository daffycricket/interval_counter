import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Widget de contrôle de valeur avec boutons +/- et affichage central,
/// en **grille à largeurs fixes** pour garantir l'alignement entre lignes.
class ValueControl extends StatelessWidget {
  // Tailles par défaut (px). Modifiables via les paramètres constructeur si besoin.
  static const double _defaultOuterBlank = 70;   // espace blanc gauche/droite
  static const double _defaultBtnSize    = 22;    // bouton carré
  static const double _defaultGap        = 40;   // espaces blancs entre éléments
  static const double _defaultCenterW    = 80;   // largeur dédiée à la valeur
  static const double _defaultRadius     = 2;
  static const double _defaultIconSize   = 16;

  final String label;
  final String value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final String? decreaseKey;
  final String? increaseKey;
  final String? valueKey;
  final String decreaseSemanticLabel;
  final String increaseSemanticLabel;
  final bool decreaseEnabled;
  final bool increaseEnabled;

  // Paramètres optionnels pour ajuster les largeurs sans toucher l'écran Home.
  final double outerBlank;
  final double btnSize;
  final double gap;
  final double centerWidth;
  final double borderRadius;
  final double iconSize;

  const ValueControl({
    super.key,
    required this.label,
    required this.value,
    this.onDecrease,
    this.onIncrease,
    this.decreaseKey,
    this.increaseKey,
    this.valueKey,
    required this.decreaseSemanticLabel,
    required this.increaseSemanticLabel,
    this.decreaseEnabled = true,
    this.increaseEnabled = true,
    this.outerBlank = _defaultOuterBlank,
    this.btnSize = _defaultBtnSize,
    this.gap = _defaultGap,
    this.centerWidth = _defaultCenterW,
    this.borderRadius = _defaultRadius,
    this.iconSize = _defaultIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label centré
        Text(label, textAlign: TextAlign.center, style: AppTextStyles.label),
        const SizedBox(height: 12),

        // Ligne à largeurs fixes ; scroll horizontal si trop large pour l'écran
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: outerBlank),

              // Bouton -
              _squareBtn(
                icon: Icons.remove,
                onPressed: decreaseEnabled ? onDecrease : null,
                semantic: decreaseSemanticLabel,
                keyString: decreaseKey,
              ),

              SizedBox(width: gap),

              // Valeur centrée dans un bloc largeur fixe
              SizedBox(
                width: centerWidth,
                child: Center(
                  child: Text(
                    value,
                    key: valueKey != null ? Key(valueKey!) : null,
                    style: AppTextStyles.value,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),

              SizedBox(width: gap),

              // Bouton +
              _squareBtn(
                icon: Icons.add,
                onPressed: increaseEnabled ? onIncrease : null,
                semantic: increaseSemanticLabel,
                keyString: increaseKey,
              ),

              SizedBox(width: outerBlank),
            ],
          ),
        ),
      ],
    );
  }

  Widget _squareBtn({
    required IconData icon,
    required VoidCallback? onPressed,
    required String semantic,
    String? keyString,
  }) {
    final enabled = onPressed != null;
    return Semantics(
      label: semantic,
      button: true,
      enabled: enabled,
      child: SizedBox(
        width: btnSize,
        height: btnSize,
        child: Material(
          key: keyString != null ? Key(keyString) : null,
          color: enabled ? Colors.black : AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Center(
              child: Icon(icon, size: iconSize, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
