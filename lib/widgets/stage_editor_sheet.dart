import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

Future<void> showStageEditorSheet(
  BuildContext context, {
  required List<ApplicationStatus> currentOrder,
  required Map<ApplicationStatus, String> currentLabels,
  required void Function(
    List<ApplicationStatus> order,
    Map<ApplicationStatus, String> labels,
  ) onSave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: FieldLog.bgPage,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (_) => _StageEditorSheet(
      currentOrder: currentOrder,
      currentLabels: currentLabels,
      onSave: onSave,
    ),
  );
}

class _StageEditorSheet extends StatefulWidget {
  final List<ApplicationStatus> currentOrder;
  final Map<ApplicationStatus, String> currentLabels;

  final void Function(
    List<ApplicationStatus> order,
    Map<ApplicationStatus, String> labels,
  ) onSave;

  const _StageEditorSheet({
    required this.currentOrder,
    required this.currentLabels,
    required this.onSave,
  });

  @override
  State<_StageEditorSheet> createState() => _StageEditorSheetState();
}

class _StageEditorSheetState extends State<_StageEditorSheet> {
  late List<ApplicationStatus> _order;

  final Map<ApplicationStatus, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();

    _order = List<ApplicationStatus>.from(widget.currentOrder);

    for (final status in ApplicationStatus.values) {
      _controllers[status] = TextEditingController(
        text: widget.currentLabels[status] ?? status.label,
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _reset() {
    setState(() {
      _order = [
        ApplicationStatus.applied,
        ApplicationStatus.screening,
        ApplicationStatus.interview,
        ApplicationStatus.offer,
        ApplicationStatus.rejected,
      ];

      for (final status in ApplicationStatus.values) {
        _controllers[status]!.text = status.label;
      }
    });
  }

  void _save() {
    final labels = <ApplicationStatus, String>{};

    for (final status in ApplicationStatus.values) {
      final value = _controllers[status]!.text.trim();

      labels[status] = value.isEmpty ? status.label : value;
    }

    widget.onSave(
      List<ApplicationStatus>.from(_order),
      labels,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Edit stages',
                    style: FieldLog.display(
                      size: 19,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Text(
              'Rename stages or drag them into a new order.',
              style: FieldLog.body(
                size: 12,
                color: FieldLog.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            Flexible(
              child: ReorderableListView.builder(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                itemCount: _order.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }

                    final item = _order.removeAt(oldIndex);
                    _order.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  final status = _order[index];

                  return _StageRow(
                    key: ValueKey(status),
                    index: index,
                    status: status,
                    controller: _controllers[status]!,
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                TextButton(
                  onPressed: _reset,
                  style: TextButton.styleFrom(
                    foregroundColor: FieldLog.textSecondary,
                  ),
                  child: Text(
                    'Reset',
                    style: FieldLog.body(
                      size: 12,
                      color: FieldLog.textSecondary,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),

                const Spacer(),

                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FieldLog.textPrimary,
                    backgroundColor: FieldLog.surfaceCard,
                    side: const BorderSide(
                      color: FieldLog.textPrimary,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FieldLog.radiusControl,
                      ),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: FieldLog.body(
                      size: 12,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: FieldLog.textPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FieldLog.radiusControl,
                      ),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: FieldLog.body(
                      size: 12,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  final int index;
  final ApplicationStatus status;
  final TextEditingController controller;

  const _StageRow({
    super.key,
    required this.index,
    required this.status,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(
        12,
        8,
        8,
        8,
      ),
      decoration: BoxDecoration(
        color: FieldLog.surfaceCard,
        border: Border.all(
          color: FieldLog.border,
        ),
        borderRadius: BorderRadius.circular(
          FieldLog.radiusControl,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller,
              style: FieldLog.body(
                size: 13,
                weight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
              ),
            ),
          ),

          ReorderableDragStartListener(
            index: index,
            child: MouseRegion(
              cursor: SystemMouseCursors.grab,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.drag_indicator_rounded,
                  size: 19,
                  color: FieldLog.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}