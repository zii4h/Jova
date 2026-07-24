import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';
import '../widgets/index_card.dart';
import '../widgets/application_form_sheet.dart';

class DashboardScreen extends StatelessWidget {
  final List<JobApplication> applications;
  final void Function(JobApplication) onAdd;
  final void Function(JobApplication) onUpdate;

  const DashboardScreen({
    super.key,
    required this.applications,
    required this.onAdd,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...applications]..sort((a, b) => b.appliedDate.compareTo(a.appliedDate));

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
                Text('log no. ${sorted.length.toString().padLeft(3, '0')}',
                    style: FieldLog.mono(size: 11)),
              ],
            ),
            const SizedBox(height: 4),
            Container(height: 1.5, color: FieldLog.border),
            const SizedBox(height: 18),
            Expanded(
              child: sorted.isEmpty
                  ? Center(
                      child: Text('no applications logged yet', style: FieldLog.mono(size: 12)),
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
                            onSave: onUpdate,
                          ),
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
