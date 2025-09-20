import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../theme/text_styles.dart';
import '../components/layout/labeled_value_row.dart';
import '../components/buttons/primary_button.dart';
import '../components/cards/preset_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int repetitions = 16;
  int workMinutes = 0;
  int workSeconds = 44;
  int restMinutes = 0;
  int restSeconds = 15;

  String get workTimeFormatted => '${workMinutes.toString().padLeft(2, '0')} : ${workSeconds.toString().padLeft(2, '0')}';
  String get restTimeFormatted => '${restMinutes.toString().padLeft(2, '0')} : ${restSeconds.toString().padLeft(2, '0')}';

  void _incrementRepetitions() {
    setState(() {
      repetitions++;
    });
  }

  void _decrementRepetitions() {
    if (repetitions > 1) {
      setState(() {
        repetitions--;
      });
    }
  }

  void _incrementWorkTime() {
    setState(() {
      workSeconds++;
      if (workSeconds >= 60) {
        workSeconds = 0;
        workMinutes++;
      }
    });
  }

  void _decrementWorkTime() {
    if (workMinutes > 0 || workSeconds > 1) {
      setState(() {
        workSeconds--;
        if (workSeconds < 0) {
          workSeconds = 59;
          workMinutes--;
        }
      });
    }
  }

  void _incrementRestTime() {
    setState(() {
      restSeconds++;
      if (restSeconds >= 60) {
        restSeconds = 0;
        restMinutes++;
      }
    });
  }

  void _decrementRestTime() {
    if (restMinutes > 0 || restSeconds > 1) {
      setState(() {
        restSeconds--;
        if (restSeconds < 0) {
          restSeconds = 59;
          restMinutes--;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tokens.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Tokens.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with volume and menu
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement volume control
                    },
                    icon: const Icon(Icons.volume_up),
                    tooltip: 'Volume',
                  ),
                  Expanded(
                    child: Slider(
                      value: 0.5,
                      onChanged: (value) {
                        // TODO: Implement volume slider
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement menu
                    },
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Menu',
                  ),
                ],
              ),
              
              const SizedBox(height: Tokens.spaceLg),
              
              // Quick Start Section
              Text('Démarrage rapide', style: AppTextStyles.title),
              
              const SizedBox(height: Tokens.spaceXl),
              
              // Repetitions
              LabeledValueRow(
                label: 'RÉPÉTITIONS',
                value: repetitions.toString(),
                onMinus: _decrementRepetitions,
                onPlus: _incrementRepetitions,
              ),
              
              const SizedBox(height: Tokens.spaceXl),
              
              // Work time
              LabeledValueRow(
                label: 'TRAVAIL',
                value: workTimeFormatted,
                onMinus: _decrementWorkTime,
                onPlus: _incrementWorkTime,
              ),
              
              const SizedBox(height: Tokens.spaceXl),
              
              // Rest time
              LabeledValueRow(
                label: 'REPOS',
                value: restTimeFormatted,
                onMinus: _decrementRestTime,
                onPlus: _incrementRestTime,
              ),
              
              const SizedBox(height: Tokens.spaceXl),
              
              // Save button
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement save preset
                    },
                    icon: const Icon(Icons.bookmark_border),
                    tooltip: 'Sauvegarder',
                  ),
                  const SizedBox(width: Tokens.spaceSm),
                  Text('SAUVEGARDER', style: AppTextStyles.label),
                ],
              ),
              
              const SizedBox(height: Tokens.spaceXl),
              
              // Start button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: '⚡ COMMENCER',
                  onPressed: () {
                    // TODO: Implement start timer
                  },
                ),
              ),
              
              const SizedBox(height: Tokens.spaceXl),
              
              // Presets section
              Row(
                children: [
                  Text('VOS PRÉRÉGLAGES', style: AppTextStyles.title),
                  const SizedBox(width: Tokens.spaceSm),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement edit presets
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: 'Modifier vos préréglages',
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement add preset
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Tokens.text,
                      side: const BorderSide(color: Tokens.text),
                    ),
                    child: const Text('+ AJOUTER'),
                  ),
                ],
              ),
              
              const SizedBox(height: Tokens.spaceLg),
              
              // Preset cards
              PresetCard(
                name: 'gainage',
                time: '14:22',
                repetitions: '20x',
                workTime: '00:40',
                restTime: '00:03',
                onTap: () {
                  // TODO: Implement load preset
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
