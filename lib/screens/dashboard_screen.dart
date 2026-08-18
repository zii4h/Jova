import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';
import '../widgets/index_card.dart';
import '../widgets/application_form_sheet.dart';
import '../widgets/status_filter_chips.dart';

class DashboardScreen extends StatefulWidget {
  final List<JobApplication> applications;
  final void Function(JobApplication) onAdd;
  final void Function(JobApplication) onUpdate;
  final void Function(String id) onDelete;

  const DashboardScreen({
    super.key,
    required this.applications,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ApplicationStatus? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final counts = <ApplicationStatus, int>{
      for (final s in ApplicationStatus.values)
        s: widget.applications.where((a) => a.status == s).length,
    };

    var visible = widget.applications;
    if (_filter != null) {
      visible = visible.where((a) => a.status == _filter).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      visible = visible
          .where((a) => a.company.toLowerCase().contains(q) || a.role.toLowerCase().contains(q))
          .toList();
    }
    final sorted = [...visible]..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Jecord', style: FieldLog.display(size: 26)),
                Text('log no. ${widget.applications.length.toString().padLeft(3, '0')}',
                    style: FieldLog.mono(size: 11)),
              ],
            ),
            const SizedBox(height: 4),
            Container(height: 1.5, color: FieldLog.border),
            const SizedBox(height: 14),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              style: FieldLog.mono(size: 13),
              decoration: InputDecoration(
                hintText: 'search company or role...',
                hintStyle: FieldLog.mono(size: 13, color: FieldLog.textSecondary),
                isDense: true,
                filled: true,
                fillColor: FieldLog.surfaceCard,
                prefixIcon: const Icon(Icons.search, size: 18),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FieldLog.radiusControl),
                  borderSide: BorderSide(color: FieldLog.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FieldLog.radiusControl),
                  borderSide: BorderSide(color: FieldLog.border),
                ),
              ),
            ),
            const SizedBox(height: 10),
            StatusFilterChips(
              selected: _filter,
              counts: counts,
              onSelect: (s) => setState(() => _filter = s),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: sorted.isEmpty
                  ? Center(
                      child: Text(
                        widget.applications.isEmpty
                            ? 'no applications logged yet'
                            : 'nothing matches that filter',
                        style: FieldLog.mono(size: 12),
                      ),
                    )
                  : ListView.builder(
                      itemCount: sorted.length,
                      itemBuilder: (context, i) {
                        final app = sorted[i];
                        return IndexCard(
                          application: app,
                          onTap: () => showApplicationFormSheet(
                            context,
                            existing: app,
                            onSave: widget.onUpdate,
                          ),
                          onDelete: () => widget.onDelete(app.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
