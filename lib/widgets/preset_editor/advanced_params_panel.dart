import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/preset_editor_state.dart';
import 'advanced_group_card.dart';
import 'add_group_button.dart';
import 'finish_card.dart';
import 'color_picker_dialog.dart';

/// Panneau principal du mode ADVANCED, orchestrant les groupes,
/// le bouton ajouter groupe, et la carte FINISH.
class AdvancedParamsPanel extends StatelessWidget {
  const AdvancedParamsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PresetEditorState>();

    return Column(
      children: [
        // Groups list
        for (var groupIdx = 0; groupIdx < state.groups.length; groupIdx++)
          AdvancedGroupCard(
            group: state.groups[groupIdx],
            groupIndex: groupIdx,
            subtotal: state.formattedGroupSubtotal(groupIdx),
            onIncrementReps: () => state.incrementGroupReps(groupIdx),
            onDecrementReps: () => state.decrementGroupReps(groupIdx),
            onAddStep: () => state.addStep(groupIdx),
            onModeToggle: (stepIdx) => state.toggleStepMode(groupIdx, stepIdx),
            onIncrementStepValue: (stepIdx) =>
                state.incrementStepValue(groupIdx, stepIdx),
            onDecrementStepValue: (stepIdx) =>
                state.decrementStepValue(groupIdx, stepIdx),
            onIncrementStepDuration: (stepIdx) =>
                state.incrementStepDuration(groupIdx, stepIdx),
            onDecrementStepDuration: (stepIdx) =>
                state.decrementStepDuration(groupIdx, stepIdx),
            onStepColorTap: (stepIdx) => _pickStepColor(context, state, groupIdx, stepIdx),
            onDuplicateStep: (stepIdx) => state.duplicateStep(groupIdx, stepIdx),
            onDeleteStep: (stepIdx) => state.removeStep(groupIdx, stepIdx),
            onReorderStep: (oldIdx, newIdx) =>
                state.reorderStep(groupIdx, oldIdx, newIdx),
          ),

        // Add group button + TOTAL
        AddGroupButton(
          onTap: state.addGroup,
          formattedTotal: state.formattedTotal,
        ),

        // FINISH card
        FinishCard(
          finishColor: state.finishColor,
          alarmBeeps: state.finishAlarmBeeps,
          onColorTap: () => _pickFinishColor(context, state),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _pickStepColor(
    BuildContext context,
    PresetEditorState state,
    int groupIdx,
    int stepIdx,
  ) async {
    final currentColor = state.groups[groupIdx].steps[stepIdx].color;
    final color = await ColorPickerDialog.show(
      context,
      currentColor: currentColor,
    );
    if (color != null) {
      state.setStepColor(groupIdx, stepIdx, color);
    }
  }

  Future<void> _pickFinishColor(
    BuildContext context,
    PresetEditorState state,
  ) async {
    final color = await ColorPickerDialog.show(
      context,
      currentColor: state.finishColor,
    );
    if (color != null) {
      state.setFinishColor(color);
    }
  }
}
