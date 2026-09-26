import 'package:flutter/material.dart';

import '../models/application.dart';
import '../theme/field_log_theme.dart';
import '../widgets/index_card.dart';
import '../widgets/application_form_sheet.dart';
import '../widgets/status_filter_chips.dart';
import '../widgets/collapsible_section.dart';
import '../widgets/stage_editor_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final List<JobApplication> applications;

  final List<ApplicationStatus> stageOrder;
  final Map<ApplicationStatus, String> stageLabels;

  final Future<void> Function(
    List<ApplicationStatus> order,
    Map<ApplicationStatus, String> labels,
  ) onStagesChanged;

  final void Function(JobApplication) onAdd;
  final void Function(JobApplication) onUpdate;
  final void Function(String id) onDelete;

  const DashboardScreen({
    super.key,
    required this.applications,
    required this.stageOrder,
    required this.stageLabels,
    required this.onStagesChanged,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  ApplicationStatus? _filter;
  String _query = '';

  void _openStageEditor() {
    showStageEditorSheet(
      context,
      currentOrder: widget.stageOrder,
      currentLabels: widget.stageLabels,
      onSave: (order, labels) {
        widget.onStagesChanged(
          order,
          labels,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final counts = <ApplicationStatus, int>{
      for (final status in ApplicationStatus.values)
        status: widget.applications
            .where(
              (app) => app.status == status,
            )
            .length,
    };

    var visible = widget.applications;

    if (_filter != null) {
      visible = visible
          .where(
            (app) => app.status == _filter,
          )
          .toList();
    }

    if (_query.trim().isNotEmpty) {
      final q =
          _query.trim().toLowerCase();

      visible = visible
          .where(
            (app) =>
                app.company
                    .toLowerCase()
                    .contains(q) ||
                app.role
                    .toLowerCase()
                    .contains(q),
          )
          .toList();
    }

    final groups =
        <ApplicationStatus,
            List<JobApplication>>{};

    for (final status in widget.stageOrder) {
      final items = visible
          .where(
            (app) => app.status == status,
          )
          .toList()
        ..sort(
          (a, b) => b.appliedDate
              .compareTo(a.appliedDate),
        );

      if (items.isNotEmpty) {
        groups[status] = items;
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          24,
          18,
          100,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Text(
                  'Jova',
                  style: FieldLog.display(
                    size: 26,
                    weight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${widget.applications.length} applications',
                  style: FieldLog.body(
                    size: 11,
                    color:
                        FieldLog.textSecondary,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              style: FieldLog.body(
                size: 13,
              ),
              decoration: InputDecoration(
                hintText:
                    'Search company or role',
                hintStyle: FieldLog.body(
                  size: 13,
                  color:
                      FieldLog.textSecondary,
                ),
                isDense: true,
                filled: true,
                fillColor:
                    FieldLog.surfaceCard,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 18,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    FieldLog.radiusControl,
                  ),
                  borderSide:
                      const BorderSide(
                    color: FieldLog.border,
                  ),
                ),
                enabledBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    FieldLog.radiusControl,
                  ),
                  borderSide:
                      const BorderSide(
                    color: FieldLog.border,
                  ),
                ),
                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    FieldLog.radiusControl,
                  ),
                  borderSide:
                      const BorderSide(
                    color:
                        FieldLog.textPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: StatusFilterChips(
                    selected: _filter,
                    counts: counts,
                    order:
                        widget.stageOrder,
                    labels:
                        widget.stageLabels,
                    onSelect: (status) {
                      setState(() {
                        _filter = status;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                TextButton.icon(
                  onPressed:
                      _openStageEditor,
                  style:
                      TextButton.styleFrom(
                    foregroundColor:
                        FieldLog.textPrimary,
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 8,
                      vertical: 7,
                    ),
                    visualDensity:
                        VisualDensity.compact,
                  ),
                  icon: const Icon(
                    Icons.tune_rounded,
                    size: 15,
                  ),
                  label: Text(
                    'Edit',
                    style: FieldLog.body(
                      size: 11,
                      color:
                          FieldLog.textPrimary,
                      weight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: groups.isEmpty
                  ? Center(
                      child: Text(
                        widget.applications
                                .isEmpty
                            ? 'No applications yet'
                            : 'Nothing matches your search',
                        style: FieldLog.body(
                          size: 12,
                          color: FieldLog
                              .textSecondary,
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        for (final entry
                            in groups.entries)
                          CollapsibleSection(
                            title: widget
                                    .stageLabels[
                                entry.key] ??
                                entry.key.label,
                            countLabel:
                                '${entry.value.length}',
                            accentColor:
                                entry.key.color,
                            trailing:
                                _QuickAddButton(
                              onTap: () {
                                showApplicationFormSheet(
                                  context,
                                  initialStatus:
                                      entry.key,
                                  onSave:
                                      widget
                                          .onAdd,
                                );
                              },
                            ),
                            child: Column(
                              children:
                                  entry.value
                                      .map(
                                        (app) =>
                                            IndexCard(
                                          application:
                                              app,
                                          onTap:
                                              () {
                                            showApplicationFormSheet(
                                              context,
                                              existing:
                                                  app,
                                              onSave:
                                                  widget.onUpdate,
                                            );
                                          },
                                          onDelete:
                                              () {
                                            widget.onDelete(
                                              app.id,
                                            );
                                          },
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Add application',
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 28,
        minHeight: 28,
      ),
      icon: const Icon(
        Icons.add_rounded,
        size: 19,
        color: FieldLog.textPrimary,
      ),
    );
  }
}