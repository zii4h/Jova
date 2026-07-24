import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';
import '../widgets/index_card.dart';
import '../widgets/application_form_sheet.dart';

class CalendarScreen extends StatefulWidget {
  final List<JobApplication> applications;
  final void Function(JobApplication) onUpdate;

  const CalendarScreen({super.key, required this.applications, required this.onUpdate});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _visibleMonth;
  DateTime? _selectedDay;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  List<JobApplication> _appsOn(DateTime day) =>
      widget.applications.where((a) => _sameDay(a.appliedDate, day)).toList();

  void _shiftMonth(int delta) {
    setState(() => _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    // Monday-first offset
    final leadingBlanks = (firstOfMonth.weekday - 1) % 7;

    final dayCells = <Widget>[];
    for (int i = 0; i < leadingBlanks; i++) {
      dayCells.add(const SizedBox());
    }
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_visibleMonth.year, _visibleMonth.month, day);
      final hasEntries = _appsOn(date).isNotEmpty;
      final isSelected = _selectedDay != null && _sameDay(_selectedDay!, date);
      dayCells.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDay = date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? FieldLog.textPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$day',
                  style: FieldLog.mono(
                    size: 12,
                    color: isSelected ? FieldLog.bgPage : FieldLog.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                if (hasEntries)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? FieldLog.bgPage : FieldLog.stageInterview,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final selectedApps = _selectedDay == null ? <JobApplication>[] : _appsOn(_selectedDay!);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calendar', style: FieldLog.display(size: 22)),
            const SizedBox(height: 4),
            Container(height: 1.5, color: FieldLog.border),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () => _shiftMonth(-1), icon: const Icon(Icons.chevron_left)),
                Text('${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                    style: FieldLog.body(size: 14, weight: FontWeight.w500)),
                IconButton(onPressed: () => _shiftMonth(1), icon: const Icon(Icons.chevron_right)),
              ],
            ),
            Row(
              children: _weekdayLabels
                  .map((w) => Expanded(
                      child: Center(child: Text(w, style: FieldLog.mono(size: 11)))))
                  .toList(),
            ),
            const SizedBox(height: 4),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: dayCells,
            ),
            const SizedBox(height: 18),
            Container(height: 1, color: FieldLog.border),
            const SizedBox(height: 12),
            Text(
              selectedApps.isEmpty ? 'nothing logged on this date' : 'logged on this date',
              style: FieldLog.mono(size: 11),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: selectedApps
                    .map((app) => IndexCard(
                          application: app,
                          onTap: () => showApplicationFormSheet(
                            context,
                            existing: app,
                            onSave: widget.onUpdate,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
