import 'package:flutter/material.dart';
import '../models/application.dart';
import '../theme/field_log_theme.dart';

/// Dev note:
/// Opens the guided add/edit form as a modal bottom sheet, split into a
/// "Details" and "Recruiter" tab per the wireframe. [initialStatus] lets a
/// caller (e.g. a stage group's quick-add) pre-set the stage for a new
/// entry without pre-filling anything else.
Future<void> showApplicationFormSheet(
  BuildContext context, {
  JobApplication? existing,
  ApplicationStatus? initialStatus,
  required void Function(JobApplication) onSave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: FieldLog.bgPage,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: _ApplicationForm(existing: existing, initialStatus: initialStatus, onSave: onSave),
    ),
  );
}

class _ApplicationForm extends StatefulWidget {
  final JobApplication? existing;
  final ApplicationStatus? initialStatus;
  final void Function(JobApplication) onSave;

  const _ApplicationForm({this.existing, this.initialStatus, required this.onSave});

  @override
  State<_ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<_ApplicationForm> {
  int _tab = 0;

  late final TextEditingController _company;
  late final TextEditingController _role;
  late final TextEditingController _source;
  late final TextEditingController _location;
  late final TextEditingController _jobType;
  late final TextEditingController _salary;
  late final TextEditingController _description;
  late final TextEditingController _recruiterName;
  late final TextEditingController _recruiterEmail;
  late final TextEditingController _recruiterLinkedIn;
  late final TextEditingController _notes;
  late DateTime _date;
  DateTime? _lastContacted;
  late ApplicationStatus _status;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _company = TextEditingController(text: e?.company ?? '');
    _role = TextEditingController(text: e?.role ?? '');
    _source = TextEditingController(text: e?.source ?? '');
    _location = TextEditingController(text: e?.location ?? '');
    _jobType = TextEditingController(text: e?.jobType ?? '');
    _salary = TextEditingController(text: e?.salary ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _recruiterName = TextEditingController(text: e?.recruiterName ?? '');
    _recruiterEmail = TextEditingController(text: e?.recruiterEmail ?? '');
    _recruiterLinkedIn = TextEditingController(text: e?.recruiterLinkedIn ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _date = e?.appliedDate ?? DateTime.now();
    _lastContacted = e?.lastContacted;
    _status = e?.status ?? widget.initialStatus ?? ApplicationStatus.applied;
  }

  @override
  void dispose() {
    _company.dispose();
    _role.dispose();
    _source.dispose();
    _location.dispose();
    _jobType.dispose();
    _salary.dispose();
    _description.dispose();
    _recruiterName.dispose();
    _recruiterEmail.dispose();
    _recruiterLinkedIn.dispose();
    _notes.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: FieldLog.mono(size: 12),
        filled: true,
        fillColor: FieldLog.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FieldLog.radiusControl),
          borderSide: BorderSide(color: FieldLog.border),
        ),
      );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickLastContacted() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastContacted ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _lastContacted = picked);
  }

  bool get _canSubmit => _company.text.trim().isNotEmpty && _role.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) return;
    final app = JobApplication(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      company: _company.text.trim(),
      role: _role.text.trim(),
      appliedDate: _date,
      status: _status,
      source: _source.text.trim(),
      notes: _notes.text.trim(),
      location: _location.text.trim(),
      jobType: _jobType.text.trim(),
      salary: _salary.text.trim(),
      description: _description.text.trim(),
      recruiterName: _recruiterName.text.trim(),
      recruiterEmail: _recruiterEmail.text.trim(),
      recruiterLinkedIn: _recruiterLinkedIn.text.trim(),
      lastContacted: _lastContacted,
    );
    widget.onSave(app);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.existing == null ? 'log new application' : 'edit application',
                  style: FieldLog.display(size: 18)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(Icons.close_rounded, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TabToggle(index: _tab, onChanged: (i) => setState(() => _tab = i)),
          const SizedBox(height: 16),
          // Dev note:
          // IndexedStack (not a rebuild-on-switch) so both tabs' fields —
          // and their controllers — stay alive while hidden. Switching
          // tabs must never lose what the user already typed.
          IndexedStack(
            index: _tab,
            alignment: Alignment.topLeft,
            children: [
              _detailsTab(),
              _recruiterTab(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: FieldLog.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FieldLog.radiusControl)),
                  ),
                  child: Text('cancel', style: FieldLog.mono(size: 13)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FieldLog.textPrimary,
                    foregroundColor: FieldLog.bgPage,
                    disabledBackgroundColor: FieldLog.border,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FieldLog.radiusControl)),
                  ),
                  child: Text(widget.existing == null ? 'save entry' : 'save changes',
                      style: FieldLog.mono(size: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _role,
          decoration: _decoration('job title'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _company,
          decoration: _decoration('company'),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(FieldLog.radiusControl),
                child: InputDecorator(
                  decoration: _decoration('applied date'),
                  child: Text(
                    '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    style: FieldLog.mono(size: 13, color: FieldLog.textPrimary),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<ApplicationStatus>(
                value: _status,
                decoration: _decoration('status'),
                items: ApplicationStatus.values
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.label, style: FieldLog.mono(size: 12))))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(controller: _location, decoration: _decoration('location (optional)')),
        const SizedBox(height: 12),
        TextField(
          controller: _jobType,
          decoration: _decoration('job type (optional — e.g. internship, remote)'),
        ),
        const SizedBox(height: 12),
        TextField(controller: _salary, decoration: _decoration('salary (optional)')),
        const SizedBox(height: 12),
        TextField(controller: _source, decoration: _decoration('source (job board, referral...)')),
        const SizedBox(height: 12),
        TextField(controller: _description, decoration: _decoration('description (optional)'), maxLines: 3),
      ],
    );
  }

  Widget _recruiterTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: _recruiterName, decoration: _decoration('recruiter name (optional)')),
        const SizedBox(height: 12),
        TextField(controller: _recruiterEmail, decoration: _decoration('email (optional)')),
        const SizedBox(height: 12),
        TextField(controller: _recruiterLinkedIn, decoration: _decoration('linkedin url (optional)')),
        const SizedBox(height: 12),
        InkWell(
          onTap: _pickLastContacted,
          borderRadius: BorderRadius.circular(FieldLog.radiusControl),
          child: InputDecorator(
            decoration: _decoration('last contacted (optional)'),
            child: Text(
              _lastContacted == null
                  ? 'not set'
                  : '${_lastContacted!.year}-${_lastContacted!.month.toString().padLeft(2, '0')}-${_lastContacted!.day.toString().padLeft(2, '0')}',
              style: FieldLog.mono(size: 13, color: FieldLog.textPrimary),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(controller: _notes, decoration: _decoration('notes (optional)'), maxLines: 3),
      ],
    );
  }
}

class _TabToggle extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _TabToggle({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: FieldLog.surfaceCard,
        border: Border.all(color: FieldLog.border),
        borderRadius: BorderRadius.circular(FieldLog.radiusControl),
      ),
      child: Row(
        children: [
          _segment(0, 'details', Icons.description_outlined),
          _segment(1, 'recruiter', Icons.person_outline_rounded),
        ],
      ),
    );
  }

  Widget _segment(int i, String label, IconData icon) {
    final active = i == index;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onChanged(i),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: active ? FieldLog.textPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(FieldLog.radiusControl - 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: active ? FieldLog.bgPage : FieldLog.textSecondary),
                const SizedBox(width: 6),
                Text(label,
                    style: FieldLog.mono(size: 12, color: active ? FieldLog.bgPage : FieldLog.textSecondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
